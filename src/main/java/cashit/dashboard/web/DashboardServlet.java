/*
 * Copyright © 2019 Dennis Schulmeister-Zimolong
 *
 * E-Mail: dhbw@windows3.de
 * Webseite: https://www.wpvs.de/
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.dashboard.web;

import cashit.common.ejb.UserBean;
import cashit.loan.ejb.LoanBean;
import cashit.loan.jpa.Loan;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet für die Startseite mit dem Übersichts-Dashboard.
 */
@WebServlet(urlPatterns = {"/app/dashboard/"})
public class DashboardServlet extends HttpServlet {

    @EJB
    LoanBean loanBean;

    @EJB
    UserBean userBean;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Loan> loans = loanBean.findByUsername(userBean.getCurrentUser().getUsername());
        request.setAttribute("loans", loans);
        // Anfrage an die JSP weiterleiten
        request.getRequestDispatcher("/WEB-INF/app/dashboard/dashboard.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getParameter("payer_accept") != null) {
            long loanId = Long.parseLong(request.getParameter("payer_accept"));
            Loan loan = loanBean.findById(loanId);
            loan.setPayer_accept(true);
            loanBean.update(loan);

        }
        if (request.getParameter("receiver_accept") != null) {
            long loanId = Long.parseLong(request.getParameter("receiver_accept"));
            Loan loan = loanBean.findById(loanId);
            loan.setReceiver_accept(true);
            loanBean.update(loan);
        }
        response.sendRedirect(request.getRequestURI());
    }

}
