package org.coralwatch.servlets;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

public class KitRequestDispatchServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AppUtil.clearCache();
        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();
        KitRequestDao kitRequestDao = CoralwatchApplication.getConfiguration().getKitRequestDao();
        UserDao userDao = CoralwatchApplication.getConfiguration().getUserDao();
        long kitRequestId = Long.valueOf(req.getParameter("kitRequest"));
        long dispatcherId = Long.valueOf(req.getParameter("currentuser"));
        UserImpl dispatcher = userDao.getById(dispatcherId);
        if (dispatcher != null && dispatcher.isSuperUser()) {
            if (kitRequestId > 0) {
                KitRequest kitRequest = kitRequestDao.getById(kitRequestId);
                kitRequest.setDispatchdate(new Date());
                kitRequest.setDispatcher(dispatcher);
                kitRequestDao.update(kitRequest);
                out.println("Successfully dispatched kit request");
            } else {
                out.println("Cannot dispatch request. Invalid kit request ID");
            }
        } else {
            out.println("Cannot dispatch request. You must be an administrator to dispatch kit requests.");
        }
    }
}
