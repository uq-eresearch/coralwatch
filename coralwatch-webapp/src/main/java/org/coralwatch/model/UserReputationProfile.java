package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.HashMap;


@Entity
public class UserReputationProfile implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotNull
    private UserImpl ratee;

    private HashMap<UserImpl, Double> raters;

//    private Set<Double> systemRatings;

    public UserReputationProfile() {
    }

    public UserReputationProfile(UserImpl ratee) {
        this.ratee = ratee;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getRatee() {
        return ratee;
    }

    public void setRatee(UserImpl ratee) {
        this.ratee = ratee;
    }

    public HashMap<UserImpl, Double> getRaters() {
        return raters;
    }

    public void setRaters(HashMap<UserImpl, Double> raters) {
        this.raters = raters;
    }
//
//    public Set<Double> getSystemRatings() {
//        return systemRatings;
//    }
//
//    public void setSystemRatings(Set<Double> systemRatings) {
//        this.systemRatings = systemRatings;
//    }
}