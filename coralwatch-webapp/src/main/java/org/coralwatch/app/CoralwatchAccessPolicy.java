package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.auth.AccessLevel;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import org.coralwatch.model.UserImpl;


public class CoralwatchAccessPolicy implements AccessPolicy<UserImpl> {

    public AccessLevel getAccessLevelForClass(UserImpl userImpl, Class<?> clazz) {
        return new AccessLevel(true, true, true, true);
    }

    public AccessLevel getAccessLevelForInstance(UserImpl userImpl, Object instance) {
        return new AccessLevel(true, true, true, true);
    }
}
