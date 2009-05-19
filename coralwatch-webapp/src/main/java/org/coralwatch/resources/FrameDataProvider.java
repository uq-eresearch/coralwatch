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
        navItems.add(new NavigationItem("Data", "${baseUrl}/data"));
        navItems.add(new NavigationItem("Education", "${baseUrl}/education"));
        navItems.add(new NavigationItem("Going Green", "${baseUrl}/goinggreen"));
        navItems.add(new NavigationItem("Graphs", "${baseUrl}/graphs"));
        navItems.add(new NavigationItem("About", "${baseUrl}/about"));
        navItems.add(new NavigationItem("Related", "${baseUrl}/links"));
        navItems.add(new NavigationItem("Login", "${baseUrl}/login"));

        return new FrameData("CoralWatch", navItems, currentUser);

    }
}
