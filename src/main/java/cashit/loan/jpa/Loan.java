package cashit.loan.jpa;

import cashit.comment.jpa.Comment;
import cashit.common.jpa.User;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.validation.constraints.NotNull;

@Entity
public class Loan implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull(message = "Bitte geben Sie einen Betrag in Euro € ein")
    private double amount;

    @NotNull(message = "Bitte geben Sie ein Transaktionsdatum in der Form DD.MM.YYYY an")
    private Date loanDate;

    @NotNull(message = "Bitte geben Sie eine Transaktionszeit in der Form HH:MM an")
    private Time loanTime;

    @NotNull(message = "Es muss einen Zahler geben")
    private User payer;

    @NotNull(message = "Es muss einen Empfänger geben")
    private User receiver;

    @OneToMany(mappedBy = "transaction", fetch = FetchType.EAGER)
    List<Comment> comments = new ArrayList<>();

    //<editor-fold defaultstate="collapsed" desc="Konstruktoren">
    public Loan(double amount, Date date, Time time, User payer, User receiver) {
        this.amount = amount;
        this.loanDate = date;
        this.loanTime = time;
        this.payer = payer;
        this.receiver = receiver;
    }

    public Loan() {
        this.amount = 0;
        this.loanDate = null;
        this.loanTime = null;
        this.payer = null;
        this.receiver = null;
    }
    //</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="Getter and Setter">
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(Date loanDate) {
        this.loanDate = loanDate;
    }

    public Time getLoanTime() {
        return loanTime;
    }

    public void setLoanTime(Time loanTime) {
        this.loanTime = loanTime;
    }

    public User getPayer() {
        return payer;
    }

    public void setPayer(User payer) {
        this.payer = payer;
    }

    public User getReceiver() {
        return receiver;
    }

    public void setReceiver(User receiver) {
        this.receiver = receiver;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
//</editor-fold>
}
