package org.coralwatch.servlets.api;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

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
        Class<?> handlerClass =
            pathInfo.matches("^/login$") ? LoginApiHandler.class :
            pathInfo.matches("^/logout$") ? LogoutApiHandler.class :
            pathInfo.matches("^/survey$") ? SurveyApiHandler.class :
            null;
        if (handlerClass == null) {
            response.setStatus(404);
            return;
        }
        try {
            Object handler = handlerClass.getConstructor().newInstance();
            handlerClass.getMethod(methodName, HttpServletRequest.class, HttpServletResponse.class).invoke(handler, request, response);
        }
        catch (InstantiationException e) {
            response.setStatus(404);
            return;
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
}
