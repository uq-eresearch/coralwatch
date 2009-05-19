package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.auth.User;
import au.edu.uq.itee.maenad.restlet.model.FrameData;
import au.edu.uq.itee.maenad.restlet.model.NavigationItem;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 12:03:30 PM
 */
public class FrameDataProvider implements au.edu.uq.itee.maenad.restlet.model.FrameDataProvider<User> {

    public FrameDataProvider() {
    }

    public FrameData getFrameData(User currentUser) {
        List<NavigationItem> navItems = new ArrayList<NavigationItem>(Arrays.asList(new NavigationItem("Home", "${baseUrl}")));
//        if (currentUser != null) {
//            navItems.add(new NavigationItem("New Entry", "${baseUrl}/ontologies?new"));
//            if (currentUser.isSuperUser()) {
//                navItems.add(new NavigationItem("Admin", "${baseUrl}/admin"));
//            }
//            navItems.add(new NavigationItem("Logout", "${baseUrl}/logout"));
//        } else {
//            if (Pronto.getConfiguration().getSubmissionEmailAddress() != null) {
//                navItems.add(new NavigationItem("Submit", "${baseUrl}/submit"));
//            }
//            navItems.add(new NavigationItem("Login", "${baseUrl}/login?redirectUrl=${currentUrl?url}"));
//        }
        navItems.add(new NavigationItem("", ""));
//        navItems.add(new NavigationItem("Overview", "${baseUrl}/overview"));
        navItems.add(new NavigationItem("About", "${baseUrl}/about"));
//        navItems.add(new NavigationItem("Related", "${baseUrl}/related"));

        return new FrameData("CoralWatch", navItems, currentUser);

    }
}
