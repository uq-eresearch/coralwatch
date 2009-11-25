package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserTrust;

import java.util.Map;

public interface UserTrustDao extends Dao<UserTrust> {

    UserTrust getTrust(UserImpl trustor, UserImpl trustee);

    double getCommunityTrustValue(UserImpl trustee);

    double getTrustValueByUser(UserImpl trustor, UserImpl trustee);

    Map<Long, Double> getCommunityTrustForAll();
}

