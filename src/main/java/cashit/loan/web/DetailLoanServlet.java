/*
 * Copyright © 2019
 *
 * André Göller https://github.com/skylinersandre
 * Tim Schneider https://github.com/DerStimmler
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.loan.web;

import cashit.comment.ejb.CommentBean;
import cashit.comment.jpa.Comment;
import cashit.common.ejb.UserBean;
import cashit.common.jpa.User;
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

@WebServlet(name = "DetailLoanServlet", urlPatterns = {"/app/detail/*"})
public class DetailLoanServlet extends HttpServlet {

    @EJB
    LoanBean loanBean;

    @EJB
    CommentBean commentBean;

    @EJB
    UserBean userBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        //Angeforderter ToDo ermitteln
        long id = -1;
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.length() >= 2) {
            try {
                id = Long.parseLong(pathInfo.split("/")[1]);
            } catch (NumberFormatException ex) {
                // URL enthält keine gültige Long-Zahl
            }
        }
        Loan loan = loanBean.findById(id);
        // Zurück auf ToDo Übersicht seite wenn es keinen ToDo dieser ID gibt
        if (loan == null) {
            response.sendRedirect(request.getContextPath() + "/index.html");
            return;
        }
        List<Comment> comments = commentBean.findByLoanId(id);

        request.setAttribute("loan", loan);
        request.setAttribute("comments", comments);
        request.getRequestDispatcher("/WEB-INF/app/detailEintrag.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        long id = -1;
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.length() >= 2) {
            try {
                id = Long.parseLong(pathInfo.split("/")[1]);
            } catch (NumberFormatException ex) {
                // URL enthält keine gültige Long-Zahl
            }
        }

        this.addComment(request, response, id);
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        User currentUser = this.userBean.getCurrentUser();
        Loan loan = loanBean.findById(id);
        String text = request.getParameter("loan_comment");
        if (text.trim().length() != 0) { //check if comment only consists of spaces
            Comment comment = new Comment(currentUser, loan, text);
            this.commentBean.saveNew(comment, id);
        }

        response.sendRedirect(request.getRequestURI());
    }
}
