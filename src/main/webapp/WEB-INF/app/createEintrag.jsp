<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib tagdir="/WEB-INF/tags/templates" prefix="template"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<template:base>
    <jsp:attribute name="title">
        Erstellen
    </jsp:attribute>

    <jsp:attribute name="head">

    </jsp:attribute>

    <jsp:attribute name="menu">

    </jsp:attribute>

    <jsp:attribute name="main">
        <div class="container">
            <div class="card card-register mx-auto mt-5">
                <div class="card-header">Loan erstellen</div>
                <div class="card-body">
                    <form method="post" class="stacked">
                        <%-- CSRF-Token --%>
                        <input type="hidden" name="csrf_token" value="${csrf_token}">
                        <%-- Eingabefelder --%>
                        <div class="form-group">
                            <select class="js-example-basic-single form-control w-25" name="cash_payer" id="payerSelectCreateLoan" required="required">
                                <option></option>
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.username}">${user.username}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <select class="js-example-basic-single form-control w-25" name="cash_receiver" id="receiverSelectCreateLoan" required="required">
                                <option></option>
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.username}">${user.username}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="cash_amount" value="${cash_form.values["cash_amount"][0]}" autofocus="autofocus" required="required" placeholder="Betrag">
                        </div>
                        <div class="form-group">
                            <div class="form-row">
                                <div class="col-md-6">
                                    <input type="date" class="form-control" name="cash_date" value="${cash_form.values["cash_date"][0]}" required="required" placeholder="Datum">
                                </div>
                                <div class="col-md-6">
                                    <input type="time" class="form-control" name="cash_time" value="${cash_form.values["cash_time"][0]}" required="required" placeholder="Zeit">
                                </div>
                            </div>
                        </div>

                        <%-- Button zum Abschicken --%>
                        <button class="btn btn-primary btn-block" name="action" value="create" type="submit">
                            Loan erstellen
                        </button>
                    </form>
                </div>

                <%-- Fehlermeldungen --%>
                <c:if test="${!empty cash_form.errors}">
                    <ul class="errors">
                        <c:forEach items="${cash_form.errors}" var="error">
                            <li>
                                ${error}
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
            </div>
        </div>
    </jsp:attribute>
</template:base>
