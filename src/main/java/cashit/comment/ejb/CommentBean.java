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
import javax.annotation.security.RolesAllowed;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
@RolesAllowed("app-user")
public class CommentBean extends EntityBean<Comment, Long> {

    @PersistenceContext
    EntityManager em;

    public CommentBean() {
        super(Comment.class);
    }
}
