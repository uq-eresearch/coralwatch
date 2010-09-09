package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.services.ReputationService;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.List;

public class ReputationServlet extends HttpServlet {

    private static Log LOGGER = LogFactoryUtil.getLog(ReputationServlet.class);
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DecimalFormat twoDForm = new DecimalFormat("#.##");

        resp.setContentType("application/json;charset=utf-8");
        PrintWriter out = resp.getWriter();

        String friendsOfStr = req.getParameter("friendsOf");
        long friendsOfId = Long.valueOf(friendsOfStr);
        UserImpl friendsOfUser = userDao.getById(friendsOfId);
        List<UserImpl> users = ReputationService.getRateesFor(friendsOfUser);

        JSONArray children = new JSONArray();
        for (UserImpl user : users) {
            try {
                JSONObject child = new JSONObject();
                child.putOpt("id", user.getId() + "");
                child.putOpt("name", user.getDisplayName());
                JSONArray grandChildren = new JSONArray();
                List<UserImpl> grandChildrenUsers = ReputationService.getRateesFor(user);
                for (UserImpl granChildUser : grandChildrenUsers) {
                    JSONObject grandChild = new JSONObject();
                    grandChild.putOpt("id", granChildUser.getId() + "");
                    grandChild.putOpt("name", granChildUser.getDisplayName());
                    grandChild.putOpt("children", new JSONArray());
                    JSONObject data = new JSONObject();
                    data.putOpt("$color", "#99d4ef");
                    data.putOpt("rating", "2.50");
                    data.putOpt("overallrating", twoDForm.format(ReputationService.getOverAllRating(granChildUser)) + "");
                    data.putOpt("relation", "grandchild");
                    grandChild.putOpt("data", data);
                    grandChildren.put(grandChild);
                }
                child.putOpt("children", grandChildren);
                JSONObject data = new JSONObject();
                data.putOpt("$color", "#ec8f8f");
                data.putOpt("rating", twoDForm.format(ReputationService.getRaterRating(friendsOfUser, user)) + "");
                data.putOpt("overallrating", twoDForm.format(ReputationService.getOverAllRating(user)) + "");
                data.putOpt("relation", "child");
                child.putOpt("data", data);
                children.put(child);
            } catch (JSONException e) {
                LOGGER.fatal("Cannot create reef json object." + e.toString());
            }
        }
        JSONObject data = new JSONObject();
        try {
            data.putOpt("id", friendsOfUser.getId() + "");
            data.putOpt("name", friendsOfUser.getDisplayName());
            data.putOpt("children", children);
            JSONObject jsonDataObject = new JSONObject();
            jsonDataObject.putOpt("$color", "#a0ec9c");
            jsonDataObject.putOpt("relation", "root");
            jsonDataObject.putOpt("overallrating", twoDForm.format(ReputationService.getOverAllRating(friendsOfUser)));
            data.putOpt("data", jsonDataObject);
        } catch (JSONException ex) {
            LOGGER.fatal("Cannot create data json object." + ex.toString());
        }
        out.print(data);
    }
}
