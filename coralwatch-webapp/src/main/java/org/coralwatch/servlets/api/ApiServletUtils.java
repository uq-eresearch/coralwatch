package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONWriter;

public class ApiServletUtils {
    public static void writeEmptySuccessResponse(HttpServletResponse response) throws IOException {
        response.setStatus(200);
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }

    public static void writeErrorResponse(HttpServletResponse response, List<String> errors) throws IOException {
        response.setStatus(200);
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            writer.key("errors");
            writer.array();
            for (String error : errors) {
                writer.object();
                writer.key("message").value(error);
                writer.endObject();
            }
            writer.endArray();
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }
}
