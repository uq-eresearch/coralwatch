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
        prefs.setValue("userUrl", ParamUtil.getString(actionRequest, "userUrl"));
        prefs.setValue("orderFormUrl", ParamUtil.getString(actionRequest, "orderFormUrl"));
        prefs.store();

        SessionMessages.add(actionRequest, portletConfig.getPortletName() + ".doConfigure");
    }

    @Override
    public String render(PortletConfig portletConfig, RenderRequest renderRequest, RenderResponse renderResponse) throws Exception {
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        renderRequest.setAttribute("orderFormUrl", prefs.getValue("orderFormUrl", "http://coralwatch.org/c/document_library/get_file?p_l_id=10132&folderId=10790&name=DLFE-510.pdf"));
        return "/data/kit-request/configuration.jsp";
    }
}
