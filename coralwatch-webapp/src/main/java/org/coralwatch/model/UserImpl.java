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

    private String firstName;

    private String lastName;

    // Do not set this field, decommissioned as part of Ticket #473 (Improve address entry for kit requests).
    // Instead set these fields: addressLine1, addressLine2, city, state, postcode.
    // See getter function below, which will first look in the new fields, but fall back on this one.
    @Column(name="address", length = 500)
    private String addressString;
    
    private String addressLine1;
    
    private String addressLine2;
    
    private String city;
    
    private String state;
    
    private String postcode;
    
    @Column(name="country", length = 256)
    private String country;

    private String phone;

    private String occupation;

    private String positionDescription;

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
            gravatarUrl = "https://www.gravatar.com/avatar/" + emailHash + "?s=80&d=" + GRAVATAR_FALLBACK;
        }
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getFullName() {
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        }
        if (displayName != null) {
            return displayName;
        }
        return null;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
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

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getPositionDescription() {
        return positionDescription;
    }

    public void setPositionDescription(String positionDescription) {
        this.positionDescription = positionDescription;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
