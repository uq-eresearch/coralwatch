package org.coralwatch.app;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.UserTrustDao;
import org.coralwatch.dataaccess.jpa.JpaConnectorService;
import org.coralwatch.dataaccess.jpa.JpaKitRequestDao;
import org.coralwatch.dataaccess.jpa.JpaReefDao;
import org.coralwatch.dataaccess.jpa.JpaSurveyDao;
import org.coralwatch.dataaccess.jpa.JpaSurveyRatingDao;
import org.coralwatch.dataaccess.jpa.JpaSurveyRecordDao;
import org.coralwatch.dataaccess.jpa.JpaUserDao;
import org.coralwatch.dataaccess.jpa.JpaUserTrustDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserTrust;
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
import java.util.Random;
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
    private final UserTrustDao userTrustDao;
    private final SurveyRatingDao surveyRatingDao;
    private final boolean isTestSetup;
    private final Properties submissionEmailConfig;
    private final ReefDao reefDao;

    public ApplicationContext() throws InitializationException {
        Properties properties = new Properties();
        InputStream resourceAsStream = null;
        try {
            resourceAsStream = ApplicationContext.class.getResourceAsStream("/coralwatch.properties");
            if (resourceAsStream == null) {
                throw new InitializationException("Configuration file not found, please ensure " +
                        "there is a 'ehmp.properties' on the classpath");
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
        this.reefDao = new JpaReefDao(this.connectorService);
        this.surveyRecordDao = new JpaSurveyRecordDao(this.connectorService);
        this.userTrustDao = new JpaUserTrustDao(this.connectorService);
        this.surveyRatingDao = new JpaSurveyRatingDao(this.connectorService);
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

    /**
     * Deletes all entries in the database.
     * <p/>
     * Note that this is a pretty inefficient way of doing this. It is intended to be used
     * only for small sets of data.
     */
    public void resetDatabase() {
        if (!isTestSetup) {
            throw new IllegalStateException("Database reset is only allowed in test mode");
        }
        deleteAll(getTrustDao());
        deleteAll(getSurveyRatingDao());
        deleteAll(getKitRequestDao());
        deleteAll(getSurveyRecordDao());
        deleteAll(getReefDao());
        deleteAll(getSurveyDao());
        deleteAll(getUserDao());
        createDefaultUsers();
    }

    private static <T> void deleteAll(Dao<T> dao) {
        for (T o : dao.getAll()) {
            dao.delete(o);
        }
    }

    private void createDefaultUsers() {
        UserImpl admin = new UserImpl("Administrator", "abdul2000@gmail.com", BCrypt.hashpw("admin", BCrypt.gensalt()), true);
        userDao.save(admin);
        UserImpl charlie = new UserImpl("Charlie", "brooking@itee.uq.edu.au", BCrypt.hashpw("charlie", BCrypt.gensalt()), false);
        userDao.save(charlie);
        userTrustDao.save(new UserTrust(admin, charlie, 5.0));
        userTrustDao.save(new UserTrust(charlie, admin, 5.0));
        UserImpl peter = new UserImpl("Peter", "pbecker@itee.uq.edu.au", BCrypt.hashpw("peter", BCrypt.gensalt()), false);
        userDao.save(peter);
        userTrustDao.save(new UserTrust(charlie, peter, 3));
        String[] names = getTestUsernames();
        for (int i = 0; i < names.length; i++) {
            UserImpl newUser = new UserImpl(names[i], names[i].toLowerCase() + "@coralwatch.org", BCrypt.hashpw(names[i].toLowerCase(), BCrypt.gensalt()), false);
            userDao.save(newUser);
            if (i % 4 == 0) {
                Random rand = new Random();
                double randomNumber = rand.nextDouble() * 5;
                userTrustDao.save(new UserTrust(admin, newUser, randomNumber));
            }
            if (i % 9 == 0) {
                Random rand = new Random();
                double randomNumber = rand.nextDouble() * 5;
                userTrustDao.save(new UserTrust(charlie, newUser, randomNumber));
            }
        }

        Logger.getLogger(getClass().getName()).log(Level.INFO,
                "Created new default admin user with email address 'admin@coralwatch.org' and password 'admin'.");
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
    public UserTrustDao getTrustDao() {
        return userTrustDao;
    }

    @Override
    public SurveyRatingDao getSurveyRatingDao() {
        return surveyRatingDao;
    }

    public ReefDao getReefDao() {
        return reefDao;
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

    private String[] getTestUsernames() {
        String[] names = {"Bakar",
                "Abolahrari",
                "Ahmad",
                "Akhand",
                "Aldhubaib",
                "Ali",
                "Altinay",
                "Alyousef",
                "Arief",
                "Arnott",
                "Au",
                "Avery",
                "Azeezullah",
                "Aziz",
                "Azman",
                "Azzuhri",
                "Benson",
                "Bertling",
                "Bhattacharya",
                "Boden",
                "Boldaji",
                "Bradley",
                "Bray",
                "Brough",
                "Campbell",
                "Carter",
                "Chang",
                "Chin",
                "Chung",
                "Clough",
                "Cole",
                "Connelly",
                "Croft",
                "Crosthwaite",
                "Dahal",
                "Dawson",
                "Dekker",
                "Ding",
                "Domyo",
                "Donovan",
                "Duczmal",
                "Eizad",
                "Emami",
                "Escott",
                "Field",
                "Finlayson",
                "Fong",
                "Fu",
                "Gal",
                "Gearon",
                "Gilmore",
                "Glover",
                "Gollapalli",
                "Greaves",
                "Green",
                "Guerin",
                "Gujrathi",
                "Hakimipour",
                "Han",
                "Hargrave",
                "Hill",
                "Ho",
                "Hochwald",
                "Hou",
                "Hua",
                "Hunchangsith",
                "Ibrahim",
                "Jadav",
                "Javed",
                "Jeremijenko",
                "Jin",
                "Kamaruddin",
                "Kanagarajah",
                "Karunajeewa",
                "Khodabandehloo",
                "Khor",
                "Kim",
                "Kliese",
                "Kong",
                "Kumar",
                "Lam",
                "Lee",
                "Lessner",
                "Leung",
                "Li",
                "Lim",
                "Lin",
                "Liu",
                "Loch",
                "Long",
                "Low",
                "Lu",
                "MacDiarmid",
                "Macdonald",
                "Madden",
                "Maddern",
                "Mahinderjit",
                "Mahrin",
                "Makukhin",
                "Marwaha",
                "Matharu",
                "McKilliam",
                "McPartland",
                "Mealy",
                "Meng",
                "Mishra",
                "Modi",
                "Mohamed",
                "Mohammad",
                "Mohd",
                "Morrison",
                "Murray",
                "Nadler",
                "Nappu",
                "Nguyen",
                "Nolan",
                "Norouznezhad",
                "Noske",
                "Nuske",
                "Parsley",
                "Pathak",
                "Pathigoda",
                "Pedersen",
                "Petoe",
                "Pham",
                "Pierce",
                "Piper",
                "Puade",
                "Qin",
                "Raboczi",
                "Raffelt",
                "Rathnayake",
                "Razali",
                "Reddy",
                "Rittenbruch",
                "Samsudin",
                "Sandhu",
                "Sanin",
                "Sankupellay",
                "Schmidt",
                "Seman",
                "Setiawan",
                "Shang",
                "Shield",
                "Sien",
                "Simpson",
                "Smith",
                "Stockwell",
                "Su",
                "Suksawatchon",
                "Syed",
                "Symons",
                "Tan",
                "Tang",
                "Taraporewalla",
                "Terrill",
                "Thanigaivelan",
                "Thomas",
                "Timms",
                "Tohnak",
                "Valencia",
                "Vasudevan",
                "Wang",
                "Wee",
                "Wilson",
                "Wong",
                "Wu",
                "Xie",
                "Yan",
                "Yang",
                "Yao",
                "Ye",
                "Yeh",
                "Yin",
                "Yu",
                "Zagriatski",
                "Zhang",
                "Zheng",
                "Zhou",
                "Zhu",
                "Zhuang",
                "Ziser"};
        return names;
    }
}