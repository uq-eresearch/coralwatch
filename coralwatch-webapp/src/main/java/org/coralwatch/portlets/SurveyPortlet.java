package org.coralwatch.portlets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.hibernate.ScrollableResults;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;

public class SurveyPortlet extends GenericPortlet {
    private static Log _log = LogFactoryUtil.getLog(SurveyPortlet.class);
    protected String viewJSP;
    protected UserDao userDao;
    protected SurveyDao surveyDao;
    protected SurveyRecordDao surveyRecordDao;
    protected ReefDao reefDao;
    protected SurveyRatingDao surveyRatingDao;
    private static List<String> shapes = Arrays.asList("Branching", "Boulder", "Plate", "Soft");

    @Override
    public void init() throws PortletException {
        viewJSP = getInitParameter("survey-jsp");
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
        surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        surveyRatingDao = CoralwatchApplication.getConfiguration().getSurveyRatingDao();
    }

    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        AppUtil.clearCache();
        renderRequest.setAttribute("surveyDao", surveyDao);
        renderRequest.setAttribute("userDao", userDao);
        renderRequest.setAttribute("surveyRatingDao", surveyRatingDao);
        renderRequest.setAttribute("reefs", reefDao.getAll());
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        renderRequest.setAttribute("reefUrl", prefs.getValue("reefUrl", "reef"));
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        include(viewJSP, renderRequest, renderResponse);
    }

    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
        PortletSession session = actionRequest.getPortletSession();

        List<String> errors = new ArrayList<String>();

        String cmd = ParamUtil.getString(actionRequest, Constants.CMD);
        _log.info("Command: " + cmd);
        try {
            UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
            if (currentUser != null) {
                if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
                    String groupName = actionRequest.getParameter("groupName");
                    String participatingAs = actionRequest.getParameter("participatingAs");
                    String country = actionRequest.getParameter("country");
                    String reefName = actionRequest.getParameter("reefName");
                    String latitudeStr = actionRequest.getParameter("latitude");
                    String longitudeStr = actionRequest.getParameter("longitude");
                    boolean isGpsDevice = ParamUtil.getBoolean(actionRequest, "isGpsDevice");
                    Date date = ParamUtil.getDate(actionRequest, "date", new SimpleDateFormat("yyyy-MM-dd"));
                    Date time = ParamUtil.getDate(actionRequest, "time", new SimpleDateFormat("'T'HH:mm:ss"));
                    String lightCondition = actionRequest.getParameter("lightCondition");
                    String activity = actionRequest.getParameter("activity");
                    String comments = actionRequest.getParameter("comments");

                    validateEmptyFields(
                        errors,
                        groupName,
                        participatingAs,
                        country,
                        reefName,
                        latitudeStr,
                        longitudeStr,
                        date,
                        time,
                        lightCondition,
                        activity
                    );
                    
                    Float latitude = ParamUtil.getFloat(actionRequest, "latitude");
                    Float longitude = ParamUtil.getFloat(actionRequest, "longitude");

                    boolean depthDisabled = ParamUtil.getBoolean(actionRequest, "depthDisabled", false);
                    Double depth = ParamUtil.getDouble(actionRequest, "depth", Double.NaN);
                    if (depth.isNaN()) {
                        if (!depthDisabled) {
                            errors.add("Depth is a required field unless marked 'not available'.");
                        }
                        depth = null;
                    }
                    boolean waterTemperatureDisabled = ParamUtil.getBoolean(actionRequest, "waterTemperatureDisabled", false);
                    Double waterTemperature = ParamUtil.getDouble(actionRequest, "waterTemperature", Double.NaN);
                    if (waterTemperature.isNaN()) {
                        if (!waterTemperatureDisabled) {
                            errors.add("Water temperature is a required field unless marked 'not available'.");
                        }
                        waterTemperature = null;
                    }

                    if (errors.isEmpty()) {
                        Reef reef = reefDao.getReefByName(reefName);
                        if (reef == null) {
                            reef = new Reef(reefName, country);
                            reefDao.save(reef);
                        }
                        if (cmd.equals(Constants.ADD)) {
                            Survey survey = new Survey();
                            survey.setCreator(currentUser);
                            survey.setGroupName(groupName);
                            survey.setParticipatingAs(participatingAs);
                            survey.setReef(reef);
                            survey.setQaState("Post Migration");
                            survey.setLatitude(latitude);
                            survey.setLongitude(longitude);
                            survey.setGPSDevice(isGpsDevice);
                            survey.setDate(date);
                            survey.setTime(time);
                            survey.setLightCondition(lightCondition);
                            survey.setDepth(depth);
                            survey.setWaterTemperature(waterTemperature);
                            survey.setActivity(activity);
                            survey.setComments(comments);
                            surveyDao.save(survey);
                            _log.info("Added survey");
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                        } else if (cmd.equals(Constants.EDIT)) {
                            long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                            Survey survey = surveyDao.getById(suveyId);
                            survey.setDateModified(new Date());
                            survey.setGroupName(groupName);
                            survey.setParticipatingAs(participatingAs);
                            survey.setReef(reef);
                            survey.setLatitude(latitude);
                            survey.setLongitude(longitude);
                            survey.setGPSDevice(isGpsDevice);
                            survey.setDate(date);
                            survey.setTime(time);
                            survey.setLightCondition(lightCondition);
                            survey.setDepth(depth);
                            survey.setWaterTemperature(waterTemperature);
                            survey.setActivity(activity);
                            survey.setComments(comments);
                            surveyDao.update(survey);
                            _log.info("Edited survey");
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                        }
                    } else {
                        actionResponse.setRenderParameter(Constants.CMD, cmd);
                        actionRequest.setAttribute("errors", errors);
                        if (cmd.equals(Constants.EDIT)) {
                            actionResponse.setRenderParameter("surveyId", String.valueOf(ParamUtil.getLong(actionRequest, "surveyId")));
                        }
                    }
                } else if (cmd.equals(Constants.DELETE)) {
                    long suveyId = ParamUtil.getLong(actionRequest, "surveyId");
                    Survey survey = surveyDao.getById(suveyId);
                    List<SurveyRecord> surveyRecords = surveyDao.getSurveyRecords(survey);
                    for (SurveyRecord record : surveyRecords) {
                        record.getSurvey().getDataset().remove(record);
                        surveyRecordDao.delete(record);
                    }
                    surveyDao.delete(survey);
                    AppUtil.clearCache();
                }
            } else {
                errors.add("You must be signed in to submit a survey.");
                actionRequest.setAttribute("errors", errors);
                actionResponse.setRenderParameter(Constants.CMD, cmd);
            }

        } catch (Exception ex) {
            errors.add("Your submission contains invalid data. Check all fields.");
            actionRequest.setAttribute("errors", errors);
            actionResponse.setRenderParameter(Constants.CMD, cmd);
            _log.error("Submission error ", ex);
        }


    }

    private void validateEmptyFields(
        List<String> errors,
        String groupName,
        String participatingAs,
        String country,
        String reefName,
        String latitudeStr,
        String longitudeStr,
        Date date,
        Date time,
        String lightCondition,
        String activity
    ) {
        List<String> emptyFields = new ArrayList<String>();
        if (groupName == null || groupName.trim().isEmpty()) {
            emptyFields.add("Group Name");
        }
        if (participatingAs == null || participatingAs.trim().isEmpty()) {
            emptyFields.add("Participating As");
        }
        if (country == null || country.trim().isEmpty()) {
            emptyFields.add("Country");
        }
        if (reefName == null || reefName.trim().isEmpty()) {
            emptyFields.add("Reef Name");
        }
        if (latitudeStr == null || latitudeStr.trim().isEmpty()) {
            emptyFields.add("Latitude");
        }
        if (longitudeStr == null || longitudeStr.trim().isEmpty()) {
            emptyFields.add("Longitude");
        }
        if (date == null || date.toString().trim().isEmpty()) {
            emptyFields.add("Date");
        }
        if (time == null || time.toString().trim().isEmpty()) {
            emptyFields.add("Time");
        }
        if (lightCondition == null || lightCondition.trim().isEmpty()) {
            emptyFields.add("Light Condition");
        }
        if (activity == null || activity.trim().isEmpty()) {
            emptyFields.add("Activity");
        }

        if (!emptyFields.isEmpty()) {
            String fields = "";
            for (String field : emptyFields) {
                fields = fields + " " + field;
            }
            errors.add("Required field(s):" + fields);
        }
    }
    
    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        if (request.getResourceID().equals("export")) {
            serveExportResource(request, response);
        }
    }
    
    protected static void serveExportResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        AppUtil.clearCache();
        
        ScrollableResults surveys = null;
        String fileNamePrefix = null;
        
        String reefIdParam = request.getParameter("reefId");
        if (reefIdParam != null) {
            ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
            Reef reef = reefDao.getById(Long.valueOf(reefIdParam));
            SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
            surveys = surveyDao.getSurveysIterator(reef);
            fileNamePrefix = reef.getName();
        }
        else {
            PortletSession session = request.getPortletSession(true);
            UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
            if (currentUser == null || !currentUser.isSuperUser()) {
                throw new PortletException("Only the administrator can export all survey data");
            }
            SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
            surveys = surveyDao.getSurveysIterator();
            fileNamePrefix = "surveys";
        }
        
        String singleSheetParam = request.getParameter("singleSheet");
        boolean singleSheet = (singleSheetParam != null && singleSheetParam.equals("true"));
        
        String fileName = fileNamePrefix + "-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls";
        response.addProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"");
        response.setProperty(ResourceResponse.EXPIRATION_CACHE, "0");
        response.setContentType("application/vnd.ms-excel;charset=utf-8");

        HSSFWorkbook workbook = new HSSFWorkbook();
        
        HSSFCellStyle dateStyle = workbook.createCellStyle();
        dateStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/MM/yyyy"));
        HSSFCellStyle timeStyle = workbook.createCellStyle();
        timeStyle.setDataFormat(workbook.createDataFormat().getFormat("HH:mm"));
        
        if (!singleSheet) {
            writeSurveySheet(workbook, surveys, dateStyle, timeStyle);
        }
        writeSurveyRecordSheet(workbook, surveys, singleSheet, dateStyle, timeStyle);
        
        workbook.write(response.getPortletOutputStream());
    }

    private static void writeSurveySheet(
        HSSFWorkbook workbook,
        ScrollableResults surveys,
        HSSFCellStyle dateStyle,
        HSSFCellStyle timeStyle
    ) {
        HSSFSheet sheet = workbook.createSheet("Surveys");
        HSSFRow headerRow = sheet.createRow(0);
        int c = addSurveyHeaderCells(headerRow, 0);
        int r = 1;
        surveys.beforeFirst();
        while (surveys.next()) {
            Survey survey = (Survey) surveys.get(0);
            HSSFRow row = sheet.createRow(r++);
            try {
                addSurveyDataCells(row, survey, dateStyle, timeStyle, 0);
            }
            catch (Exception e) {
                _log.error(e);
            }
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }

    private static int addSurveyDataCells(HSSFRow row, Survey survey, HSSFCellStyle dateStyle, HSSFCellStyle timeStyle, int c) {
        Map<String, Long> shapeCounts = new HashMap<String, Long>();
        for (String shape : shapes) {
            shapeCounts.put(shape, 0l);
        }
        long sumLight = 0;
        long sumDark = 0;
        for (SurveyRecord record : survey.getDataset()) {
            if (shapeCounts.containsKey(record.getCoralType())) {
                shapeCounts.put(record.getCoralType(), shapeCounts.get(record.getCoralType()) + 1);
            }
            sumLight += record.getLightestNumber();
            sumDark += record.getDarkestNumber();
        }
        int numRecords = survey.getDataset().size();
        row.createCell(c++).setCellValue(survey.getId());
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getCreator().getDisplayName()));
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getGroupName()));
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getParticipatingAs()));
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getReef().getName()));
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getReef().getCountry()));
        {
            HSSFCell cell = row.createCell(c++);
            if (survey.getLongitude() != null) {
                cell.setCellValue(survey.getLongitude());
            }
        }
        {
            HSSFCell cell = row.createCell(c++);
            if (survey.getLatitude() != null) {
                cell.setCellValue(survey.getLatitude());
            }
        }
        {
            HSSFCell cell = row.createCell(c++);
            cell.setCellStyle(dateStyle);
            if (survey.getDate() != null) {
                cell.setCellValue(survey.getDate());
            }
        }
        {
            HSSFCell cell = row.createCell(c++);
            cell.setCellStyle(timeStyle);
            if (survey.getTime() != null) {
                cell.setCellValue(survey.getTime());
            }
        }
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getLightCondition()));
        {
            HSSFCell cell = row.createCell(c++);
            if (survey.getDepth() != null) {
                cell.setCellValue(survey.getDepth());
            }
        }
        {
            HSSFCell cell = row.createCell(c++);
            if (survey.getWaterTemperature() != null) {
                cell.setCellValue(survey.getWaterTemperature());
            }
        }
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getActivity()));
        row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getComments()));
        row.createCell(c++).setCellValue(numRecords);
        for (String shape : shapes) {
            row.createCell(c++).setCellValue(shapeCounts.get(shape));
        }
        row.createCell(c++).setCellValue(sumLight / (double) numRecords);
        row.createCell(c++).setCellValue(sumDark / (double) numRecords);
        row.createCell(c++).setCellValue((sumLight + sumDark) / (2d * numRecords));
        return c;
    }
    
    private static int addSurveyHeaderCells(HSSFRow row, int c) {
        row.createCell(c++).setCellValue(new HSSFRichTextString("Survey"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Creator"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Group Name"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Participating As"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Reef"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Country"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Longitude"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Latitude"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Date"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Time"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Light Condition"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Depth"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Water Temperature"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Activity"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Comments"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Number of records"));
        for (String shape : shapes) {
            row.createCell(c++).setCellValue(new HSSFRichTextString(shape));
        }
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average lightest"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average darkest"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average overall"));
        return c;
    }

    private static void writeSurveyRecordSheet(
        HSSFWorkbook workbook,
        ScrollableResults surveys,
        boolean includeSurveyColumns,
        HSSFCellStyle dateStyle,
        HSSFCellStyle timeStyle
    ) {
        HSSFSheet sheet = workbook.createSheet("Survey Records");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        if (includeSurveyColumns) {
            c = addSurveyHeaderCells(row, c);
        }
        else {
            row.createCell(c++).setCellValue(new HSSFRichTextString("Survey"));
            row.createCell(c++).setCellValue(new HSSFRichTextString("Creator"));
            row.createCell(c++).setCellValue(new HSSFRichTextString("Reef"));
            row.createCell(c++).setCellValue(new HSSFRichTextString("Date"));
            row.createCell(c++).setCellValue(new HSSFRichTextString("Time"));
        }
        row.createCell(c++).setCellValue(new HSSFRichTextString("Coral Type"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Lightest Letter"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Lightest Number"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Darkest Letter"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Darkest Number"));
        int r = 1;
        surveys.beforeFirst();
        while (surveys.next()) {
            Survey survey = (Survey) surveys.get(0);
            for (SurveyRecord record : survey.getDataset()) {
                row = sheet.createRow(r++);
                try {
                    c = 0;
                    if (includeSurveyColumns) {
                        c = addSurveyDataCells(row, survey, dateStyle, timeStyle, c);
                    }
                    else {
                        row.createCell(c++).setCellValue(record.getSurvey().getId());
                        row.createCell(c++).setCellValue(new HSSFRichTextString(record.getSurvey().getCreator().getDisplayName()));
                        row.createCell(c++).setCellValue(new HSSFRichTextString(record.getSurvey().getReef().getName()));
                        {
                            HSSFCell cell = row.createCell(c++);
                            cell.setCellStyle(dateStyle);
                            if (record.getSurvey().getDate() != null) {
                                cell.setCellValue(record.getSurvey().getDate());
                            }
                        }
                        {
                            HSSFCell cell = row.createCell(c++);
                            cell.setCellStyle(timeStyle);
                            if (record.getSurvey().getTime() != null) {
                                cell.setCellValue(record.getSurvey().getTime());
                            }
                        }
                    }
                    row.createCell(c++).setCellValue(new HSSFRichTextString(record.getCoralType()));
                    row.createCell(c++).setCellValue(new HSSFRichTextString(String.valueOf(record.getLightestLetter())));
                    row.createCell(c++).setCellValue(record.getLightestNumber());
                    row.createCell(c++).setCellValue(new HSSFRichTextString(String.valueOf(record.getDarkestLetter())));
                    row.createCell(c++).setCellValue(record.getDarkestNumber());
                }
                catch (Exception e) {
                    _log.error(e);
                }
            }
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
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

    @Override
    public void destroy() {
        if (_log.isInfoEnabled()) {
            _log.info("Destroying portlet");
        }
    }

}
