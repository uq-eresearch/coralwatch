package org.coralwatch.app;

import org.coralwatch.dataaccess.*;
import org.coralwatch.dataaccess.jpa.JpaConnectorService;
import org.restlet.service.ConnectorService;

import java.util.Properties;


public interface Configuration {

    int getHttpPort();

    ConnectorService getConnectorService();

    UserDao getUserDao();

    SurveyDao getSurveyDao();

    KitRequestDao getKitRequestDao();

    SurveyRecordDao getSurveyRecordDao();

    UserRatingDao getRatingDao();

    SurveyRatingDao getSurveyRatingDao();

    ReefDao getReefDao();

    UserReputationProfileDao getReputationProfileDao();

    JpaConnectorService getJpaConnectorService();

    /**
     * An explicitly configured base URL.
     * <p/>
     * This allows configuring the base URL of the application explicitly in
     * cases where it can not be determined correctly by the application (e.g.
     * if a reverse proxy mangles HTTP headers).
     * <p/>
     * A return value of null means that the application dynamically resolves
     * the base URL.
     *
     * @return The explicit base URL if configured, null otherwise.
     */
    String getBaseUrl();

    Properties getSubmissionEmailConfig();

    /**
     * If true the system runs in test mode.
     * <p/>
     * Test mode might allow additional functionality to make testing more easy,
     * e.g. resetting the database.
     *
     * @return If the test mode has been enabled.
     */
    boolean isTestSetup();


    boolean isRatingSetup();
}