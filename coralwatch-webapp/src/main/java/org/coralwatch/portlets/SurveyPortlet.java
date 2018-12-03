package org.coralwatch.portlets;

import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Pattern;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
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
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRatingDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.dataaccess.jpa.JpaConnectorService;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.coralwatch.util.Emailer;
import org.hibernate.ScrollableResults;
import org.json.JSONException;
import org.json.JSONWriter;

import au.com.bytecode.opencsv.CSVWriter;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.util.PortalUtil;

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
        String cmd = ParamUtil.getString(renderRequest, Constants.CMD);
        PortletSession session = renderRequest.getPortletSession();
        UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
        if (cmd.equals("bulk_add") && ((currentUser == null) || !currentUser.isSuperUser())) {
            List<String> errors = new ArrayList<String>();
            errors.add("You must be admin to do bulk uploads");
            renderRequest.setAttribute("errors", errors);
        }
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
                if (cmd.equals("bulk_add")) {
                    UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(actionRequest);
                    if (currentUser.isSuperUser()) {
                        String type = uploadRequest.getParameter("type");
                        if (ObjectUtils.equals(type, "standard")) {
                            processStandardBulkUploadAction(uploadRequest, actionResponse, cmd, currentUser, errors);
                        }
                        else if (ObjectUtils.equals(type, "surg")) {
                            processSURGBulkUploadAction(uploadRequest, actionResponse, cmd, currentUser, errors);
                        }
                        else {
                            errors.add("Unrecognised spreadsheet type: " + String.valueOf(type));
                        }
                    } else {
                        errors.add("You must be admin to do bulk uploads");
                    }
                    if (!errors.isEmpty()) {
                        uploadRequest.setAttribute("errors", errors);
                        actionResponse.setRenderParameter(Constants.CMD, cmd);
                    }
                } else if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
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
                    Survey.ReviewState reviewState = null;
                    if (currentUser.isSuperUser() && cmd.equals(Constants.EDIT)) {
                        reviewState = Survey.ReviewState.valueOf(actionRequest.getParameter("reviewState"));
                    }

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
                            survey.setReviewState(Survey.ReviewState.UNREVIEWED);
                            surveyDao.save(survey);
                            _log.info("Added survey");
                            actionResponse.setRenderParameter("surveyId", String.valueOf(survey.getId()));
                            actionResponse.setRenderParameter(Constants.CMD, Constants.VIEW);
                            sendNewSurveyEmail(currentUser, String.valueOf(survey.getId()));
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
                            if (currentUser.isSuperUser()) {
                                survey.setReviewState(reviewState);
                            }
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
    
    private void sendNewSurveyEmail(UserImpl currentUser, String surveyId) {
      try {
        Emailer.sendNewSurveyEmail(currentUser.getEmail(), surveyId);
      } catch(Exception e) {
        _log.warn("sending of new survey email failed", e);
      }
    }

    private enum StandardBulkImportColumns {
        GROUP_NAME("Group Name", true),
        PARTICIPATING_AS("Participating as", true),
        COUNTRY("Country of Survey", true),
        REEF_NAME("Reef Name", true),
        IS_GPS_DEVICE("I used a GPS", true),
        LATITUDE("Latitude", true),
        LONGITUDE("Longitude", true),
        DATE("Observation Date", true),
        TIME("Time", true),
        LIGHT_CONDITION("Light condition", true),
        DEPTH_METRES("Depth (m)", false),
        DEPTH_FEET("Depth (feet)", false),
        WATER_TEMPERATURE_C("Water Temp. (C)", false),
        WATER_TEMPERATURE_F("Water Temp. (F)", false),
        ACTIVITY("Activity", true),
        CORAL_TYPE("Coral Type", true),
        LIGHT("Light", true),
        DARK("Dark", true),
        COMMENTS("Comments", false);

        private final String title;

        private final boolean mandatory;

        StandardBulkImportColumns(String title, boolean mandatory) {
            this.title = title;
            this.mandatory = mandatory;
        }

        public String getTitle() {
            return title;
        }

        public boolean getMandatory() {
            return mandatory;
        }

        public static List<StandardBulkImportColumns> getMandatoryColumns() {
            List<StandardBulkImportColumns> mandatoryColumns = new ArrayList<StandardBulkImportColumns>();
            for (StandardBulkImportColumns column : StandardBulkImportColumns.values()) {
                if (column.getMandatory()) {
                    mandatoryColumns.add(column);
                }
            }
            return mandatoryColumns;
        }
    }
    
    private <T> T getColumnValue(
        EnumMap<StandardBulkImportColumns, List<Object>> columnValuesMap,
        StandardBulkImportColumns column,
        Class<T> clazz
    ) {
        List<Object> values = columnValuesMap.get(column);
        if ((values == null) || values.isEmpty()) {
            return null;
        }
        Object value = values.get(0);
        if (String.class.isInstance(value) && StringUtils.isBlank(String.valueOf(value))) {
            return null;
        }
        if (clazz.isInstance(value)) {
            return clazz.cast(value);
        }
        if((clazz == Date.class) && (value instanceof String)) {
          Date guessed = guessDate((String)value);
          if(guessed != null) {
            return clazz.cast(guessed);
          }
        }
        throw new RuntimeException(
            "Expected " + clazz.getSimpleName() + " " +
            "for " + column.getTitle() + " " +
            "but got " + value.getClass().getSimpleName() + " " +
            "\"" + String.valueOf(value) + "\""
        );
    }

    private Date guessDate(String s) {
      if(StringUtils.isBlank(s)) {
        return null;
      }
      try {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.parse(s);
      } catch(ParseException e) {}
      try {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        return sdf.parse(s);
      } catch(ParseException e) {}
      return null;
    }

    private void processStandardBulkUploadAction(
        UploadPortletRequest uploadRequest,
        ActionResponse actionResponse,
        String cmd,
        UserImpl currentUser,
        List<String> errors
    ) {
        JpaConnectorService jpaConnectorService = CoralwatchApplication.getConfiguration().getJpaConnectorService();
        EntityManager entityManager = jpaConnectorService.getEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            String fieldName = "file";
            File file = uploadRequest.getFile(fieldName);
            Workbook workbook = null;
            try {
                workbook = WorkbookFactory.create(file);
            }
            catch (Exception e) {
                errors.add("Could not read spreadsheet file (must be *.xls or *.xlsx)");
                return;
            }
            Sheet sheet = null;
            try {
                sheet = workbook.getSheetAt(0);
            }
            catch (Exception e) {
                errors.add("Could not find sheet inside spreadsheet");
                return;
            }
            List<StandardBulkImportColumns> mandatoryColumns = StandardBulkImportColumns.getMandatoryColumns();
            int headerRowIndex = -1;
            EnumMap<StandardBulkImportColumns, List<Integer>> columnIndicesMap =
                new EnumMap<StandardBulkImportColumns, List<Integer>>(StandardBulkImportColumns.class);
            for (Row row : sheet) {
                columnIndicesMap.clear();
                for (Cell cell : row) {
                    String cellValue =
                        (cell.getCellType() == Cell.CELL_TYPE_NUMERIC)
                        ? String.valueOf(cell.getNumericCellValue())
                        : cell.getStringCellValue().trim();
                    for (StandardBulkImportColumns column : StandardBulkImportColumns.values()) {
                        if (column.getTitle().equalsIgnoreCase(cellValue)) {
                            List<Integer> columnIndices = columnIndicesMap.get(column);
                            if (columnIndices == null) {
                                columnIndices = new ArrayList<Integer>();
                                columnIndicesMap.put(column, columnIndices);
                            }
                            columnIndices.add(cell.getColumnIndex());
                        }
                    }
                }
                if (columnIndicesMap.keySet().containsAll(mandatoryColumns)) {
                    headerRowIndex = row.getRowNum();
                    break;
                }
            }
            if (headerRowIndex == -1) {
                StringBuilder colNames = new StringBuilder();
                for (int i = 0; i < mandatoryColumns.size(); i++) {
                    colNames.append("\"").append(mandatoryColumns.get(i).getTitle()).append("\"");
                    if (i < (mandatoryColumns.size() - 1)) {
                        colNames.append(", ");
                    }
                }
                errors.add("Could not find row with all mandatory columns: " + colNames + ".");
                return;
            }

            Pattern colorPattern = Pattern.compile("(?i)[BCDE][123456]");
            List<Survey> previousSurveys = new ArrayList<Survey>();
            for (int rowNum = headerRowIndex + 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
                try {
                    Row row = sheet.getRow(rowNum);
                    if (row == null) {
                        continue;
                    }
                    boolean rowEmpty = true;
                    EnumMap<StandardBulkImportColumns, List<Object>> columnValuesMap =
                            new EnumMap<StandardBulkImportColumns, List<Object>>(StandardBulkImportColumns.class);
                    for (StandardBulkImportColumns column : columnIndicesMap.keySet()) {
                        List<Integer> columnIndices = columnIndicesMap.get(column);
                        List<Object> columnValues = columnValuesMap.get(column);
                        if (columnValues == null) {
                            columnValues = new ArrayList<Object>();
                            columnValuesMap.put(column, columnValues);
                        }
                        for (int columnIndex : columnIndices) {
                            Cell cell = row.getCell(columnIndex);
                            if (cell == null) {
                                continue;
                            }
                            if (cell.getCellType() != Cell.CELL_TYPE_BLANK) {
                                rowEmpty = false;
                            }
                            if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                                if (DateUtil.isCellDateFormatted(cell)) {
                                    columnValues.add(cell.getDateCellValue());
                                }
                                else {
                                    columnValues.add(cell.getNumericCellValue());
                                }
                            }
                            else {
                                columnValues.add(cell.getStringCellValue().trim());
                            }
                        }
                        if (column.getMandatory() && columnValues.isEmpty()) {
                            errors.add("Missing value for " + column.getTitle() + " on row " + (rowNum + 1));
                        }
                    }
                    if (rowEmpty) {
                        continue;
                    }

                    String groupName = getColumnValue(columnValuesMap, StandardBulkImportColumns.GROUP_NAME, String.class);
                    String participatingAs = getColumnValue(columnValuesMap, StandardBulkImportColumns.PARTICIPATING_AS, String.class);
                    String country = getColumnValue(columnValuesMap, StandardBulkImportColumns.COUNTRY, String.class);
                    String reefName = getColumnValue(columnValuesMap, StandardBulkImportColumns.REEF_NAME, String.class);
                    String isGpsDeviceString = getColumnValue(columnValuesMap, StandardBulkImportColumns.IS_GPS_DEVICE, String.class);
                    Double latitudeDouble = getColumnValue(columnValuesMap, StandardBulkImportColumns.LATITUDE, Double.class);
                    Float latitude = (latitudeDouble != null) ? latitudeDouble.floatValue() : null;
                    Double longitudeDouble = getColumnValue(columnValuesMap, StandardBulkImportColumns.LONGITUDE, Double.class);
                    Float longitude = (longitudeDouble != null) ? longitudeDouble.floatValue() : null;
                    Date date = getColumnValue(columnValuesMap, StandardBulkImportColumns.DATE, Date.class);
                    Date time = getColumnValue(columnValuesMap, StandardBulkImportColumns.TIME, Date.class);
                    String lightCondition = getColumnValue(columnValuesMap, StandardBulkImportColumns.LIGHT_CONDITION, String.class);
                    Double depthMetres = getColumnValue(columnValuesMap, StandardBulkImportColumns.DEPTH_METRES, Double.class);
                    Double depthFeet = getColumnValue(columnValuesMap, StandardBulkImportColumns.DEPTH_FEET, Double.class);
                    Double waterTemperatureC = getColumnValue(columnValuesMap, StandardBulkImportColumns.WATER_TEMPERATURE_C, Double.class);
                    Double waterTemperatureF = getColumnValue(columnValuesMap, StandardBulkImportColumns.WATER_TEMPERATURE_F, Double.class);
                    String activity = getColumnValue(columnValuesMap, StandardBulkImportColumns.ACTIVITY, String.class);
                    String coralType = getColumnValue(columnValuesMap, StandardBulkImportColumns.CORAL_TYPE, String.class);
                    String light = getColumnValue(columnValuesMap, StandardBulkImportColumns.LIGHT, String.class);
                    String dark = getColumnValue(columnValuesMap, StandardBulkImportColumns.DARK, String.class);
                    String comments = getColumnValue(columnValuesMap, StandardBulkImportColumns.COMMENTS, String.class);

                    if (!(StringUtils.equalsIgnoreCase(isGpsDeviceString, "yes") || StringUtils.equalsIgnoreCase(isGpsDeviceString, "no"))) {
                        errors.add(StandardBulkImportColumns.IS_GPS_DEVICE.getTitle() + " must be either 'Yes' or 'No'");
                    }
                    boolean isGpsDevice = StringUtils.equalsIgnoreCase(isGpsDeviceString, "yes");
                    
                    if ((depthMetres == null) && (depthFeet == null)) {
                        errors.add("Depth must be provided either in metres or feet");
                    }
                    else if (depthMetres == null) {
                        depthMetres = depthFeet * 0.3048;
                    }

                    Survey survey = null;
                    for (Survey previousSurvey : previousSurveys) {
                        if (
                            previousSurvey.getReef().getName().equals(reefName) &&
                            (date != null) && (previousSurvey.getDate().getTime() == date.getTime()) &&
                            (time != null) && (previousSurvey.getTime().getTime() == time.getTime()) &&
                            ObjectUtils.equals(previousSurvey.getLatitude(), latitude) &&
                            ObjectUtils.equals(previousSurvey.getLongitude(), longitude) &&
                            ObjectUtils.equals(previousSurvey.getDepth(), depthMetres)
                        ) {
                            survey = previousSurvey;
                            break;
                        }
                    }
                    if (survey == null) {
                        if (lightCondition == null) {
                            errors.add(
                                "Unrecognised weather value on row " + (rowNum + 1) + ": " +
                                "should be Full Sunshine, Sunny, Cloudy, Rainy, or Broken Cloud"
                            );
                        }

                        if ((waterTemperatureC == null) && (waterTemperatureF == null)) {
                            errors.add("Water temperature must be provided either in C or F");
                        }
                        else if (waterTemperatureC == null) {
                            waterTemperatureC = 100 / (212 - 32) * (waterTemperatureF - 32);
                        }

                        if (errors.isEmpty()) {
                            Reef reef = reefDao.getReefByName(reefName);
                            if (reef == null) {
                                reef = new Reef(reefName, country);
                                reefDao.save(reef);
                            }
                            survey = new Survey();
                            survey.setCreator(currentUser);
                            survey.setGroupName(groupName);
                            survey.setParticipatingAs(participatingAs);
                            survey.setReef(reef);
                            survey.setQaState("Post Migration");
                            survey.setLatitude(latitude.floatValue());
                            survey.setLongitude(longitude.floatValue());
                            survey.setGPSDevice(isGpsDevice);
                            survey.setDate(date);
                            survey.setTime(time);
                            survey.setLightCondition(lightCondition);
                            survey.setDepth(depthMetres);
                            survey.setWaterTemperature(waterTemperatureC);
                            survey.setActivity(activity);
                            survey.setComments(comments);
                            survey.setReviewState(Survey.ReviewState.UNREVIEWED);
                            surveyDao.save(survey);
                            previousSurveys.add(survey);
                        }
                    }
                    if (!colorPattern.matcher(light).matches() || !colorPattern.matcher(dark).matches()) {
                        errors.add(
                            "Unrecognised Light/Dark value on row " + (rowNum + 1) + ": " +
                            "should be a letter (B, C, D, E) followed by a number (1-6)"
                        );
                    }
                    if (errors.isEmpty()) {
                        SurveyRecord record = new SurveyRecord();
                        record.setSurvey(survey);
                        record.setCoralType(coralType);
                        record.setLightestLetter(Character.toUpperCase(light.charAt(0)));
                        record.setLightestNumber(Integer.parseInt(light.substring(1, 2)));
                        record.setDarkestLetter(Character.toUpperCase(dark.charAt(0)));
                        record.setDarkestNumber(Integer.parseInt(dark.substring(1, 2)));
                        surveyRecordDao.save(record);
                    }
                }
                catch (Exception rowException) {
                    String msg = "Exception processing row " + (rowNum + 1);
                    _log.error(msg, rowException);
                    errors.add(msg + ": " + rowException.toString());
                }
            }
            if (!errors.isEmpty()) {
                return;
            }
        }
        catch (Exception e2) {
            String msg = "Error processing bulk upload";
            _log.error(msg, e2);
            errors.add(msg);
            return;
        }
        finally {
            if (errors.isEmpty()) {
                _log.info("Committing standard bulk upload transaction");
                transaction.commit();
            }
            else {
                _log.info("Rolling back standard bulk upload transaction");
                if (transaction.isActive()) {
                    transaction.rollback();
                }
            }
            uploadRequest.cleanUp();
        }
    }

    private enum SURGBulkImportColumns {
        SURVEY_PERIOD("Survey Period", false),
        ISLAND("Island", false),
        SITE("Location/Site", true),
        DATE("Date", true),
        TIME("Time", true),
        LATITUDE("Latitude", true),
        LONGITUDE("Longitude", true),
        BEARING("Bearing", false),
        DEPTH("Depth (m)", false),
        WATER_TEMPERATURE("Water Temp. (C)", false),
        WEATHER("Weather", true),
        NAME("Name", false),
        FAMILY("Family", false),
        CORAL_TYPE("Coral Type", true),
        DARK("Dark", true),
        LIGHT("Light", true);

        private final String title;

        private final boolean mandatory;

        SURGBulkImportColumns(String title, boolean mandatory) {
            this.title = title;
            this.mandatory = mandatory;
        }

        public String getTitle() {
            return title;
        }

        public boolean getMandatory() {
            return mandatory;
        }

        public static List<SURGBulkImportColumns> getMandatoryColumns() {
            List<SURGBulkImportColumns> mandatoryColumns = new ArrayList<SURGBulkImportColumns>();
            for (SURGBulkImportColumns column : SURGBulkImportColumns.values()) {
                if (column.getMandatory()) {
                    mandatoryColumns.add(column);
                }
            }
            return mandatoryColumns;
        }
    }

    private void processSURGBulkUploadAction(
        UploadPortletRequest uploadRequest,
        ActionResponse actionResponse,
        String cmd,
        UserImpl currentUser,
        List<String> errors
    ) {
        JpaConnectorService jpaConnectorService = CoralwatchApplication.getConfiguration().getJpaConnectorService();
        EntityManager entityManager = jpaConnectorService.getEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            String groupName = uploadRequest.getParameter("groupName");
            String participatingAs = uploadRequest.getParameter("participatingAs");
            String country = uploadRequest.getParameter("country");
            boolean isGpsDevice = ParamUtil.getBoolean(uploadRequest, "isGpsDevice");
            String activity = uploadRequest.getParameter("activity");
            String formComments = uploadRequest.getParameter("comments");

            if (StringUtils.isBlank(groupName) || StringUtils.isBlank(participatingAs) ||
                StringUtils.isBlank(country) || StringUtils.isBlank(activity)) {
                errors.add("Group Name, Participating As, Country of Survey, and Activity are all required");
                return;
            }

            String fieldName = "file";
            File file = uploadRequest.getFile(fieldName);
            Workbook workbook = null;
            try {
                workbook = WorkbookFactory.create(file);
            }
            catch (Exception e) {
                errors.add("Could not read spreadsheet file (must be *.xls or *.xlsx)");
                return;
            }
            Sheet sheet = null;
            try {
                sheet = workbook.getSheetAt(0);
            }
            catch (Exception e) {
                errors.add("Could not find sheet inside spreadsheet");
                return;
            }
            List<SURGBulkImportColumns> mandatoryColumns = SURGBulkImportColumns.getMandatoryColumns();
            int headerRowIndex = -1;
            EnumMap<SURGBulkImportColumns, List<Integer>> columnIndicesMap =
                new EnumMap<SURGBulkImportColumns, List<Integer>>(SURGBulkImportColumns.class);
            for (Row row : sheet) {
                columnIndicesMap.clear();
                for (Cell cell : row) {
                    String cellValue =
                        (cell.getCellType() == Cell.CELL_TYPE_NUMERIC)
                        ? String.valueOf(cell.getNumericCellValue())
                        : cell.getStringCellValue().trim();
                    for (SURGBulkImportColumns column : SURGBulkImportColumns.values()) {
                        if (column.getTitle().equalsIgnoreCase(cellValue)) {
                            List<Integer> columnIndices = columnIndicesMap.get(column);
                            if (columnIndices == null) {
                                columnIndices = new ArrayList<Integer>();
                                columnIndicesMap.put(column, columnIndices);
                            }
                            columnIndices.add(cell.getColumnIndex());
                        }
                    }
                }
                if (columnIndicesMap.keySet().containsAll(mandatoryColumns)) {
                    headerRowIndex = row.getRowNum();
                    break;
                }
            }
            if (headerRowIndex == -1) {
                StringBuilder colNames = new StringBuilder();
                for (int i = 0; i < mandatoryColumns.size(); i++) {
                    colNames.append("\"").append(mandatoryColumns.get(i).getTitle()).append("\"");
                    if (i < (mandatoryColumns.size() - 1)) {
                        colNames.append(", ");
                    }
                }
                errors.add("Could not find row with all mandatory columns: " + colNames + ".");
                return;
            }

            Pattern colorPattern = Pattern.compile("(?i)[BCDE][123456]");
            List<Survey> previousSurveys = new ArrayList<Survey>();
            for (int rowNum = headerRowIndex + 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
                try {
                    Row row = sheet.getRow(rowNum);
                    if (row == null) {
                        continue;
                    }
                    EnumMap<SURGBulkImportColumns, List<Object>> columnValuesMap =
                            new EnumMap<SURGBulkImportColumns, List<Object>>(SURGBulkImportColumns.class);
                    for (SURGBulkImportColumns column : columnIndicesMap.keySet()) {
                        List<Integer> columnIndices = columnIndicesMap.get(column);
                        List<Object> columnValues = columnValuesMap.get(column);
                        if (columnValues == null) {
                            columnValues = new ArrayList<Object>();
                            columnValuesMap.put(column, columnValues);
                        }
                        for (int columnIndex : columnIndices) {
                            Cell cell = row.getCell(columnIndex);
                            if (cell == null) {
                                continue;
                            }
                            if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                                if (DateUtil.isCellDateFormatted(cell)) {
                                    columnValues.add(cell.getDateCellValue());
                                }
                                else {
                                    columnValues.add(cell.getNumericCellValue());
                                }
                            }
                            else {
                                columnValues.add(cell.getStringCellValue().trim());
                            }
                        }
                        if (column.getMandatory() && columnValues.isEmpty()) {
                            errors.add("Missing value for " + column.getTitle() + " on row " + (rowNum + 1));
                        }
                    }

                    String reefName =
                        columnValuesMap.get(SURGBulkImportColumns.SITE).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.SITE).get(0);
                    Float latitude =
                        columnValuesMap.get(SURGBulkImportColumns.LATITUDE).isEmpty() ? null :
                        ((Double) columnValuesMap.get(SURGBulkImportColumns.LATITUDE).get(0)).floatValue();
                    Float longitude =
                        columnValuesMap.get(SURGBulkImportColumns.LONGITUDE).isEmpty() ? null :
                        ((Double) columnValuesMap.get(SURGBulkImportColumns.LONGITUDE).get(0)).floatValue();
                    Date date =
                        columnValuesMap.get(SURGBulkImportColumns.DATE).isEmpty() ? null :
                        (Date) columnValuesMap.get(SURGBulkImportColumns.DATE).get(0);
                    Date time =
                        columnValuesMap.get(SURGBulkImportColumns.TIME).isEmpty() ? null :
                        (Date) columnValuesMap.get(SURGBulkImportColumns.TIME).get(0);
                    String weather =
                        columnValuesMap.get(SURGBulkImportColumns.WEATHER).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.WEATHER).get(0);
                    Double depth =
                        columnValuesMap.get(SURGBulkImportColumns.DEPTH).isEmpty() ? null :
                        (Double) columnValuesMap.get(SURGBulkImportColumns.DEPTH).get(0);
                    Double waterTemperature =
                        columnValuesMap.get(SURGBulkImportColumns.WATER_TEMPERATURE).isEmpty() ? null :
                        (Double) columnValuesMap.get(SURGBulkImportColumns.WATER_TEMPERATURE).get(0);
                    String surveyPeriod =
                        columnValuesMap.get(SURGBulkImportColumns.SURVEY_PERIOD).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.SURVEY_PERIOD).get(0);
                    String island =
                        columnValuesMap.get(SURGBulkImportColumns.ISLAND).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.ISLAND).get(0);
                    List<Object> nameObjects = columnValuesMap.get(SURGBulkImportColumns.NAME);
                    Double bearing =
                        columnValuesMap.get(SURGBulkImportColumns.BEARING).isEmpty() ? null :
                        (Double) columnValuesMap.get(SURGBulkImportColumns.BEARING).get(0);
                    String coralType =
                        columnValuesMap.get(SURGBulkImportColumns.CORAL_TYPE).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.CORAL_TYPE).get(0);
                    String light =
                        columnValuesMap.get(SURGBulkImportColumns.LIGHT).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.LIGHT).get(0);
                    String dark =
                        columnValuesMap.get(SURGBulkImportColumns.DARK).isEmpty() ? null :
                        (String) columnValuesMap.get(SURGBulkImportColumns.DARK).get(0);

                    Survey survey = null;
                    for (Survey previousSurvey : previousSurveys) {
                        if (
                            previousSurvey.getReef().getName().equals(reefName) &&
                            (date != null) && (previousSurvey.getDate().getTime() == date.getTime()) &&
                            (time != null) && (previousSurvey.getTime().getTime() == time.getTime()) &&
                            ObjectUtils.equals(previousSurvey.getLatitude(), latitude) &&
                            ObjectUtils.equals(previousSurvey.getLongitude(), longitude) &&
                            ObjectUtils.equals(previousSurvey.getDepth(), depth)
                        ) {
                            survey = previousSurvey;
                            break;
                        }
                    }
                    if (survey == null) {
                        String lightCondition =
                            (
                                weather.equalsIgnoreCase("Full Sunshine") ||
                                weather.equalsIgnoreCase("Full Sun") ||
                                weather.equalsIgnoreCase("Sunny")
                            ) ? "Full Sunshine" :
                            (
                                weather.equalsIgnoreCase("Cloudy") ||
                                weather.equalsIgnoreCase("Raining")
                            ) ? "Cloudy" :
                            (
                                weather.equalsIgnoreCase("Broken Cloud")
                            ) ? "Broken Cloud" :
                            null;
                        if (lightCondition == null) {
                            errors.add(
                                "Unrecognised weather value on row " + (rowNum + 1) + ": " +
                                "should be Full Sunshine, Sunny, Cloudy, Rainy, or Broken Cloud"
                            );
                        }

                        StringBuilder comments = new StringBuilder();
                        if (surveyPeriod != null) {
                            comments.append("Survey Period: " + surveyPeriod + "\n");
                        }
                        if (island != null) {
                            comments.append("Island: " + island + "\n");
                        }
                        if ((nameObjects != null)) {
                            List<String> nameStrings = new ArrayList<String>();
                            for (Object nameObject : nameObjects) {
                                if (StringUtils.isNotBlank((String) nameObject) && !((String) nameObject).equalsIgnoreCase("No name supplied")) {
                                    nameStrings.add(((String) nameObject).trim());
                                }
                            }
                            if (!nameStrings.isEmpty()) {
                                comments.append("Names: " + StringUtils.join(nameStrings, ", ") + "\n");
                            }
                        }
                        if (bearing != null) {
                            comments.append("Bearing: " + bearing + "\n");
                        }
                        if (StringUtils.isNotBlank(formComments)) {
                            comments.append("\n");
                            comments.append(formComments);
                        }

                        if (errors.isEmpty()) {
                            Reef reef = reefDao.getReefByName(reefName);
                            if (reef == null) {
                                reef = new Reef(reefName, country);
                                reefDao.save(reef);
                            }
                            survey = new Survey();
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
                            survey.setComments(comments.toString());
                            survey.setReviewState(Survey.ReviewState.UNREVIEWED);
                            surveyDao.save(survey);
                            previousSurveys.add(survey);
                        }
                    }
                    if (!colorPattern.matcher(light).matches() || !colorPattern.matcher(dark).matches()) {
                        errors.add(
                            "Unrecognised Light/Dark value on row " + (rowNum + 1) + ": " +
                            "should be a letter (B, C, D, E) followed by a number (1-6)"
                        );
                    }
                    if (errors.isEmpty()) {
                        SurveyRecord record = new SurveyRecord();
                        record.setSurvey(survey);
                        record.setCoralType(coralType);
                        record.setLightestLetter(Character.toUpperCase(light.charAt(0)));
                        record.setLightestNumber(Integer.parseInt(light.substring(1, 2)));
                        record.setDarkestLetter(Character.toUpperCase(dark.charAt(0)));
                        record.setDarkestNumber(Integer.parseInt(dark.substring(1, 2)));
                        surveyRecordDao.save(record);
                    }
                }
                catch (Exception rowException) {
                    String msg = "Exception processing row " + (rowNum + 1);
                    _log.error(msg, rowException);
                    errors.add(msg + ": " + rowException.toString());
                }
            }
            if (!errors.isEmpty()) {
                return;
            }
        }
        catch (Exception e2) {
            String msg = "Error processing bulk upload";
            _log.error(msg, e2);
            errors.add(msg);
            return;
        }
        finally {
            if (errors.isEmpty()) {
                _log.info("Committing standard bulk upload transaction");
                transaction.commit();
            }
            else {
                _log.info("Rolling back standard bulk upload transaction");
                if (transaction.isActive()) {
                    transaction.rollback();
                }
            }
            uploadRequest.cleanUp();
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
        if (request.getResourceID().equals("list")) {
            serveListResource(request, response);
        }
        else if (request.getResourceID().equals("export")) {
            serveExportResource(request, response);
        }
    }

    protected static void serveListResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        AppUtil.clearCache();

        UserImpl currentUser = (UserImpl) request.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);

        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        Random rand = new Random();
        String format = request.getParameter("format");

        if (format.equals("json")) {
            response.setContentType("application/json;charset=utf-8");
            PrintWriter out = response.getWriter();
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
                            writer.key("date");
                            writer.value(survey.getDate().getTime());
                            writer.endObject();
                        }
                    } catch (JSONException e) {
                        _log.error("Exception creating survey json", e);
                    }
                }
                writer.endArray();
            } catch (JSONException e) {
                throw new PortletException("Exception creating surveys json", e);
            }
        }

        else if (format.equals("xml")) {
            response.setContentType("text/xml;charset=utf-8");
            PrintWriter out = response.getWriter();
            try {
                ScrollableResults results = null;
                String createdByUserIdParam = request.getParameter("createdByUserId");
                String reefIdParam = request.getParameter("reefId");
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
                    String group = (String) results.get(7);
                    String comments = (String) results.get(8);

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

                    if ((currentUser != null) && currentUser.isSuperUser()) {
                        writer.writeStartElement("reviewState");
                        writer.writeCharacters(reviewState.name());
                        writer.writeEndElement();
                    }

                    writer.writeStartElement("groupname");
                    writer.writeCharacters(group == null ? "" : group);
                    writer.writeEndElement();

                    writer.writeStartElement("comments");
                    writer.writeCharacters(comments == null ? "" : comments);
                    writer.writeEndElement();

                    writer.writeEndElement();
                }
                writer.writeEndElement();
            }
            catch (Exception e) {
                _log.error("Exception creating survey xml", e);
            }
        }
    }

    protected static void serveExportResource(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        AppUtil.clearCache();

        ScrollableResults surveys = null;
        String fileNamePrefix = null;

        String countryParam = request.getParameter("country");
        String reefNameParam = request.getParameter("reefName");
        String groupParam = request.getParameter("group");
        String surveyorParam = request.getParameter("surveyor");
        String commentParam = request.getParameter("comment");

        String reefIdParam = request.getParameter("reefId");

        if (reefIdParam != null) {
            ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
            Reef reef = reefDao.getById(Long.valueOf(reefIdParam));
            SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
            surveys = surveyDao.getSurveysIterator(reef);
            fileNamePrefix = reef.getName();
        }

        else if ((countryParam != null) || (reefNameParam != null) || (groupParam != null) || (surveyorParam != null) || (commentParam != null)) {
            PortletSession session = request.getPortletSession(true);
            UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
            if (currentUser == null || !currentUser.isSuperUser()) {
                //throw new PortletException("Only the administrator can export all survey data");
            }
            SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
            surveys = surveyDao.getSurveysIteratorWithFilters(countryParam, reefNameParam, groupParam, surveyorParam, commentParam);
            fileNamePrefix = "surveys";
        }

        else {
            PortletSession session = request.getPortletSession(true);
            UserImpl currentUser = (UserImpl) session.getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
            if (currentUser == null || !currentUser.isSuperUser()) {
                //throw new PortletException("Only the administrator can export all survey data");
            }
            SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
            surveys = surveyDao.getSurveysIterator();
            fileNamePrefix = "surveys";
        }

        String singleSheetParam = request.getParameter("singleSheet");
        boolean singleSheet = (singleSheetParam != null && singleSheetParam.equals("true"));

        String fileNameBase = fileNamePrefix + "-" + new SimpleDateFormat("yyyyMMdd").format(new Date());
        String format = request.getParameter("format");
        if (format != null && format.equals("csv")) {
            writeCSVStream(fileNameBase, response, surveys, singleSheet);
        }
        else {
            writeExcelWorkbook(fileNameBase, response, surveys, singleSheet);
        }
    }

    private static void writeCSVStream(
        String fileNameBase,
        ResourceResponse response,
        ScrollableResults surveys,
        boolean singleSheet
    )
    throws IOException {
        response.addProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileNameBase + ".csv\"");
        response.setProperty(ResourceResponse.EXPIRATION_CACHE, "0");
        response.setContentType("text/csv;charset=utf-8");

        CSVWriter writer = new CSVWriter(new OutputStreamWriter(response.getPortletOutputStream(), "UTF8"));

        List<String> headers = new ArrayList<String>();
        headers.add("Survey");
        headers.add("Creator");
        headers.add("Group Name");
        headers.add("Participating As");
        headers.add("Reef");
        headers.add("Country");
        headers.add("Longitude");
        headers.add("Latitude");
        headers.add("Date");
        headers.add("Time");
        headers.add("Light Condition");
        headers.add("Depth");
        headers.add("Water Temperature");
        headers.add("Activity");
        headers.add("Comments");
        headers.add("Number of records");
        for (String shape : shapes) {
            headers.add(shape);
        }
        headers.add("Average lightest");
        headers.add("Average darkest");
        headers.add("Average overall");
        headers.add("Coral Type");
        headers.add("Lightest Letter");
        headers.add("Lightest Number");
        headers.add("Darkest Letter");
        headers.add("Darkest Number");
        writer.writeNext(headers.toArray(new String[headers.size()]));

        surveys.beforeFirst();
        while (surveys.next()) {
            Survey survey = (Survey) surveys.get(0);
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
            DecimalFormat latLngFormat = new DecimalFormat("0.000000");
            DecimalFormat depthFormat = new DecimalFormat("0.00");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            DecimalFormat waterTemperatureFormat = new DecimalFormat("0.00");
            DecimalFormat averageFormat = new DecimalFormat("0.00");
            for (SurveyRecord record : survey.getDataset()) {
                try {
                    List<String> values = new ArrayList<String>();
                    int numRecords = survey.getDataset().size();
                    values.add(String.valueOf(survey.getId()));
                    values.add(survey.getCreator().getDisplayName());
                    values.add(survey.getGroupName());
                    values.add(survey.getParticipatingAs());
                    values.add(survey.getReef().getName());
                    values.add(survey.getReef().getCountry());
                    values.add((survey.getLongitude() != null) ? latLngFormat.format(survey.getLongitude()) : "");
                    values.add((survey.getLatitude() != null) ? latLngFormat.format(survey.getLatitude()) : "");
                    values.add((survey.getDate() != null) ? dateFormat.format(survey.getDate()) : "");
                    values.add((survey.getTime() != null) ? timeFormat.format(survey.getTime()) : "");
                    values.add(survey.getLightCondition());
                    values.add((survey.getDepth() != null) ? depthFormat.format(survey.getDepth()) : "");
                    values.add((survey.getWaterTemperature() != null) ? waterTemperatureFormat.format(survey.getWaterTemperature()) : "");
                    values.add(survey.getActivity());
                    values.add(survey.getComments());
                    values.add(String.valueOf(numRecords));
                    for (String shape : shapes) {
                        values.add(String.valueOf(shapeCounts.get(shape)));
                    }
                    values.add(averageFormat.format(sumLight / (double) numRecords));
                    values.add(averageFormat.format(sumDark / (double) numRecords));
                    values.add(averageFormat.format((sumLight + sumDark) / (2d * numRecords)));
                    values.add(record.getCoralType());
                    values.add(String.valueOf(record.getLightestLetter()));
                    values.add(String.valueOf(record.getLightestNumber()));
                    values.add(String.valueOf(record.getDarkestLetter()));
                    values.add(String.valueOf(record.getDarkestNumber()));
                    writer.writeNext(values.toArray(new String[values.size()]));
                }
                catch (Exception e) {
                    _log.error(e);
                }
            }
            writer.flush();
        }

        writer.close();
    }

    private static void writeExcelWorkbook(
        String fileNameBase,
        ResourceResponse response,
        ScrollableResults surveys,
        boolean singleSheet
    )
    throws IOException {
        response.addProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileNameBase + ".xls\"");
        response.setProperty(ResourceResponse.EXPIRATION_CACHE, "0");
        response.setContentType("application/vnd.ms-excel;charset=utf-8");

        HSSFWorkbook workbook = new HSSFWorkbook();

        HSSFCellStyle dateStyle = workbook.createCellStyle();
        dateStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/MM/yyyy"));
        HSSFCellStyle timeStyle = workbook.createCellStyle();
        timeStyle.setDataFormat(workbook.createDataFormat().getFormat("HH:mm"));

        if (singleSheet) {
            writeSurveyRecordSheet(workbook, surveys, true, dateStyle, timeStyle);
        }
        else {
            writeSurveySheet(workbook, surveys, dateStyle, timeStyle);
            writeSurveyRecordSheet(workbook, surveys, false, dateStyle, timeStyle);
        }
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
