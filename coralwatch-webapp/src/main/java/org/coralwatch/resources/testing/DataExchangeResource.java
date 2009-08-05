package org.coralwatch.resources.testing;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.ApplicationContext;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.coralwatch.resources.DataDownloadResource;
import org.restlet.data.MediaType;
import org.restlet.ext.fileupload.RestletFileUpload;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;

import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.TechnicalSubmissionError;
import static au.edu.uq.itee.maenad.util.NullHelper.equalsOrBothNull;
import static au.edu.uq.itee.maenad.util.NullHelper.fallback;

public class DataExchangeResource extends DataDownloadResource {
    /**
     * A lookup index for Surveys already imported.
     *
     * We could query the database, but this would require pushing our specific needs into the
     * persistence layer and since we have to handle lots of NULLs querying is quite messy.
     * Instead we just use a String-based lookup, with all relevant attributes concatenated.
     */
    private final Map<String, Survey> surveyIndex = new HashMap<String, Survey>();

    /**
     * The number to use for the next anonymous user.
     */
    private int anonymousUserId;

    /**
     * The number to use for the next unnamed reef.
     */
    private int unknownReefId;

    public DataExchangeResource() throws InitializationException {
        super();
        setModifiable(true);
    }

    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        if (entity != null) {
            if (MediaType.MULTIPART_FORM_DATA.equals(entity.getMediaType(), true)) {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                factory.setSizeThreshold(1000240);

                RestletFileUpload upload = new RestletFileUpload(factory);
                List<FileItem> items;
                InputStream dataStream = null;
                boolean deleteData = false;
                try {
                    items = upload.parseRequest(getRequest());
                    for (FileItem fi : items) {
                        if (fi.getFieldName().equals("upfile")) {
                            Logger.getLogger(getClass().getName()).log(Level.INFO, "Found file");
                            dataStream = fi.getInputStream();
                        } else if (fi.getFieldName().equals("resetData")) {
                            deleteData = fi.getString().equalsIgnoreCase("true");
                        }
                    }
                    if (dataStream == null) {
                        errors.add(new SubmissionError("No file uploaded"));
                    } else {
                        if (deleteData) {
                            ((ApplicationContext) CoralwatchApplication.getConfiguration()).resetDatabase();
                        }
                        HSSFWorkbook workbook = new HSSFWorkbook(dataStream);
                        readSurveys(workbook);
                    }
                } catch (Exception e) {
                    Logger.getLogger(getClass().getName()).log(Level.INFO, "File upload failed", e);
                    errors
                            .add(new TechnicalSubmissionError("File upload failed (maybe the input could not be read)",
                                    e));
                } finally {
                    if (dataStream != null) {
                        try {
                            dataStream.close();
                        } catch (IOException e) {
                            // not much we can do here, just log the problem, otherwise ignore
                            Logger.getLogger(getClass().getName()).log(Level.WARNING,
                                    "Closing input stream from browser upload failed", e);
                        }
                    }
                }
            }
        } else {
            errors.add(new SubmissionError("No upload data found"));
        }
        if (!errors.isEmpty()) {
            redirectToSubmissionErrorPage(errors);
        } else {
            redirect("/dashboard");
        }
    }

    private List<SubmissionError> readSurveys(HSSFWorkbook workbook) {
        // We start numbering the anonymous users with a number representing the number
        // of users we have so far. This works nicely on an empty database (only the admin
        // exists, so we start with "anonymous1"). It should also not clash if there are
        // anonymous users in there already, but that is not guaranteed. Since the import
        // is meant to be against an empty DB it shoudn't matter
        anonymousUserId = userDao.getAll().size();

        HSSFSheet sheet = workbook.getSheet("Surveys");
        if (sheet == null) {
            return Collections.singletonList(new SubmissionError(
                    "Workbook does not contain sheet with the name 'Surveys'"));
        }
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        for (int r = 1; r <= sheet.getLastRowNum(); r++) { // we skip the header row
            errors.addAll(readSurvey(sheet.getRow(r)));
        }
        return errors;
    }

    // we don't want to bother with Calendar & Co just for setting the time of day
    @SuppressWarnings("deprecation")
    private List<SubmissionError> readSurvey(HSSFRow row) {
        Logger.getLogger(getClass().getName()).log(Level.FINE, "Reading row: " + (row.getRowNum() + 1));
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        int c = 1; // we skip the ID
        String username = getStringValue(row.getCell(c++));
        String groupname = getStringValue(row.getCell(c++));
        String email = getStringValue(row.getCell(c++));
        String country = getStringValue(row.getCell(c++));
        String participation = getStringValue(row.getCell(c++));
        Date date = getDateValue(row.getCell(c++));
        String location = getStringValue(row.getCell(c++));
        String coralType = getStringValue(row.getCell(c++));
        String lColor = getStringValue(row.getCell(c++));
        Integer lIntensity = getIntegerValue(row.getCell(c++));
        String dColor = getStringValue(row.getCell(c++));
        Integer dIntensity = getIntegerValue(row.getCell(c++));
        c++; // avIntensity
        String comments = getStringValue(row.getCell(c++));
        String timeOfDay = getStringValue(row.getCell(c++));
        String weather = getStringValue(row.getCell(c++));
        String activity = getStringValue(row.getCell(c++));
        Double temperature = getDoubleValue(row.getCell(c++));
        Integer latDeg = getIntegerValue(row.getCell(c++));
        Integer latMin = getIntegerValue(row.getCell(c++));
        String latSec = getStringValue(row.getCell(c++));
        Integer longDeg = getIntegerValue(row.getCell(c++));
        Integer longMin = getIntegerValue(row.getCell(c++));
        String longSec = getStringValue(row.getCell(c++));
        Date time = null;
        if ("early morning".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 7, 0);
        } else if ("late morning".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 10, 0);
        } else if ("midday".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 12, 0);
        } else if ("early afternoon".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 15, 0);
        } else if ("late afternoon".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 17, 0);
        } else if ("evening".equalsIgnoreCase(timeOfDay)) {
            time = new Date(0, 0, 0, 20, 0);
        } else if ("null".equalsIgnoreCase(timeOfDay)) {
            // nothing to do
        } else {
            errors.add(new SubmissionError("Unknown entry for time of day in row " + (row.getRowNum() + 1)));
        }
        float latitude = (float) convertDegreesToDecimal(latDeg, latMin, latSec);
        float longitude = (float) convertDegreesToDecimal(longDeg, longMin, longSec);

        Logger.getLogger(DataExchangeResource.class.getName()).log(
                Level.FINER,
                String.format("Trying to find survey having %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s", username,
                        groupname, participation, location, weather, date, time, latitude,
                        longitude, activity, comments));
        String lookupString = username + "::" + groupname + "::" + participation + "::" + location
                + "::" + weather + "::" + date + "::" + time + "::" + latitude + "::" + longitude + "::" + activity
                + "::" + comments;
        Survey survey = surveyIndex.get(lookupString);
        if (survey == null) {
            survey = new Survey();
            UserImpl user;
            if (username == null) {
                user = new UserImpl("anonymous" + anonymousUserId++, "unknown", "unknown", null, false);
                userDao.save(user);
            } else {
                user = userDao.getByUsername(username);
                if (user == null) {
                    user = new UserImpl(username, username, email, null, false);
                    user.setCountry("unknown");
                    Logger.getLogger(DataExchangeResource.class.getName()).log(Level.INFO, "Creating user " + username);
                    userDao.save(user);
                } else {
                    if (!equalsOrBothNull(user.getEmail(), email)) {
                        if ("unknown".equals(user.getEmail())) {
                            user.setEmail(email);
                        } else {
                            String message = String.format(
                                    "Mismatch of email addresses during import: user has '%s', row %d says '%s'", user
                                            .getEmail(), row.getRowNum() + 1, email);
                            Logger.getLogger(DataExchangeResource.class.getName()).log(Level.WARNING, message);
                            errors.add(new SubmissionError(message));
                        }
                    }
                }
            }
            assert user != null;
            survey.setCreator(user);
            survey.setDate(date);
            survey.setTime(time);
            Reef reef;
            if (location == null) {
                reef = new Reef("Unknown Reef " + unknownReefId++, fallback(country, "unknown"));
                reefDao.save(reef);
            } else {
                reef = reefDao.getReefByName(location);
                if (reef == null) {
                    reef = new Reef();
                    reef.setName(location);
                    reef.setCountry(fallback(country, "unknown"));
                    Logger.getLogger(DataExchangeResource.class.getName()).log(Level.INFO,
                            "Creating reef " + location + " (" + country + ")");
                    reefDao.save(reef);
                } else {
                    if (!equalsOrBothNull(reef.getCountry(), country)) {
                        if ("unknown".equals(reef.getCountry())) {
                            reef.setCountry(country);
                        } else {
                            String message = String.format(
                                    "Mismatch of countries during import: reef has '%s', row %d says '%s'", reef
                                            .getCountry(), row.getRowNum() + 1, country);
                            Logger.getLogger(DataExchangeResource.class.getName()).log(Level.WARNING, message);
                            errors.add(new SubmissionError(message));
                        }
                    }
                }
            }
            survey.setReef(reef);
            survey.setOrganisation(fallback(groupname, "unknown"));
            survey.setOrganisationType(fallback(participation, "unknown"));
            survey.setWeather(fallback(weather, "unknown"));
            survey.setActivity(fallback(activity, "unknown"));
            if (temperature != null) {
                survey.setTemperature(temperature);
            }
            if (latitude != -9999) {
                survey.setLatitude(latitude);
            }
            if (longitude != -9999) {
                survey.setLongitude(longitude);
            }
            survey.setComments(comments);
            Logger.getLogger(getClass().getName()).log(Level.FINE, "Creating new survey: " + survey);
            surveyDao.save(survey);
            surveyIndex.put(lookupString, survey);
        }
        SurveyRecord surveyRecord = new SurveyRecord(survey, coralType, lColor.charAt(0), lIntensity, dColor.charAt(0),
                dIntensity);
        surveyRecordDao.save(surveyRecord);
        return errors;
    }

    private double convertDegreesToDecimal(Integer deg, Integer min, String sec) {
        if (deg == null || min == null || sec == null) {
            return -9999;
        }
        int sign = 1;
        Character lastChar = sec.charAt(sec.length() - 1);
        if (!Character.isDigit(lastChar)) {
            sec = sec.substring(0, sec.length() - 1);
            if ("wWsS".indexOf(lastChar) != -1) {
                sign = -1;
            }
        }
        return sign * (deg + min / 60f + Double.parseDouble(sec) / 3600f);
    }

    private String getStringValue(HSSFCell cell) {
        switch (cell.getCellType()) {
        case HSSFCell.CELL_TYPE_STRING:
            String result = cell.getRichStringCellValue().getString();
            if ("NULL".equals(result)) {
                return null;
            }
            return result;
        case HSSFCell.CELL_TYPE_NUMERIC:
            return String.valueOf(cell.getNumericCellValue());
        default:
            return null;
        }
    }

    private Integer getIntegerValue(HSSFCell cell) {
        if (cell.getCellType() != HSSFCell.CELL_TYPE_NUMERIC) {
            return null;
        }
        return (int) cell.getNumericCellValue();
    }

    private Date getDateValue(HSSFCell cell) {
        return cell.getDateCellValue();
    }

    private Double getDoubleValue(HSSFCell cell) {
        if (cell.getCellType() != HSSFCell.CELL_TYPE_NUMERIC) {
            return null;
        }
        return cell.getNumericCellValue();
    }

    @Override
    protected boolean postAllowed(UserImpl user, Representation entity) {
        return user != null && user.isSuperUser();
    }
}
