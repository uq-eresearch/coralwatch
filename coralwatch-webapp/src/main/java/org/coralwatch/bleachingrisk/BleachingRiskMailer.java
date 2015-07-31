package org.coralwatch.bleachingrisk;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.dataaccess.jpa.EntityManagerThreadLocal;
import org.coralwatch.model.Survey;
import org.coralwatch.util.Emailer;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.RemovalListener;
import com.google.common.cache.RemovalNotification;

public class BleachingRiskMailer {

  private static BleachingRiskMailer INSTANCE = null;

  private Thread thread;

  private volatile boolean run = true;

  private final SurveyDao surveyDao;
  
  private final EntityManagerThreadLocal emtl;

  private Cache<String, String> emails = CacheBuilder.newBuilder()
      .expireAfterWrite(60, TimeUnit.MINUTES)
      .removalListener(new RemovalListener<String, String>() {
        @Override
        public void onRemoval(RemovalNotification<String, String> rn) {
          System.out.println("bleaching risk mailer: removing email from cache: "+rn.getKey());
        }})
      .build();

  private BleachingRiskMailer(SurveyDao surveyDao, EntityManagerThreadLocal emtl) {
    this.surveyDao = surveyDao;
    this.emtl = emtl;
    thread = new Thread(new Runnable() {
      @Override
      public void run() {
        BleachingRiskMailer.this.run();
      }}, "BleachingRiskMailer");
    thread.start();
  }

  private void run() {
    String uuid = UUID.randomUUID().toString();
    System.out.println("bleaching risk mailer running "+uuid);
    try {Thread.sleep(1000 * 120);} catch (InterruptedException e) {}
    while(run) {
      try {
        emails.cleanUp();
        List<Survey> surveys = surveyDao.bleachingRiskMailer();
        for(Survey s : surveys) {
          s.setBr_mailed("ok");
          surveyDao.save(s);
          if(emails.getIfPresent(s.getCreator().getEmail()) == null) {
            emails.put(s.getCreator().getEmail(), "ok");
            System.out.println(String.format("sending bleaching risk event email"
                + " for survey %s to %s", s.getId(), s.getCreator().getEmail()));
            Emailer.sendBleachingRiskEmail(s);
          } else {
            System.out.println(String.format("not sending bleaching event email for survey id %s"
                + " to %s because recipient already received this kind of email recently",
                s.getId(), s.getCreator().getEmail()));
          }
        }
        emtl.closeEntityManager();
      } catch(Throwable t) {
        t.printStackTrace();
      }
      try {
        Thread.sleep(1000*60*60);
      } catch (InterruptedException e) {}
    }
    System.out.println("bleaching risk mailer exiting "+uuid);
  }

  public synchronized static void start(SurveyDao surveyDao, EntityManagerThreadLocal emtl) {
    if(INSTANCE == null) {
      INSTANCE = new BleachingRiskMailer(surveyDao, emtl);
    }
  }

  public synchronized static void stop() {
    if(INSTANCE != null) {
      INSTANCE.run = false;
      INSTANCE.thread.interrupt();
    }
  }

}
