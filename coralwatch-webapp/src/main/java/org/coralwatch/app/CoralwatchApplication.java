package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import org.restlet.Application;

public class CoralwatchApplication extends Application {

    private static final Configuration configuration;

    static {
        try {
            configuration = new ApplicationContext();
        } catch (InitializationException ex) {
            throw new RuntimeException("Failed to initialize application", ex);
        }
    }

    public static Configuration getConfiguration() {
        return configuration;
    }
}