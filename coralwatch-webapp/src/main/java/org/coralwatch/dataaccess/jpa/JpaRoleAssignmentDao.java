package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.RoleAssignmentDao;
import org.coralwatch.model.RoleAssignment;


public class JpaRoleAssignmentDao extends JpaDao<RoleAssignment> implements RoleAssignmentDao {

    public JpaRoleAssignmentDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }
}
