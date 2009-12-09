package org.coralwatch.model;

import org.hibernate.validator.NotNull;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.io.Serializable;

@Entity
public class Reef implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotNull
    @Column(unique = true)
    private String name;

    @NotNull
    private String country;

    /**
     * Stores the quality assurance state of the entry.
     * <p/>
     * This should be modelled in a base class, but we avoid that for now.
     *
     * @see Survey#qaState
     */
    private String qaState;

    public Reef() {
    }

    public Reef(String reefName, String country) {
        this.name = reefName;
        this.country = country;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public void setQaState(String qaState) {
        this.qaState = qaState;
    }

    public String getQaState() {
        return qaState;
    }

}
