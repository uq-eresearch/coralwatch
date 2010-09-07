package org.coralwatch.portlets.configuration;

import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;

import javax.portlet.*;

/**
 * Created by IntelliJ IDEA.
 * User: alabri
 * Date: 07/09/2010
 * Time: 10:20:10 AM
 * To change this template use File | Settings | File Templates.
 */
public class KitRequestConfigurationActionImpl implements ConfigurationAction {
    @Override
    public void processAction(PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
        String portletResource = ParamUtil.getString(actionRequest, "portletResource");

        PortletPreferences prefs = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);
        String userUrl = ParamUtil.getString(actionRequest, "userUrl");
        prefs.setValue("userUrl", userUrl);
        prefs.store();

        SessionMessages.add(actionRequest, portletConfig.getPortletName() + ".doConfigure");
    }

    @Override
    public String render(PortletConfig portletConfig, RenderRequest renderRequest, RenderResponse renderResponse) throws Exception {
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        return "/data/kit-request/configuration.jsp";
    }
}
