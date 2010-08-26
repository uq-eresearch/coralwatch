package org.coralwatch.servlets;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.KitRequestDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;
import org.coralwatch.util.Emailer;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

public class KitRequestDispatchServlet extends HttpServlet {
    private static Log _log = LogFactoryUtil.getLog(KitRequestDispatchServlet.class);

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
                //TODO Send email to requester
                String line1 = "Dear " + kitRequest.getRequester().getDisplayName() + "\n\n";
                String line2 = "We have shipped your CoralWatch kit. Your kit request details are below." + "\n\n";
                String line3 = "Kit Type: " + kitRequest.getKitType() + "\nLanguage: " + kitRequest.getLanguage() + "\nPostal Address: " + kitRequest.getAddress() + ", " + kitRequest.getCountry() + "\nNotes: " + (kitRequest.getNotes() == null ? "" : kitRequest.getNotes());
                String line4 = "\n\nThank you for volunteering with CoralWatch.\n\nRegards,\nCoralWatch\nhttp://coralwatch.org";
                String message = line1 + line2 + line3 + line4;
                try {
                    Emailer.sendEmail(kitRequest.getRequester().getEmail(), "no-reply@coralwatch.org", "CoralWatch Kit Shipment", message);
                } catch (MessagingException e) {
                    _log.fatal("Cannot send kit dispatch email.");
                }
                out.println("Successfully dispatched kit request");
            } else {
                out.println("Cannot dispatch request. Invalid kit request ID");
            }
        } else {
            out.println("Cannot dispatch request. You must be an administrator to dispatch kit requests.");
        }
    }
}
