package org.coralwatch.portlets;

import java.io.IOException;

import javax.portlet.GenericPortlet;
import javax.portlet.PortletContext;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class BleachingRiskPortlet extends GenericPortlet {

  private final static Log _log = LogFactoryUtil.getLog(BleachingRiskPortlet.class);

  @Override
  protected void doView(RenderRequest request, RenderResponse response)
      throws PortletException, IOException {
    PortletContext portletContext = getPortletContext();
    PortletRequestDispatcher portletRequestDispatcher = portletContext.getRequestDispatcher(
        "/data/bleaching-risk/bleaching.html");
    if(portletRequestDispatcher == null) {
      _log.error("include not found");
    } else {
      try {
        portletRequestDispatcher.include(request, response);
      } catch (Exception e) {
        _log.error(e, e);
      }
    }
  }

  @Override
  public void destroy() {
    _log.info("Destroying portlet");
  }

}
