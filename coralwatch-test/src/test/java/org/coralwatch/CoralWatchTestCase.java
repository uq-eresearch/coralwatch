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

    public void clickButton(String buttonId) {
        super.clickButton(buttonId);
        waitForDojo();
    }

    public void clickLink(String linkId) {
        super.clickLink(linkId);
        waitForDojo();
    }

    public void clickLinkWithExactText(String linkText) {
        super.clickLinkWithExactText(linkText);
        waitForDojo();
    }

    /**
     * Waits for some milliseconds to let Dojo do its thing.
     * 
     * It seems that sometimes we get race conditions between our calls and Dojo's changing
     * of widgets. We should find a way to synchronize properly, but for now we just wait.
     */
    protected void waitForDojo() {
        try {
            Thread.sleep(200);
        } catch (InterruptedException e) {
            // should not happen
        }
    }
}
