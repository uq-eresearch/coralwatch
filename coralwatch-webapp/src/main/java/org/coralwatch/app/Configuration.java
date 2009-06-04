package org.coralwatch.app;

import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.restlet.service.ConnectorService;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 12:07:43 PM
 */
public interface Configuration {

    int getHttpPort();

    ConnectorService getConnectorService();

    UserDao getUserDao();

    SurveyDao getSurveyDao();

    SurveyRecordDao getSurveyRecordDao();

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
}