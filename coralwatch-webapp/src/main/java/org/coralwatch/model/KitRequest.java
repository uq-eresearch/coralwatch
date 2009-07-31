package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
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

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date requestDate;

    @Temporal(TemporalType.DATE)
    private Date dispatchdate;

    private String address;

    private String notes;

    public KitRequest(){
        
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

}
