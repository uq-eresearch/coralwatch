package org.coralwatch.services;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.Constants;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.*;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserReputationProfile;
import org.coralwatch.services.reputation.Criterion;
import org.coralwatch.util.AppUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ReputationService {
    private static Log LOGGER = LogFactoryUtil.getLog(ReputationService.class);
    private static UserReputationProfileDao userReputationProfileDao = CoralwatchApplication.getConfiguration().getReputationProfileDao();

    //    private static UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
    public static double rateSurvey(long surveyId) {
        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
        UserRatingDao userRatingDao = CoralwatchApplication.getConfiguration().getRatingDao();
        SurveyRatingDao suveyRatingDao = CoralwatchApplication.getConfiguration().getSurveyRatingDao();
        Survey survey = surveyDao.getById(surveyId);

        //Get rating based on the community rating
        double communityRating = suveyRatingDao.getCommunityRatingValue(survey);
        //Get rating based on surveyor rating
        double creatorRating = userRatingDao.getCommunityRatingValue(survey.getCreator());

        //Get rating based on amount of data
        double amountOfDataRating = 0;
        int numberOfRecords = surveyDao.getSurveyRecords(survey).size();
        //TODO this is an arbitrary evaluation, need to have a real metric here
        if (numberOfRecords < 50) {
            amountOfDataRating = numberOfRecords / 10;
        } else {
            amountOfDataRating = 5;
        }

        //Get rating based on completeness of the metadata
        double ratingOfCompleteness = 0;

        //Get rating based on consistency

        return 0;
    }

    public static void calculateSystemRating(UserImpl ratee) {
        Double rating = 0.0;
        //1. Get rating of user's metadata
        Double profileRating = getProfileCompletenesRating(ratee);

        //2. Get rating of user's data

        //3. Get rating of user's amount of data
//        Double amountOfDataRating = getUserAmountOfDataRating(ratee);

        //4. Get rating of user's frequency of contribution

        //5. Get rating of user's role


//        rating = ((profileRating + amountOfDataRating) / 2.0);
        rating = profileRating;
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            userReputationProfile = new UserReputationProfile(ratee);
            userReputationProfile.setSystemRating(rating);
            userReputationProfileDao.save(userReputationProfile);
        } else {
            userReputationProfile.setSystemRating(rating);
            userReputationProfileDao.update(userReputationProfile);
        }
        AppUtil.clearCache();
    }

    public static void calculateUserRating(UserImpl rater, UserImpl ratee, Criterion criterion) {
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            userReputationProfile = new UserReputationProfile(ratee);
            HashMap<UserImpl, Double> map = new HashMap<UserImpl, Double>();
            map.put(rater, criterion.getRatingValue());
            userReputationProfile.setRaters(map);
            userReputationProfileDao.save(userReputationProfile);
        } else {
            HashMap<UserImpl, Double> map = userReputationProfile.getRaters();
            if (map == null) {
                map = new HashMap<UserImpl, Double>();
                userReputationProfile.setRaters(map);
            }
            map.put(rater, criterion.getRatingValue());
            userReputationProfileDao.update(userReputationProfile);
        }

        AppUtil.clearCache();
    }

    public static Double getOverAllRating(UserImpl ratee) {
        Double overAllRating = 0.0;
        Double overAllDirectRating = 0.0;
        calculateSystemRating(ratee);
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            return 0.0;
        } else {
            HashMap<UserImpl, Double> raters = userReputationProfile.getRaters();
            if (raters != null) {
                int raterCount = raters.size();
                for (UserImpl rater : raters.keySet()) {
                    overAllRating = overAllRating + raters.get(rater);
                }
                overAllDirectRating = overAllRating / raterCount;
            }
        }

        Double systemRating = userReputationProfile.getSystemRating();
        overAllRating = ((overAllDirectRating + systemRating) / 2.0);
        return overAllRating;
    }


    public static Double getRaterRating(UserImpl rater, UserImpl ratee) {
        UserReputationProfile userReputationProfile = userReputationProfileDao.getByRatee(ratee);
        if (userReputationProfile == null) {
            return 0.0;
        } else {
            HashMap<UserImpl, Double> map = userReputationProfile.getRaters();
            if (map == null) {
                return 0.0;
            }
            Double raterRating = map.get(rater);
            if (raterRating == null) {
                return 0.0;
            }
            return raterRating;
        }
    }

    public static List<UserImpl> getRateesFor(UserImpl friendsOfUser) {
        List<UserReputationProfile> userReputationProfiles = userReputationProfileDao.getAll();
        List<UserImpl> ratees = new ArrayList<UserImpl>();
        for (UserReputationProfile reputationProfile : userReputationProfiles) {
            HashMap<UserImpl, Double> map = reputationProfile.getRaters();
            if (map != null && map.containsKey(friendsOfUser)) {
                ratees.add(reputationProfile.getRatee());
            }
        }
        return ratees;
    }

    private static Double getProfileCompletenesRating(UserImpl ratee) {
        Double score = 6.0;
        String address = ratee.getAddress();
        String country = ratee.getCountry();
        String displayName = ratee.getDisplayName();
        String email = ratee.getEmail();
        String occupation = ratee.getOccupation();
        String qualification = ratee.getPositionDescription();

        if (address == null || address.isEmpty()) {
            score--;
        }
        if (country == null || country.isEmpty()) {
            score--;
        }
        if (displayName == null || displayName.isEmpty()) {
            score--;
        }
        if (email == null || email.isEmpty()) {
            score--;
        }
        if (occupation == null || occupation.isEmpty()) {
            score--;
        }
        if (qualification == null || qualification.isEmpty()) {
            score--;
        }
        return ((score / 6) * Constants.STAR_RATING_MAX_VALUE);
    }

    private static Double getUserAmountOfDataRating(UserImpl ratee) {
        Double score = 0.0;
        UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
        //Amount of data rating is calculated based on the number surveys contributed by this user compared to
        //The number of surveys contributed by the highest contributor in the system
        UserImpl highestContributor = getHighestContributor();
        double highestNumberOfSurveys = userDao.getNumberOfSurveys(highestContributor).doubleValue();
        double userNumberOfSurveys = userDao.getNumberOfSurveys(ratee).doubleValue();
        score = ((userNumberOfSurveys / highestNumberOfSurveys) * Constants.STAR_RATING_MAX_VALUE);
        return score;
    }

    public static UserImpl getHighestContributor() {
        UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
        List<UserImpl> users = userDao.getAll();
        UserImpl highestContributor = null;
        long numberOfSurveys = 0;
        for (UserImpl user : users) {
            long userSurveys = userDao.getNumberOfSurveys(user);
            if (userSurveys >= numberOfSurveys) {
                highestContributor = user;
                numberOfSurveys = userSurveys;
            }
        }
        return highestContributor;
    }
}
