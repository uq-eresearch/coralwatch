package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.auth.AccessLevel;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import au.edu.uq.itee.maenad.restlet.auth.User;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 1:40:04 PM
 */
public class CoralwatchAccessPolicy implements AccessPolicy<User> {

    public AccessLevel getAccessLevelForClass(User user, Class<?> clazz) {
        return new AccessLevel(true, true, true, true);
    }

    public AccessLevel getAccessLevelForInstance(User user, Object instance) {
        return new AccessLevel(true, true, true, true);
    }
}
