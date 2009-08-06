package org.coralwatch.user;

import org.coralwatch.CoralWatchTestCase;

public class ChangeUserTest extends CoralWatchTestCase {
    public void testChangeAdminDetails() {
        loginAsAdmin();
        clickLinkWithExactText("CoralWatch Administrator");
        clickButton("editButton");

        setTextField("signupEmail", "john.doe@example.org");
        setTextField("signupEmail2", "john.doe@example.org");
        setTextField("signupDisplayName", "John Doe");
//        setTextField("role", "Member");
        setTextField("signupOccupation", "Placeholder");
        setTextField("signupAddress", "13 Corner St, Nowhere land");
        //notWorking setTextField("country", "Tuvalu");
        assertMatchInElement("submitButton", "Update");
        clickButton("submitButton");

        assertTextPresent("Logged in as John Doe");
        assertTextPresent("john.doe@example.org");
        assertTextPresent("13 Corner St, Nowhere land");
        //assertTextPresent("Tuvalu");
    }
}
