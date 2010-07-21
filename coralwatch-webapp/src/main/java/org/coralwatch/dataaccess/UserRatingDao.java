package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserRating;

import java.util.List;
import java.util.Map;

public interface UserRatingDao extends Dao<UserRating> {

    UserRating getRating(UserImpl rater, UserImpl rated);

    double getCommunityRatingValue(UserImpl rated);

    double getRatingValueByUser(UserImpl rater, UserImpl rated);

    Map<Long, Double> getCommunityRatingForAll();

    List<UserImpl> getRatersForUser(long ratedId);
}

