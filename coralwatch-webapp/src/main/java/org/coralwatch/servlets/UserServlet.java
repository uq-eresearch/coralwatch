package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
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
import java.util.Random;

public class UserServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(UserServlet.class);

    protected UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        AppUtil.clearCache();
        PrintWriter out = res.getWriter();
        String format = req.getParameter("format");
        if (format.equals("xml")) {
            res.setContentType("text/xml");
            try {
                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
                Document doc = docBuilder.newDocument();

                //creating a new instance of a DOM to build a DOM tree.

                Element root = doc.createElement("members");
                //adding a node after the last child node of the specified node.
                doc.appendChild(root);

                UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
                List<UserImpl> listOfUsers = userDao.getAll();
                for (UserImpl user : listOfUsers) {
                    Element userNode = doc.createElement("member");
                    root.appendChild(userNode);

                    Element nameNode = doc.createElement("name");
                    userNode.appendChild(nameNode);
                    Text userName = doc.createTextNode(user.getDisplayName());
                    nameNode.appendChild(userName);

                    Element joinedDateNode = doc.createElement("joined");
                    userNode.appendChild(joinedDateNode);
                    Text joinedDate = doc.createTextNode(user.getRegistrationDate().getTime() + "");
                    joinedDateNode.appendChild(joinedDate);

                    Element countryNode = doc.createElement("country");
                    userNode.appendChild(countryNode);
                    String country = user.getCountry();
                    Text countryName = doc.createTextNode(country == null ? "Not Available" : country);
                    countryNode.appendChild(countryName);

                    Element surveysNode = doc.createElement("surveys");
                    userNode.appendChild(surveysNode);
                    Text numberOfSurveys = doc.createTextNode(userDao.getSurveyEntriesCreated(user).size() + "");
                    surveysNode.appendChild(numberOfSurveys);

                    Random rand = new Random();
                    Element ratingNode = doc.createElement("rating");
                    userNode.appendChild(ratingNode);
                    Text rating = doc.createTextNode(rand.nextInt(5) + "");
                    ratingNode.appendChild(rating);

                    Element viewNode = doc.createElement("view");
                    userNode.appendChild(viewNode);
                    Text viewLink = doc.createTextNode(user.getId() + "");
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
            catch (Exception ex) {
                LOGGER.fatal("Cannot create user xml list.", ex);
            }

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AppUtil.clearCache();
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        String cmd = req.getParameter("cmd");
        String email = req.getParameter("email");
        String id = req.getParameter("id");

        if (cmd.equalsIgnoreCase("reset")) {
            UserImpl user = userDao.getByEmail(email);
            //if user's reset id is
            if (user.getPasswordResetId().equals(id)) {
                //generate password

                //reset password

                //send email
            }
        }
    }

}

