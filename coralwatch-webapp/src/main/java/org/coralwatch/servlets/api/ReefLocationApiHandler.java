package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.Location;
import org.coralwatch.dataaccess.ReefDao;

import com.google.gson.Gson;

public class ReefLocationApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    final ReefDao rdao = CoralwatchApplication.getConfiguration().getReefDao();
    final Gson gson = new Gson();
    String reefname = request.getParameter("reef");
    if(StringUtils.isNotBlank(reefname)) {
      Location location = rdao.getReefLocation(reefname);
      if(location != null) {
        response.getWriter().write(gson.toJson(location));
      } else {
        response.getWriter().write(gson.toJson(new Object()));
      }
    } else {
      String json = gson.toJson(rdao.getAllReefLocations());
      String etag = Integer.toHexString(Math.abs(json.hashCode())).toLowerCase();
      String ifNoneMatch = request.getHeader("If-None-Match");
      if(StringUtils.equals(etag, ifNoneMatch)) {
        response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
      } else {
        response.setHeader("ETag", etag);
        response.getWriter().write(json);
      }
    }
  }

}
