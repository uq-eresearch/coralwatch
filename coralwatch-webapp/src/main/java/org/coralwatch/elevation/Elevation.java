package org.coralwatch.elevation;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Survey;
import org.json.JSONArray;
import org.json.JSONObject;

public class Elevation {

  private static final String ELEVATION_API_URL =
      "http://maps.googleapis.com/maps/api/elevation/json";

  private static final String LOCATION_MISSING = 
      "location wrong or missing";

  private static Elevation INSTANCE;

  private static Thread thread;

  private volatile boolean run = true;

  private static class PreparedCall {
    String url;
    List<Survey> included;
    List<Survey> tail;

    public PreparedCall(String url, List<Survey> included, List<Survey> tail) {
      this.url = url;
      this.included = included;
      this.tail = tail;
    }
  }

  private final String apiKey;

  private final SurveyDao surveyDao;

  private Elevation(String apiKey, SurveyDao surveyDao) {
    this.apiKey = apiKey;
    this.surveyDao = surveyDao;
  }

  private boolean urlSizeOk(String url) {
    if(StringUtils.isNotBlank(apiKey)) {
      url = url + "&key=" + apiKey;
    }
    return (url.length() < 2000);
  }

  private PreparedCall prepare(List<Survey> surveys) {
    LinkedList<Survey> work = new LinkedList<Survey>(surveys);
    List<Survey> included = new ArrayList<Survey>();
    StringBuilder sb = new StringBuilder(ELEVATION_API_URL);
    sb.append("?locations=");
    while((included.size() < 1) && (!work.isEmpty()) && urlSizeOk(sb.toString())) {
      if(!run) {
        break;
      }
      Survey survey = work.removeFirst();
      Float lat = survey.getLatitude();
      Float lng = survey.getLongitude();
      if((lat != null) && (lng != null) && (lat >= -90.0) &&
          (lat <= 90.0) && (lng >= -180.0) && (lng <= 180.0)) {
        if(!included.isEmpty()) {
          sb.append("|");
        }
        included.add(survey);
        sb.append(lat+","+lng);
      } else {
        survey.setElevationStatus(LOCATION_MISSING);
        surveyDao.save(survey);
      }
    }
    if(StringUtils.isNotBlank(apiKey)) {
      sb.append("key="+apiKey);
    }
    return new PreparedCall(sb.toString(), included, work);
  }

  private void elevationCall(String targetURL, List<Survey> surveys) {
    HttpURLConnection con = null;
    try {
      URL url = new URL(targetURL);
      con = (HttpURLConnection)url.openConnection();
      InputStream response = con.getInputStream();
      String in = IOUtils.toString(response);
      System.out.println("server response");
      System.out.println(in);
      JSONObject json = new JSONObject(in);
      String status = json.getString("status");
      JSONArray results = json.getJSONArray("results");
      if(results.length() != surveys.size()) {
        System.out.println(String.format("elevation: exepected result and surveys size to be equal"
            + " %s, %s",results.length(), surveys.size()));
        run = false;
      } else {
        for(int i = 0;i<surveys.size();i++) {
          Survey survey = surveys.get(i);
          JSONObject result = results.getJSONObject(i);
          double elevation = result.getDouble("elevation");
          survey.setElevation(elevation);
          survey.setElevationStatus(status);
          surveyDao.save(survey);
        }
      }
    } catch(Exception e) {
      try {
        for(Survey survey : surveys) {
          survey.setElevationStatus(e.getMessage());
          surveyDao.save(survey);
        }
      } catch(Exception e2) {}
    } finally {
      if(con != null) {
        con.disconnect();
      }
    }
  }

  private void updateElevation(List<Survey> surveys) {
    while(true) {
      if(!run) {
        break;
      }
      PreparedCall pc = prepare(surveys);
      if(!pc.included.isEmpty()) {
        System.out.println(String.format("elevation call includes %s surveys, url: %s",
            pc.included.size(), pc.url));
        elevationCall(pc.url, pc.included);
      }
      if(pc.tail.isEmpty()) {
        break;
      } else {
        surveys = pc.tail;
        try {Thread.sleep(500);} catch (InterruptedException e) {}
      }
    }
  }

  private void run() {
    String uuid = UUID.randomUUID().toString();
    System.out.println("elevation service running "+uuid);
    try {Thread.sleep(1000 * 20);} catch (InterruptedException e) {}
    while(run) {
      try {
        List<Survey> surveys = surveyDao.missingElevation();
        if((surveys!= null) && !surveys.isEmpty()) {
          updateElevation(surveys);
        }
        if(!run) {
          break;
        }
        try {Thread.sleep(1000 * 60);} catch (InterruptedException e) {}
      } catch(Throwable t) {
        t.printStackTrace();
      }
    }
    System.out.println("elevation service exiting "+uuid);
  }

  public synchronized static void start(String apiKey, SurveyDao surveyDao) {
    if(INSTANCE == null) {
      INSTANCE = new Elevation(apiKey, surveyDao);
      thread = new Thread(new Runnable() {
        @Override
        public void run() {
          INSTANCE.run();
        }}, "elevation service");
      thread.start();
    }
  }

  public synchronized static void stop() {
    if(INSTANCE != null) {
      INSTANCE.run = false;
      thread.interrupt();
    }
  }

}
