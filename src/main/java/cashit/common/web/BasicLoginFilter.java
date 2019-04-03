package cashit.common.web;

import cashit.common.ejb.UserBean;
import cashit.common.jpa.User;
import java.io.IOException;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BasicLoginFilter implements Filter {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BASIC_PREFIX = "Basic ";
    private static final String FILTER_PARAMETER_ROLE_NAMES_COMMA_SEPARATED = "role-names-comma-sep";
    private static final String ROLE_SEPARATOR = ",";
    private static final String BASIC_AUTH_SEPARATOR = ":";

    @EJB
    private UserBean userBean;

    /**
     * Liste der Benutzerrollen, mit denen sich der Anwender authentifizieren
     * muss
     */
    private List<String> roleNames;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String roleNamesParam = filterConfig.getInitParameter(FILTER_PARAMETER_ROLE_NAMES_COMMA_SEPARATED);
        String[] roleNamesParsed = null;

        if (roleNamesParam != null) {
            roleNamesParsed = roleNamesParam.split(ROLE_SEPARATOR);
        }

        if (roleNamesParsed != null) {
            this.roleNames = Arrays.asList(roleNamesParsed);
        }

        if (this.roleNames == null || this.roleNames.isEmpty()) {
            throw new IllegalArgumentException("No roles defined!");
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        // Benutzername und Password aus den Authorozation-Header auslesen
        String authHeader = request.getHeader(AUTHORIZATION_HEADER);
        if (authHeader == null || !authHeader.startsWith(BASIC_PREFIX)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Authorization Header fehlt");
            return;
        }

        String autfHeaderUserPwPart = authHeader.substring(BASIC_PREFIX.length());
        if (autfHeaderUserPwPart == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anmeldung nur über Basic-Auth möglich");
            return;
        }

        String headerDecoded = new String(Base64.getDecoder().decode(autfHeaderUserPwPart));
        if (!headerDecoded.contains(BASIC_AUTH_SEPARATOR)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Benutzername oder Passwort fehlt");
            return;
        }
        String[] userPwPair = headerDecoded.split(BASIC_AUTH_SEPARATOR);
        if (userPwPair.length != 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Benutzername oder Passwort fehlt");
            return;
        }
        String userDecoded = userPwPair[0];
        String passDecoded = userPwPair[1];

        request.logout();
        request.login(userDecoded, passDecoded);

        // check roles for the user
        // Logindaten und Rollenzuordnung prüfen
        User user = this.userBean.findByUsername(userDecoded);
        boolean hasRoles = false;

        if (user == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Benutzerprofil nicht gefunden");
            return;
        }

        for (String role : this.roleNames) {
            if (user.getGroups().contains(role)) {
                hasRoles = true;
                break;
            }
        }

        if (hasRoles) {
            chain.doFilter(request, response);

        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Keine ausreichenden Berechtigungen");
        }
    }

    @Override
    public void destroy() {
    }
}
