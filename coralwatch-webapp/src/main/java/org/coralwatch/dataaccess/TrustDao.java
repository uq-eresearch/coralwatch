package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;

import java.util.Map;

public interface TrustDao extends Dao<Trust> {

    Trust getTrust(UserImpl trustor, UserImpl trustee);

    double getCommunityTrustValue(UserImpl trustee);

    double getTrustValueByUser(UserImpl trustor, UserImpl trustee);

    Map<Long, Double> getCommunityTrustForAll();
}

