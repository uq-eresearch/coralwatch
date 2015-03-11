package org.coralwatch.portlets;

import java.io.IOException;

import javax.portlet.GenericPortlet;
import javax.portlet.PortletContext;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

public abstract class SimplePortlet extends GenericPortlet {

  @Override
  protected void doView(RenderRequest request, RenderResponse response)
      throws PortletException, IOException {
    PortletContext portletContext = getPortletContext();
    PortletRequestDispatcher portletRequestDispatcher =
        portletContext.getRequestDispatcher(include());
    if(portletRequestDispatcher == null) {
      throw new PortletException(String.format(
          "PortletRequestDispatcher is null for %s", include()));
    } else {
      try {
        portletRequestDispatcher.include(request, response);
      } catch (Exception e) {
        throw new PortletException(String.format("while including %s", include()), e);
      }
    }
  }

  abstract String include();

}
