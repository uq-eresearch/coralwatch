package org.coralwatch.servlets.api;

import java.io.IOException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.json.JSONException;
import org.json.JSONWriter;

// TODO: Remove code duplication from UserPortlet
public class UserApiHandler {
    private UserDao userDao;
    private Long userId;

    public UserApiHandler(Long userId) {
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
        this.userId = userId;
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserImpl user = userDao.getById(userId);
        if (user == null) {
            response.setStatus(404);
            return;
        }

        response.setStatus(200);
        response.setContentType("application/json");
        UserImpl currentUser = AppUtil.getCurrentUser(request);
        JSONWriter writer = new JSONWriter(response.getWriter());
        try {
            writer.object();
            writer.key("url").value(String.format("/coralwatch/api/user/%d", + user.getId()));
            writer.key("displayName").value(user.getDisplayName());
            if (user.equals(currentUser)) {
                writer.key("email").value(user.getEmail());
                writer.key("firstName").value(user.getFirstName());
                writer.key("lastName").value(user.getLastName());
                writer.key("phone").value(user.getPhone());
                writer.key("addressLine1").value(user.getAddressLine1());
                writer.key("addressLine2").value(user.getAddressLine2());
                writer.key("city").value(user.getCity());
                writer.key("state").value(user.getState());
                writer.key("postcode").value(user.getPostcode());
            }
            writer.key("country").value(user.getCountry());
            writer.key("positionDescription").value(user.getPositionDescription());
            writer.key("registrationDate").value(new SimpleDateFormat("yyyy-MM-dd").format(user.getRegistrationDate()));
            writer.key("numSurveys").value(userDao.getSurveyEntriesCreated(user).size());
            writer.key("portalUrl").value(String.format(
                "/web/guest/user" +
                "?p_p_id=userportlet_WAR_coralwatch" +
                "&_userportlet_WAR_coralwatch_cmd=view" +
                "&_userportlet_WAR_coralwatch_userId=%s",
                user.getId()
            ));
            writer.endObject();
        }
        catch (JSONException e) {
            throw new IOException(e);
        }
    }
}
