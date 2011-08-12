package org.coralwatch.app;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.dataaccess.*;
import org.coralwatch.dataaccess.jpa.*;
import org.coralwatch.model.*;
import org.restlet.service.ConnectorService;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.*;
import java.util.Date;
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
    private final UserRatingDao userRatingDao;
    private final SurveyRatingDao surveyRatingDao;
    private final boolean isTestSetup;
    private final boolean isRatingSetup;
    private final Properties submissionEmailConfig;
    private final ReefDao reefDao;
    private final UserReputationProfileDao userReputationProfileDao;


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
        this.userReputationProfileDao = new JpaUserReputationProfileDao(this.connectorService);
        this.surveyRecordDao = new JpaSurveyRecordDao(this.connectorService);
        this.userRatingDao = new JpaUserRatingDao(this.connectorService);
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
        this.isRatingSetup = Boolean.valueOf(getProperty(properties, "ratingOn", "false"));
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
        deleteAll(getRatingDao());
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


        UserImpl admin = new UserImpl("Administrator", "admin@coralwatch.org", BCrypt.hashpw("coralwatch", BCrypt.gensalt()), true);
        userDao.save(admin);
//        createTestUsers(admin);
        Logger.getLogger(getClass().getName()).log(Level.INFO,
                "Created new default admin user with email address 'admin@coralwatch.org' and password 'coralwatch'.");
    }

    @SuppressWarnings("unused")
    private void createTestUsers(UserImpl admin) {
        UserImpl charlie = new UserImpl("Charlie", "brooking@itee.uq.edu.au", BCrypt.hashpw("charlie", BCrypt.gensalt()), false);
        userDao.save(charlie);
        userRatingDao.save(new UserRating(admin, charlie, 5.0));
        userRatingDao.save(new UserRating(charlie, admin, 5.0));
        UserImpl peter = new UserImpl("Peter", "pbecker@itee.uq.edu.au", BCrypt.hashpw("peter", BCrypt.gensalt()), false);
        userDao.save(peter);
        userRatingDao.save(new UserRating(charlie, peter, 3));

        //Add dummy reefs
        Random rand = new Random();
        String[] testReefNames = getTestReefNames();
        for (String testReefName : testReefNames) {
            String[] countries = {"Australia", "New Zealand"};
            reefDao.save(new Reef(testReefName, countries[rand.nextInt(2)]));
        }

        //Add some test surveys
        Survey testSurvey1 = getTestSurvey(admin);
        surveyDao.save(testSurvey1);
        addTestSurveyRecord(testSurvey1);

        Survey testSurvey2 = getTestSurvey(admin);
        surveyDao.save(testSurvey2);
        addTestSurveyRecord(testSurvey2);

        Survey testSurvey3 = getTestSurvey(admin);
        surveyDao.save(testSurvey3);
        addTestSurveyRecord(testSurvey3);

        Survey testSurvey4 = getTestSurvey(admin);
        surveyDao.save(testSurvey4);
        addTestSurveyRecord(testSurvey4);

        //Add dummy usernames with rating
        String[] testUsernames = getTestUsernames();
        for (int i = 0; i < testUsernames.length; i++) {
            UserImpl newUser = new UserImpl(testUsernames[i], testUsernames[i].toLowerCase() + "@coralwatch.org", BCrypt.hashpw(testUsernames[i].toLowerCase(), BCrypt.gensalt()), false);
            userDao.save(newUser);
            Survey testSurvey = getTestSurvey(newUser);
            surveyDao.save(testSurvey);
            addTestSurveyRecord(testSurvey);
            if (i % 4 == 0) {
                double randomNumber = rand.nextDouble() * 5;
                userRatingDao.save(new UserRating(admin, newUser, randomNumber));
                Survey testSurvey5 = getTestSurvey(newUser);
                surveyDao.save(testSurvey5);
                addTestSurveyRecord(testSurvey5);
            }
            if (i % 9 == 0) {
                double randomNumber = rand.nextDouble() * 5;
                userRatingDao.save(new UserRating(charlie, newUser, randomNumber));
                Survey testSurvey6 = getTestSurvey(newUser);
                surveyDao.save(testSurvey6);
                addTestSurveyRecord(testSurvey6);
            }
            if (i % 31 == 0) {
                double randomNumber = rand.nextDouble() * 5;
                userRatingDao.save(new UserRating(newUser, admin, randomNumber));
            }
            if (i % 35 == 0) {
                double randomNumber = rand.nextDouble() * 5;
                userRatingDao.save(new UserRating(newUser, charlie, randomNumber));
            }
        }
    }

    private Survey getTestSurvey(UserImpl user) {
        Random rand = new Random(new Date().getTime());
        Survey survey = new Survey();
        survey.setCreator(user);
        survey.setGroupName("eResearch");
        survey.setParticipatingAs("School/University");
        survey.setReef(reefDao.getAll().get(rand.nextInt(24)));
        if (survey.getReef().getName().endsWith("Lizard Island")) {
            survey.setLatitude(new Float(-14.672 - rand.nextDouble()));
            survey.setLongitude(new Float(145.486 + rand.nextDouble()));
        } else {
            survey.setLatitude(new Float(-11 - rand.nextInt(20) - rand.nextDouble()));
            survey.setLongitude(new Float(154 + rand.nextInt(10) + rand.nextDouble()));
        }
        @SuppressWarnings("deprecation")
        Date date = new Date(2000 + rand.nextInt(11) - 1900, rand.nextInt(12), rand.nextInt(30));
        survey.setDate(date);
        survey.setTime(date);
        survey.setDateSubmitted(new Date());
        survey.setDateModified(new Date());
        survey.setLightCondition("Full Sunshine");
        survey.setActivity("Reef Walking");
        survey.setWaterTemperature(rand.nextInt(25) + 1 + 1.0);
        survey.setTotalRatingValue(rand.nextInt(5) + 1);
        survey.setNumberOfRatings(rand.nextInt(100) + 1);
        return survey;
    }

    private void addTestSurveyRecord(Survey survey) {
        Random rand = new Random(new Date().getTime());
        String[] coralType = {"Branching", "Boulder", "Plate", "Soft"};
        char[] letters = {'B', 'C', 'D', 'E'};
        for (int i = 0; i < rand.nextInt(15); i++) {
            SurveyRecord record = new SurveyRecord(survey, coralType[rand.nextInt(4)], letters[rand.nextInt(4)], rand.nextInt(6) + 1, letters[rand.nextInt(4)], rand.nextInt(6) + 1);
            surveyRecordDao.save(record);
        }
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
    public UserRatingDao getRatingDao() {
        return userRatingDao;
    }

    @Override
    public SurveyRatingDao getSurveyRatingDao() {
        return surveyRatingDao;
    }

    @Override
    public ReefDao getReefDao() {
        return reefDao;
    }

    @Override
    public UserReputationProfileDao getReputationProfileDao() {
        return userReputationProfileDao;
    }

    @Override
    public JpaConnectorService getJpaConnectorService() {
        return connectorService;
    }

    @Override
    public Properties getSubmissionEmailConfig() {
        return submissionEmailConfig;
    }

    @Override
    public boolean isTestSetup() {
        return isTestSetup;
    }

    public boolean isRatingSetup() {
        return isRatingSetup;
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
        return new String[]{"Bakar",
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
    }

    private String[] getTestReefNames() {
        return new String[]{
                "Nymph Island",
                "Eagle Island",
                "Lizard Island",
                "Osprey Island",
                "Palfrey Island",
                "Seabird Islets",
                "South Island",
                "Turtle Island Group",
                "Pethebridge Isles",
                "Rocky Islets",
                "Two Islands",
                "Three Islands",
                "Hope Islands",
                "Snapper Island",
                "Michaelmas Cay",
                "Upolu Cay",
                "Green Island",
                "Fitzroy Island",
                "High Island",
                "Mabel Island",
                "Normanby Island",
                "Round Island",
                "Hutchison Island",
                "Jessie Island",
                "Sisters Island",
                "Stephens Island"};
    }
}