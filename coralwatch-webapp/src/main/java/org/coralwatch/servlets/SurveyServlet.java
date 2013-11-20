package org.coralwatch.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.hibernate.ScrollableResults;
import org.json.JSONException;
import org.json.JSONWriter;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class SurveyServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(SurveyServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        AppUtil.clearCache();

        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        Random rand = new Random();
        String format = req.getParameter("format");
        if (format.equals("json")) {
            res.setContentType("application/json;charset=utf-8");
            PrintWriter out = res.getWriter();
            JSONWriter writer = new JSONWriter(out);
            ScrollableResults surveys = surveyDao.getSurveysIterator();
            try {
                writer.array();
                surveys.beforeFirst();
                while (surveys.next()) {
                    Survey survey = (Survey) surveys.get(0);
                    try {
                        if (survey.getLatitude() != null && survey.getLongitude() != null) {
                            writer.object();
                            writer.key("id");
                            writer.value(survey.getId());
                            writer.key("lat");
                            writer.value(survey.getLatitude());
                            writer.key("lng");
                            writer.value(survey.getLongitude());
                            @SuppressWarnings("deprecation")
                            String localeString = survey.getDate().toLocaleString();
                            writer.key("date");
                            writer.value(localeString);
                            writer.endObject();
                        }
                    }
                    catch (JSONException e) {
                        LOGGER.error("Exception creating survey JSON", e);
                    }
                }
                writer.endArray();
            }
            catch (JSONException e) {
                throw new ServletException("Exception creating surveys JSON", e);
            }
        } else if (format.equals("xml")) {
            res.setContentType("text/xml;charset=utf-8");
            PrintWriter out = res.getWriter();
            try {
                ScrollableResults results = null;
                String createdByUserIdParam = req.getParameter("createdByUserId");
                String reefIdParam = req.getParameter("reefId");
                if (createdByUserIdParam != null) {
                    long createdByUserId = Long.valueOf(createdByUserIdParam);
                    UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
                    UserImpl surveyCreator = userDao.getById(createdByUserId);
                    results = surveyDao.getSurveysForDojo(null, surveyCreator);
                }
                else if (reefIdParam != null) {
                    long reefId = Long.valueOf(reefIdParam);
                    ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
                    Reef reef = reefDao.getById(reefId);
                    results = surveyDao.getSurveysForDojo(reef, null);
                }
                else {
                    results = surveyDao.getSurveysForDojo(null, null);
                }

                XMLOutputFactory output = XMLOutputFactory.newInstance();
                XMLStreamWriter writer = output.createXMLStreamWriter(out);
                writer.writeStartDocument();

                results.beforeFirst();
                writer.writeStartElement("surveys");
                while (results.next()) {
                    String creatorDisplayName = (String) results.get(0);
                    Date date = (Date) results.get(1);
                    String reefName = (String) results.get(2);
                    String country = (String) results.get(3);
                    Number numSurveyRecords = (Number) results.get(4);
                    Long surveyId = (Long) results.get(5);
                    Survey.ReviewState reviewState = (Survey.ReviewState) results.get(6);

                    writer.writeStartElement("survey");

                    writer.writeStartElement("surveyor");
                    writer.writeCharacters(creatorDisplayName);
                    writer.writeEndElement();

                    writer.writeStartElement("date");
                    writer.writeCharacters(String.valueOf(date.getTime()));
                    writer.writeEndElement();

                    writer.writeStartElement("reef");
                    writer.writeCharacters(reefName);
                    writer.writeEndElement();

                    writer.writeStartElement("country");
                    writer.writeCharacters(country == null || country.toLowerCase().startsWith("unknown") ? "" : country);
                    writer.writeEndElement();

                    writer.writeStartElement("records");
                    writer.writeCharacters(String.valueOf(numSurveyRecords));
                    writer.writeEndElement();

                    if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
                        writer.writeStartElement("rating");
                        writer.writeCharacters(rand.nextInt(6) + "");
                        writer.writeEndElement();
                    }

                    writer.writeStartElement("view");
                    writer.writeCharacters(surveyId + "");
                    writer.writeEndElement();

                    writer.writeStartElement("reviewState");
                    writer.writeCharacters(reviewState.name());
                    writer.writeEndElement();

                    writer.writeEndElement();
                }
                writer.writeEndElement();
            }
            catch (Exception e) {
                LOGGER.error("Exception creating survey XML", e);
            }
        }
    }
}