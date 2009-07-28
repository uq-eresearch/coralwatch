package org.coralwatch;

import net.sourceforge.jwebunit.junit.WebTestCase;

public abstract class CoralWatchTestCase extends WebTestCase {
    public void setUp() throws Exception {
        super.setUp();
        String baseUrl = System.getProperty("coralwatch.baseUrl", "http://localhost:9635");
        setBaseUrl(baseUrl);
    }
}
