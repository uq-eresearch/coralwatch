package org.coralwatch.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

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
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

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
                String userIdStr = req.getParameter("createdByUserId");
                long createdByUserId = Long.valueOf(userIdStr == null ? "-1" : userIdStr);
                UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
                UserImpl surveyCreator = userDao.getById(createdByUserId);

                String reefIdStr = req.getParameter("reefId");
                long reefId = Long.valueOf(reefIdStr == null ? "-1" : reefIdStr);
                ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
                Reef reef = reefDao.getById(reefId);

                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
                //creating a new instance of a DOM to build a DOM tree.
                Document doc = docBuilder.newDocument();

                Element root = doc.createElement("surveys");
                //adding a node after the last child node of the specified node.
                doc.appendChild(root);

                List<Survey> listOfSurveys = surveyDao.getAll();
                if (surveyCreator != null) {
                    listOfSurveys = userDao.getSurveyEntriesCreated(surveyCreator);
                }

                if (reef != null) {
                    listOfSurveys = reefDao.getSurveysByReef(reef);
                }
                for (Survey srv : listOfSurveys) {
                    Element survey = doc.createElement("survey");
                    root.appendChild(survey);

                    Element surveyorNode = doc.createElement("surveyor");
                    survey.appendChild(surveyorNode);
                    Text surveyorName = doc.createTextNode(srv.getCreator().getDisplayName());
                    surveyorNode.appendChild(surveyorName);

                    Element dateNode = doc.createElement("date");
                    survey.appendChild(dateNode);
                    Text surveyDate = doc.createTextNode(srv.getDate().getTime() + "");
                    dateNode.appendChild(surveyDate);

                    Element reefNode = doc.createElement("reef");
                    survey.appendChild(reefNode);
                    Text reefName = doc.createTextNode(srv.getReef().getName());
                    reefNode.appendChild(reefName);

                    Element countryNode = doc.createElement("country");
                    survey.appendChild(countryNode);
                    String country = srv.getReef().getCountry();
                    Text countryName = doc.createTextNode(country == null || country.toLowerCase().startsWith("unknown") ? "" : country);
                    countryNode.appendChild(countryName);

                    Element numberOfRecordsNode = doc.createElement("records");
                    survey.appendChild(numberOfRecordsNode);
                    Text numberOfRecords = doc.createTextNode(surveyDao.getSurveyRecords(srv).size() + "");
                    numberOfRecordsNode.appendChild(numberOfRecords);

                    //Rating
                    if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
                        Element ratingNode = doc.createElement("rating");
                        survey.appendChild(ratingNode);
                        Text rating = doc.createTextNode(rand.nextInt(6) + "");
                        ratingNode.appendChild(rating);
                    }

                    Element viewNode = doc.createElement("view");
                    survey.appendChild(viewNode);
                    Text viewLink = doc.createTextNode(srv.getId() + "");
                    viewNode.appendChild(viewLink);
                }
                //TransformerFactory instance is used to create Transformer objects.
                TransformerFactory factory = TransformerFactory.newInstance();
                Transformer transformer = factory.newTransformer();
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");

                // create string from xml tree
                StringWriter sw = new StringWriter();
                StreamResult result = new StreamResult(sw);
                DOMSource source = new DOMSource(doc);
                transformer.transform(source, result);

                String xmlString = sw.toString();
                out.print(xmlString);
            }
            catch (Exception e) {
                LOGGER.fatal("Cannot create survey xml list." + e.toString());
            }

        }
    }

}
