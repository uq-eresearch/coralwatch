package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
public class KitRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @OneToOne
    @NotNull
    private UserImpl requester;

    @OneToOne
    private UserImpl dispatcher;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date requestDate;

    @Temporal(TemporalType.DATE)
    private Date dispatchdate;

    @Column(length = 500)
    private String address;

    @Column(length = 256)
    private String country;

    @Column(length = 64)
    private String language;

    private String kitType;

    @Column(length = 2000)
    private String notes;

    public KitRequest() {

    }

    public KitRequest(UserImpl requester) {
        this.requester = requester;
        this.requestDate = new Date();
        this.address = requester.getAddress();
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getRequester() {
        return requester;
    }

    public void setRequester(UserImpl requester) {
        this.requester = requester;
    }

    public UserImpl getDispatcher() {
        return dispatcher;
    }

    public void setDispatcher(UserImpl dispatcher) {
        this.dispatcher = dispatcher;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public Date getDispatchdate() {
        return dispatchdate;
    }

    public void setDispatchdate(Date dispatchdate) {
        this.dispatchdate = dispatchdate;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getKitType() {
        return kitType;
    }

    public void setKitType(String kitType) {
        this.kitType = kitType;
    }    
}
