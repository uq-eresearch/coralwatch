package org.coralwatch.model;

import au.edu.uq.itee.maenad.util.HashGenerator;
import org.hibernate.validator.NotNull;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity(name = "AppUser")
public class UserImpl implements au.edu.uq.itee.maenad.restlet.auth.User, Serializable {

    /**
     * The type of image Gravatar generates if no image is attached to an email address.
     * <p/>
     * At the time of writing Gravatar offers three generation schemes: "identicon"
     * (geometric patterns), "monsterid" (monsters) and "wavatar" (cartoony characters).
     * Alternatively a URL for a fallback image can be provided.
     * <p/>
     * If the value is not provided (or invalid), the Gravatar icon will be rendered.
     */
    private static final String GRAVATAR_FALLBACK = "identicon";

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(unique = true)
    private String email;

    private String displayName;

    @Column(length = 500)
    private String address;

    private String occupation;

    private String qualification;

    private String country;

    private String passwordHash;

    private String passwordResetId;

    @Temporal(TemporalType.TIMESTAMP)
    @NotNull
    private Date registrationDate;

    @NotNull
    private boolean superUser;


    /**
     * Flags an entry as migrated from the old website.
     * <p/>
     * Some of these entries may be anonymous entries generated where fields where empty in the
     * old database. The anonymous entries all have email addressed of the form "anonymousXXX"
     * and the display name is "unknown" -- thus they are not distinguished any further.
     */
    @NotNull
    private boolean migrated = false;

    @Transient
    private String gravatarUrl;

    public UserImpl() {
        this.registrationDate = new Date();
    }

    public UserImpl(String displayName, String email, String passwordHash, boolean superUser) {
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

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
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
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        return email.equals(((UserImpl) o).email);
    }

    @Override
    public int hashCode() {
        return email.hashCode();
    }

    @Override
    public String getUsername() {
        return getEmail();
    }

    public void setMigrated(boolean migrated) {
        this.migrated = migrated;
    }

    public boolean isMigrated() {
        return migrated;
    }

    public String getPasswordResetId() {
        return passwordResetId;
    }

    public void setPasswordResetId(String passwordResetId) {
        this.passwordResetId = passwordResetId;
    }
}
