package org.coralwatch.resources;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.resource.OutputRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.AccessControlledResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;

public class DataExchangeResource extends AccessControlledResource<UserImpl> {
    private final UserDao userDao;
    private final ReefDao reefDao;
    private final SurveyDao surveyDao;
    private final SurveyRecordDao surveyRecordDao;
    private final KitRequestDao kitrequestDao;

    public DataExchangeResource() throws InitializationException {
        super();
        getVariants().add(new Variant(MediaType.APPLICATION_EXCEL));
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
        this.reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        this.surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        this.surveyRecordDao = CoralwatchApplication.getConfiguration().getSurveyRecordDao();
        this.kitrequestDao = CoralwatchApplication.getConfiguration().getKitRequestDao();
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return user != null && user.isSuperUser();
    }

    @Override
    protected Representation protectedRepresent(Variant variant) throws ResourceException {
        OutputRepresentation r = new OutputRepresentation(MediaType.APPLICATION_EXCEL) {
            @Override
            public void write(OutputStream stream) throws IOException {
                HSSFWorkbook workbook = new HSSFWorkbook();
                writeUserSheet(workbook);
                writeReefSheet(workbook);
                writeSurveySheet(workbook);
                writeSurveyRecordSheet(workbook);
                writeKitRequestSheet(workbook);
                workbook.write(stream);
            }
        };
        r.setDownloadable(true);
        r.setDownloadName("coralwatch-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls");
        return r;
    }

    private void writeUserSheet(HSSFWorkbook workbook) {
        HSSFSheet sheet = workbook.createSheet("Users");
        int c = 0;
        HSSFRow row = sheet.createRow(0);
        setCell(row.createCell(c++), "Username");
        setCell(row.createCell(c++), "Display Name");
        setCell(row.createCell(c++), "Email Address");
        setCell(row.createCell(c++), "Address");
        setCell(row.createCell(c++), "Occupation");
        setCell(row.createCell(c++), "Country");
        setCell(row.createCell(c++), "Password Hash");
        setCell(row.createCell(c++), "Registration Date");
        setCell(row.createCell(c++), "Super User");
        int r = 1;
        for (UserImpl user : userDao.getAll()) {
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), user.getUsername());
            setCell(row.createCell(c++), user.getDisplayName());
            setCell(row.createCell(c++), user.getEmail());
            setCell(row.createCell(c++), user.getAddress());
            setCell(row.createCell(c++), user.getOccupation());
            setCell(row.createCell(c++), user.getCountry());
            setCell(row.createCell(c++), user.getPasswordHash());
            setCell(row.createCell(c++), user.getRegistrationDate());
            setCell(row.createCell(c++), user.isSuperUser());
        }
    }

    private void writeReefSheet(HSSFWorkbook workbook) {
        HSSFSheet sheet = workbook.createSheet("Reefs");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        setCell(row.createCell(c++), "ID");
        setCell(row.createCell(c++), "Name");
        setCell(row.createCell(c++), "Country");
        int r = 1;
        for (Reef reef : reefDao.getAll()) {
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), reef.getId());
            setCell(row.createCell(c++), reef.getName());
            setCell(row.createCell(c++), reef.getCountry());
        }
    }

    private void writeSurveySheet(HSSFWorkbook workbook) {
        HSSFSheet sheet = workbook.createSheet("Surveys");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        setCell(row.createCell(c++), "ID");
        setCell(row.createCell(c++), "Creator");
        setCell(row.createCell(c++), "Organisation");
        setCell(row.createCell(c++), "Organisation Type");
        setCell(row.createCell(c++), "Reef");
        setCell(row.createCell(c++), "Longitude");
        setCell(row.createCell(c++), "Latitude");
        setCell(row.createCell(c++), "Date");
        setCell(row.createCell(c++), "Time");
        setCell(row.createCell(c++), "Weather");
        setCell(row.createCell(c++), "Activity");
        setCell(row.createCell(c++), "Temperature");
        setCell(row.createCell(c++), "Comments");
        int r = 1;
        for (Survey survey : surveyDao.getAll()) {
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), survey.getId());
            setCell(row.createCell(c++), survey.getCreator().getUsername());
            setCell(row.createCell(c++), survey.getOrganisation());
            setCell(row.createCell(c++), survey.getOrganisationType());
            setCell(row.createCell(c++), survey.getReef().getId());
            setCell(row.createCell(c++), survey.getLongitude());
            setCell(row.createCell(c++), survey.getLatitude());
            setCell(row.createCell(c++), survey.getDate());
            setCell(row.createCell(c++), survey.getTime());
            setCell(row.createCell(c++), survey.getWeather());
            setCell(row.createCell(c++), survey.getActivity());
            setCell(row.createCell(c++), survey.getTemperature());
            setCell(row.createCell(c++), survey.getComments());
        }
    }

    private void writeSurveyRecordSheet(HSSFWorkbook workbook) {
        HSSFSheet sheet = workbook.createSheet("Survey Records");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        setCell(row.createCell(c++), "Survey");
        setCell(row.createCell(c++), "Coral Type");
        setCell(row.createCell(c++), "Lightest Letter");
        setCell(row.createCell(c++), "Lightest Number");
        setCell(row.createCell(c++), "Darkest Letter");
        setCell(row.createCell(c++), "Darkest Number");
        int r = 1;
        for (SurveyRecord record : surveyRecordDao.getAll()) {
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), record.getSurvey().getId());
            setCell(row.createCell(c++), record.getCoralType());
            setCell(row.createCell(c++), record.getLightestLetter());
            setCell(row.createCell(c++), record.getLightestNumber());
            setCell(row.createCell(c++), record.getDarkestLetter());
            setCell(row.createCell(c++), record.getDarkestNumber());
        }
    }

    private void writeKitRequestSheet(HSSFWorkbook workbook) {
        HSSFSheet sheet = workbook.createSheet("Kit Requests");
        int c = 0;
        HSSFRow row = sheet.createRow(0);
        setCell(row.createCell(c++), "Requester");
        setCell(row.createCell(c++), "Request Date");
        setCell(row.createCell(c++), "Dispatch Date");
        setCell(row.createCell(c++), "Address");
        setCell(row.createCell(c++), "Notes");
        int r = 1;
        for (KitRequest request : kitrequestDao.getAll()) {
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), request.getRequester().getUsername());
            setCell(row.createCell(c++), request.getRequestDate());
            setCell(row.createCell(c++), request.getDispatchdate());
            setCell(row.createCell(c++), request.getAddress());
            setCell(row.createCell(c++), request.getNotes());
        }
    }

    private void setCell(HSSFCell cell, String value) {
        cell.setCellValue(new HSSFRichTextString(value));
    }

    private void setCell(HSSFCell cell, long value) {
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, double value) {
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, Date value) {
        cell.setCellValue(value);
        // TODO: add formatting
    }

    private void setCell(HSSFCell cell, boolean value) {
        cell.setCellValue(value);
        // TODO: add formatting
    }
}
