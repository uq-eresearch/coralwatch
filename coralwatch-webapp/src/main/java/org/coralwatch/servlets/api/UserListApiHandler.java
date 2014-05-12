package org.coralwatch.servlets.api;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.coralwatch.util.AppUtil;

import au.edu.uq.itee.maenad.util.BCrypt;

// TODO: Remove code duplication from UserPortlet
public class UserListApiHandler {
    private UserDao userDao;

    public UserListApiHandler() {
        this.userDao = CoralwatchApplication.getConfiguration().getUserDao();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errors = new ArrayList<String>();

        String email = request.getParameter("email");
        String email2 = request.getParameter("email2");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String displayName = request.getParameter("displayName");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String addressLine1 = request.getParameter("addressLine1");
        String addressLine2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postcode = request.getParameter("postcode");
        String country = request.getParameter("country");

        List<String> requiredFieldsMissing = new ArrayList<String>();
        if (StringUtils.isBlank(email)) {
            requiredFieldsMissing.add("Email");
        }
        if (StringUtils.isBlank(firstName)) {
            requiredFieldsMissing.add("First Name");
        }
        if (StringUtils.isBlank(lastName)) {
            requiredFieldsMissing.add("Last Name");
        }
        if (StringUtils.isBlank(displayName)) {
            requiredFieldsMissing.add("Display Name");
        }
        if (StringUtils.isBlank(password)) {
            requiredFieldsMissing.add("Password");
        }
        if (StringUtils.isBlank(country)) {
            requiredFieldsMissing.add("Country");
        }
        if (!requiredFieldsMissing.isEmpty()) {
            errors.add("Required fields: " + StringUtils.join(requiredFieldsMissing, ", ") + ".");
        }
        if (StringUtils.isNotBlank(email) && !email.equals(email2)) {
            errors.add("Confirm your email address.");
        }
        if (StringUtils.isNotBlank(password) && password.length() < 6) {
            errors.add("Password must be at least 6 characters.");
        }
        if (StringUtils.isNotBlank(password) && !password.equals(password2)) {
            errors.add("Confirm your password.");
        }
        if (userDao.getByEmail(email) != null) {
            errors.add("An account with the same email already exists.");
        }
        
        if (!errors.isEmpty()) {
            ApiServletUtils.writeErrorResponse(response, 400, errors);
            return;
        }

        UserImpl user = new UserImpl(displayName, email, BCrypt.hashpw(password, BCrypt.gensalt()), false);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setAddressLine1(addressLine1);
        user.setAddressLine2(addressLine2);
        user.setCity(city);
        user.setState(state);
        user.setPostcode(postcode);
        user.setCountry(country);
        userDao.save(user);

        AppUtil.setCurrentUser(request, user);

        response.setStatus(201);
        response.setHeader("Location", String.format("/coralwatch/api/user/%d", user.getId()));
    }
}
