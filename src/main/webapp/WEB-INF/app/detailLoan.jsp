<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib tagdir="/WEB-INF/tags/templates" prefix="template"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt"%>

<template:base>
    <jsp:attribute name="title">
        Detail
    </jsp:attribute>

    <jsp:attribute name="head">

    </jsp:attribute>

    <jsp:attribute name="menu">

    </jsp:attribute>

    <jsp:attribute name="main">

        <jsp:useBean id="utils" class="cashit.common.web.WebUtils"/>

        <div class="container">
            <div class="card card-register mx-auto mt-5">
                <%-- Inhalt ToDo --%>
                <div class="card-body">
                    <%-- Ausgabefelder --%>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Payer:</b>
                        </div>
                        <div class="col">
                            ${loan.payer.username}
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Payer accept:</b>
                        </div>
                        <div class="col">
                            <input type="checkbox" disabled ${loan.payer_accept eq true ? "checked" : ""}>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Receiver:</b>
                        </div>
                        <div class="col">
                            ${loan.receiver.username}
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Receiver accept:</b>
                        </div>
                        <div class="col">
                            <input type="checkbox" disabled ${loan.receiver_accept eq true ? "checked" : ""}>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Datum:</b>
                        </div>
                        <div class="col">
                            ${utils.formatDate(loan.loanDate)}
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Zeit:</b>
                        </div>
                        <div class="col">
                            ${utils.formatTime(loan.loanTime)} Uhr
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <b>Betrag:</b>
                        </div>
                        <div class="col">
                            ${utils.formatDouble(loan.amount)} €
                        </div>
                    </div>
                </div>
                <%-- Fehlermeldungen --%>
                <c:if test="${!empty change_form.errors}">
                    <ul class="errors">
                        <c:forEach items="${change_form.errors}" var="error">
                            <li>${error}</li>
                            </c:forEach>
                    </ul>
                </c:if>
            </div>
        </div>

        <%-- Kommentare --%>
        <div class="container chat-container mt-7">
            <c:forEach items="${loan.comments}" var="comment">
                <div class="chat ${pageContext.request.userPrincipal.name eq comment.user.username ? 'me' : 'you'}">
                    <p>${comment.commentText}</p>
                    <span class="time"><i class="far fa-clock mr-2 ml-3"></i><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${comment.commentTimestamp}"/></span>
                    <span class="time"><i class="far fa-user mr-2"></i>${comment.user.username}</span>
                </div>
            </c:forEach>
            <hr class="bg-light">
            <form method="post" class="stacked">
                <div class="d-flex justify-content-center mt-6 mb-5">
                    <div class="col">
                        <div class="row justify-content-center">
                            <textarea class="form-control comment-textarea" type="text" name="loan_comment" value="${loan_form.values["loan_comment"][0]}" required="required"></textarea>
                        </div>
                        <div class="row justify-content-center">
                            <button type="submit" class="btn btn-labeled btn-dark mt-1" name="action" value="comment">
                                <span class="btn-label"><i class="fas fa-comments"></i></span>  Kommentieren
                            </button>
                        </div>
                    </div>
                </div>

                <%-- CSRF-Token --%>
                <input type="hidden" name="csrf_token" value="${csrf_token}">
            </form>
        </div>
    </jsp:attribute>
</template:base>

