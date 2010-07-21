package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.UserRatingDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRating;
import org.coralwatch.model.UserImpl;
import org.coralwatch.model.UserRating;
import org.coralwatch.util.AppUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class RatingServlet extends HttpServlet {

    private static Log _log = LogFactoryUtil.getLog(RatingServlet.class);
    protected UserRatingDao ratingDao;
    protected UserDao userDao;
    protected SurveyRatingDao surveyRatingDao;
    protected SurveyDao surveyDao;

    @Override
    public void init() throws ServletException {
        ratingDao = CoralwatchApplication.getConfiguration().getRatingDao();
        surveyRatingDao = CoralwatchApplication.getConfiguration().getSurveyRatingDao();
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AppUtil.clearCache();
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();
        try {
            String cmd = req.getParameter("cmd");
            if (cmd.equals("rateuser")) {
                double ratingValue = Double.valueOf(req.getParameter("value"));
                long raterId = Long.valueOf(req.getParameter("raterId"));
                long ratedId = Long.valueOf(req.getParameter("ratedId"));
                UserImpl rater = userDao.getById(raterId);
                UserImpl rated = userDao.getById(ratedId);
                UserRating rating = ratingDao.getRating(rater, rated);
                if (rating == null) {
                    rating = new UserRating(rater, rated, ratingValue);
                    ratingDao.save(rating);
                } else {
                    rating.setRatingValue(ratingValue);
                    ratingDao.update(rating);
                }
                AppUtil.clearCache();
//                out.println(record.getId());
            } else if (cmd.equals("ratesurvey")) {
                double ratingValue = Double.valueOf(req.getParameter("value"));
                long raterId = Long.valueOf(req.getParameter("raterId"));
                long surveyId = Long.valueOf(req.getParameter("surveyId"));
                UserImpl rater = userDao.getById(raterId);
                Survey survey = surveyDao.getById(surveyId);

                SurveyRating surveyRating = surveyRatingDao.getSurveyRating(rater, survey);

                if (surveyRating == null) {
                    surveyRating = new SurveyRating(rater, survey, ratingValue);
                    surveyRatingDao.save(surveyRating);
                } else {
                    surveyRating.setRatingValue(ratingValue);
                    surveyRatingDao.update(surveyRating);
                }
                AppUtil.clearCache();
//                out.println("Successfully deleted record");
            }
        } catch (Exception ex) {
            out.println("System error." + ex.getMessage());
            _log.fatal("Error in record servlet ", ex);
        }
    }
}
