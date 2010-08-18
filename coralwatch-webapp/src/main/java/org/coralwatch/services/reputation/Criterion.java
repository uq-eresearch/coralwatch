package org.coralwatch.services.reputation;

/**
 * Created by IntelliJ IDEA.
 * User: alabri
 * Date: 18/08/2010
 * Time: 10:19:39 AM
 * To change this template use File | Settings | File Templates.
 */
public interface Criterion {
    Double getRatingValue();

    void setRatee(Object ratee);

    void setRater(Object rater);
}
