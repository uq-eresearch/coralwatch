package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.Reef;

import java.util.List;

public interface ReefDao extends Dao<Reef> {
    List<Reef> getReef(String name);
}

