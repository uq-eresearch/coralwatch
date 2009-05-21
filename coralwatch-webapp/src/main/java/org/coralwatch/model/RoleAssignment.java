package org.coralwatch.model;

import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.io.Serializable;

@Entity
public class RoleAssignment implements Serializable {

    private static final long serialVersionUID = 1;
    /**
     * A numerical ID that's not really necessary.
     *
     * Unfortunately JPA doesn't easily let you use entities as part of a primary
     * key, see e.g. http://en.wikibooks.org/wiki/Java_Persistence/Identity_and_Sequencing#Primary_Keys_through_OneToOne_Relationships
     *
     * Using an extra ID column is not that sophisticated, but having references
     * to column names all over your code isn't either.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @Embedded
    @NotNull
    private Individual individual;
    @NotNull
    @Length(min = 6, max = 50)
    private String roleName;

    public RoleAssignment() {
    }

    public RoleAssignment(Individual individual, String roleName) {
        this.individual = individual;
        this.roleName = roleName;
    }

    public Individual getIndividual() {
        return individual;
    }

    public void setIndividual(Individual individual) {
        this.individual = individual;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
