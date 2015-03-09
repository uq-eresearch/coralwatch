package org.coralwatch.servlets.api;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        dispatch("doGet", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        dispatch("doPost", request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        dispatch("doPut", request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        dispatch("doDelete", request, response);
    }

    private void dispatch(String methodName, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Object handler = null;
        String[] groups = null;
        if ((groups = getMatch(pathInfo, "^/login$")) != null) {
            handler = new LoginApiHandler();
        }
        else if ((groups = getMatch(pathInfo, "^/logout$")) != null) {
            handler = new LogoutApiHandler();
        }
        else if ((groups = getMatch(pathInfo, "^/user$")) != null) {
            handler = new UserListApiHandler();
        }
        else if ((groups = getMatch(pathInfo, "^/user/([0-9]+)$")) != null) {
            handler = new UserApiHandler(Long.parseLong(groups[0]));
        }
        else if ((groups = getMatch(pathInfo, "^/survey$")) != null) {
            handler = new SurveyListApiHandler();
        }
        else if ((groups = getMatch(pathInfo, "^/survey/([0-9]+)$")) != null) {
            handler = new SurveyApiHandler(Long.parseLong(groups[0]));
        }
        else if ((groups = getMatch(pathInfo, "^/survey/([0-9]+)/record$")) != null) {
            handler = new SurveyRecordListApiHandler(Long.parseLong(groups[0]));
        }
        else if ((groups = getMatch(pathInfo, "^/survey/([0-9]+)/record/([0-9]+)$")) != null) {
            handler = new SurveyRecordApiHandler(Long.parseLong(groups[1]));
        }
        else if ((groups = getMatch(pathInfo, "^/reef$")) != null) {
            handler = new ReefListApiHandler();
        } else if((groups = getMatch(pathInfo, "^/reeflocation$")) != null) {
          handler = new ReefLocationApiHandler();
        } else if((groups = getMatch(pathInfo, "^/bleaching-risk/?$")) != null) {
          handler = new BleachingRiskApiHandler();
        }
        if (handler == null) {
            response.setStatus(404);
            return;
        }
        try {
            Method method = handler.getClass().getMethod(methodName, HttpServletRequest.class, HttpServletResponse.class);
            method.invoke(handler, request, response);
        }
        catch (NoSuchMethodException e) {
            response.setStatus(405);
            return;
        }
        catch (InvocationTargetException e) {
            throw new ServletException(e);
        }
        catch (IllegalAccessException e) {
            throw new ServletException(e);
        }
    }
    
    private String[] getMatch(String input, String regex) {
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(input);
        if (!m.matches()) {
            return null;
        }
        String[] groups = new String[m.groupCount()];
        for (int i = 0; i < m.groupCount(); i++) {
            groups[i] = m.group(i + 1);
        }
        return groups;
    }
}
