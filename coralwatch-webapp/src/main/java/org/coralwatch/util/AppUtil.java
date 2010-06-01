package org.coralwatch.util;

import org.coralwatch.app.CoralwatchApplication;

public class AppUtil {
    /**
     * This method is used to clear the database cache
     */
    public static void clearCache() {
        CoralwatchApplication.getConfiguration().getJpaConnectorService().getEntityManager().clear();
    }
}
