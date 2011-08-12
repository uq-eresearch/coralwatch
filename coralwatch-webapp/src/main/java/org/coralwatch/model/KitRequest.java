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

    // Old field for address: single line rather than separate fields.
    // Do not set this field for new records. Only kept for old records.
    @Column(length = 500)
    private String address;
    
    @Column(length = 255)
    private String addressLine1;
    
    @Column(length = 255)
    private String addressLine2;
    
    @Column(length = 255)
    private String addressLine3;
    
    // City / Suburb
    @Column(length = 255)
    private String city;
    
    // State / Province / Region
    @Column(length = 255)
    private String state;
    
    // Post code / ZIP code
    @Column(length = 255)
    private String postcode;

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

    public String getAddressLine3() {
        return addressLine3;
    }

    public void setAddressLine3(String addressLine3) {
        this.addressLine3 = addressLine3;
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
    
    public String getAddressListing(boolean multiLine) {
        if (address != null) {
            return address;
        }
        String delimiter = multiLine ? "\n" : ", ";
        StringBuilder builder = new StringBuilder();
        builder.append(addressLine1 + delimiter);
        if (addressLine2 != null && !addressLine2.isEmpty()) {
            builder.append(addressLine2 + delimiter);
        }
        if (addressLine3 != null && !addressLine3.isEmpty()) {
            builder.append(addressLine3 + delimiter);
        }
        builder.append(city + ", " + state + ", " + postcode + delimiter);
        builder.append(country);
        return builder.toString();
    }
}
