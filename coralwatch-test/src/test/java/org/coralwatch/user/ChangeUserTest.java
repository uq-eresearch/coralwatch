package org.coralwatch.user;

import org.coralwatch.CoralWatchTestCase;

public class ChangeUserTest extends CoralWatchTestCase {
    public void testChangeAdminDetails() {
        loginAsAdmin();
        clickLinkWithExactText("Abdul Alabri");
        clickButton("editButton");

        setTextField("displayName", "John Doe");
        setTextField("occupation", "Placeholder");
        setTextField("email", "john.doe@example.org");
        setTextField("email2", "john.doe@example.org");
        setTextField("address", "13 Corner St, Nowhere land");
        //notWorking setTextField("country", "Tuvalu");
        assertMatchInElement("submitButton", "Update");
        clickButton("submitButton");

        assertTextPresent("Logged in as John Doe");
        assertTextPresent("john.doe@example.org");
        assertTextPresent("13 Corner St, Nowhere land");
        //assertTextPresent("Tuvalu");
    }
}