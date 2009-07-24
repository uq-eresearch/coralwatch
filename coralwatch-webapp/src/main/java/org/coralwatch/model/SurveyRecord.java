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
    private char lightestLetter;

    @NotNull
    private int lightestNumber;

    @NotNull
    private char darkestLetter;

    @NotNull
    private int darkestNumber;


    public SurveyRecord() {
    }

    public SurveyRecord(Survey survey, String coralType, char lightestLetter, int lightestNumber, char darkestLetter, int darkestNumber) {
        this.survey = survey;
        this.coralType = coralType;
        this.lightestLetter = lightestLetter;
        this.lightestNumber = lightestNumber;
        this.darkestLetter = darkestLetter;
        this.darkestNumber = darkestNumber;
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

    public char getLightestLetter() {
        return lightestLetter;
    }

    public void setLightestLetter(char lightestLetter) {
        this.lightestLetter = lightestLetter;
    }

    public int getLightestNumber() {
        return lightestNumber;
    }

    public void setLightestNumber(int lightestNumber) {
        this.lightestNumber = lightestNumber;
    }

    public char getDarkestLetter() {
        return darkestLetter;
    }

    public void setDarkestLetter(char darkestLetter) {
        this.darkestLetter = darkestLetter;
    }

    public int getDarkestNumber() {
        return darkestNumber;
    }

    public void setDarkestNumber(int darkestNumber) {
        this.darkestNumber = darkestNumber;
    }
}
