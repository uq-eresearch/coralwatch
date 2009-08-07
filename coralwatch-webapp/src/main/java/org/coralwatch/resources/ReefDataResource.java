package org.coralwatch.resources;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

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
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYShapeRenderer;
import org.jfree.data.time.Day;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
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
		if (variant.getMediaType().equals(MediaType.APPLICATION_EXCEL)
				|| "excel".equals(format)) {
			Reef reef = getJpaEntity();
			final List<Survey> surveys = getDao().getSurveysByReef(reef);
			OutputRepresentation r = new OutputRepresentation(
					MediaType.APPLICATION_EXCEL) {
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
			r.setDownloadName(reef.getName() + "-"
					+ new SimpleDateFormat("yyyyMMdd").format(new Date())
					+ ".xls");
			return r;
		}
		if (variant.getMediaType().equals(MediaType.IMAGE_PNG)
				|| "png".equals(format)) {
			final Reef reef = getJpaEntity();
			final List<Survey> surveys = getDao().getSurveysByReef(reef);
			OutputRepresentation r = new OutputRepresentation(
					MediaType.IMAGE_PNG) {
				@Override
				public void write(OutputStream stream) throws IOException {
					TimeSeries[] series = new TimeSeries[] {
							new TimeSeries("B-light"),
							new TimeSeries("C-light"),
							new TimeSeries("D-light"),
							new TimeSeries("E-light"),
							new TimeSeries("B-dark"),
							new TimeSeries("C-dark"),
							new TimeSeries("D-dark"),
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
							if(countLights[i]!=0) {
								series[i].addOrUpdate(new Day(survey.getDate()), sumLights[i]/(double)countLights[i]);
							}
						}
						for (int i = 0; i < sumDarks.length; i++) {
							if(countDarks[i]!=0) {
								series[i+sumLights.length].addOrUpdate(new Day(survey.getDate()), sumDarks[i]/(double)countDarks[i]);
							}
						}
					}
					TimeSeriesCollection dataset = new TimeSeriesCollection();
					for (int i = 0; i < series.length; i++) {
						dataset.addSeries(series[i]);
					}
					final JFreeChart newChart = ChartFactory.createTimeSeriesChart(
							reef.getName() + " (" + reef.getCountry() + ")",
							"Time", "Average Color", dataset,
							true, false, false);
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
					Color[] colors = new Color[]{
							new Color(244, 247, 193),
							new Color(247, 203, 193),
							new Color(247, 220, 193),
							new Color(247, 233, 193),
							new Color(100, 120, 0),
							new Color(120, 23, 0),
							new Color(120, 60, 0),
							new Color(120, 89, 0)
					};
					for (int i = 0; i < colors.length; i++) {
						itemRenderer.setSeriesPaint(i, colors[i]);
					}
					plot.setRenderer(itemRenderer);
					BufferedImage image = new BufferedImage(700, 400,
							BufferedImage.TYPE_INT_ARGB);
					Graphics2D g2d = image.createGraphics();
					newChart.draw(g2d, new Rectangle2D.Double(0, 0, image
							.getWidth(), image.getHeight()));
					ImageIO.write(image, "PNG", stream);
				}
			};
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

	private void writeSurveyRecordSheet(HSSFWorkbook workbook,
			List<Survey> surveys) {
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
		for (Survey survey : surveys) {
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
	protected void fillDatamodel(Map<String, Object> datamodel)
			throws NoDataFoundException {
		super.fillDatamodel(datamodel);
		datamodel.put("surveys", getDao().getSurveysByReef(getJpaEntity()));
	}

	@Override
	protected boolean getAllowed(UserImpl user, Variant variant) {
		return true;
	}
}
