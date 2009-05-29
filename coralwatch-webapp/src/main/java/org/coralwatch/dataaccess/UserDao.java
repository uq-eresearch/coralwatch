package org.coralwatch.dataaccess;


import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import java.util.List;


public interface UserDao extends Dao<UserImpl> {
    List<Survey> getSurveyEntriesCreated(UserImpl user);
}
