package org.coralwatch.services.reputation.impl;

import org.coralwatch.services.reputation.Criterion;

public class DirectUserRatingCriterion implements Criterion {

    private Double directRating;

    public DirectUserRatingCriterion(Double directRating) {
        this.directRating = directRating;
    }

    @Override
    public Double getRatingValue() {
        return this.directRating;
    }

    @Override
    public void setRatee(Object ratee) {
    }

    @Override
    public void setRater(Object rater) {
    }
}
