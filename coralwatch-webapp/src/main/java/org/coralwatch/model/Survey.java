package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


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

    @ManyToOne
    @NotNull
    private Reef reef;

    @NotNull
    private float latitude;

    @NotNull
    private float longitude;

    private boolean isGPSDevice;

    @NotNull
    @Temporal(TemporalType.DATE)
    private Date date;

    @Temporal(TemporalType.TIME)
    private Date time;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateSubmitted;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateModified;

    @NotNull
    private String weather;

    @NotNull
    private String activity;

    @NotNull
    private double temperature;

    @Column(length = 2000)
    private String comments;

    private double totalRatingValue;
    private long numberOfRatings;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "survey", fetch = FetchType.LAZY)
    private List<SurveyRecord> dataset = new ArrayList<SurveyRecord>();

    /**
     * Stores information relating to quality assurance of the data.
     * <p/>
     * Currently it is used only to store the word "migrated" for every survey migrated
     * from the old version of the Coralwatch website, which had hardly any data validation.
     */
    private String qaState;

    public Survey() {
        dateSubmitted = new Date();
        dateModified = new Date();
        totalRatingValue = 0;
        numberOfRatings = 0;
    }

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

    public Reef getReef() {
        return reef;
    }

    public void setReef(Reef reef) {
        this.reef = reef;
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

    public boolean isGPSDevice() {
        return isGPSDevice;
    }

    public void setGPSDevice(boolean GPSDevice) {
        isGPSDevice = GPSDevice;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Date getDateSubmitted() {
        return dateSubmitted;
    }

    public void setDateSubmitted(Date dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
    }

    public Date getDateModified() {
        return dateModified;
    }

    public void setDateModified(Date dateModified) {
        this.dateModified = dateModified;
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

    public double getTotalRatingValue() {
        return totalRatingValue;
    }

    public void setTotalRatingValue(double totalRatingValue) {
        this.totalRatingValue = Math.round(totalRatingValue);
    }

    public long getNumberOfRatings() {
        return numberOfRatings;
    }

    public void setNumberOfRatings(long numberOfRatings) {
        this.numberOfRatings = numberOfRatings;
    }

    public List<SurveyRecord> getDataset() {
        return dataset;
    }

    public void setDataset(List<SurveyRecord> dataset) {
        this.dataset = dataset;
    }

    public void setQaState(String qaState) {
        this.qaState = qaState;
    }

    public String getQaState() {
        return qaState;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Survey survey = (Survey) o;

        if (id != survey.id) return false;

        return true;
    }
}
