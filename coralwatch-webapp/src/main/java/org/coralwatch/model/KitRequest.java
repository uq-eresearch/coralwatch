package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Entity
public class KitRequest implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    @NotNull
    private UserImpl requester;

    @NotNull
    @Temporal(TemporalType.DATE)
    private Date requestDate;

    @Temporal(TemporalType.DATE)
    private Date sentDate;

    private String comments;

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

    public Date getSentDate() {
        return sentDate;
    }

    public void setSentDate(Date sentDate) {
        this.sentDate = sentDate;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
    
}
