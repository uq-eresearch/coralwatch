package org.coralwatch;


public class FrontpageTest extends CoralWatchTestCase {
    public void setUp() throws Exception {
        super.setUp();
    }

    public void testFrontPageShows() {
        beginAt("/");
        assertTitleEquals("CoralWatch");
        // check if end of page is rendered
        assertTextPresent("If you have any queries or comments please email");
        assertTextPresent("CoralWatch Supporters");
        // check menu is rendered
        assertLinkPresentWithText("Login");
    }
}
