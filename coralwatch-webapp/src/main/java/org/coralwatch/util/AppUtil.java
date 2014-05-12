package org.coralwatch.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;

public class AppUtil {
    /**
     * This method is used to clear the database cache
     */
    public static void clearCache() {
        CoralwatchApplication.getConfiguration().getJpaConnectorService().getEntityManager().clear();
    }
    
    public static UserImpl getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (UserImpl) session.getAttribute("currentUser") : null;
    }

    public static void setCurrentUser(HttpServletRequest request, UserImpl user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
    }
}
