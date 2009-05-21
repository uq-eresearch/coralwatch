package org.coralwatch.model;

import org.hibernate.validator.Email;
import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;

import javax.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public class Individual implements Serializable {

    private static final long serialVersionUID = 1L;
    @NotNull
    @Length(min = 6, max = 50)
    private String displayName;
    @Email
    private String emailAddress;

    public Individual() {
    }

    public Individual(String displayName, String emailAddress) {
        this.displayName = displayName;
        this.emailAddress = emailAddress;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }
}
