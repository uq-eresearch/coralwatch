package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Entity(name = "AppUser")
@NamedQueries({
        @NamedQuery(name = "User.getSurveyCreated",
                query = "SELECT o FROM Survey o WHERE o.creator = :user ORDER BY o.id")
})
public class UserImpl implements au.edu.uq.itee.maenad.restlet.auth.User, Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotNull
    private String username;
    private String displayName;

    @NotNull
    private String email;

    @NotNull
    private String passwordHash;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date registrationDate;

    @NotNull
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
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        UserImpl user = (UserImpl) o;

        if (id != user.id) return false;
        if (superUser != user.superUser) return false;
        if (!displayName.equals(user.displayName)) return false;
        if (!email.equals(user.email)) return false;
        if (!passwordHash.equals(user.passwordHash)) return false;
        if (!registrationDate.equals(user.registrationDate)) return false;
        if (!username.equals(user.username)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (id ^ (id >>> 32));
        result = 31 * result + username.hashCode();
        result = 31 * result + displayName.hashCode();
        result = 31 * result + email.hashCode();
        result = 31 * result + passwordHash.hashCode();
        result = 31 * result + registrationDate.hashCode();
        result = 31 * result + (superUser ? 1 : 0);
        return result;
    }
}
