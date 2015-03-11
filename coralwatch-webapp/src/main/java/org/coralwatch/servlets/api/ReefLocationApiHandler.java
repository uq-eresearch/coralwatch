package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefLocation;
import org.coralwatch.dataaccess.ReefDao;

import com.google.gson.Gson;

public class ReefLocationApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    final ReefDao rdao = CoralwatchApplication.getConfiguration().getReefDao();
    final Gson gson = new Gson();
    String reefname = request.getParameter("reef");
    if(StringUtils.isNotBlank(reefname)) {
      ReefLocation location = rdao.getReefLocation(reefname);
      if(location != null) {
        response.getWriter().write(gson.toJson(location));
      } else {
        response.getWriter().write(gson.toJson(new Object()));
      }
    } else {
      final String json = gson.toJson(rdao.getAllReefLocations());
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
}
