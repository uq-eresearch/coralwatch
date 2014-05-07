package org.coralwatch.services;

import java.awt.Color;
import java.awt.Font;
import java.awt.Paint;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateTickUnit;
import org.jfree.chart.axis.DateTickUnitType;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.axis.TickUnits;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.renderer.xy.XYShapeRenderer;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.time.Month;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.ui.RectangleEdge;
import org.jfree.ui.VerticalAlignment;

@SuppressWarnings("serial")
public class PlotService {
    public static final Map<Character, Map<Integer, Color>> CORAL_COLORS = new HashMap<Character, Map<Integer, Color>>() {{
        HashMap<Integer, Color> bValues = new HashMap<Integer, Color>();
        bValues.put(1, new Color(247, 248, 232));
        bValues.put(2, new Color(244, 247, 193));
        bValues.put(3, new Color(236, 241, 139));
        bValues.put(4, new Color(202, 208, 72));
        bValues.put(5, new Color(153, 159, 41));
        bValues.put(6, new Color(100, 120, 0));
        put('B', bValues);
        HashMap<Integer, Color> cValues = new HashMap<Integer, Color>();
        cValues.put(1, new Color(247, 236, 233));
        cValues.put(2, new Color(247, 203, 193));
        cValues.put(3, new Color(240, 159, 140));
        cValues.put(4, new Color(208, 98, 72));
        cValues.put(5, new Color(159, 63, 41));
        cValues.put(6, new Color(120, 23, 0));
        put('C', cValues);
        HashMap<Integer, Color> dValues = new HashMap<Integer, Color>();
        dValues.put(1, new Color(247, 236, 225));
        dValues.put(2, new Color(247, 220, 193));
        dValues.put(3, new Color(240, 190, 140));
        dValues.put(4, new Color(212, 150, 88));
        dValues.put(5, new Color(155, 95, 35));
        dValues.put(6, new Color(120, 60, 0));
        put('D', dValues);
        HashMap<Integer, Color> eValues = new HashMap<Integer, Color>();
        eValues.put(1, new Color(247, 242, 227));
        eValues.put(2, new Color(247, 233, 193));
        eValues.put(3, new Color(240, 214, 140));
        eValues.put(4, new Color(210, 176, 80));
        eValues.put(5, new Color(159, 128, 41));
        eValues.put(6, new Color(120, 89, 0));
        put('E', eValues);
    }};

    // TODO shape names should really be an enum, maybe with the color attached to them
    public static final Map<String, Color> SHAPE_COLORS = new HashMap<String, Color>() {{
        put("Branching", new Color(195, 38, 47));
        put("Boulder", new Color(217, 226, 39));
        put("Plate", new Color(210, 210, 212));
        put("Soft", new Color(248, 148, 34));
    }};

    // we don't want to use Calendar
    public static JFreeChart createTimelinePlot(final List<Survey> surveys, boolean legend, int titleSize) {
        class DataPoint {
            long numRecords = 0;
            long sumLight = 0;
            long sumDark = 0;
        }
        ;
        Map<Date, DataPoint> data = new HashMap<Date, DataPoint>();
        for (Survey survey : surveys) {
            if (survey.getDate() == null) {
                continue;
            }
            GregorianCalendar calendar = new GregorianCalendar();
            calendar.setTime(survey.getDate());
            calendar.set(Calendar.DAY_OF_MONTH, 1);
            Date datePoint = calendar.getTime();
            DataPoint dataPoint = data.get(datePoint);
            if (dataPoint == null) {
                dataPoint = new DataPoint();
                data.put(datePoint, dataPoint);
            }
            for (SurveyRecord record : survey.getDataset()) {
                dataPoint.numRecords++;
                dataPoint.sumLight += record.getLightestNumber();
                dataPoint.sumDark += record.getDarkestNumber();
            }
        }
        TimeSeriesCollection dataset = new TimeSeriesCollection();
        TimeSeries series = new TimeSeries("Darkest");
        for (Date date : data.keySet()) {
            DataPoint dataPoint = data.get(date);
            series.add(new Month(date), (dataPoint.sumDark + dataPoint.sumLight) / (2d * dataPoint.numRecords));
        }
        dataset.addSeries(series);
        final JFreeChart newChart = ChartFactory.createTimeSeriesChart(
                "Average Colour Over Time", "Time", "Average Colour Score", dataset, legend, false,
                false);
        newChart.getTitle().setFont(new Font(null, Font.PLAIN, titleSize));
        Color transparent = new Color(0, 0, 0, 0);
        newChart.setBackgroundPaint(transparent);
        XYPlot plot = newChart.getXYPlot();
        plot.setBackgroundPaint(transparent);
        plot.setDomainGridlinePaint(Color.DARK_GRAY);
        plot.setRangeGridlinePaint(Color.DARK_GRAY);
        TickUnits tickUnits = new TickUnits();
        tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 1, new SimpleDateFormat("MM/yyyy")));
        tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 3, new SimpleDateFormat("MM/yyyy")));
        tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 6, new SimpleDateFormat("MM/yyyy")));
        tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 12, new SimpleDateFormat("MM/yyyy")));
        tickUnits.add(new DateTickUnit(DateTickUnitType.YEAR, 1, new SimpleDateFormat("MM/yyyy")));
        plot.getDomainAxis().setStandardTickUnits(tickUnits);
        NumberAxis numberAxis = new NumberAxis();
        numberAxis.setAutoRange(false);
        numberAxis.setRange(1, 6);
        numberAxis.setTickUnit(new NumberTickUnit(0.5));
        plot.setRangeAxis(numberAxis);
        plot.getRangeAxis().setLabel("Average Colour Score");
        plot.getRangeAxis().setLabelFont(new Font(null, Font.PLAIN, titleSize));
        plot.getDomainAxis().setLabelFont(new Font(null, Font.PLAIN, titleSize));
        XYShapeRenderer itemRenderer = new XYShapeRenderer();
        itemRenderer.setSeriesPaint(0, CORAL_COLORS.get('D').get(6));
        plot.setRenderer(itemRenderer);
        return newChart;
    }

    public static JFreeChart createCoralCountPlot(final List<Survey> surveys, boolean legend, int titleSize) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        String rowKey = "All";
        for (int i = 1; i <= 6; i++) {
            dataset.setValue(0, rowKey, String.valueOf(i));
        }
        int totalRecords = 0;
        for (Survey survey : surveys) {
            List<SurveyRecord> records = survey.getDataset();
            totalRecords = totalRecords + records.size();
            for (SurveyRecord record : records) {
                int num = (int) (0.5 + (record.getDarkestNumber() + record.getLightestNumber()) / 2d);
                String columnKey = String.valueOf(num);
                dataset.setValue(dataset.getValue(rowKey, columnKey).intValue() + 1, rowKey, columnKey);
            }
        }
        for (int i = 1; i <= 6; i++) {
            dataset.setValue((dataset.getValue(rowKey, String.valueOf(i)).doubleValue() / totalRecords) * 100, rowKey, String.valueOf(i));
        }

        String chartTitle = "Colour Distribution";
        if (surveys.size() > 1) {
            chartTitle = "Colour Distribution of All Surveys";
        }
        JFreeChart chart = ChartFactory.createBarChart(chartTitle, null, null,
                dataset, PlotOrientation.VERTICAL, legend, false, false);
        chart.getTitle().setFont(new Font(null, Font.PLAIN, titleSize));

        final TextTitle subtitle = new TextTitle(totalRecords + " Corals Surveyed");
        subtitle.setFont(new Font("SansSerif", Font.PLAIN, titleSize));
        subtitle.setPosition(RectangleEdge.RIGHT);
        subtitle.setVerticalAlignment(VerticalAlignment.CENTER);
        chart.addSubtitle(subtitle);

        CategoryPlot plot = chart.getCategoryPlot();
        plot.setBackgroundAlpha(0);
        plot.setRangeGridlinePaint(Color.GRAY);
        plot.getRangeAxis().setLabel("Frequency (%)");
        plot.getRangeAxis().setLabelFont(new Font(null, Font.PLAIN, titleSize));
        plot.getDomainAxis().setLabel("Colour Score");
        plot.getDomainAxis().setLabelFont(new Font(null, Font.PLAIN, titleSize));

        TickUnits tickUnits = new TickUnits();
//        double[] ticks = new double[]{1, 5, 10, 50, 100, 500, 1000, 5000, 10000, 50000, 1000000, 500000};
        double[] ticks = new double[]{10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
        for (double d : ticks) {
            tickUnits.add(new NumberTickUnit(d));
        }
        plot.getRangeAxis().setStandardTickUnits(tickUnits);
        BarRenderer renderer = new BarRenderer() {
            @Override
            public Paint getItemPaint(int row, int column) {
                return CORAL_COLORS.get('D').get(column + 1);
            }
        };
        renderer.setShadowVisible(false);
        plot.setRenderer(renderer);
        return chart;
    }

    public static JFreeChart createShapePiePlot(final List<Survey> surveys, boolean labels, boolean legend, int titleSize) {
        DefaultPieDataset dataset = new DefaultPieDataset();
        int numberOfRecords = 0;
        for (Survey survey : surveys) {
            List<SurveyRecord> surveyRecords = survey.getDataset();
            numberOfRecords = numberOfRecords + surveyRecords.size();
            for (SurveyRecord record : surveyRecords) {
                String coralShape = record.getCoralType();
                if (!dataset.getKeys().contains(coralShape)) {
                    dataset.setValue(coralShape, 1);
                } else {
                    Number curValue = dataset.getValue(coralShape);
                    dataset.setValue(coralShape, curValue.intValue() + 1);
                }
            }
        }
        String chartTitle = "Coral Type Distribution";
        if (surveys.size() > 1) {
            chartTitle = "Coral Type Distribution of All Surveys";
        }

        JFreeChart chart = ChartFactory.createPieChart(chartTitle, dataset, legend, false, false);
        chart.getTitle().setFont(new Font(null, Font.PLAIN, titleSize));
        chart.getLegend().setItemFont(new Font("SansSerif", Font.PLAIN, titleSize - 2));


        PiePlot plot = (PiePlot) chart.getPlot();
        plot.setBackgroundAlpha(0);
        plot.setSimpleLabels(true);
        plot.setLabelGenerator(null);
        plot.setLabelBackgroundPaint(Color.WHITE);
        plot.setShadowPaint(Color.WHITE);

        if (!labels) {
            plot.setLabelShadowPaint(null);
        }
        for (Object key : plot.getDataset().getKeys()) {
            plot.setSectionPaint((Comparable<?>) key, SHAPE_COLORS.get(key));
        }

        final TextTitle subtitle = new TextTitle(numberOfRecords + " Corals Surveyed");
        subtitle.setFont(new Font("SansSerif", Font.PLAIN, titleSize));
        subtitle.setPosition(RectangleEdge.BOTTOM);
        subtitle.setVerticalAlignment(VerticalAlignment.BOTTOM);
        chart.addSubtitle(subtitle);

        return chart;
    }
}
