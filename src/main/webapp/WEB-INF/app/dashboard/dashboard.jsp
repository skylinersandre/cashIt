<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib tagdir="/WEB-INF/tags/templates" prefix="template"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<template:base>
    <jsp:attribute name="title">
        Dashboard
    </jsp:attribute>

    <jsp:attribute name="head">

    </jsp:attribute>

    <jsp:attribute name="menu">

    </jsp:attribute>

    <jsp:attribute name="main">
        <c:set var="total_Pay" value="${0}"></c:set>
        <c:set var="total_Receive" value="${0}"></c:set>
        <c:forEach items="${loans}" var="loan">
            <c:if test="${loan.payer_accept ne true or loan.receiver_accept ne true}">
                <c:choose>
                    <c:when test="${loan.payer.username eq pageContext.request.userPrincipal.name}">
                        <c:set var="total_Pay" value="${total_Pay + loan.amount}"></c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="total_Receive" value="${total_Receive + loan.amount}"></c:set>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </c:forEach>

        <jsp:useBean id="utils" class="cashit.common.web.WebUtils"/>

        <div id="mainContainer" class="container w-100">
            <div id="overview" class="card bg-light mb-4 flex-nowrap">
                <div class="card-header bg-light">
                    Dashboard
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col">
                            <span id="overview_Positive" class="text-success float-left h1 ml-4">+ ${utils.formatDouble(total_Receive)} €</span>
                        </div>
                        <div class="col">
                            <span id="overview_Negative" class="text-danger float-right h1 mr-4">- ${utils.formatDouble(total_Pay)} €</span>
                        </div>
                    </div>
                    <div class="row">
                        <div id="overview_Progress" class="progress w-100">
                            <c:choose>
                                <c:when test="${(total_Pay + total_Receive) eq 0}">
                                    <div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="progress-bar bg-success" role="progressbar" style="width: ${100 /(total_Pay + total_Receive) * total_Receive}%" aria-valuenow="${total_Receive}" aria-valuemin="0" aria-valuemax="${total_Pay + total_Receive}">+ ${utils.formatDouble(total_Receive)} €</div>
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: ${100 /(total_Pay + total_Receive) * total_Pay}%" aria-valuenow="${total_Pay}" aria-valuemin="0" aria-valuemax="${total_Pay + total_Receive}">- ${utils.formatDouble(total_Pay)} €</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <div id="middleContainer" class="row mt-2 mb-2">
                <div  class="col card w-50 float-left mr-1 p-0">
                    <div class="card col bg-secondary">
                        <div id="receiveLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                            <c:forEach items="${loans}" var="loan">
                                <c:if test="${loan.receiver.username eq pageContext.request.userPrincipal.name and (loan.payer_accept ne true or loan.receiver_accept ne true)}">
                                    <div class="card bg-light mt-1 mb-1">
                                        <div class="row m-0">
                                            <div class="col-md-1 pl-1 pr-0">
                                                ${loan.payer.username eq pageContext.request.userPrincipal.name ? "<i class=\"fas fa-minus text-danger\"></i>" : "<i class=\"fas fa-plus text-success\"></i>"}
                                            </div>
                                            <div class="col-md-3 font-weight-bold">
                                                ${utils.formatDouble(loan.amount)} €
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatDate(loan.loanDate)}
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatTime(loan.loanTime)} Uhr
                                            </div>
                                            <div class="col-md float-right text-right pl-0 pr-1 cursor-pointer" onclick="document.location.href = '${pageContext.request.contextPath}/app/detail/${loan.id}/'">
                                                <i class="fas fa-info-circle fa-lg"></i>&nbsp;<i class="far fa-comments ml-1 text-muted"></i><span class="text-muted">&nbsp;${fn:length(loan.comments)}</span>
                                            </div>
                                        </div>
                                        <div class="row m-0">
                                            <hr class="w-75 border-white">
                                        </div>
                                        <div class="row m-0">
                                            <div class="col-md-3" align="center">
                                                ${loan.receiver.username}
                                            </div>
                                            <div class="col" align="center">
                                                <div class="mx-auto">
                                                    <span style="float:left;">
                                                        <form method="post" id="receiver_Form${loan.id}" name="receiver_accept">
                                                            <%-- CSRF-Token --%>
                                                            <input type="hidden" name="csrf_token" value="${csrf_token}">
                                                            <label class="${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                                <input onclick="document.getElementById('receiver_Form${loan.id}').submit();" type="checkbox" name="receiver_accept" value="${loan.id}" id="receiver_accept"  ${loan.receiver_accept eq true ? "checked disabled" : ""} ${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                            </label>
                                                        </form>
                                                    </span>
                                                    <span style="float:right;">
                                                        <label class="${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                            <input type="checkbox" name="payer_accept" value="${loan.id}" id="payer_accept" ${loan.payer_accept eq true ? "checked" : ""} ${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                        </label>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col-md-3" align="center">
                                                ${loan.payer.username}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="col card w-50 float-right ml-1 p-0">
                    <div class="card col bg-secondary">
                        <div id="payerLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                            <c:forEach items="${loans}" var="loan">
                                <c:if test="${loan.payer.username eq pageContext.request.userPrincipal.name and (loan.payer_accept ne true or loan.receiver_accept ne true)}">
                                    <div class="card bg-light mt-1 mb-1">
                                        <div class="row m-0">
                                            <div class="col-md-1 pl-1 pr-0">
                                                ${loan.payer.username eq pageContext.request.userPrincipal.name ? "<i class=\"fas fa-minus text-danger\"></i>" : "<i class=\"fas fa-plus text-success\"></i>"}
                                            </div>
                                            <div class="col-md-3 font-weight-bold">
                                                ${utils.formatDouble(loan.amount)} €
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatDate(loan.loanDate)}
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatTime(loan.loanTime)} Uhr
                                            </div>
                                            <div class="col-md float-right text-right pl-0 pr-1 cursor-pointer" onclick="document.location.href = '${pageContext.request.contextPath}/app/detail/${loan.id}/'">
                                                <i class="fas fa-info-circle fa-lg"></i>&nbsp;<i class="far fa-comments ml-1 text-muted"></i><span class="text-muted">&nbsp;${fn:length(loan.comments)}</span>
                                            </div>
                                        </div>
                                        <div class="row m-0">
                                            <hr class="w-75 border-white">
                                        </div>
                                        <div class="row m-0">
                                            <div class="col-md-3" align="center">
                                                ${loan.receiver.username}
                                            </div>
                                            <div class="col" align="center">
                                                <div class="mx-auto">
                                                    <span style="float:left;">
                                                        <label class="${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                            <input type="checkbox" name="receiver_accept" value="${loan.id}" id="receiver_accept" ${loan.receiver_accept eq true ? "checked disabled" : ""} ${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                        </label>
                                                    </span>
                                                    <span style="float:right;">
                                                        <form method="post" id="payer_Form${loan.id}" name="payer_accept">
                                                            <%-- CSRF-Token --%>
                                                            <input type="hidden" name="csrf_token" value="${csrf_token}">
                                                            <label class="${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                                <input  onclick="document.getElementById('payer_Form${loan.id}').submit();" type="checkbox" name="payer_accept" value="${loan.id}" id="payer_accept" ${loan.payer_accept eq true ? "checked disabled" : ""} ${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                            </label>
                                                        </form>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col-md-3" align="center">
                                                ${loan.payer.username}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            <div id="bottomContainer" class="row mt-2">
                <div class="card mr-1 p-0 w-100">
                    <div class="card col bg-secondary">
                        <div id="acceptedLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                            <c:forEach items="${loans}" var="loan">
                                <c:if test="${loan.payer_accept eq true and loan.receiver_accept eq true}">
                                    <div class="card bg-light mt-1 mb-1">
                                        <div class="row m-0">
                                            <div class="col-md-1 pl-1 pr-0">
                                                ${loan.payer.username eq pageContext.request.userPrincipal.name ? "<i class=\"fas fa-minus text-danger\"></i>" : "<i class=\"fas fa-plus text-success\"></i>"}
                                            </div>
                                            <div class="col-md-3 font-weight-bold">
                                                ${utils.formatDouble(loan.amount)} €
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatDate(loan.loanDate)}
                                            </div>
                                            <div class="col-md-3 pl-0 pr-0">
                                                ${utils.formatTime(loan.loanTime)} Uhr
                                            </div>
                                            <div class="col-md float-right text-right pl-0 pr-1 cursor-pointer" onclick="document.location.href = '${pageContext.request.contextPath}/app/detail/${loan.id}/'">
                                                <i class="fas fa-info-circle fa-lg"></i>&nbsp;<i class="far fa-comments ml-1 text-muted"></i><span class="text-muted">&nbsp;${fn:length(loan.comments)}</span>
                                            </div>
                                        </div>
                                        <div class="row m-0">
                                            <hr class="w-75 border-white">
                                        </div>
                                        <div class="row m-0">
                                            <div class="col-md-3" align="center">
                                                ${loan.receiver.username}
                                            </div>
                                            <div class="col" align="center">
                                                <div class="mx-auto" >
                                                    <label class="${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                        <input type="checkbox" name="receiver_accept" value="${loan.id}" id="receiver_accept" ${loan.receiver_accept eq true ? "checked disabled" : ""} ${loan.receiver.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                    </label>
                                                    <label class="${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}">
                                                        <input type="checkbox" name="payer_accept" value="${loan.id}" id="payer_accept" ${loan.payer_accept eq true ? "checked disabled" : ""} ${loan.payer.username eq pageContext.request.userPrincipal.name ? "" : "disabled"}>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-3" align="center">
                                                ${loan.payer.username}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </jsp:attribute>
</template:base>
