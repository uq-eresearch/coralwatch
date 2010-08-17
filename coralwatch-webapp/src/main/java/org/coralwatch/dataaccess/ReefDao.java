package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;

import java.util.List;

public interface ReefDao extends Dao<Reef> {
    Reef getReefByName(String name);

    List<Reef> getReefsByCountry(String country);

    List<Survey> getSurveysByReef(Reef reef);

    Reef getById(Long id);
}

