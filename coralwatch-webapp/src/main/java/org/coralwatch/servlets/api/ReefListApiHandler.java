package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.model.Reef;
import org.json.JSONException;
import org.json.JSONWriter;

public class ReefListApiHandler {
    private ReefDao reefDao;
    
    public ReefListApiHandler() {
        reefDao = CoralwatchApplication.getConfiguration().getReefDao();
    }
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Reef> reefs = reefDao.getAll();
        response.setStatus(200);
        response.setContentType("application/json");
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.array();
            for (Reef reef : reefs) {
                writer.object();
                writer.key("name").value(reef.getName());
                writer.key("country").value(reef.getCountry());
                writer.endObject();
            }
            writer.endArray();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }
}
