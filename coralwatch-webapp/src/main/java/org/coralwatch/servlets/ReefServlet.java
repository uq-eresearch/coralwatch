package org.coralwatch.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;

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
import org.coralwatch.model.Reef;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.hibernate.ScrollableResults;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class ReefServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(ReefServlet.class);

    private Long asLong(String s) {
      try {
        return new Long(s);
      } catch(Exception e) {
        return null;
      }
    }

    @Override 
    protected void doDelete(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
      UserImpl currentUser = AppUtil.getCurrentUser(req);
      if((currentUser != null) && currentUser.isSuperUser()) {
        Long reefId = asLong(req.getParameter("id"));
        if(reefId != null) {
          ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
          SurveyDao sDao = CoralwatchApplication.getConfiguration().getSurveyDao();
          Reef reef = reefDao.getById(reefId);
          if(reef != null) {
            ScrollableResults sr = sDao.getSurveysIterator(reef);
            try {
              // only allow to delete the reef if it has no surveys attached to it
              if(!sr.next()) {
                reefDao.delete(reef);
              }
            } finally {
              if(sr != null) {sr.close();}
            }
          }
        }
        res.setStatus(HttpServletResponse.SC_OK);
      } else {
        System.out.println("only admins can delete reefs");
        res.sendError(HttpServletResponse.SC_FORBIDDEN);
      }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        AppUtil.clearCache();
        ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();

        String format = req.getParameter("format");
        if (format.equals("xml")) {
            res.setContentType("text/xml;charset=utf-8");
            PrintWriter out = res.getWriter();
            try {
                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
                //creating a new instance of a DOM to build a DOM tree.
                Document doc = docBuilder.newDocument();

                Element root = doc.createElement("reefs");
                //adding a node after the last child node of the specified node.
                doc.appendChild(root);

                ScrollableResults results = reefDao.getReefsIterator();
                results.beforeFirst();
                while (results.next()) {
                    long reefId = ((Number) results.get(0)).longValue();
                    String country = (String) results.get(1);
                    String name = (String) results.get(2);
                    long numSurveyRecords = ((Number) results.get(3)).longValue();

                    Element reefNode = doc.createElement("reef");
                    root.appendChild(reefNode);

                    Element reefNameNode = doc.createElement("name");
                    reefNode.appendChild(reefNameNode);
                    Text reefName = doc.createTextNode(name);
                    reefNameNode.appendChild(reefName);

                    Element reefCountryNode = doc.createElement("country");
                    reefNode.appendChild(reefCountryNode);
                    Text countryName = doc.createTextNode(country == null || country.toLowerCase().startsWith("unknown") ? "" : country);
                    reefCountryNode.appendChild(countryName);

                    Element surveysNode = doc.createElement("surveys");
                    reefNode.appendChild(surveysNode);
                    Text surveys = doc.createTextNode(Long.toString(numSurveyRecords));
                    surveysNode.appendChild(surveys);

                    Element viewNode = doc.createElement("view");
                    reefNode.appendChild(viewNode);
                    Text view = doc.createTextNode(Long.toString(reefId));
                    viewNode.appendChild(view);

                    Element downloadNode = doc.createElement("download");
                    reefNode.appendChild(downloadNode);
                    Text download = doc.createTextNode(Long.toString(reefId));
                    downloadNode.appendChild(download);

                    if(numSurveyRecords == 0) {
                      Element deleteNode = doc.createElement("delete");
                      reefNode.appendChild(deleteNode);
                      deleteNode.appendChild(doc.createTextNode(Long.toString(reefId)));
                    }
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

        } else if (format.equals("json")) {
            String country = req.getParameter("country");
            res.setContentType("application/json;charset=utf-8");
            PrintWriter out = res.getWriter();
            JSONArray reefs = new JSONArray();
            List<Reef> listOfReefs;
            if (country.equals("all")) {
                listOfReefs = reefDao.getReefsWithSurvey();
            } else {
                listOfReefs = reefDao.getReefsWithSurvey(country);
            }
            if (listOfReefs != null && listOfReefs.size() > 0) {
                for (Reef reef : listOfReefs) {
                    try {
                        JSONObject rf = new JSONObject();
                        rf.putOpt("id", reef.getId());
                        rf.putOpt("name", reef.getName());
                        String reefCountry = reef.getCountry();
                        rf.putOpt("country", reefCountry == null || reefCountry.toLowerCase().startsWith("unknown") ? "" : reefCountry);
                        reefs.put(rf);
                    } catch (JSONException e) {
                        LOGGER.fatal("Cannot create reef json object." + e.toString());
                    }
                }
            }
            JSONObject data = new JSONObject();
            try {
                data.putOpt("identifier", "id");
                data.putOpt("label", "name");
                data.putOpt("items", reefs);
            } catch (JSONException ex) {
                LOGGER.fatal("Cannot create data json object." + ex.toString());
            }
            out.print(data);

        }
    }

}
