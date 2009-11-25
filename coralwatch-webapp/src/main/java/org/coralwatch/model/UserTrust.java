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
public class UserTrust implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @OneToOne
    @NotNull
    UserImpl trustor;

    @OneToOne
    @NotNull
    UserImpl trustee;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date trustDate;

    @NotNull
    private double trustValue;

    public UserTrust() {
        trustDate = new Date();
    }

    public UserTrust(UserImpl trustor, UserImpl trustee, double trustValue) {
        this.trustor = trustor;
        this.trustee = trustee;
        this.trustDate = new Date();
        this.trustValue = trustValue;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UserImpl getTrustor() {
        return trustor;
    }

    public void setTrustor(UserImpl trustor) {
        this.trustor = trustor;
    }

    public UserImpl getTrustee() {
        return trustee;
    }

    public void setTrustee(UserImpl trustee) {
        this.trustee = trustee;
    }

    public Date getTrustDate() {
        return trustDate;
    }

    public void setTrustDate(Date trustDate) {
        this.trustDate = trustDate;
    }

    public double getTrustValue() {
        return trustValue;
    }

    public void setTrustValue(double trustValue) {
        this.trustValue = trustValue;
    }
}
