package org.springframework.samples.petclinic.owner;

import java.util.Collection;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@Component("ownerRepositoryImpl")
public class OwnerRepositoryCustomImpl implements OwnerRepository {

	@PersistenceContext
    private EntityManager entityManager;
    
	@Override
	public Collection<Owner> findByLastName(String lastName) {
		System.out.println("Vulnerable method 1");
	    	String sqlQuery = "SELECT DISTINCT owner FROM Owner owner left join fetch owner.pets WHERE owner.lastName LIKE '" + lastName +"%'";
	    	
	    	TypedQuery<Owner> query = this.entityManager.createQuery(sqlQuery, Owner.class);
	
	    	return query.getResultList();
	}

	@Override
	public Owner findById(Integer id) {
		System.out.println("Vulnerable method 2");
	    	String sqlQuery = "SELECT owner FROM Owner owner left join fetch owner.pets WHERE owner.id = " + id;
	    	
	    	TypedQuery<Owner> query = this.entityManager.createQuery(sqlQuery, Owner.class);
	
	    	return query.getSingleResult();
	}

	@Override
	public void save(Owner owner) {
	
		// If the object already exists, then we can't directly use the detached object in persist.
		if (owner.getId() != null) {
			this.entityManager.merge(owner);
			return;
		}
		
		this.entityManager.persist(owner);
	}

}

