package org.coralwatch;

import net.sourceforge.jwebunit.junit.WebTestCase;

/**
 * A base class that handles aspects common to all tests against CoralWatch.
 */
public abstract class CoralWatchTestCase extends WebTestCase {
    public void setUp() throws Exception {
        super.setUp();
        String baseUrl = System.getProperty("coralwatch.baseUrl", "http://localhost:9635");
        setBaseUrl(baseUrl);
        beginAt("/reset");
        gotoPage("/");
    }

    protected void login(String username, String password) {
        clickLinkWithExactText("Login");
        setTextField("username", username);
        setTextField("password", password);
        clickButton("loginButton");
    }

    protected void loginAsAdmin() {
        login("admin", "admin");
    }

    protected void loginAsUser() {
        login("user", "user");
    }

    protected void logout() {
        clickLinkWithExactText("Logout");
    }
}
