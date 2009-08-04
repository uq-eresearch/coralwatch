package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyDao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;

import java.util.Date;
import java.util.List;


public class JpaSurveyDao extends JpaDao<Survey> implements SurveyDao {
    public JpaSurveyDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<SurveyRecord> getSurveyRecords(Survey survey) {
        return entityManagerSource.getEntityManager().createNamedQuery("Survey.getData").setParameter("survey",
                survey).getResultList();
    }

    @Override
    public Survey getExactSurvey(UserImpl creator, String organisation, String organisationType, Reef reef,
            String weather, Date date, Date time, float latitude, float longitude, String activity, String comments) {
        List<?> resultList = entityManagerSource.getEntityManager().createNamedQuery("Survey.getExactSurvey")
                .setParameter("creator", creator).setParameter("organisation", organisation).setParameter(
                        "organisationType", organisationType).setParameter("reef", reef).setParameter("weather",
                        weather).setParameter("date", date).setParameter("time", time).setParameter("latitude",
                        latitude).setParameter("longitude", longitude).setParameter("activity", activity).setParameter(
                        "comments", comments).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        return (Survey) resultList.get(0);
    }
}
