package org.coralwatch.portlets.configuration;

import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;

import javax.portlet.*;

public class SurveyConfigurationActionImpl implements ConfigurationAction {

    @Override
    public void processAction(PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
        String portletResource = ParamUtil.getString(actionRequest, "portletResource");

        PortletPreferences prefs = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);
        String surveyUrl = ParamUtil.getString(actionRequest, "surveyUrl");
        String reefUrl = ParamUtil.getString(actionRequest, "reefUrl");
        String userUrl = ParamUtil.getString(actionRequest, "userUrl");
        prefs.setValue("surveyUrl", surveyUrl);
        prefs.setValue("reefUrl", reefUrl);
        prefs.setValue("userUrl", userUrl);
        prefs.store();

        SessionMessages.add(actionRequest, portletConfig.getPortletName() + ".doConfigure");
    }

    @Override
    public String render(PortletConfig portletConfig, RenderRequest renderRequest, RenderResponse renderResponse) throws Exception {
        PortletPreferences prefs = renderRequest.getPreferences();
        renderRequest.setAttribute("surveyUrl", prefs.getValue("surveyUrl", "survey"));
        renderRequest.setAttribute("reefUrl", prefs.getValue("reefUrl", "reef"));
        renderRequest.setAttribute("userUrl", prefs.getValue("userUrl", "user"));
        return "/data/survey/configuration.jsp";
    }
}