package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.SurveyDao;

import com.google.gson.Gson;

public class BleachingRiskApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    response.setContentType("application/json; charset=UTF-8");
    SurveyDao sdao = CoralwatchApplication.getConfiguration().getSurveyDao();
    response.getWriter().write(new Gson().toJson(
        StringUtils.equalsIgnoreCase(request.getParameter("all"), "all")?
        sdao.bleachingRiskAll():sdao.bleachingRiskCurrent()));
  }
}
