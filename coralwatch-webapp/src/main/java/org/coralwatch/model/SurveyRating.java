package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
public class SurveyRating implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @OneToOne
    @NotNull
    UserImpl rator;

    @OneToOne
    @NotNull
    Survey survey;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date ratingDate;

    @NotNull
    private double ratingValue;


    public SurveyRating() {
        ratingDate = new Date();
    }

    public SurveyRating(UserImpl rator, Survey survey, double ratingValue) {
        this.rator = rator;
        this.survey = survey;
        this.ratingDate = new Date();
        this.ratingValue = ratingValue;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getRator() {
        return rator;
    }

    public void setRator(UserImpl rator) {
        this.rator = rator;
    }

    public Survey getSurvey() {
        return survey;
    }

    public void setSurvey(Survey survey) {
        this.survey = survey;
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
