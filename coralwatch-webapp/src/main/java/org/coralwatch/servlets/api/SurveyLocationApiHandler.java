package org.coralwatch.servlets.api;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.Survey;
import org.coralwatch.util.M;
import org.hibernate.ScrollableResults;

import com.google.common.collect.Lists;
import com.google.gson.Gson;

public class SurveyLocationApiHandler {

  private ScrollableResults fromDb() {
    return CoralwatchApplication.getConfiguration().getSurveyDao().getSurveysIterator();
  }

  private List<Map<String, Object>> surveys() {
    final ScrollableResults surveys = fromDb();
    final List<Map<String, Object>> l = Lists.newArrayList();
    while(surveys.next()) {
      Survey survey = (Survey) surveys.get(0);
      if((survey.getLatitude() != null) && (survey.getLongitude() != null)) {
        l.add(M.<String, Object>of("id", survey.getId(), "lat", survey.getLatitude(),
            "lng", survey.getLongitude(), "date", survey.getDate().getTime()));
      }
    }
    return l;
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    final String json = new Gson().toJson(surveys());
    final String etag = String.format("%08x", json.hashCode());
    response.setContentType("application/json; charset=utf-8");
    response.setHeader("ETag", etag);
    if(StringUtils.equals(etag, request.getHeader("If-None-Match"))) {
      response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
    } else {
      response.getWriter().write(json);
    }
  }
}
