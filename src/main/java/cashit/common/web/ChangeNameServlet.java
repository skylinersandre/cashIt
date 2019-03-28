package cashit.common.web;

import cashit.common.ejb.UserBean;
import cashit.common.ejb.ValidationBean;
import cashit.common.jpa.Form;
import cashit.common.jpa.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/app/user/changename/"})
public class ChangeNameServlet extends HttpServlet {

    @EJB
    UserBean userBean;

    @EJB
    ValidationBean validationBean;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Anfrage an dazugerhörige JSP weiterleiten
        request.getRequestDispatcher("/WEB-INF/app/user/changeName.jsp").forward(request, response);

        // Alte Formulardaten aus der Session entfernen
        HttpSession session = request.getSession();
        session.removeAttribute("change_form");
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // username automatisch auslesen & Formulareingaben auslesen
        User user = userBean.getCurrentUser();
        String password = request.getParameter("password");
        List<String> errors = new ArrayList<>();
        Form form = new Form();
        form.setValues(request.getParameterMap());

        //ALTES PASSWORT ÜBERPRÜFEN
        if (!user.checkPassword(password)) {
            errors.add("Aktuelles Passwort ist nicht korrekt.");
        }
        //Check neues Passwort in valdiationBean
        errors = validationBean.validate(user, errors);

        user.setVorname(request.getParameter("vorname"));
        user.setNachname(request.getParameter("nachname"));

        if (errors.isEmpty()) {
            this.userBean.update(user);
            response.sendRedirect(request.getContextPath() + "/app/dashboard/");
        } else {
            form.setErrors(errors);
            // Fehler: Formuler erneut anzeigen
            HttpSession session = request.getSession();
            session.setAttribute("change_form", form);
            response.sendRedirect(request.getRequestURI());
        }
    }
}
