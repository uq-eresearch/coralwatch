package org.coralwatch.dataaccess.jpa;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Query;

import org.coralwatch.dataaccess.ReefDao;
import org.coralwatch.dataaccess.ReefLocation;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.hibernate.CacheMode;
import org.hibernate.ScrollableResults;
import org.hibernate.ejb.HibernateEntityManager;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;

import com.google.common.collect.Lists;

public class JpaReefDao extends JpaDao<Reef> implements ReefDao, Serializable {
    public JpaReefDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Reef> getAll() {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o ORDER BY country").getResultList();
    }

    @Override
    public Reef getReefByName(String name) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o WHERE o.name = :name").setParameter(
                "name", name).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "The name of a reef should be unique";
        return (Reef) resultList.get(0);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Reef> getReefsByCountry(String country) {
        List<Reef> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o WHERE o.country = :country ORDER BY name").setParameter(
                "country", country).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "The name of a reef should be unique";

        return resultList;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Survey> getSurveysByReef(Reef reef) {
        return entityManagerSource.getEntityManager().createQuery("SELECT o FROM Survey o WHERE o.reef.id = :reefId").setParameter("reefId",
                reef.getId()).getResultList();
    }

    @Override
    public Reef getById(Long id) {
        List<?> resultList = entityManagerSource.getEntityManager().createQuery("SELECT o FROM Reef o WHERE o.id = :id").setParameter("id", id).getResultList();
        if (resultList.isEmpty()) {
            return null;
        }
        assert resultList.size() == 1 : "id should be unique";
        return (Reef) resultList.get(0);

    }

    @Override
    public int count() {
        try {
            return ((Long)entityManagerSource.getEntityManager().createQuery(
                    "select count(*) from Reef").getSingleResult()).intValue();
        } catch(Exception e) {
            return 0;
        }
    }

    @Override
    public ScrollableResults getReefsIterator() {
        HibernateEntityManager entityManager = (HibernateEntityManager) entityManagerSource.getEntityManager();
        String queryStr = "select reef.id, reef.country, reef.name, count(survey.id) as surveys" +
                " from reef left outer join survey on (reef.id = survey.reef_id)" +
                " group by reef.id, reef.country, reef.name order by reef.country, reef.name;";
        org.hibernate.Query query = entityManager.getSession()
            .createSQLQuery(queryStr)
            .setCacheMode(CacheMode.IGNORE)
            .setFetchSize(50);
        return query.scroll();
    }

    private Query nativeQuery(String query, Class<?> clas) {
      return entityManagerSource.getEntityManager().createNativeQuery(query, clas);
    }

    private Query nativeQuery(String query) {
      return entityManagerSource.getEntityManager().createNativeQuery(query);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Reef> getReefsWithSurvey() {
      return nativeQuery("SELECT DISTINCT r.* FROM reef r JOIN survey s on"
          + " r.id = s.reef_id WHERE s.datemodified is not null and s.latitude is not null and"
          + " s.longitude is not null and s.latitude between -90.0 and 90.0 and"
          + " s.longitude between -180.0 and 180.0 and (s.elevation is null OR s.elevation < 10.0 )"
          + " ORDER BY r.country, r.name", Reef.class).getResultList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Reef> getReefsWithSurvey(String country) {
      return nativeQuery("SELECT DISTINCT r.* FROM reef r JOIN survey s on"
          + " r.id = s.reef_id WHERE s.datemodified is not null and s.latitude is not null and"
          + " s.longitude is not null and s.latitude between -90.0 and 90.0 and"
          + " s.longitude between -180.0 and 180.0 and (s.elevation is null OR s.elevation < 10.0 )"
          + " and country = ? ORDER BY r.country, r.name",
          Reef.class).setParameter(1, country).getResultList();
    }

    private ReefLocation of(Object o) {
      if(o instanceof Object[] ) {
        Object[] oa = (Object[])o;
        if(oa.length == 4 && (oa[0] instanceof String) && (oa[1] instanceof String) &&
            (oa[2] instanceof Number) && (oa[3] instanceof Number)) {
          return new ReefLocation(oa[0].toString(), oa[1].toString(),
              ((Number)oa[2]).doubleValue(), ((Number)oa[3]).doubleValue());
        }
      }
      return null;
    }

    @Override
    public ReefLocation getReefLocation(String reefname) {
      try {
        Object[] o = (Object[])nativeQuery("select r.name, r.country, s.latitude, s.longitude " +
            "from survey s join reef r on s.reef_id = r.id where r.name = ? and s.latitude is not null" +
            " and s.longitude is not null and s.latitude between -90.0 and 90.0 and" +
            " s.longitude between -180.0 and 180.0 and (s.elevation is null OR s.elevation < 10.0 )" +
            " order by s.datemodified DESC").setParameter(1, reefname).setMaxResults(1).getSingleResult();
        return of(o);
      } catch(Exception e) {
        return null;
      }
    }

    public List<ReefLocation> getAllReefLocations() {
      List<?> l = nativeQuery("select distinct on (r.name) r.name, r.country, s.latitude, s.longitude from"
          + " survey s join reef r on s.reef_id = r.id where s.latitude is not null and s.longitude "
          + "is not null and s.latitude between -90.0 and 90.0 and s.longitude between -180.0 and"
          + " 180.0 and (s.elevation is null OR s.elevation < 10.0 )"
          + " order by r.name, s.datemodified DESC").getResultList();
      List<ReefLocation> locations = Lists.newArrayList();
      for(Object o : l) {
        ReefLocation rl = of(o);
        if(o != null) {
          locations.add(rl);
        }
      }
      return locations;
    }

}
