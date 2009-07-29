package org.coralwatch.app;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.jpa.JpaConnectorService;
import org.coralwatch.dataaccess.jpa.JpaKitRequestDao;
import org.coralwatch.dataaccess.jpa.JpaSurveyDao;
import org.coralwatch.dataaccess.jpa.JpaSurveyRecordDao;
import org.coralwatch.dataaccess.jpa.JpaUserDao;
import org.coralwatch.model.UserImpl;
import org.restlet.service.ConnectorService;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;


public class ApplicationContext implements Configuration, ServletContextListener {
    private final EntityManagerFactory emf;
    private final int httpPort;
    private final String baseUrl;
    private final JpaConnectorService connectorService;
    private final UserDao userDao;
    private final Logger logger = Logger.getLogger(ApplicationContext.class.getName());
    private final SurveyDao surveyDao;
    private final KitRequestDao kitRequestDao;
    private final SurveyRecordDao surveyRecordDao;
    private final boolean isTestSetup;
    private final Properties submissionEmailConfig;

    public ApplicationContext() throws InitializationException {
        Properties properties = new Properties();
        InputStream resourceAsStream = null;
        try {
            resourceAsStream = ApplicationContext.class.getResourceAsStream("/coralwatch.properties");
            if (resourceAsStream == null) {
                throw new InitializationException("Configuration file not found, please ensure " +
                        "there is a 'pronto.properties' on the classpath");
            }
            properties.load(resourceAsStream);
        } catch (IOException ex) {
            throw new InitializationException("Failed to load configuration properties", ex);
        } finally {
            if (resourceAsStream != null) {
                try {
                    resourceAsStream.close();
                } catch (IOException ex) {
                    // so what?
                }
            }
        }
        // try to load additional developer-specific settings
        File devPropertiesFile = new File("local/coralwatch.properties");
        if (devPropertiesFile.isFile()) {
            InputStream fileInputStream = null;
            try {
                fileInputStream = new FileInputStream(devPropertiesFile);
                properties.load(fileInputStream);
            } catch (FileNotFoundException ex) {
                // should never happen since we checked before
            } catch (IOException ex) {
                throw new InitializationException("Failed to load development configuration properties", ex);
            } finally {
                if (fileInputStream != null) {
                    try {
                        fileInputStream.close();
                    } catch (IOException ex) {
                        // so what?
                    }
                }
            }

        }

        final String persistenceUnitName = getProperty(properties, "persistenceUnitName");
        emf = Persistence.createEntityManagerFactory(persistenceUnitName);
        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                emf.close();
            }
        }));
        this.connectorService = new JpaConnectorService(emf);
        this.surveyDao = new JpaSurveyDao(this.connectorService);
        this.kitRequestDao = new JpaKitRequestDao(this.connectorService);
        this.surveyRecordDao = new JpaSurveyRecordDao(this.connectorService);
        this.userDao = new JpaUserDao(this.connectorService);
        if (userDao.getAll().isEmpty()) {
            // ensure that there's always one user to begin with
            createDefaultUsers();
        }

        this.submissionEmailConfig = new Properties();
        String submissionEmailServer = getProperty(properties, "emailServer");
        this.submissionEmailConfig.setProperty("mail.smtp.host", submissionEmailServer);

        this.httpPort = Integer.valueOf(getProperty(properties, "httpPort", "8181"));
        this.baseUrl = getProperty(properties, "baseUrl", null);
        this.isTestSetup = Boolean.valueOf(getProperty(properties, "testMode", "false"));
    }

    public void resetDatabase() {
        if (!isTestSetup) {
            throw new IllegalStateException("Database reset is only allowed in test mode");
        }
        deleteAll(getSurveyRecordDao());
        deleteAll(getSurveyDao());
        deleteAll(getKitRequestDao());
        deleteAll(getUserDao());
        createDefaultUsers();
    }

    private static <T> void deleteAll(Dao<T> dao) {
        for (T o : dao.getAll()) {
            dao.delete(o);
        }
    }

    private void createDefaultUsers() {
        UserImpl defaultAdmin = new UserImpl("admin", "Abdul Alabri", "alabri@itee.uq.edu.au", BCrypt.hashpw("admin",
                BCrypt.gensalt()), true);
        userDao.save(defaultAdmin);
        Logger.getLogger(getClass().getName()).log(Level.INFO,
                "Created new default admin user with username and password 'admin'.");
        UserImpl defaultUser = new UserImpl("user", "Peter Becker", "pbecker@itee.uq.edu.au", BCrypt.hashpw("user", BCrypt
                .gensalt()), false);
        userDao.save(defaultUser);
        Logger.getLogger(getClass().getName()).log(Level.INFO,
                "Created new default user with username and password 'user'.");
    }

    @Override
    public int getHttpPort() {
        return httpPort;
    }

    @Override
    public ConnectorService getConnectorService() {
        return connectorService;
    }

    @Override
    public UserDao getUserDao() {
        return userDao;
    }

    @Override
    public String getBaseUrl() {
        return baseUrl;
    }

    @Override
    public SurveyDao getSurveyDao() {
        return surveyDao;
    }

    @Override
    public KitRequestDao getKitRequestDao() {
        return kitRequestDao;
    }

    @Override
    public SurveyRecordDao getSurveyRecordDao() {
        return surveyRecordDao;
    }

    @Override
    public Properties getSubmissionEmailConfig() {
        return submissionEmailConfig;
    }

    @Override
    public boolean isTestSetup() {
        return isTestSetup;
    }

    private static String getProperty(Properties properties, String propertyName) throws InitializationException {
        return getProperty(properties, propertyName, false);
    }

    private static String getProperty(Properties properties, String propertyName, boolean allowEmpty) throws InitializationException {
        String result = properties.getProperty(propertyName);
        if (result == null || (!allowEmpty && result.isEmpty())) {
            throw new InitializationException(String.format("Failed to load required property '%s', " +
                    "please check configuration", propertyName));
        }
        return result;
    }

    private static String getProperty(Properties properties, String propertyName, String defaultValue) {
        String result = properties.getProperty(propertyName);
        if (result == null) {
            result = defaultValue;

            Logger.getLogger(ApplicationContext.class.getName()).log(Level.INFO,
                    String.format("No value for property '%s' found, falling back to default of '%s'", propertyName, defaultValue));
        }
        return result;
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.log(Level.INFO, "Initialized Coralwatch application.........OK");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            emf.close();
            connectorService.stop();
        } catch (Exception ex) {
            logger.log(Level.SEVERE, "Error while closing Coralwatch application", ex);
        }
        logger.log(Level.INFO, "Closed Coralwatch application.........OK");
    }
}
