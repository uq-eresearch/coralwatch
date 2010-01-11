package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.model.FrameData;
import au.edu.uq.itee.maenad.restlet.model.NavigationItem;
import org.coralwatch.model.UserImpl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class FrameDataProvider implements au.edu.uq.itee.maenad.restlet.model.FrameDataProvider<UserImpl> {

    public FrameDataProvider() {
    }

    public FrameData getFrameData(UserImpl currentUserImpl) {
        List<NavigationItem> navItems = new ArrayList<NavigationItem>(Arrays.asList(new NavigationItem("Home", "${baseUrl}")));

        navItems.add(new NavigationItem("About", "${baseUrl}/about"));
        navItems.add(new NavigationItem("Graphs", "${baseUrl}/graphs"));
        navItems.add(new NavigationItem("Education", "${baseUrl}/education"));
        navItems.add(new NavigationItem("Going Green", "${baseUrl}/goinggreen"));
        navItems.add(new NavigationItem("Related", "${baseUrl}/links"));

        if (currentUserImpl != null) {
            navItems.add(new NavigationItem("Dashboard", "${baseUrl}/dashboard"));
        } else {
            navItems.add(new NavigationItem("Submit/Login", "${baseUrl}/login?redirectUrl=${baseUrl}/dashboard"));
        }

        return new FrameData("CoralWatch", navItems, currentUserImpl);

    }

}
