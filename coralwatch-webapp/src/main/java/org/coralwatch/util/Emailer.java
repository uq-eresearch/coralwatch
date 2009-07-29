package org.coralwatch.util;

import org.coralwatch.app.CoralwatchApplication;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;

public class Emailer {

    public static void sendEmail(String toEmailAddress, String fromEmailAddress, String subject, String text) throws MessagingException {
        Session session = Session.getDefaultInstance(CoralwatchApplication.getConfiguration().getSubmissionEmailConfig());
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmailAddress));
        message.setSubject(subject);
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmailAddress));
        message.setSentDate(new Date());
        message.setText(text);
        Transport.send(message);
    }
}
