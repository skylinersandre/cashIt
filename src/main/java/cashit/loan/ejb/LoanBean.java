/*
 * Copyright © 2019
 *
 * André Göller https://github.com/skylinersandre
 * Tim Schneider https://github.com/DerStimmler
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.loan.ejb;

import cashit.common.ejb.EntityBean;
import cashit.loan.jpa.Loan;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.NoResultException;

@Stateless
public class LoanBean extends EntityBean<Loan, Long> {

    public LoanBean() {
        super(Loan.class);
    }

    public List<Loan> findByUsername(String username) {
        try {
            return em.createQuery("SELECT t FROM Loan t WHERE t.payer.username = :username OR t.receiver.username = :username")
                    .setParameter("username", username)
                    .getResultList();
        } catch (NoResultException ex) {
            return null;
        }
    }
}
