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
import javax.persistence.OneToOne;
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
    @OneToOne
    private User payer;

    @NotNull(message = "Es muss einen Empfänger geben")
    @OneToOne
    private User receiver;

    boolean payer_accept;

    boolean receiver_accept;

    @OneToMany(fetch = FetchType.EAGER)
    List<Comment> comments = new ArrayList<>();

    //<editor-fold defaultstate="collapsed" desc="Konstruktoren">
    public Loan(double amount, Date loanDate, Time loanTime, User payer, User receiver) {
        this.amount = amount;
        this.loanDate = loanDate;
        this.loanTime = loanTime;
        this.payer = payer;
        this.receiver = receiver;
        this.payer_accept = false;
        this.receiver_accept = false;
    }

    public Loan() {
        this.amount = 0;
        this.loanDate = null;
        this.loanTime = null;
        this.payer = null;
        this.receiver = null;
        this.payer_accept = false;
        this.receiver_accept = false;
    }
    //</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="Getter and Setter">
    public Long getId() {
        return id;
    }

    public boolean isPayer_accept() {
        return payer_accept;
    }

    public void setPayer_accept(boolean payer_accept) {
        this.payer_accept = payer_accept;
    }

    public boolean isReceiver_accept() {
        return receiver_accept;
    }

    public void setReceiver_accept(boolean receiver_accept) {
        this.receiver_accept = receiver_accept;
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
