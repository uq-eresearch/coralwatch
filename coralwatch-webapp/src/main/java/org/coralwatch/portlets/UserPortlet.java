package org.coralwatch.portlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletContext;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.PortletSession;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.UserRatingDao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.services.ReputationService;
import org.coralwatch.util.AppUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import au.edu.uq.itee.maenad.util.BCrypt;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;

public class UserPortlet extends GenericPortlet {

    private static Log _log = LogFactoryUtil.getLog(UserPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected UserRatingDao userRatingDao;

    public void init() throws PortletException {
        viewJSP = getInitParameter("user-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        userRatingDao = CoralwatchApplication.getConfiguration().getRatingDao();
    }

    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        renderRequest.setAttribute("userDao", userDao);
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        renderRequest.setAttribute("userPageUrl", prefs.getValue("userPageUrl", "user"));
        include(viewJSP, renderRequest, renderResponse);
    }

    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        PortletSession session = actionRequest.getPortletSession(true);
        List<String> errors = new ArrayList<String>();
        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);

        String email = actionRequest.getParameter("email");
        String email2 = actionRequest.getParameter("email2");
        String password = actionRequest.getParameter("password");
        String password2 = actionRequest.getParameter("password2");
        String displayName = actionRequest.getParameter("displayName");
        String firstName = actionRequest.getParameter("firstName");
        String lastName = actionRequest.getParameter("lastName");
        String addressLine1 = actionRequest.getParameter("addressLine1");
        String addressLine2 = actionRequest.getParameter("addressLine2");
        String city = actionRequest.getParameter("city");
        String state = actionRequest.getParameter("state");
        String postcode = actionRequest.getParameter("postcode");
        String country = actionRequest.getParameter("country");
        String phone = actionRequest.getParameter("phone");
        String positionDescription = actionRequest.getParameter("positionDescription");
        long userId = ParamUtil.getLong(actionRequest, "userId");

        if (cmd.equals(Constants.ADD)) {
            if (
                (email == null || email.isEmpty()) ||
                (firstName == null || firstName.isEmpty()) ||
                (lastName == null || lastName.isEmpty()) ||
                (displayName == null || displayName.isEmpty()) ||
                (password == null) ||
                (country == null || country.isEmpty())
            ) {
                errors.add("Please complete required fields.");
            } else {
                if (!email.equals(email2)) {
                    errors.add("Confirm your email address.");
                } else {
                    if (password.length() < 6) {
                        errors.add("Password must be at least 6 characters.");
                    } else {
                        if (!password.equals(password2)) {
                            errors.add("Confirm your password.");
                        } else {
                            if (userDao.getByEmail(email) != null) {
                                errors.add("An account with the same email already exists.");
                            } else {
                                UserImpl userImpl = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
                                userImpl.setAddressLine1(addressLine1);
                                userImpl.setAddressLine2(addressLine2);
                                userImpl.setCity(city);
                                userImpl.setState(state);
                                userImpl.setPostcode(postcode);
                                userImpl.setCountry(country);
                                userImpl.setFirstName(firstName);
                                userImpl.setLastName(lastName);
                                userDao.save(userImpl);
                                actionResponse.setRenderParameter("userId", String.valueOf(userImpl.getId()));
                                actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                                //reset user object stored on session
                                UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
                                if ((currentUser != null) && (currentUser.getId() == userImpl.getId())) {
                                    session.setAttribute("currentUser", userImpl, PortletSession.APPLICATION_SCOPE);
                                }
                            }
                        }


                    }
                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter(Constants.CMD, Constants.ADD);
                actionRequest.setAttribute("errors", errors);
            }
        } else if (cmd.equals(Constants.EDIT)) {
            if (
                (
                    StringUtils.isNotBlank(addressLine1) ||
                    StringUtils.isNotBlank(addressLine2) ||
                    StringUtils.isNotBlank(city) ||
                    StringUtils.isNotBlank(state) ||
                    StringUtils.isNotBlank(postcode)
                )
                &&
                (
                    StringUtils.isBlank(addressLine1) ||
                    StringUtils.isBlank(city) ||
                    StringUtils.isBlank(state) ||
                    StringUtils.isBlank(postcode)
                )
            ) {
                errors.add("Addresses must include Address Line 1, City, State, and Postcode (or leave all blank).");
            }
            if (
                (email == null || email.isEmpty()) ||
                (firstName == null || firstName.isEmpty()) ||
                (lastName == null || lastName.isEmpty()) ||
                (displayName == null || displayName.isEmpty()) ||
                (password == null) ||
                (country == null || country.isEmpty())
            ) {
                errors.add("Please complete required fields.");
            } else {
                UserImpl user = userDao.getById(userId);
                if (!email.equals(user.getEmail()) && !email.equals(email2)) {
                    errors.add("Confirm your email address.");
                } else {
                    UserImpl userByEmail = userDao.getByEmail(email);
                    if (userByEmail != null && userByEmail.getId() != userId) {
                        errors.add("Email address is already used.");
                    } else {
                        if (password != null && password2 != null && password.length() >= 6 && password.equals(password2)) {
                            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
                        }
                        user.setEmail(email);
                        user.setDisplayName(displayName);
                        user.setFirstName(firstName);
                        user.setLastName(lastName);
//                                user.setOccupation(occupation);
                        user.setPhone(phone);
                        user.setPositionDescription(positionDescription);
                        user.setAddressLine1(addressLine1);
                        user.setAddressLine2(addressLine2);
                        user.setCity(city);
                        user.setState(state);
                        user.setPostcode(postcode);
                        user.setCountry(country);
                        userDao.update(user);
                        AppUtil.clearCache();
                        actionResponse.setRenderParameter("userId", String.valueOf(user.getId()));
                        actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                        //reset user object stored on session
                        UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
                        if ((currentUser != null) && (currentUser.getId() == user.getId())) {
                            session.setAttribute("currentUser", user, PortletSession.APPLICATION_SCOPE);
                        }
                    }

                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter("userId", String.valueOf(userId));
                actionResponse.setRenderParameter(Constants.CMD, Constants.EDIT);
                actionRequest.setAttribute("errors", errors);
            }
        } else if (cmd.equals(Constants.RESET)) {
            String resetPassword = actionRequest.getParameter("resetpassword");
            String resetPassword2 = actionRequest.getParameter("resetpassword2");
            String resetid = actionRequest.getParameter("resetid");
            if (resetPassword.length() < 6) {
                errors.add("Password must be at least 6 characters.");
            }
            else if (!resetPassword.equals(resetPassword2)) {
                errors.add("Password and confirmation don't match.");
            }
            else {
                UserImpl user = userDao.getById(userId);
                if (resetid.equals(user.getPasswordResetId())) {
                    user.setPasswordHash(BCrypt.hashpw(resetPassword, BCrypt.gensalt()));
                    UUID uuid = UUID.randomUUID();
                    String passwordResetId = uuid.toString();
                    user.setPasswordResetId(passwordResetId);
                    userDao.update(user);
                    AppUtil.clearCache();
//                    actionResponse.setRenderParameter("userId", String.valueOf(user.getId()));
                    actionResponse.setRenderParameter("successMsg", "Your password has been updated successfully.");
                    actionResponse.setRenderParameter(Constants.CMD, Constants.PRINT);
                    //reset user object stored on session
                    UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
                    if ((currentUser != null) && (currentUser.getId() == user.getId())) {
                        session.setAttribute("currentUser", user, PortletSession.APPLICATION_SCOPE);
                    }
                } else {
                    errors.add("Invalid password reset request.");
                }
            }
            if (errors.size() > 0) {
                actionResponse.setRenderParameter("userId", String.valueOf(userId));
                actionResponse.setRenderParameter("resetid", String.valueOf(resetid));
                actionResponse.setRenderParameter(Constants.CMD, Constants.RESET);
                actionRequest.setAttribute("errors", errors);
            }
        }
    }
    
    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        if (request.getResourceID().equals("ajax")) {
            serveAjaxResourse(request, response);
        }
        else if (request.getResourceID().equals("export")) {
            serveExportResource(request, response);
        }
    }

    private void serveAjaxResourse(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        response.setContentType("text/xml;charset=utf-8");
        response.setProperty(ResourceResponse.EXPIRATION_CACHE, "0");
        PrintWriter out = response.getWriter();
        try {
            DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
            Document doc = docBuilder.newDocument();

            //creating a new instance of a DOM to build a DOM tree.

            Element root = doc.createElement("members");
            //adding a node after the last child node of the specified node.
            doc.appendChild(root);

            UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();

            String friendsOfStr = request.getParameter("friendsOf");
            List<UserImpl> listOfUsers;
            if (friendsOfStr != null) {
                long friendsOfId = Long.valueOf(friendsOfStr);
                UserImpl friendsOfUser = userDao.getById(friendsOfId);
                listOfUsers = ReputationService.getRateesFor(friendsOfUser);
            } else {
                listOfUsers = userDao.getAll();
            }

            for (UserImpl user : listOfUsers) {
                if (!user.getDisplayName().toLowerCase().startsWith("unknown")) {
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
                    Text countryName = doc.createTextNode(country == null || country.toLowerCase().startsWith("unknown") ? "" : country);
                    countryNode.appendChild(countryName);

                    Element surveysNode = doc.createElement("surveys");
                    userNode.appendChild(surveysNode);
                    Text numberOfSurveys = doc.createTextNode(userDao.getSurveyEntriesCreated(user).size() + "");
                    surveysNode.appendChild(numberOfSurveys);

                    //Rating stuff
                    if (CoralwatchApplication.getConfiguration().isRatingSetup()) {

                        Element ratingNode = doc.createElement("rating");
                        userNode.appendChild(ratingNode);
                        Double overAllRating = ReputationService.getOverAllRating(user);
                        Text rating = doc.createTextNode(overAllRating + "");

                        ratingNode.appendChild(rating);
                    }

                    Element viewNode = doc.createElement("view");
                    userNode.appendChild(viewNode);
                    Text viewLink = doc.createTextNode(user.getId() + "");
                    viewNode.appendChild(viewLink);
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
        catch (Exception ex) {
            _log.fatal("Cannot create user xml list.", ex);
        }
    }
    
    private void serveExportResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        PortletSession session = request.getPortletSession(true);
        UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        if (currentUser == null || !currentUser.isSuperUser()) {
            throw new PortletException("Only the administrator can export member details");
        }
        response.setContentType("application/vnd.ms-excel");
        String fileName = "users-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls";
        response.addProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"");
        response.setProperty(ResourceResponse.EXPIRATION_CACHE, "0");
        try {
            HSSFWorkbook workbook = new HSSFWorkbook();
            
            HSSFCellStyle headerCellStyle = workbook.createCellStyle();
            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            headerCellStyle.setFont(font);
            
            HSSFCellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/mm/yyyy"));
            
            HSSFSheet sheet = workbook.createSheet("Users");
            {
                HSSFRow row = sheet.createRow(0);
                
                int columnIndex = 0;
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Display name"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 40 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("First name"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 20 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Last name"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 20 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Email address"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 40 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Country"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 30 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Date registered"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 20 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Date last entered data"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 20 * 256);
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString("Surveys"));
                    cell.setCellStyle(headerCellStyle);
                    sheet.setColumnWidth(cell.getColumnIndex(), 10 * 256);
                }
            }
            List<UserImpl> users = userDao.getAll();
            for (int i = 0; i < users.size(); i++) {
                UserImpl user = users.get(i);
                Date dateLastEnteredData = null;
                List<Survey> surveys = userDao.getSurveyEntriesCreated(user);
                for (Survey survey : surveys) {
                    if (dateLastEnteredData == null || survey.getDateModified().after(dateLastEnteredData)) {
                        dateLastEnteredData = survey.getDateModified();
                    }
                }
                HSSFRow row = sheet.createRow(1 + i);
                int columnIndex = 0;
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString(user.getDisplayName()));
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString(user.getFirstName()));
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString(user.getLastName()));
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString(user.getEmail()));
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(new HSSFRichTextString(user.getCountry()));
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellStyle(dateCellStyle);
                    if (user.getRegistrationDate() != null) {
                        cell.setCellValue(user.getRegistrationDate());
                    }
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellStyle(dateCellStyle);
                    if (dateLastEnteredData != null) {
                        cell.setCellValue(dateLastEnteredData);
                    }
                }
                {
                    HSSFCell cell = row.createCell(columnIndex++);
                    cell.setCellValue(surveys.size());
                }
            }
            workbook.write(response.getPortletOutputStream());
            response.getPortletOutputStream().close();
        }
        catch (Exception e) {
            throw new PortletException("Exception creating user spreadsheet", e);
        }
    }
    
    protected void include(String path, RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

        PortletContext portletContext = getPortletContext();
        PortletRequestDispatcher portletRequestDispatcher = portletContext.getRequestDispatcher(path);

        if (portletRequestDispatcher == null) {
            _log.error(path + " is not a valid include");
        } else {
            try {
                portletRequestDispatcher.include(renderRequest, renderResponse);
            } catch (Exception e) {
                _log.error(e, e);
                portletRequestDispatcher = portletContext.getRequestDispatcher("/error.jsp");

                if (portletRequestDispatcher == null) {
                    _log.error("/error.jsp is not a valid include");
                } else {
                    portletRequestDispatcher.include(renderRequest, renderResponse);
                }
            }
        }
    }

    public void destroy() {
        if (_log.isInfoEnabled()) {
            _log.info("Destroying portlet");
        }
    }

}
