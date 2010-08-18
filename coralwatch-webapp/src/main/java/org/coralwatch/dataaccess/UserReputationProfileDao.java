package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserReputationProfile;

public interface UserReputationProfileDao extends Dao<UserReputationProfile> {

    UserReputationProfile getByRatee(UserImpl ratee);
}
