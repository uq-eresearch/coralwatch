package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import java.io.Serializable;

@Entity
public class SurveyRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    @NotNull
    private Survey survey;

    @NotNull
    private String coralType;

    @NotNull
    private String lightest;

    @NotNull
    private String darkest;

    public SurveyRecord() {
    }

    public SurveyRecord(Survey survey, String coralType, String lightest, String darkest) {

        this.survey = survey;
        this.coralType = coralType;
        this.lightest = lightest;
        this.darkest = darkest;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Survey getSurvey() {
        return survey;
    }

    public void setSurvey(Survey survey) {
        this.survey = survey;
    }

    public String getCoralType() {
        return coralType;
    }

    public void setCoralType(String coralType) {
        this.coralType = coralType;
    }

    public String getLightest() {
        return lightest;
    }

    public void setLightest(String lightest) {
        this.lightest = lightest;
    }

    public String getDarkest() {
        return darkest;
    }

    public void setDarkest(String darkest) {
        this.darkest = darkest;
    }
}
