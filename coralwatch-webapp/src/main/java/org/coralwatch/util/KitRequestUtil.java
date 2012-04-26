package org.coralwatch.util;

import javax.mail.MessagingException;

import org.coralwatch.model.KitRequest;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class KitRequestUtil {

    private static Log _log = LogFactoryUtil.getLog(KitRequestUtil.class);

    public static void sendDispatchEmail(KitRequest kitRequest) {
        sendEmail(
            kitRequest,
            "We have shipped your CoralWatch kit.",
            "Thank you for volunteering with CoralWatch."
        );
    }

    public static void sendReceiptEmail(KitRequest kitRequest) {
        sendEmail(
            kitRequest,
            "We have received your kit request.",
            "We will send you an email when your request is dispatched."
        );
    }
    
    private static void sendEmail(KitRequest kitRequest, String openingMessage, String closingMessage) {
        String message = 
            "Dear " + kitRequest.getRequester().getDisplayName() + "\n" +
            "\n" +
            openingMessage + " Your kit request details are below.\n" +
            "\n" +
            "Kit Type: " + kitRequest.getKitType() + "\n" +
            "Language: " + kitRequest.getLanguage() + "\n" +
            "\n" +
            "Postal Address:\n" +
            "\n" +
            kitRequest.getAddressString() + "\n" +
            kitRequest.getCountry() + "\n" +
            "\n" +
            "Contact phone: " + kitRequest.getPhone() + "\n" +
            "Contact email: " + kitRequest.getEmail() + "\n" +
            "\n" +
            "Notes:\n" +
            "\n" +
            ((kitRequest.getNotes() == null || kitRequest.getNotes().isEmpty()) ? "(none provided)" : kitRequest.getNotes()) + "\n" +
            "\n" +
            closingMessage + "\n" +
            "\n" +
            "Regards,\n" +
            "CoralWatch\n" +
            "http://coralwatch.org";
        try {
            Emailer.sendEmail(kitRequest.getEmail(), "no-reply@coralwatch.org", "CoralWatch Kit Shipment", message);
        } catch (MessagingException e) {
            _log.fatal("Cannot send kit dispatch email.");
        }
    }
}
