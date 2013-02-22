package org.coralwatch.dataaccess;


import java.util.List;
import java.util.Map;

import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import au.edu.uq.itee.maenad.dataaccess.Dao;


public interface UserDao extends Dao<UserImpl> {
    List<Survey> getSurveyEntriesCreated(UserImpl user);

    List<UserImpl> getAdministrators();

    UserImpl getByEmail(String email);

    UserImpl getById(Long id);

    Long getNumberOfSurveys(UserImpl user);

    UserImpl getHighestContributor();
    
    int count();
    
    Map<Long, Long> getSurveyEntriesCreatedAll();
}
