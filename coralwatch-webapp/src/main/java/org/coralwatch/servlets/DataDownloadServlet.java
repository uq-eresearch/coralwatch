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
        
        HSSFCellStyle dateStyle = workbook.createCellStyle();
        dateStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/MM/yyyy"));
        HSSFCellStyle timeStyle = workbook.createCellStyle();
        timeStyle.setDataFormat(workbook.createDataFormat().getFormat("HH:mm"));
        
        writeSurveySheet(workbook, surveys, dateStyle, timeStyle);
        writeSurveyRecordSheet(workbook, surveys, dateStyle, timeStyle);
        
        ServletOutputStream stream = response.getOutputStream();
        workbook.write(stream);
    }

    private static void writeSurveySheet(
        HSSFWorkbook workbook,
        List<Survey> surveys,
        HSSFCellStyle dateStyle,
        HSSFCellStyle timeStyle
    ) {
        HSSFSheet sheet = workbook.createSheet("Surveys");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        row.createCell(c++).setCellValue(new HSSFRichTextString("ID"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Creator"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Group Name"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Participating As"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Reef"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Longitude"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Latitude"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Date"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Time"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Light Condition"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Activity"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Water Temperature"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Comments"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Number of records"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Branching"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Boulder"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Plate"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Soft"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average lightest"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average darkest"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Average overall"));
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
            row.createCell(c++).setCellValue(survey.getId());
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getCreator().getUsername()));
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getGroupName()));
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getParticipatingAs()));
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getReef().getName()));
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
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getActivity()));
            {
                HSSFCell cell = row.createCell(c++);
                if (survey.getWaterTemperature() != null) {
                    cell.setCellValue(survey.getWaterTemperature());
                }
            }
            row.createCell(c++).setCellValue(new HSSFRichTextString(survey.getComments()));
            row.createCell(c++).setCellValue(numRecords);
            row.createCell(c++).setCellValue(shapeCounts.get("Branching"));
            row.createCell(c++).setCellValue(shapeCounts.get("Boulder"));
            row.createCell(c++).setCellValue(shapeCounts.get("Plate"));
            row.createCell(c++).setCellValue(shapeCounts.get("Soft"));
            row.createCell(c++).setCellValue(sumLight / (double) numRecords);
            row.createCell(c++).setCellValue(sumDark / (double) numRecords);
            row.createCell(c++).setCellValue((sumLight + sumDark) / (2d * numRecords));
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }

    private static void writeSurveyRecordSheet(
        HSSFWorkbook workbook,
        List<Survey> surveys,
        HSSFCellStyle dateStyle,
        HSSFCellStyle timeStyle
    ) {
        HSSFSheet sheet = workbook.createSheet("Survey Records");
        HSSFRow row = sheet.createRow(0);
        int c = 0;
        row.createCell(c++).setCellValue(new HSSFRichTextString("Survey"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Creator"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Reef"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Date"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Time"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Coral Type"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Lightest Letter"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Lightest Number"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Darkest Letter"));
        row.createCell(c++).setCellValue(new HSSFRichTextString("Darkest Number"));
        int r = 1;
        for (Survey survey : surveys) {
            for (SurveyRecord record : survey.getDataset()) {
                row = sheet.createRow(r++);
                c = 0;
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
                row.createCell(c++).setCellValue(new HSSFRichTextString(record.getCoralType()));
                row.createCell(c++).setCellValue(new HSSFRichTextString(String.valueOf(record.getLightestLetter())));
                row.createCell(c++).setCellValue(record.getLightestNumber());
                row.createCell(c++).setCellValue(new HSSFRichTextString(String.valueOf(record.getDarkestLetter())));
                row.createCell(c++).setCellValue(record.getDarkestNumber());
            }
        }
        for (; c >= 0; c--) {
            sheet.autoSizeColumn((short) c);
        }
    }
}
