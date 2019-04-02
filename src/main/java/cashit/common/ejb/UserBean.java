/*
 * Copyright © 2018 Dennis Schulmeister-Zimolong
 *
 * E-Mail: dhbw@windows3.de
 * Webseite: https://www.wpvs.de/
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.common.ejb;

import cashit.common.jpa.User;
import javax.annotation.Resource;
import javax.annotation.security.RolesAllowed;
import javax.ejb.EJBContext;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * Spezielle EJB zum Anlegen eines Benutzers und Aktualisierung des Passworts.
 */
@Stateless
public class UserBean extends EntityBean<User, String> {

    @PersistenceContext
    EntityManager em;

    @Resource
    EJBContext ctx;

    //<editor-fold defaultstate="collapsed" desc="Konstruktor">
    public UserBean() {
        super(User.class);
    }

    //</editor-fold>
    //<editor-fold defaultstate="collapsed" desc="Weitere Methoden">
    /**
     * Gibt das Datenbankobjekt des aktuell eingeloggten Benutzers zurück,
     *
     * @return Eingeloggter Benutzer oder null
     */
    public User getCurrentUser() {
        return this.em.find(User.class, this.ctx.getCallerPrincipal().getName());
    }

    public User findByUsername(String username) {
        return em.find(User.class, username);
    }

    /**
     *
     * @param username
     * @param vorname
     * @param nachname
     * @param password
     * @throws UserBean.UserAlreadyExistsException
     */
    public void signup(String username, String vorname, String nachname, String password) throws UserAlreadyExistsException {
        if (em.find(User.class, username) != null) {
            throw new UserAlreadyExistsException("Der Benutzername $B ist bereits vergeben.".replace("$B", username));
        }

        User user = new User(username, vorname, nachname, password);
        user.addToGroup("app-user");
        em.persist(user);
    }

    /**
     * Passwort ändern (ohne zu speichern)
     *
     * @param user
     * @param oldPassword
     * @param newPassword
     * @throws UserBean.InvalidCredentialsException
     */
    @RolesAllowed("app-user")
    public void changePassword(User user, String oldPassword, String newPassword) throws InvalidCredentialsException {
        if (user == null || !user.checkPassword(oldPassword)) {
            throw new InvalidCredentialsException("Benutzername oder Passwort sind falsch.");
        }

        user.setPassword(newPassword);
    }

    /**
     * Benutzer löschen
     *
     * @param user Zu löschender Benutzer
     */
    @RolesAllowed("app-user")
    public void delete(User user) {
        this.em.remove(user);
    }

    /**
     * Benutzer aktualisieren
     *
     * @param user Zu aktualisierender Benutzer
     * @return Gespeicherter Benutzer
     */
    @RolesAllowed("app-user")
    public User update(User user) {
        return em.merge(user);
    }

    /**
     * Fehler: Der Benutzername ist bereits vergeben
     */
    public class UserAlreadyExistsException extends Exception {

        public UserAlreadyExistsException(String message) {
            super(message);
        }
    }

    /**
     * Fehler: Das übergebene Passwort stimmt nicht mit dem des Benutzers
     * überein
     */
    public class InvalidCredentialsException extends Exception {

        public InvalidCredentialsException(String message) {
            super(message);
        }
    }
//</editor-fold>
}
