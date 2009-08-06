package org.coralwatch.user;

import org.coralwatch.CoralWatchTestCase;

public class ChangeUserTest extends CoralWatchTestCase {
    public void testChangeAdminDetails() {
        loginAsAdmin();
        clickLinkWithExactText("CoralWatch Administrator");
        clickButton("editButton");

        setTextField("email", "john.doe@example.org");
        setTextField("email2", "john.doe@example.org");
        setTextField("displayName", "John Doe");
//        setTextField("role", "Member");
        setTextField("occupation", "Placeholder");
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
