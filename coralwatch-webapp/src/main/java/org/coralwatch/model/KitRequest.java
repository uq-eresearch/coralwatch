package org.coralwatch.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.validator.NotNull;

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

    // Do not set this field, decommissioned as part of Ticket #473 (Improve address entry for kit requests).
    // Instead set these fields: addressLine1, addressLine2, city, state, postcode.
    // See getter function below, which will first look in the new fields, but fall back on this one.
    @Column(name="address", length = 500)
    private String addressString;
    
    private String name;
    
    private String addressLine1;
    
    private String addressLine2;
    
    private String city;
    
    private String state;
    
    private String postcode;
    
    @Column(name="country", length = 256)
    private String country;
    
    private String phone;
    
    private String email;
    
    @Column(length = 64)
    private String language;

    private String kitType;

    @Column(length = 2000)
    private String notes;

    public KitRequest() {

    }

    public KitRequest(UserImpl requester) {
        this.requester = requester;
        this.name = requester.getFullName();
        this.addressLine1 = requester.getAddressLine1();
        this.addressLine2 = requester.getAddressLine2();
        this.city = requester.getCity();
        this.state = requester.getState();
        this.postcode = requester.getPostcode();
        this.country = requester.getCountry();
        this.phone = requester.getPhone();
        this.email = requester.getEmail();
        this.requestDate = new Date();
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

    public String getAddressString() {
        if (addressString != null) {
            return addressString;
        }
        if (addressLine1 != null) {
            StringBuilder builder = new StringBuilder();
            builder.append(addressLine1);
            if (addressLine2 != null && !addressLine2.isEmpty()) {
                builder.append("\n");
                builder.append(addressLine2);
            }
            builder.append("\n");
            builder.append(city);
            builder.append("\n");
            builder.append(state);
            builder.append(" ");
            builder.append(postcode);
            return builder.toString();
        }
        return null;
    }

    public void setAddressString(String addressString) {
        this.addressString = addressString;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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
