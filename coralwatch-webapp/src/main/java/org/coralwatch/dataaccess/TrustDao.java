package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Trust;
import org.coralwatch.model.UserImpl;

public interface TrustDao extends Dao<Trust> {

    Trust getTrust(UserImpl trustor, UserImpl trustee);

    double getCommunityTrustValue(UserImpl trustee);

    double getTrustValueByUser(UserImpl trustor, UserImpl trustee);
}
