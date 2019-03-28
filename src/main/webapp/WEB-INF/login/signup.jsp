<%--
    Copyright © 2018 Dennis Schulmeister-Zimolong

    E-Mail: dhbw@windows3.de
    Webseite: https://www.wpvs.de/

    Dieser Quellcode ist lizenziert unter einer
    Creative Commons Namensnennung 4.0 International Lizenz.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib tagdir="/WEB-INF/tags/templates" prefix="template"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="base_url" value="<%=request.getContextPath()%>" />

<template:base>
    <jsp:attribute name="title">
        Registrierung
    </jsp:attribute>

    <jsp:attribute name="head">

    </jsp:attribute>

    <jsp:attribute name="menu">

    </jsp:attribute>

    <jsp:attribute name="main">
        <div class="container">
            <div class="card card-register mx-auto mt-5">
                <div class="card-header">Registrieren</div>
                <div class="card-body">
                    <form method="post" class="stacked">

                        <%-- CSRF-Token --%>
                        <input type="hidden" name="csrf_token" value="${csrf_token}">

                        <%-- Eingabefelder --%>
                        <div class="input-group form-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                            </div>
                            <input type="text" class="form-control" name="signup_username" value="${signup_form.values["signup_username"][0]}" placeholder="Benutzername" required="required" autofocus="autofocus">
                        </div>
                        <div class="input-group form-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                            </div>
                            <input type="text" class="form-control" name="signup_vorname" value="${signup_form.values["signup_vorname"][0]}" placeholder="Vorname" required="required">
                        </div>
                        <div class="input-group form-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                            </div>
                            <input type="text" class="form-control" name="signup_nachname" value="${signup_form.values["signup_nachname"][0]}" placeholder="Nachname" required="required">
                        </div>
                        <div class="input-group form-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-key"></i></span>
                            </div>
                            <input type="password" class="form-control mr-1" name="signup_password1" value="${signup_form.values["signup_password1"][0]}" placeholder="Passwort" required="required">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-key"></i></span>
                            </div>
                            <input type="password" class="form-control" name="signup_password2" value="${signup_form.values["signup_password2"][0]}" placeholder="Passwort wiederholen" required="required">
                        </div>

                        <%-- Button zum Abschicken --%>
                        <div class="side-by-side">
                            <%-- Button zum Abschicken --%>
                            <input class="btn btn-primary btn-block" type="submit" value="Registrieren">
                        </div>
                    </form>
                </div>
                <%-- Fehlermeldungen --%>
                <c:if test="${!empty signup_form.errors}">
                    <ul class="errors">
                        <c:forEach items="${signup_form.errors}" var="error">
                            <li>${error}</li>
                            </c:forEach>
                    </ul>
                </c:if>
            </div>
        </div>
    </jsp:attribute>
</template:base>
