package org.coralwatch.services;

import java.awt.Color;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.text.DateFormatter;

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
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.time.Month;
import org.jfree.data.time.Quarter;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;

public class PlotService {
	public static final Map<Character, Map<Integer, Color>> COLORS = new HashMap<Character, Map<Integer, Color>>();
	static {
		HashMap<Integer, Color> bValues = new HashMap<Integer, Color>();
		bValues.put(1, new Color(247, 248, 232));
		bValues.put(2, new Color(244, 247, 193));
		bValues.put(3, new Color(236, 241, 139));
		bValues.put(4, new Color(202, 208, 72));
		bValues.put(5, new Color(153, 159, 41));
		bValues.put(6, new Color(100, 120, 0));
		COLORS.put('B', bValues);
		HashMap<Integer, Color> cValues = new HashMap<Integer, Color>();
		cValues.put(1, new Color(247, 236, 233));
		cValues.put(2, new Color(247, 203, 193));
		cValues.put(3, new Color(240, 159, 140));
		cValues.put(4, new Color(208, 98, 72));
		cValues.put(5, new Color(159, 63, 41));
		cValues.put(6, new Color(120, 23, 0));
		COLORS.put('C', cValues);
		HashMap<Integer, Color> dValues = new HashMap<Integer, Color>();
		dValues.put(1, new Color(247, 236, 225));
		dValues.put(2, new Color(247, 220, 193));
		dValues.put(3, new Color(240, 190, 140));
		dValues.put(4, new Color(212, 150, 88));
		dValues.put(5, new Color(155, 95, 35));
		dValues.put(6, new Color(120, 60, 0));
		COLORS.put('D', dValues);
		HashMap<Integer, Color> eValues = new HashMap<Integer, Color>();
		eValues.put(1, new Color(247, 242, 227));
		eValues.put(2, new Color(247, 233, 193));
		eValues.put(3, new Color(240, 214, 140));
		eValues.put(4, new Color(210, 176, 80));
		eValues.put(5, new Color(159, 128, 41));
		eValues.put(6, new Color(120, 89, 0));
		COLORS.put('E', eValues);
	}

	@SuppressWarnings("deprecation") // we don't want to use Calendar
	public static JFreeChart createTimelinePlot(final List<Survey> surveys) {
		class DataPoint {
			long numRecords = 0;
			long sumLight = 0;
			long sumDark = 0;
		};
		Map<Date,DataPoint> data = new HashMap<Date,DataPoint>();
		for (Survey survey : surveys) {
			if (survey.getDate() == null) {
				continue;
			}
			int year = survey.getDate().getYear();
			//int month = ((survey.getDate().getMonth()-1)/3)*3 +1;
			int month = survey.getDate().getMonth();
			Date datePoint = new Date(year,month,1);
			DataPoint dataPoint = data.get(datePoint);
			if(dataPoint == null) {
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
		TimeSeries lightSeries = new TimeSeries("Lightest");
		TimeSeries darkSeries = new TimeSeries("Darkest");
		for (Date date : data.keySet()) {
			DataPoint dataPoint = data.get(date);
			lightSeries.add(new Month(date), dataPoint.sumLight/(double)dataPoint.numRecords);
			darkSeries.add(new Month(date), dataPoint.sumDark/(double)dataPoint.numRecords);
		}
		dataset.addSeries(lightSeries);
		dataset.addSeries(darkSeries);
		final JFreeChart newChart = ChartFactory.createTimeSeriesChart(
				"Average Color Over Time", "Time", "Average Color", dataset, true, false,
				false);
		Color transparent = new Color(0, 0, 0, 0);
		newChart.setBackgroundPaint(transparent);
		XYPlot plot = newChart.getXYPlot();
		plot.setBackgroundPaint(transparent);
		plot.setDomainGridlinePaint(Color.DARK_GRAY);
		plot.setRangeGridlinePaint(Color.DARK_GRAY);
		TickUnits tickUnits = new TickUnits();
		tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 1, new SimpleDateFormat("MM/yyyy")));
		tickUnits.add(new DateTickUnit(DateTickUnitType.MONTH, 3, new SimpleDateFormat("MM/yyyy")));
		tickUnits.add(new DateTickUnit(DateTickUnitType.YEAR, 1, new SimpleDateFormat("MM/yyyy")));
		plot.getDomainAxis().setStandardTickUnits(tickUnits);
		NumberAxis numberAxis = new NumberAxis();
		numberAxis.setAutoRange(false);
		numberAxis.setRange(1, 6);
		plot.setRangeAxis(numberAxis);
		XYShapeRenderer itemRenderer = new XYShapeRenderer();
		itemRenderer.setSeriesPaint(0, COLORS.get('E').get(3));
		itemRenderer.setSeriesPaint(1, COLORS.get('E').get(6));
		plot.setRenderer(itemRenderer);
		return newChart;
	}

	public static JFreeChart createCoralCountPlot(final List<Survey> surveys) {
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		for(char c ='B'; c<='E'; c++) {
			for (int i = 1; i <= 6; i++) {
				dataset.setValue(0, String.valueOf(c), String.valueOf(i));
			}
		}
		for (Survey survey : surveys) {
			for (SurveyRecord record : survey.getDataset()) {
				int num = (int) (0.5 + (record.getDarkestNumber() + record
						.getLightestNumber()) / 2d);
				String rowKey = String.valueOf(record.getDarkestLetter());
				String columnKey = String.valueOf(num);
				dataset.setValue(
						dataset.getValue(rowKey, columnKey).intValue() + 1,
						rowKey, columnKey);
			}
		}
		JFreeChart chart = ChartFactory.createStackedBarChart("Color Distribution", null, null,
				dataset, PlotOrientation.HORIZONTAL, false, false, false);
		CategoryPlot plot = chart.getCategoryPlot();
		plot.setBackgroundAlpha(0);
		plot.setRangeGridlinePaint(Color.GRAY);
		TickUnits tickUnits = new TickUnits();
		double[] ticks = new double[]{1,5,10,50,100,500,1000,5000,10000,50000,1000000,500000};
		for(double d: ticks){
			tickUnits.add(new NumberTickUnit(d));
		}
		plot.getRangeAxis().setStandardTickUnits(tickUnits);
		BarRenderer renderer = (BarRenderer) plot.getRenderer();
		for(char c ='B'; c<='E'; c++) {
			renderer.setSeriesPaint(c - 'B', COLORS.get(c).get(5));
		}		
		return chart;
	}

	public static JFreeChart createShapePiePlot(final List<Survey> surveys) {
		DefaultPieDataset dataset = new DefaultPieDataset();
		for (Survey survey : surveys) {
			for (SurveyRecord record : survey.getDataset()) {
				String coralShape = record.getCoralType();
				if (!dataset.getKeys().contains(coralShape)) {
					dataset.setValue(coralShape, 1);
				} else {
					Number curValue = dataset.getValue(coralShape);
					dataset.setValue(coralShape, curValue.intValue() + 1);
				}
			}
		}
		JFreeChart chart = ChartFactory.createPieChart("Shape Distribution", dataset,
				false, false, false);
		PiePlot plot = (PiePlot) chart.getPlot();
		plot.setBackgroundAlpha(0);
		plot.setSimpleLabels(true);
		plot.setLabelBackgroundPaint(COLORS.get('D').get(1));
		plot.setLabelShadowPaint(null);
		int i = 0;
		for(Object key: plot.getDataset().getKeys()) {
			plot.setSectionPaint((Comparable<?>) key, COLORS.get((char)('B' + i)).get(6-i));
			i++;
		}
		return chart;
	}
}
