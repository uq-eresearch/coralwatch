package org.coralwatch.servlets;

import org.apache.poi.hssf.usermodel.*;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.util.AppUtil;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DataDownloadServlet extends HttpServlet {

    private HSSFCellStyle dateStyle;
    private HSSFCellStyle timeStyle;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AppUtil.clearCache();
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        ReefDao reefDao = CoralwatchApplication.getConfiguration().getReefDao();
        long id = Long.valueOf(request.getParameter("id"));
        Reef reef = reefDao.getById(id);
        response.setHeader("Content-Disposition", "attachment; filename=" + reef.getName() + "-"
                + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls");

        final List<Survey> surveys = reefDao.getSurveysByReef(reef);

        HSSFWorkbook workbook = new HSSFWorkbook();
        createDateStyles(workbook);
        writeSurveySheet(workbook, surveys);
        writeSurveyRecordSheet(workbook, surveys);
        ServletOutputStream stream = response.getOutputStream();
        workbook.write(stream);
    }

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
        setCell(row.createCell(c++), "Group Name");
        setCell(row.createCell(c++), "Participating As");
        setCell(row.createCell(c++), "Reef");
        setCell(row.createCell(c++), "Longitude");
        setCell(row.createCell(c++), "Latitude");
        setCell(row.createCell(c++), "Date");
        setCell(row.createCell(c++), "Time");
        setCell(row.createCell(c++), "Light Condition");
        setCell(row.createCell(c++), "Activity");
        setCell(row.createCell(c++), "Water Temperature");
        setCell(row.createCell(c++), "Comments");
        setCell(row.createCell(c++), "Number of records");
        setCell(row.createCell(c++), "Branching");
        setCell(row.createCell(c++), "Boulder");
        setCell(row.createCell(c++), "Plate");
        setCell(row.createCell(c++), "Soft");
        setCell(row.createCell(c++), "Average lightest");
        setCell(row.createCell(c++), "Average darkest");
        setCell(row.createCell(c++), "Average overall");
        int r = 1;
        for (Survey survey : surveys) {
            Map<String, Long> shapeCounts = new HashMap<String, Long>();
            shapeCounts.put("Branching", 0l);
            shapeCounts.put("Boulder", 0l);
            shapeCounts.put("Plate", 0l);
            shapeCounts.put("Soft", 0l);
            long sumLight = 0;
            long sumDark = 0;
            for (SurveyRecord record : survey.getDataset()) {
                shapeCounts.put(record.getCoralType(), shapeCounts.get(record.getCoralType()) + 1);
                sumLight += record.getLightestNumber();
                sumDark += record.getDarkestNumber();
            }
            int numRecords = survey.getDataset().size();
            row = sheet.createRow(r++);
            c = 0;
            setCell(row.createCell(c++), survey.getId());
            setCell(row.createCell(c++), survey.getCreator().getUsername());
            setCell(row.createCell(c++), survey.getGroupName());
            setCell(row.createCell(c++), survey.getParticipatingAs());
            setCell(row.createCell(c++), survey.getReef().getName());
            setCell(row.createCell(c++), survey.getLongitude());
            setCell(row.createCell(c++), survey.getLatitude());
            setCell(row.createCell(c++), survey.getDate());
            setTimeCell(row.createCell(c++), survey.getTime());
            setCell(row.createCell(c++), survey.getLightCondition());
            setCell(row.createCell(c++), survey.getActivity());
            setCell(row.createCell(c++), survey.getWaterTemperature());
            setCell(row.createCell(c++), survey.getComments());
            setCell(row.createCell(c++), numRecords);
            setCell(row.createCell(c++), shapeCounts.get("Branching"));
            setCell(row.createCell(c++), shapeCounts.get("Boulder"));
            setCell(row.createCell(c++), shapeCounts.get("Plate"));
            setCell(row.createCell(c++), shapeCounts.get("Soft"));
            setCell(row.createCell(c++), sumLight / (double) numRecords);
            setCell(row.createCell(c++), sumDark / (double) numRecords);
            setCell(row.createCell(c++), (sumLight + sumDark) / (2d * numRecords));
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }

    private void writeSurveyRecordSheet(HSSFWorkbook workbook,
                                        List<Survey> surveys) {
        HSSFSheet sheet = workbook.createSheet("Survey Records");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        setCell(row.createCell(c++), "Survey");
        setCell(row.createCell(c++), "Creator");
        setCell(row.createCell(c++), "Reef");
        setCell(row.createCell(c++), "Date");
        setCell(row.createCell(c++), "Time");
        setCell(row.createCell(c++), "Coral Type");
        setCell(row.createCell(c++), "Lightest Letter");
        setCell(row.createCell(c++), "Lightest Number");
        setCell(row.createCell(c++), "Darkest Letter");
        setCell(row.createCell(c++), "Darkest Number");
        int r = 1;
        for (Survey survey : surveys) {
            for (SurveyRecord record : survey.getDataset()) {
                row = sheet.createRow(r++);
                c = 0;
                setCell(row.createCell(c++), record.getSurvey().getId());
                setCell(row.createCell(c++), record.getSurvey().getCreator().getDisplayName());
                setCell(row.createCell(c++), record.getSurvey().getReef().getName());
                setCell(row.createCell(c++), record.getSurvey().getDate());
                setTimeCell(row.createCell(c++), record.getSurvey().getTime());
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

}
