package org.coralwatch.app;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 12:07:43 PM
 */
public interface Configuration {

    int getHttpPort();


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