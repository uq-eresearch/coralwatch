package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.auth.AccessLevel;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;

import org.coralwatch.model.Reef;
import org.coralwatch.model.Survey;
import org.coralwatch.model.SurveyRecord;
import org.coralwatch.model.UserImpl;

import java.util.HashSet;
import java.util.Set;


public class CoralwatchAccessPolicy implements AccessPolicy<UserImpl> {
    private static final AccessLevel CREATE_ONLY = new AccessLevel(true, false, false, false);
    private static final AccessLevel EVERYTHING_ALLOWED = new AccessLevel(true, true, true, true);
    private static final Set<Class<?>> NORMAL_USERS_CAN_CREATE_INSTANCES = new HashSet<Class<?>>();
    static {
    	NORMAL_USERS_CAN_CREATE_INSTANCES.add(Reef.class);
        NORMAL_USERS_CAN_CREATE_INSTANCES.add(Survey.class);
        NORMAL_USERS_CAN_CREATE_INSTANCES.add(SurveyRecord.class);
        NORMAL_USERS_CAN_CREATE_INSTANCES.add(UserImpl.class);
    }

    public AccessLevel getAccessLevelForClass(UserImpl userImpl, Class<?> clazz) {
        if (userImpl == null) {
            return CREATE_ONLY;
        }
        if (userImpl.isSuperUser()) {
            return EVERYTHING_ALLOWED;
        }
        return new AccessLevel(NORMAL_USERS_CAN_CREATE_INSTANCES.contains(clazz), true, false, false);
    }

    public AccessLevel getAccessLevelForInstance(UserImpl user, Object instance) {
        if (user != null && user.isSuperUser()) {
            return EVERYTHING_ALLOWED;
        }
        boolean canCreate = false;
        boolean canRead = false;
        boolean canUpdate = false;
        boolean canDelete = false;

        if (instance instanceof UserImpl) {
            canCreate = true; //Any one can create users
            canRead = user != null; //Only logged in users can read users
            canUpdate = instance.equals(user); //Users can edit their own profiles
            canDelete = false; // only super users can delete profiles
        }
        if (instance instanceof Survey) {
            canCreate = user !=null;
            canRead = true;
            canUpdate = (user != null) && user.equals(((Survey) instance).getCreator());
            canDelete = (user != null) && user.equals(((Survey) instance).getCreator());;
        }
        if (instance instanceof SurveyRecord) {
            canCreate = user !=null;
            canRead = true;
            canUpdate = (user != null) && user.equals(((SurveyRecord) instance).getSurvey().getCreator());
            canDelete = (user != null) && user.equals(((SurveyRecord) instance).getSurvey().getCreator());
        }

        return new AccessLevel(canCreate, canRead, canUpdate, canDelete);
    }
}
