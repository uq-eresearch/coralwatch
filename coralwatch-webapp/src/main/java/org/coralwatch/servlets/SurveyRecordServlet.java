package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.util.AppUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class SurveyRecordServlet extends HttpServlet {

    protected SurveyDao surveyDao;
    protected SurveyRecordDao surveyRecordDao;
    private static Log _log = LogFactoryUtil.getLog(SurveyRecordServlet.class);

    @Override
    public void init() throws ServletException {
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AppUtil.clearCache();
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();
        try {
            String cmd = req.getParameter("cmd");
            if (cmd.equals("add")) {
                long suveyId = Long.valueOf(req.getParameter("surveyId"));
                String coralType = req.getParameter("coralType");
                String lightColor = req.getParameter("light_color");
                String darkColor = req.getParameter("dark_color");
                //TODO need validation here
                char lightLetter = lightColor.trim().charAt(0);
                int lightNumber = Integer.parseInt(lightColor.trim().charAt(1) + "");
                char darkLetter = darkColor.trim().charAt(0);
                int darkNumber = Integer.parseInt(darkColor.trim().charAt(1) + "");
                Survey survey = surveyDao.getById(suveyId);
                SurveyRecord record = new SurveyRecord(survey, coralType, lightLetter, lightNumber, darkLetter, darkNumber);
                survey.getDataset().add(record);
                surveyRecordDao.save(record);
                out.println(record.getId());
            } else if (cmd.equals("delete")) {
                long recordId = Long.valueOf(req.getParameter("recordId"));
                SurveyRecord surveyRec = surveyRecordDao.getById(recordId);
                surveyRec.getSurvey().getDataset().remove(surveyRec);
                surveyRecordDao.delete(surveyRec);
                out.println("Successfully deleted record");
            }
        } catch (Exception ex) {
            out.println("System error." + ex.getMessage());
            _log.fatal("Error in record servlet ", ex);
        }
    }
}
