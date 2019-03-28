/*
 * Copyright © 2019
 *
 * André Göller https://github.com/skylinersandre
 * Tim Schneider https://github.com/DerStimmler
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.comment.ejb;

import cashit.comment.jpa.Comment;
import cashit.common.ejb.EntityBean;
import java.util.List;
import javax.annotation.security.RolesAllowed;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;

@Stateless
@RolesAllowed("app-user")
public class CommentBean extends EntityBean<Comment, Long> {

    @PersistenceContext
    EntityManager em;

    public CommentBean() {
        super(Comment.class);
    }

    public List<Comment> findByLoanId(long id) {
        try {
            return this.em.createQuery("SELECT c FROM Comment c JOIN c.loan t where t.id= :id").setParameter("id", id).getResultList();
        } catch (NoResultException ex) {
            return null;
        }
    }
}
