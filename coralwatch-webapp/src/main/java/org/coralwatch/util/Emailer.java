package org.coralwatch.util;

import java.util.Date;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.coralwatch.app.CoralwatchApplication;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class Emailer {
    private static Log _log = LogFactoryUtil.getLog(Emailer.class);

    public static void sendEmail(String toEmailAddress, String fromEmailAddress, String subject, String text) throws MessagingException {
        Session session = Session.getDefaultInstance(CoralwatchApplication.getConfiguration().getSubmissionEmailConfig());
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmailAddress));
        message.setSubject(subject);
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmailAddress));
        message.setSentDate(new Date());
        message.setText(text);
        Transport.send(message);
        _log.info("Email Sent to " + toEmailAddress);
    }
}
