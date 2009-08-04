package org.coralwatch.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.PostLoad;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.validator.NotNull;

import au.edu.uq.itee.maenad.util.HashGenerator;

@Entity(name = "AppUser")
@NamedQueries({
        @NamedQuery(name = "User.getConductedSurveys",
                query = "SELECT o FROM Survey o WHERE o.creator = :user ORDER BY o.id"),
        @NamedQuery(name = "User.getUserByUsername", query = "SELECT o FROM AppUser o WHERE o.username = :username"),
        @NamedQuery(name = "User.getAdministrators",
                query = "SELECT v FROM AppUser v WHERE v.superUser = TRUE ORDER BY v.id")
})
public class UserImpl implements au.edu.uq.itee.maenad.restlet.auth.User, Serializable {

    /**
     * The type of image Gravatar generates if no image is attached to an email address.
     *
     * At the time of writing Gravatar offers three generation schemes: "identicon"
     * (geometric patterns), "monsterid" (monsters) and "wavatar" (cartoony characters).
     * Alternatively a URL for a fallback image can be provided.
     *
     * If the value is not provided (or invalid), the Gravatar icon will be rendered.
     */
    private static final String GRAVATAR_FALLBACK = "identicon";

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotNull
    @Column(unique = true)
    private String username;
    private String displayName;

    private String email;

    private String address;

    private String occupation;

    private String country;

    private String passwordHash;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date registrationDate;

    @NotNull
    private boolean superUser;

    @Transient
    private String gravatarUrl;

    public UserImpl() {
    }

    public UserImpl(String username, String displayName, String email, String passwordHash, boolean superUser) {
        this.username = username;
        this.displayName = displayName;
        this.email = email;
        updateGravatarUrl();
        this.passwordHash = passwordHash;
        this.superUser = superUser;
        this.registrationDate = new Date();
    }

    @PostLoad
    private void updateGravatarUrl() {
        if (getEmail() == null) {
            gravatarUrl = null;
        } else {
            String emailHash = HashGenerator.createMD5Hash(getEmail());
            gravatarUrl = "http://www.gravatar.com/avatar/" + emailHash + "?s=80&d=" + GRAVATAR_FALLBACK;
        }
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
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
        updateGravatarUrl();
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

    public String getGravatarUrl() {
        return gravatarUrl;
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
