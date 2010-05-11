package org.coralwatch.dataaccess;

import au.edu.uq.itee.maenad.dataaccess.Dao;
import org.coralwatch.model.KitRequest;
import org.coralwatch.model.UserImpl;

import java.util.List;

public interface KitRequestDao extends Dao<KitRequest> {
    KitRequest getById(Long id);

    List<KitRequest> getByRequester(UserImpl requester);
}
