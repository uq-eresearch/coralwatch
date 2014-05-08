package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;

import au.edu.uq.itee.maenad.util.BCrypt;

// TODO: Remove code duplication from LoginPortlet
public class LoginApiHandler {
    private UserDao userDao;

    public LoginApiHandler() {
        userDao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        List<String> errors = new ArrayList<String>();
        UserImpl currentUser = doLogin(email, password, errors);
        if (currentUser != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", currentUser);
            response.setStatus(204);
        }
        else {
            ApiServletUtils.writeErrorResponse(response, errors);
        }
    }

    private UserImpl doLogin(String email, String password, List<String> errors) {
        if (StringUtils.isBlank(email)) {
            errors.add("Enter a valid email address.");
            return null;
        }
        UserImpl currentUser = userDao.getByEmail(email);
        if (currentUser == null) {
            errors.add("Enter valid sign in details.");
            return null;
        }
        if (StringUtils.isBlank(password) || !BCrypt.checkpw(password, currentUser.getPasswordHash())) {
            errors.add("Enter a valid password.");
            return null;
        }
        return currentUser;
    }
}
