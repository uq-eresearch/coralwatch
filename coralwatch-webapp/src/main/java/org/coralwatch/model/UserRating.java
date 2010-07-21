package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
public class UserRating implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @OneToOne
    @NotNull
    UserImpl rater;

    @OneToOne
    @NotNull
    UserImpl rated;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date ratingDate;

    @NotNull
    private double ratingValue;

    public UserRating() {
        ratingDate = new Date();
    }

    public UserRating(UserImpl rater, UserImpl trustee, double ratingValue) {
        this.rater = rater;
        this.rated = trustee;
        this.ratingDate = new Date();
        this.ratingValue = ratingValue;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getRater() {
        return rater;
    }

    public void setRater(UserImpl rater) {
        this.rater = rater;
    }

    public UserImpl getRated() {
        return rated;
    }

    public void setRated(UserImpl rated) {
        this.rated = rated;
    }

    public Date getRatingDate() {
        return ratingDate;
    }

    public void setRatingDate(Date ratingDate) {
        this.ratingDate = ratingDate;
    }

    public double getRatingValue() {
        return ratingValue;
    }

    public void setRatingValue(double ratingValue) {
        setRatingDate(new Date());
        this.ratingValue = ratingValue;
    }
}
