package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

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
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;

public class SurveyServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(SurveyServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        AppUtil.clearCache();
        PrintWriter out = res.getWriter();
        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();

        String format = req.getParameter("format");
        if (format.equals("json")) {
            res.setContentType("application/json");
            JSONArray surveys = new JSONArray();
            List<Survey> listOfSurveys = surveyDao.getAll();
            int count = 0;
            for (Survey srv : listOfSurveys) {
                try {
                    if (srv.getLatitude() != null && srv.getLongitude() != null) {
                        JSONObject survey = new JSONObject();
                        survey.putOpt("id", srv.getId());
                        survey.putOpt("reef", srv.getReef().getName());
                        survey.putOpt("country", srv.getReef().getCountry());
                        survey.putOpt("latitude", srv.getLatitude());
                        survey.putOpt("longitude", srv.getLongitude());
                        survey.putOpt("records", surveyDao.getSurveyRecords(srv).size());
                        survey.putOpt("date", srv.getDate().toLocaleString());
                        surveys.put(survey);
                        count++;
                    }
                } catch (JSONException e) {
                    LOGGER.fatal("Cannot create survey json object." + e.toString());
                }
            }
            JSONObject data = new JSONObject();

            try {
                data.putOpt("count", count);
                data.putOpt("surveys", surveys);
            } catch (JSONException ex) {
                LOGGER.fatal("Cannot create data json object." + ex.toString());
            }
            out.println(data);
        } else if (format.equals("xml")) {
            res.setContentType("text/xml");
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
                    Text countryName = doc.createTextNode(srv.getReef().getCountry());
                    countryNode.appendChild(countryName);

                    Element numberOfRecordsNode = doc.createElement("records");
                    survey.appendChild(numberOfRecordsNode);
                    Text numberOfRecords = doc.createTextNode(surveyDao.getSurveyRecords(srv).size() + "");
                    numberOfRecordsNode.appendChild(numberOfRecords);


                    Element actionNode = doc.createElement("view");
                    survey.appendChild(actionNode);
                    Text action = doc.createTextNode(srv.getId() + "");
                    actionNode.appendChild(action);

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
                LOGGER.fatal("Cannot create survey json object." + e.toString());
            }

        }
    }

}
