package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;

import com.google.gson.Gson;

public class BleachingRiskApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write(new Gson().toJson(
        CoralwatchApplication.getConfiguration().getSurveyDao().bleachingRisk()));
  }
}
