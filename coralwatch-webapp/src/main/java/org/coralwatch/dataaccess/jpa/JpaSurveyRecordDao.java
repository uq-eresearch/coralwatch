package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.SurveyRecordDao;
import org.coralwatch.model.SurveyRecord;

import java.io.Serializable;
import java.util.List;

public class JpaSurveyRecordDao extends JpaDao<SurveyRecord> implements SurveyRecordDao , Serializable {
    public JpaSurveyRecordDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    public SurveyRecord getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM SurveyRecord o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (SurveyRecord) resultList.get(0);
    }

    @Override
    public int count() {
        try {
            return ((Long)entityManagerSource.getEntityManager().createQuery(
                    "select count(*) from SurveyRecord").getSingleResult()).intValue();
        } catch(Exception e) {
            return 0;
        }
    }
}
