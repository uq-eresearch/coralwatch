package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import java.io.Serializable;
import java.util.Date;


@Entity
public class Survey implements Serializable {

    private static final long serialVersionUID = 1;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    @NotNull
    private UserImpl creator;

    @NotNull
    private String organisation;

    @NotNull
    private String organisationType;

    @NotNull
    private String country;

    @NotNull
    private String reefName;

    @NotNull
    private float latitude;

    @NotNull
    private float longitude;

    @NotNull
    private Date date;

    @NotNull
    private String time;

    @NotNull
    private String weather;

    @NotNull
    private String activity;

    @NotNull
    private double temperature;

    private String comments;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getCreator() {
        return creator;
    }

    public void setCreator(UserImpl creator) {
        this.creator = creator;
    }

    public String getOrganisation() {
        return organisation;
    }

    public void setOrganisation(String organisation) {
        this.organisation = organisation;
    }

    public String getOrganisationType() {
        return organisationType;
    }

    public void setOrganisationType(String organisationType) {
        this.organisationType = organisationType;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getReefName() {
        return reefName;
    }

    public void setReefName(String reefName) {
        this.reefName = reefName;
    }

    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getWeather() {
        return weather;
    }

    public void setWeather(String weather) {
        this.weather = weather;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Survey survey = (Survey) o;

        if (id != survey.id) return false;
        if (Float.compare(survey.latitude, latitude) != 0) return false;
        if (Float.compare(survey.longitude, longitude) != 0) return false;
        if (Double.compare(survey.temperature, temperature) != 0) return false;
        if (activity != null ? !activity.equals(survey.activity) : survey.activity != null) return false;
        if (comments != null ? !comments.equals(survey.comments) : survey.comments != null) return false;
        if (country != null ? !country.equals(survey.country) : survey.country != null) return false;
        if (creator != null ? !creator.equals(survey.creator) : survey.creator != null) return false;
        if (date != null ? !date.equals(survey.date) : survey.date != null) return false;
        if (organisation != null ? !organisation.equals(survey.organisation) : survey.organisation != null)
            return false;
        if (organisationType != null ? !organisationType.equals(survey.organisationType) : survey.organisationType != null)
            return false;
        if (reefName != null ? !reefName.equals(survey.reefName) : survey.reefName != null) return false;
        if (weather != null ? !weather.equals(survey.weather) : survey.weather != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        result = (int) (id ^ (id >>> 32));
        result = 31 * result + (creator != null ? creator.hashCode() : 0);
        result = 31 * result + (organisation != null ? organisation.hashCode() : 0);
        result = 31 * result + (organisationType != null ? organisationType.hashCode() : 0);
        result = 31 * result + (country != null ? country.hashCode() : 0);
        result = 31 * result + (reefName != null ? reefName.hashCode() : 0);
        result = 31 * result + (latitude != +0.0f ? Float.floatToIntBits(latitude) : 0);
        result = 31 * result + (longitude != +0.0f ? Float.floatToIntBits(longitude) : 0);
        result = 31 * result + (date != null ? date.hashCode() : 0);
        result = 31 * result + (weather != null ? weather.hashCode() : 0);
        result = 31 * result + (activity != null ? activity.hashCode() : 0);
        temp = temperature != +0.0d ? Double.doubleToLongBits(temperature) : 0L;
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        result = 31 * result + (comments != null ? comments.hashCode() : 0);
        return result;
    }

}
