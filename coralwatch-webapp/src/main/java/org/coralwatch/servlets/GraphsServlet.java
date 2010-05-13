package org.coralwatch.servlets;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.coralwatch.services.PlotService;
import org.jfree.chart.JFreeChart;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class GraphsServlet extends HttpServlet {

    private static int IMAGE_WIDTH = 300;
    private static int IMAGE_HEIGHT = 200;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("image/png");

        SurveyDao surveyDao = CoralwatchApplication.getConfiguration().getSurveyDao();
        String chart = request.getParameter("chart");
        long surveyId = Long.valueOf(request.getParameter("surveyId"));
        int imageWidth = Integer.valueOf(request.getParameter("width"));
        int imageHeight = Integer.valueOf(request.getParameter("height"));
        boolean labels = Boolean.valueOf(request.getParameter("labels"));
        boolean legend = Boolean.valueOf(request.getParameter("legend"));
        int titleSize = Integer.valueOf(request.getParameter("titleSize"));
        if (imageWidth > 5) {
            IMAGE_WIDTH = imageWidth;
        }
        if (imageHeight > 5) {
            IMAGE_HEIGHT = imageHeight;
        }
        final Survey survey = surveyDao.getById(surveyId);
        final List<Survey> surveys = Collections.singletonList(survey);
        final JFreeChart newChart;
        if ("shapePie".equals(chart)) {
            newChart = PlotService.createShapePiePlot(surveys, labels, legend, titleSize);
        } else {
            newChart = PlotService.createCoralCountPlot(surveys, legend, titleSize);
        }
        BufferedImage image = new BufferedImage(IMAGE_WIDTH, IMAGE_HEIGHT, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2d = image.createGraphics();
        newChart.draw(g2d, new Rectangle2D.Double(0, 0, image.getWidth(), image.getHeight()));
        ServletOutputStream stream = response.getOutputStream();
        ImageIO.write(image, "PNG", stream);
    }
}
