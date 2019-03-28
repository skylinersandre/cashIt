/*
 * Copyright © 2019
 *
 * André Göller https://github.com/skylinersandre
 * Tim Schneider https://github.com/DerStimmler
 *
 * Dieser Quellcode ist lizenziert unter einer
 * Creative Commons Namensnennung 4.0 International Lizenz.
 */
package cashit.comment.jpa;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;
import cashit.common.jpa.User;
import cashit.loan.jpa.Loan;

@Entity
public class Comment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @NotNull(message = "Der Kommentar muss einem Beutzer zugeordnet werden!")
    private User user;

    @ManyToOne
    private Loan loan;

    @Lob //text of a comment can be greater than 255 chars
    @NotNull(message = "Bitte geben Sie einen Kommentar ein!")
    private String commentText;

    private Timestamp commentTimestamp;

    //<editor-fold defaultstate="collapsed" desc="Konstruktoren">
    public Comment() {
        this.user = null;
        this.loan = null;
        this.commentText = "";
        this.commentTimestamp = null;
    }

    public Comment(User user, Loan transaction, String commentText) {
        this.user = user;
        this.loan = transaction;
        this.commentText = commentText;
        this.commentTimestamp = new Timestamp(System.currentTimeMillis());
    }
    //</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="Getter and Setter">
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Loan getLoan() {
        return loan;
    }

    public void setTodo(Loan transaction) {
        this.loan = transaction;
    }

    public String getCommentText() {
        return commentText;
    }

    public void setCommentText(String commentText) {
        this.commentText = commentText;
    }

    public Timestamp getCommentTimestamp() {
        return commentTimestamp;
    }

    public void setCommentTimestamp(Timestamp commentTimestamp) {
        this.commentTimestamp = commentTimestamp;
    }
//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="Equals, hashCode">
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Comment)) {
            return false;
        }
        Comment other = (Comment) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }
//</editor-fold>
}
