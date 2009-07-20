package org.coralwatch.app;

import java.util.HashSet;
import java.util.Set;

import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import au.edu.uq.itee.maenad.restlet.auth.AccessLevel;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;


public class CoralwatchAccessPolicy implements AccessPolicy<UserImpl> {
    private static final AccessLevel ANONYMOUS_CAN_CREATE_ONLY = new AccessLevel(true, false, false, false);
    private static final Set<Class<?>> NORMAL_USERS_CAN_CREATE_INSTANCES = new HashSet<Class<?>>();

    static {
        NORMAL_USERS_CAN_CREATE_INSTANCES.add(Survey.class);
        NORMAL_USERS_CAN_CREATE_INSTANCES.add(UserImpl.class);
    }

    public AccessLevel getAccessLevelForClass(UserImpl userImpl, Class<?> clazz) {

        if (userImpl == null) {
            return ANONYMOUS_CAN_CREATE_ONLY;
        }
        boolean canRead = true;
        boolean canCreate;
        if (NORMAL_USERS_CAN_CREATE_INSTANCES.contains(clazz)) {
            canCreate = true;
        } else {
            // superusers can create everything
            canCreate = userImpl.isSuperUser();
        }
        boolean canChange;
        // only superusers get the generic write access
        if (userImpl.isSuperUser()) {
            canChange = true;
        } else {
            canChange = false;
        }
        return new AccessLevel(canCreate, canRead, canChange, canChange);
    }

    public AccessLevel getAccessLevelForInstance(UserImpl user, Object instance) {
        boolean canCreate = false;
        boolean canRead = false;
        boolean canUpdate = false;
        boolean canDelete = false;

        if (instance instanceof UserImpl) {
            canCreate = true; //Any one can create users
            canRead = user != null; //Only logged in users can read users
            canUpdate = user.equals(instance); //Users can edit their own profiles
            canDelete = user.isSuperUser(); //Super users can delete profiles
        }
        if (instance instanceof Survey) {
            canCreate = user !=null;
            canRead = user !=null;
            canUpdate = user.equals(((Survey)instance).getCreator()); //Users can edit their own profiles
            canDelete = user.isSuperUser(); //Super users can delete profiles
        }

        return new AccessLevel(canCreate, canRead, canUpdate, canDelete);
    }
}
