package org.coralwatch;

import net.sourceforge.jwebunit.junit.WebTestCase;

public class FrontpageTest extends WebTestCase {
    public void setUp() throws Exception {
        super.setUp();
        setBaseUrl("http://localhost:9635");
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
