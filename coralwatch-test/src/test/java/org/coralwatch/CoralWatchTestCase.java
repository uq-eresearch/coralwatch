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

    protected void login(String email, String password) {
        clickLinkWithExactText("Login");
        setTextField("email", email);
        setTextField("password", password);
        clickButton("loginButton");
    }

    protected void loginAsAdmin() {
        login("email@example.org", "admin");
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

    /**
     * Waits for a bit to let Dojo do its thing.
     * 
     * It seems that sometimes we get race conditions between our calls and Dojo's changing
     * of widgets. We should find a way to synchronize properly, but for now we just wait.
     * 
     * See also http://htmlunit.sourceforge.net/faq.html#AJAXDoesNotWork -- that one refers
     * to AJAX and we can't actually access the WebClient instance (despite using it underneath),
     * but at least the general idea is the same. We would just need to figure out how to
     * reliably determine that Dojo has finished setting up the page.
     */
    protected void waitForDojo() {
        try {
            Thread.sleep(2000); // at 1sec we still had sporadic failures
        } catch (InterruptedException e) {
            // should not happen
        }
    }
}
