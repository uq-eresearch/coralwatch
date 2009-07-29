package org.coralwatch;


public class BaselineTest extends CoralWatchTestCase {
    public void testFrontPageShows() {
        assertTitleEquals("CoralWatch");
        // check if end of page is rendered
        assertTextPresent("If you have any queries or comments please email");
        assertTextPresent("CoralWatch Supporters");
        // check menu is rendered
        assertLinkPresentWithText("Login");
    }

    public void testLoginLogout() {
        loginAsAdmin();
        assertTextPresent("Abdul Alabri");
        assertLinkPresentWithExactText("New Survey");
        logout();
        assertTextPresent("You successfully logged out.");
        loginAsUser();
        assertTextPresent("Peter Becker");
        assertLinkPresentWithExactText("New Survey");
        logout();
        assertTextPresent("You successfully logged out.");
    }
}
