package org.coralwatch.services;

import java.awt.Color;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYShapeRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.time.Day;
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

	public static JFreeChart createScatterPlot(String chartTitle,
			final List<Survey> surveys) {
		TimeSeries[] series = new TimeSeries[] { new TimeSeries("B-light"),
				new TimeSeries("C-light"), new TimeSeries("D-light"),
				new TimeSeries("E-light"), new TimeSeries("B-dark"),
				new TimeSeries("C-dark"), new TimeSeries("D-dark"),
				new TimeSeries("E-dark") };
		for (Survey survey : surveys) {
			if (survey.getDate() == null) {
				continue;
			}
			long[] sumLights = new long[] { 0, 0, 0, 0 };
			long[] sumDarks = new long[] { 0, 0, 0, 0 };
			long[] countLights = new long[] { 0, 0, 0, 0 };
			long[] countDarks = new long[] { 0, 0, 0, 0 };
			for (SurveyRecord record : survey.getDataset()) {
				int posLight = record.getLightestLetter() - 'B';
				int posDark = record.getDarkestLetter() - 'B';
				sumLights[posLight] += record.getLightestNumber();
				sumDarks[posDark] += record.getDarkestNumber();
				countLights[posLight]++;
				countDarks[posDark]++;
			}
			// TODO results override each other if they happen on
			// the same day (in avoidance of bug #130)
			for (int i = 0; i < sumLights.length; i++) {
				if (countLights[i] != 0) {
					series[i].addOrUpdate(new Day(survey.getDate()),
							sumLights[i] / (double) countLights[i]);
				}
			}
			for (int i = 0; i < sumDarks.length; i++) {
				if (countDarks[i] != 0) {
					series[i + sumLights.length].addOrUpdate(new Day(survey
							.getDate()), sumDarks[i] / (double) countDarks[i]);
				}
			}
		}
		TimeSeriesCollection dataset = new TimeSeriesCollection();
		for (int i = 0; i < series.length; i++) {
			dataset.addSeries(series[i]);
		}
		final JFreeChart newChart = ChartFactory.createTimeSeriesChart(
				chartTitle, "Time", "Average Color", dataset, true, false,
				false);
		Color transparent = new Color(0, 0, 0, 0);
		newChart.setBackgroundPaint(transparent);
		XYPlot plot = newChart.getXYPlot();
		plot.setBackgroundPaint(transparent);
		plot.setDomainGridlinePaint(Color.DARK_GRAY);
		plot.setRangeGridlinePaint(Color.DARK_GRAY);
		NumberAxis numberAxis = new NumberAxis();
		numberAxis.setAutoRange(false);
		numberAxis.setRange(1, 6);
		plot.setRangeAxis(numberAxis);
		XYShapeRenderer itemRenderer = new XYShapeRenderer();
		// TODO this duplicates the color values of the COLORS constant
		Color[] colors = new Color[] { new Color(244, 247, 193),
				new Color(247, 203, 193), new Color(247, 220, 193),
				new Color(247, 233, 193), new Color(100, 120, 0),
				new Color(120, 23, 0), new Color(120, 60, 0),
				new Color(120, 89, 0) };
		for (int i = 0; i < colors.length; i++) {
			itemRenderer.setSeriesPaint(i, colors[i]);
		}
		plot.setRenderer(itemRenderer);
		return newChart;
	}

	public static JFreeChart createCoralCountPlot(String chartTitle,
			List<Survey> surveys) {
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		String rowKey = "Count";
		for (int i = 1; i <= 6; i++) {
			dataset.setValue(0, rowKey, String.valueOf(i));
		}
		for (Survey survey : surveys) {
			for (SurveyRecord record : survey.getDataset()) {
				int num = (int) ((record.getDarkestNumber() + record
						.getLightestNumber()) / 2d);
				String columnKey = String.valueOf(num);
				dataset.setValue(
						dataset.getValue(rowKey, columnKey).intValue() + 1,
						rowKey, columnKey);
			}
		}
		JFreeChart chart = ChartFactory.createBarChart(chartTitle, null, null,
				dataset, PlotOrientation.HORIZONTAL, false, false, false);
		return chart;
	}

	public static JFreeChart createShapePiePlot(String chartTitle,
			List<Survey> surveys) {
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
		JFreeChart chart = ChartFactory.createPieChart(chartTitle, dataset,
				false, false, false);
		return chart;
	}
}
