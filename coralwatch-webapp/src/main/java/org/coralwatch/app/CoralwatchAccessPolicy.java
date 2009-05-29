package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.auth.AccessLevel;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import org.coralwatch.model.Survey;
import org.coralwatch.model.UserImpl;

import java.util.HashSet;
import java.util.Set;


public class CoralwatchAccessPolicy implements AccessPolicy<UserImpl> {
    private static final AccessLevel ANONYMOUS_CAN_READ_ONLY = new AccessLevel(false, true, false, false);
    private static final AccessLevel ANONYMOUS_CAN_CREATE_ONLY = new AccessLevel(true, false, false, false);
    private static final Set<Class> NORMAL_USERS_CAN_CREATE_INSTANCES = new HashSet<Class>();

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
        if (user == null) {
            return ANONYMOUS_CAN_READ_ONLY;
        }
        boolean canChange;
        if (user.isSuperUser()) {
            canChange = true;
        } else {
            canChange = false;
            if (instance instanceof Survey) {
                canChange = user.equals(((Survey) instance).getCreator());
            }
            if (instance instanceof UserImpl) {
                canChange = user.equals(instance);
            }
        }
        return new AccessLevel(true, true, canChange, canChange);
    }
}
