package org.coralwatch.dataaccess;

import java.util.List;

import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;

import au.edu.uq.itee.maenad.dataaccess.Dao;

public interface ReefDao extends Dao<Reef> {
    Reef getReefByName(String name);
    List<Survey> getSurveysByReef(Reef reef);
}

