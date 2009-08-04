package org.coralwatch.resources.testing;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
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

public class DataExchangeResource extends DataDownloadResource {
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
        HSSFSheet sheet = workbook.getSheet("Surveys");
        if (sheet == null) {
            return Collections.singletonList(new SubmissionError(
                    "Workbook does not contain sheet with the name 'Surveys'"));
        }
        UserImpl anonymous = userDao.getByUsername("anonymous");
        if (anonymous == null) {
            anonymous = new UserImpl("anonymous", "unknown", null, null, false);
            userDao.save(anonymous);
        }
        Reef unknownReef = reefDao.getReefByName("unknown");
        if (unknownReef == null) {
            unknownReef = new Reef();
            unknownReef.setName("unknown");
            unknownReef.setCountry("unknown");
        }
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        for (int r = 1; r <= sheet.getLastRowNum(); r++) { // we skip the header row
            errors.addAll(readSurvey(sheet.getRow(r), anonymous, unknownReef));
        }
        return errors;
    }

    // TODO remove suppression of deprecation warnings once we have a proper solution for the time of day
    @SuppressWarnings("deprecation")
    private List<SubmissionError> readSurvey(HSSFRow row, UserImpl anonymous, Reef unknownReef) {
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
        Double latSec = getDoubleValue(row.getCell(c++));
        Integer longDeg = getIntegerValue(row.getCell(c++));
        Integer longMin = getIntegerValue(row.getCell(c++));
        Double longSec = getDoubleValue(row.getCell(c++));
        UserImpl user = (username == null) ? anonymous : userDao.getByUsername(username);
        if (user == null) {
            user = new UserImpl(username, username, email, null, false);
            // TODO do we want to assume "country" refers to the user?
            user.setCountry("unknown");
            userDao.save(user);
        } else {
            // TODO add consistency checks
        }
        Reef reef;
        if (location == null) {
            reef = unknownReef;
        } else {
            reef = reefDao.getReefByName(location);
            if (reef == null) {
                reef = new Reef();
                reef.setName(location);
                reef.setCountry(country);
                reefDao.save(reef);
            } else {
                // TODO add consistency checks
            }
        }

        // TODO figure out how to group the rows into surveys
        Survey survey = new Survey();
        survey.setCreator(user);
        survey.setDate(date);
        survey.setReef(reef);
        // TODO figure out how to deal with the time of day properly
        if ("early morning".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 7, 0));
        } else if ("late morning".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 10, 0));
        } else if ("midday".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 12, 0));
        } else if ("early afternoon".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 15, 0));
        } else if ("late afternoon".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 17, 0));
        } else if ("evening".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(new Date(0, 0, 0, 20, 0));
        } else if ("null".equalsIgnoreCase(timeOfDay)) {
            survey.setTime(null);
        } else {
            errors.add(new SubmissionError("Unknown entry for time of day in row " + (row.getRowNum() + 1)));
        }
        // TODO check if the next two are assigned correctly
        survey.setOrganisation((groupname != null) ? groupname : "unknown");
        survey.setOrganisationType((participation != null) ? participation : "unknown");
        // TODO set the reef
        survey.setWeather((weather!=null)?weather:"unknown");
        survey.setActivity((activity!=null)?activity:"unknown");
        if (temperature != null) {
            survey.setTemperature(temperature);
        }
        if (latDeg != null) {
            survey.setLatitude((float) convertDegreesToDecimal(latDeg, latMin, latSec));
        }
        if (longDeg != null) {
            survey.setLongitude((float) convertDegreesToDecimal(longDeg, longMin, longSec));
        }
        survey.setComments(comments);
        SurveyRecord surveyRecord = new SurveyRecord(survey, coralType, lColor.charAt(0), lIntensity, dColor.charAt(0),
                dIntensity);
        Logger.getLogger(getClass().getName()).log(Level.FINE, "Creating new survey: " + survey);
        surveyDao.save(survey);
        surveyRecordDao.save(surveyRecord);
        return errors;
    }

    private double convertDegreesToDecimal(int deg, int min, double sec) {
        return deg + min / 60f + sec / 3600f;
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
