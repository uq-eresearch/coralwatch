package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.Location;
import org.json.JSONWriter;

public class ReefLocationApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    JSONWriter writer = new JSONWriter(response.getWriter());
    String reefname = request.getParameter("reef");
    writer.object();
    if(StringUtils.isNotBlank(reefname)) {
      Location location = CoralwatchApplication.getConfiguration().getReefDao().getReefLocation(reefname);
      if(location != null) {
        writer.key("lat").value(location.getLatitude());
        writer.key("lng").value(location.getLongitude());
      }
    }
    writer.endObject();
  }

}
