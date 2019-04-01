/*
 * Copyright © 2019
 *
 * André Göller https://github.com/skylinersandre
 * Tim Schneider https://github.com/DerStimmler
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.rest;

import cashit.loan.ejb.LoanBean;
import cashit.loan.jpa.Loan;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Stateless
@Path("Loans")
@Produces(MediaType.APPLICATION_JSON)
public class LoanRessource {

    @EJB
    LoanBean loanBean;

    @GET
    @Path("id/{id}")
    @Transactional
    public Loan getLoans(@PathParam("id") Long id) {
        return this.loanBean.findById(id);
    }
}
