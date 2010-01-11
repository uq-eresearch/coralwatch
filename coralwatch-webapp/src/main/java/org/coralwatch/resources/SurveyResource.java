package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;
import org.coralwatch.services.PlotService;
import org.jfree.chart.JFreeChart;
import org.restlet.data.Form;
import org.restlet.data.MediaType;
import org.restlet.data.Parameter;
import org.restlet.resource.OutputRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import javax.imageio.ImageIO;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SurveyResource extends ModifiableEntityResource<Survey, SurveyDao, UserImpl> {
    private static final Logger LOGGER = Logger.getLogger(SurveyResource.class.getName());
    private static final int IMAGE_WIDTH = 300;
    private static final int IMAGE_HEIGHT = 200;
    private boolean noFrame = false;

    public SurveyResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getSurveyDao());
        //TODO move the creation of graphs to a different resource
//        getVariants().add(0, new Variant(MediaType.IMAGE_PNG));
    }

    @Override
    protected Representation protectedRepresent(Variant variant)
            throws ResourceException {

        Parameter param = getQuery().getFirst("noframe");
        if (param != null && Boolean.parseBoolean(param.getValue())) {
            noFrame = true;
            setMainTemplateName("noframe.html.ftl");
        }

        String format = getQuery().getFirstValue("format");
        if (variant.getMediaType().equals(MediaType.IMAGE_PNG)
                || "png".equals(format)) {
            String chart = getQuery().getFirstValue("chart");
            loadJpaEntity();
            final Survey survey = getJpaEntity();
            final List<Survey> surveys = Collections.singletonList(survey);
            final JFreeChart newChart;
            if ("shapePie".equals(chart)) {
                newChart = PlotService.createShapePiePlot(surveys);
            } else {
                newChart = PlotService.createCoralCountPlot(surveys);
            }
            OutputRepresentation r = new OutputRepresentation(MediaType.IMAGE_PNG) {
                @Override
                public void write(OutputStream stream) throws IOException {
                    BufferedImage image = new BufferedImage(IMAGE_WIDTH,
                            IMAGE_HEIGHT, BufferedImage.TYPE_INT_ARGB);
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

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
        Survey survey = (Survey) datamodel.get(getTemplateObjectName());
        datamodel.put("noFrame", noFrame);
        datamodel.put("surveyRecs", getDao().getSurveyRecords(survey));
        datamodel.put("reefRecs", CoralwatchApplication.getConfiguration().getReefDao().getAll());
        datamodel.put("communityTrust", CoralwatchApplication.getConfiguration().getTrustDao().getCommunityTrustValue(survey.getCreator()));
        datamodel.put("communityRating", CoralwatchApplication.getConfiguration().getSurveyRatingDao().getCommunityRatingValue(survey));
        datamodel.put("userRating", CoralwatchApplication.getConfiguration().getSurveyRatingDao().getRatingValueByUser(getCurrentUser(), survey));
    }

    @Override
    protected void updateObject(Survey survey, Form form) throws SubmissionException {
        updateSurvey(survey, form);
    }

    static void updateSurvey(Survey survey, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();

        String organisation = form.getFirstValue("organisation");
        if ((organisation == null) || organisation.isEmpty()) {
            errors.add(new SubmissionError("No organisation name was provided. Organisation name must be supplied."));
        } else {
            survey.setOrganisation(organisation);
        }

        String organisationType = form.getFirstValue("organisationType");
        if ((organisationType == null) || organisationType.isEmpty()) {
            errors.add(new SubmissionError("No organisation type was provided. Organisation type must be supplied."));
        } else {
            survey.setOrganisationType(organisationType);
        }

        String reefName = form.getFirstValue("reefName");
        if ((reefName == null) || reefName.isEmpty()) {
            errors.add(new SubmissionError("No reef name was provided. Reef name must be supplied."));
        } else {
            Reef reef = CoralwatchApplication.getConfiguration().getReefDao().getReefByName(reefName);
            if (reef == null) {
                errors.add(new SubmissionError("The reef you provided is invalid. Reef name must be supplied."));
            } else {
                survey.setReef(reef);
            }
        }

        String latitudeStr = form.getFirstValue("latitude");
        if (latitudeStr == null || latitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No latitude value was provided. Latitude value must be supplied."));
        } else {
            try {
                float latitude = Float.parseFloat(latitudeStr);
                survey.setLatitude(latitude);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.INFO, "Faild to parse latitude. Value entered: " + latitudeStr, e);
                errors.add(new SubmissionError("Latitude value supplied is invalid."));
            }
        }

        String longitudeStr = form.getFirstValue("longitude");
        if (longitudeStr == null || longitudeStr.isEmpty()) {
            errors.add(new SubmissionError("No longitude value was provided. Longitude value must be supplied."));
        } else {
            try {
                float longitude = Float.parseFloat(longitudeStr);
                survey.setLongitude(longitude);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.INFO, "Faild to parse longitude. Value entered: " + longitudeStr, e);
                errors.add(new SubmissionError("Longitude value supplied is invalid."));
            }
        }

        String dateStr = form.getFirstValue("date").trim();
        if (dateStr == null || dateStr.isEmpty()) {
            errors.add(new SubmissionError("No survey date was provided. Survey Date must be supplied."));
        } else {
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                Date date = df.parse(dateStr);
                survey.setDate(date);
            } catch (ParseException ex) {
                errors.add(new SubmissionError("Date value supplied is invalid."));
            }
        }

        String timeStr = form.getFirstValue("time");
        if ((timeStr == null) || timeStr.isEmpty()) {
            errors.add(new SubmissionError("No time was provided. Time must be supplied."));
        } else {
            try {
                DateFormat df = new SimpleDateFormat("'T'HH:mm:ss");
                Date time = df.parse(timeStr);
                survey.setTime(time);
            } catch (ParseException ex) {
                LOGGER.log(Level.INFO, "Faild to parse time for survey. Time entered: " + timeStr, ex);
                errors.add(new SubmissionError("Time value supplied is invalid."));
            }
        }

        survey.setDateModified(new Date());

        String weather = form.getFirstValue("weather");
        if ((weather == null) || weather.isEmpty()) {
            errors.add(new SubmissionError("No weather condition was provided. Weather condition must be supplied."));
        } else {
            survey.setWeather(weather);
        }

        String activity = form.getFirstValue("activity");
        if ((activity == null) || activity.isEmpty()) {
            errors.add(new SubmissionError("No activity was provided. Activity must be supplied."));
        } else {
            survey.setActivity(activity);
        }

        String temp = form.getFirstValue("temperature");
        if (temp == null || temp.isEmpty()) {
            errors.add(new SubmissionError("No temperature value was provided. Temperature value must be supplied."));
        } else {
            double temperature = Double.parseDouble(temp);
            survey.setTemperature(temperature);
        }

        String comments = form.getFirstValue("comments");
        survey.setComments(comments);


        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected void preDeleteHook(Survey survey) {
        super.preDeleteHook(survey);
        LOGGER.info("##### Deleted survey: " + survey.getId() + " #####");
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        return true;
        //Only logged in users and super users can edit profiles
        //Logged in users can only edit their own survey
//        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
//        Survey survey = getDao().load(id);
//        return getAccessPolicy().getAccessLevelForInstance(userImpl, survey).canRead();
    }
}
