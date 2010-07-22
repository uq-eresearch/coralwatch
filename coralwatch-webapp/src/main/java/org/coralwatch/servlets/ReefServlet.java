package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.util.AppUtil;
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

public class ReefServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(SurveyServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        AppUtil.clearCache();
        PrintWriter out = res.getWriter();
        ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();

        String format = req.getParameter("format");
        if (format.equals("xml")) {
            res.setContentType("text/xml");
            try {
                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
                //creating a new instance of a DOM to build a DOM tree.
                Document doc = docBuilder.newDocument();

                Element root = doc.createElement("reefs");
                //adding a node after the last child node of the specified node.
                doc.appendChild(root);

                List<Reef> listOfReefs = reefDao.getAll();

                for (Reef reef : listOfReefs) {
                    Element reefNode = doc.createElement("reef");
                    root.appendChild(reefNode);

                    Element reefNameNode = doc.createElement("name");
                    reefNode.appendChild(reefNameNode);
                    Text reefName = doc.createTextNode(reef.getName());
                    reefNameNode.appendChild(reefName);

                    Element reefCountryNode = doc.createElement("country");
                    reefNode.appendChild(reefCountryNode);
                    Text countryName = doc.createTextNode(reef.getCountry());
                    reefCountryNode.appendChild(countryName);

                    Element surveysNode = doc.createElement("surveys");
                    reefNode.appendChild(surveysNode);
                    Text surveys = doc.createTextNode(reefDao.getSurveysByReef(reef).size() + "");
                    surveysNode.appendChild(surveys);

                    Element viewNode = doc.createElement("view");
                    reefNode.appendChild(viewNode);
                    Text view = doc.createTextNode(reef.getId() + "");
                    viewNode.appendChild(view);

                    Element downloadNode = doc.createElement("download");
                    reefNode.appendChild(downloadNode);
                    Text download = doc.createTextNode(reef.getId() + "");
                    downloadNode.appendChild(download);

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
