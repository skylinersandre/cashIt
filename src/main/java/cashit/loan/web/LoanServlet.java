/*
 * Copyright © 2018 Dennis Schulmeister-Zimolong
 *
 * E-Mail: dhbw@windows3.de
 * Webseite: https://www.wpvs.de/
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.loan.web;

import cashit.common.ejb.UserBean;
import cashit.common.ejb.ValidationBean;
import cashit.common.jpa.Form;
import cashit.common.jpa.FormatUtils;
import cashit.common.jpa.User;
import cashit.loan.ejb.LoanBean;
import cashit.loan.jpa.Loan;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet für die tabellarische Auflisten der Aufgaben.
 */
@WebServlet(name = "CreateLoanServlet", urlPatterns = {"/app/create/"})
public class LoanServlet extends HttpServlet {

    @EJB
    private LoanBean loanBean;

    @EJB
    private UserBean userBean;

    @EJB
    ValidationBean validationBean;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        List<User> existingUsers = this.userBean.findAll();
        session.setAttribute("users", existingUsers);
        // Anfrage an die JSP weiterleiten
        request.getRequestDispatcher("/WEB-INF/app/createEintrag.jsp").forward(request, response);
        session.removeAttribute("cash_form");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        List<String> errors = new ArrayList<>();
        HttpSession session = request.getSession();

        Loan loan = this.createLoan(request);
        errors = this.validationBean.validate(loan, errors);

        if (!errors.isEmpty()) {
            Form form = new Form();
            form.setValues(request.getParameterMap());
            form.setErrors(errors);
            session.setAttribute("cash_form", form);

            response.sendRedirect(request.getRequestURI());
        } else {
            this.loanBean.saveNew(loan);
            response.sendRedirect("/app/dashboard/");
        }
    }

    private Loan createLoan(HttpServletRequest request) {

        double amount = Double.parseDouble(request.getParameter("cash_amount"));
        Date dueDate = FormatUtils.parseDate(request.getParameter("cash_date"));
        Time dueTime = FormatUtils.parseTime(request.getParameter("cash_time"));
        String payername = request.getParameter("cash_payer");
        User payer = this.userBean.findById(payername);
        String receivername = request.getParameter("cash_receiver");
        User receiver = this.userBean.findById(receivername);
        return new Loan(
                amount,
                dueDate,
                dueTime,
                payer,
                receiver);
    }

}
