package org.coralwatch.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Entity(name = "AppUser")
public class UserImpl implements au.edu.uq.itee.maenad.restlet.auth.User, Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private String username;
    private String displayName;
    private String email;
    private String passwordHash;
    @Temporal(TemporalType.TIMESTAMP)
    private Date registrationDate;
    private boolean superUser;

    public UserImpl() {
    }

    public UserImpl(String username, String displayName, String email, String passwordHash, boolean superUser) {
        this.username = username;
        this.displayName = displayName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.superUser = superUser;
        this.registrationDate = new Date();
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isSuperUser() {
        return superUser;
    }

    public void setSuperUser(boolean superUser) {
        this.superUser = superUser;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final UserImpl other = (UserImpl) obj;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 43 * hash + (int) (this.id ^ (this.id >>> 32));
        return hash;
    }

}
