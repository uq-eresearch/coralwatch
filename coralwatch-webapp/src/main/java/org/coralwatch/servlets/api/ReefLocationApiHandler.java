package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.hibernate.ScrollableResults;
import org.json.JSONWriter;

public class ReefLocationApiHandler {

  private Survey findSurveyWithLocation(Reef reef) {
    if(reef == null) {
      return null;
    }
    SurveyDao sd = CoralwatchApplication.getConfiguration().getSurveyDao();
    ScrollableResults sr = null;
    try {
      sr = sd.getSurveysIterator(reef);
      while(sr.next()) {
        Survey s = (Survey)sr.get(0);
        if((s != null) && (s.getLatitude() != null) && (s.getLongitude() != null)) {
          return s;
        }
      }
      return null;
    } finally {
      if(sr != null) {
        try {sr.close();} catch (RuntimeException e) {}
      }
    }
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    JSONWriter writer = new JSONWriter(response.getWriter());
    String reefname = request.getParameter("reef");
    writer.object();
    if(StringUtils.isNotBlank(reefname)) {
      Reef reef = CoralwatchApplication.getConfiguration().getReefDao().getReefByName(reefname);
      Survey s = findSurveyWithLocation(reef);
      if(s != null) {
        writer.key("lat").value(s.getLatitude());
        writer.key("lng").value(s.getLongitude());
      }
    }
    writer.endObject();
  }

}
