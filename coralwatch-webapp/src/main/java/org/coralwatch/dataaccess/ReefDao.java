package org.coralwatch.dataaccess;

import org.coralwatch.model.Reef;

import au.edu.uq.itee.maenad.dataaccess.Dao;

public interface ReefDao extends Dao<Reef> {
    Reef getReefByName(String name);
}

