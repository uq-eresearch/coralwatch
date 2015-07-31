package org.coralwatch.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Date;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.Survey;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class Emailer {
    private static final Log _log = LogFactoryUtil.getLog(Emailer.class);

    private static Session getSession() {
      return Session.getDefaultInstance(
          CoralwatchApplication.getConfiguration().getSubmissionEmailConfig());
    }

    private static MimeMessage newMsg(String to, String from, String subject) throws MessagingException {
      MimeMessage message = new MimeMessage(getSession());
      message.setFrom(new InternetAddress(from));
      message.setSubject(subject);
      message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
      message.setSentDate(new Date());
      return message;
    }

    private static void send(MimeMessage message) throws MessagingException {
      Transport.send(message);
      _log.info("Email Sent to " + message.getRecipients(Message.RecipientType.TO)[0].toString());
    }

    public static void sendEmail(String to, String from, String subject,
        String text) throws MessagingException {
      MimeMessage message = newMsg(to, from, subject);
      message.setText(text);
      send(message);
    }

    private static InputStream getResource(String name) {
      return Emailer.class.getResourceAsStream("/org/coralwatch/newsurveyemail/"+name);
    }

    private static String emailContent(String name) throws IOException {
      return IOUtils.toString(getResource(name));
    }

    private static DataSource getImage(String name, String mimetype) throws IOException {
      InputStream in = getResource(name);
      if(in == null) {
        throw new RuntimeException(String.format("image %s not found", name));
      }
      return new ByteArrayDataSource(in, mimetype);
    }

    private static MimeBodyPart inlineImage(String name, String mimetype,
        String cid) throws MessagingException, IOException {
      MimeBodyPart imagePart = new MimeBodyPart();
      imagePart.setDataHandler(new DataHandler(getImage(name, mimetype)));
      imagePart.setContentID(String.format("<%s>", cid));
      imagePart.setDisposition(MimeBodyPart.INLINE);
      return imagePart;
    }

    public static void sendNewSurveyEmail(String to,
        String surveyId) throws IOException, MessagingException {
      MimeMultipart content = new MimeMultipart("related");
      MimeBodyPart htmlPart = new MimeBodyPart();
      String cnt = emailContent("email.html");
      cnt = StringUtils.replace(cnt, "<surveyid>", surveyId);
      cnt = StringUtils.replace(cnt, "<baseurl>",
          CoralwatchApplication.getConfiguration().getBaseUrl());
      htmlPart.setText(cnt, "UTF-8", "html");
      content.addBodyPart(htmlPart);
      content.addBodyPart(inlineImage("logo.png", "image/png", "logo"));
      content.addBodyPart(inlineImage("facebook.jpeg", "image/jpeg", "fb"));
      content.addBodyPart(inlineImage("twitter.jpeg", "image/jpeg", "tw"));
      MimeMessage message = newMsg(to,
          "CoralWatch <no-reply@coralwatch.org>", "Thanks for your data");
      message.setContent(content);
      send(message);
    }

    public static void sendBleachingRiskEmail(Survey s) throws IOException, MessagingException {
      MimeMultipart content = new MimeMultipart("related");
      MimeBodyPart htmlPart = new MimeBodyPart();
      String cnt = emailContent("bleachingrisk.html");
      htmlPart.setText(cnt, "UTF-8", "html");
      content.addBodyPart(htmlPart);
      content.addBodyPart(inlineImage("logo.png", "image/png", "logo"));
      content.addBodyPart(inlineImage("facebook.jpeg", "image/jpeg", "fb"));
      content.addBodyPart(inlineImage("twitter.jpeg", "image/jpeg", "tw"));
      MimeMessage message = newMsg(s.getCreator().getEmail(),
          "CoralWatch <no-reply@coralwatch.org>", "Bleaching risk");
      message.setContent(content);
      send(message);
    }
}
