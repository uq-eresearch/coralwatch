package org.coralwatch.resources;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.resource.OutputRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import au.edu.uq.itee.maenad.restlet.EntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;


public class ReefDataResource extends EntityResource<Reef, ReefDao, UserImpl> {

    private HSSFCellStyle dateStyle;
	private HSSFCellStyle timeStyle;

	public ReefDataResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getReefDao());
        setContentTemplateName("reefdata.html.ftl");
        getVariants().add(new Variant(MediaType.APPLICATION_EXCEL));
    }
    
    @Override
    protected Representation protectedRepresent(Variant variant)
    		throws ResourceException {
    	String format = getQuery().getFirstValue("format");
    	loadJpaEntity();
    	if(variant.getMediaType().equals(MediaType.APPLICATION_EXCEL) || "excel".equals(format)) {
    		Reef reef = getJpaEntity();
    		final List<Survey> surveys = getDao().getSurveysByReef(reef);
            OutputRepresentation r = new OutputRepresentation(MediaType.APPLICATION_EXCEL) {
                @Override
                public void write(OutputStream stream) throws IOException {
                    HSSFWorkbook workbook = new HSSFWorkbook();
                    createDateStyles(workbook);
                    writeSurveySheet(workbook, surveys);
                    writeSurveyRecordSheet(workbook, surveys);
                    workbook.write(stream);
                }
            };
            r.setDownloadable(true);
            r.setDownloadName(reef.getName() + "-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls");
            return r;
    	}
    	return super.protectedRepresent(variant);
    }

    // TODO copy & paste code -- abstract the Excel handling
    protected void createDateStyles(HSSFWorkbook workbook) {
        HSSFDataFormat dataFormat = workbook.createDataFormat();
        dateStyle = workbook.createCellStyle();
        dateStyle.setDataFormat(dataFormat.getFormat("dd/MM/yyyy"));
        timeStyle = workbook.createCellStyle();
        timeStyle.setDataFormat(dataFormat.getFormat("HH:mm"));
    }

    private void writeSurveySheet(HSSFWorkbook workbook, List<Survey> surveys) {
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
        for (Survey survey : surveys) {
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
            setTimeCell(row.createCell(c++), survey.getTime());
            setCell(row.createCell(c++), survey.getWeather());
            setCell(row.createCell(c++), survey.getActivity());
            setCell(row.createCell(c++), survey.getTemperature());
            setCell(row.createCell(c++), survey.getComments());
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }

    private void writeSurveyRecordSheet(HSSFWorkbook workbook, List<Survey> surveys) {
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
        for(Survey survey:surveys){
	        for (SurveyRecord record : survey.getDataset()) {
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
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }
    
    private void setCell(HSSFCell cell, String value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(new HSSFRichTextString(value));
    }

    private void setCell(HSSFCell cell, Character value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(new HSSFRichTextString(value.toString()));
    }

    private void setCell(HSSFCell cell, Integer value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, Long value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, Float value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, Double value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
    }

    private void setCell(HSSFCell cell, Date value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
        cell.setCellStyle(dateStyle);
    }

    private void setTimeCell(HSSFCell cell, Date value) {
        if (value == null) {
            return;
        }
        cell.setCellValue(value);
        cell.setCellStyle(timeStyle);
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
    	super.fillDatamodel(datamodel);
        datamodel.put("surveys", getDao().getSurveysByReef(getJpaEntity()));
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) {
        return true;
    }
}