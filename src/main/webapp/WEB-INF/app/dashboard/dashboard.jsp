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
        <div id="searchAlert" class="my-auto mx-auto alert-info">
            Daten werden abgerufen...
        </div>
        <div id="mainContainer" class="container w-100 d-none">
            <div id="overview" class="card bg-light mb-2 flex-nowrap">
                <div class="card-header bg-light">
                    Dashboard
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col">
                            <span id="overview_Positive" class="text-success float-left h1 ml-4">-</span>
                        </div>
                        <div class="col">
                            <span id="overview_Negative" class="text-danger float-right h1 mr-4">-</span>
                        </div>
                    </div>
                    <div class="row">
                        <div id="overview_Progress" class="progress w-100">
                        </div>
                    </div>
                </div>
            </div>
            <div id="middleContainer" class="row mt-2 mb-2">
                <div  class="col card w-50 float-left mr-1 p-0">
                    <div class="card col bg-secondary">
                        <div id="receiveLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                        </div>
                    </div>
                </div>
                <div class="col card w-50 float-right ml-1 p-0">
                    <div class="card col bg-secondary">
                        <div id="payerLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                        </div>
                    </div>
                </div>
            </div>
            <div id="bottomContainer" class="row mt-2">
                <div class="card mr-1 p-0 w-100">
                    <div class="card col bg-secondary">
                        <div id="acceptedLoans" class="card-body pl-0 pr-0">
                            <!-- Loans -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function printResults(results) {
                //Suchhinweis ausblenden
                document.getElementById("searchAlert").classList.add("d-none");
                //Main Container einblenden
                document.getElementById("mainContainer").classList.remove("d-none");

                var total_Pay = 0;
                var total_Receive = 0;
                var currentUsername = "${pageContext.request.userPrincipal.name}";
                var receiveLoans = document.getElementById("receiveLoans");
                var payerLoans = document.getElementById("payerLoans");
                var acceptedLoans = document.getElementById("acceptedLoans");
                var overview_Positive = document.getElementById("overview_Positive");
                var overview_Negative = document.getElementById("overview_Negative");
                var overview_Progress = document.getElementById("overview_Progress");

                results.forEach(loan => {

                    let loanCard = `
                            <div class="card bg-light mt-1 mb-1">
        <div class="row">
        <div class="col-md-1">
\${loan.payer.username === currentUsername ? "<i class=\"fas fa-minus text-danger\"></i>" : "<i class=\"fas fa-plus text-success\"></i>"}
        </div>
        <div class="col-md-2 font-weight-bold">
\${loan.amount} €
        </div>
        <div class="col-md-2">
\${loan.loanDate}
        </div>
        <div class="col">
\${loan.loanTime}
        </div>
        </div>
        <div class="row">
        <div class="col" align="center">
\${loan.receiver.username}
        </div>
        <div class="col">
<div class="btn-group btn-group-toggle mx-auto" data-toggle="buttons">
            <label class="btn btn-sm btn-info \${loan.receiver.username === currentUsername ? "" : "disabled"}">
                <input type="checkbox" name="receiver_accept" id="receiver_accept" autocomplete="off" \${loan.receiver_accept === true ? "checked" : ""} \${loan.receiver.username === currentUsername ? "" : "disabled"}> Receiver
            </label>
            <label class="btn btn-sm btn-info \${loan.payer.username === currentUsername ? "" : "disabled"}">
                <input type="checkbox" name="payer_accept" id="payer_accept" autocomplete="off" \${loan.payer_accept === true ? "checked" : ""} \${loan.payer.username === currentUsername ? "" : "disabled"}> Payer
            </label>
</div>
        </div>
        <div class="col" align="center">
\${loan.payer.username}
        </div>
        </div>
                            </div>
                        `;

                    //Done
                    if (loan.payer_accept === true && loan.receiver_accept === true) {
                        acceptedLoans.innerHTML += loanCard;
                        return;
                    }
                    //Receive
                    if (loan.receiver.username === currentUsername) {
                        total_Receive += loan.amount;
                        receiveLoans.innerHTML += loanCard;
                    }
                    //Pay
                    if (loan.payer.username === currentUsername) {
                        total_Pay += loan.amount;
                        payerLoans.innerHTML += loanCard;
                    }
                });

                //Dashboard
                overview_Positive.innerHTML = `+ \${total_Receive}`;
                overview_Negative.innerHTML = `- \${total_Pay}`;

                overview_Progress.innerHTML = `
                    <div class="progress-bar bg-success" role="progressbar" style="width: \${100 /(total_Pay + total_Receive) * total_Receive}%" aria-valuenow="\${total_Receive}" aria-valuemin="0" aria-valuemax="\${total_Pay + total_Receive}">+ \${total_Receive} €</div>
                    <div class="progress-bar bg-danger" role="progressbar" style="width: \${100 /(total_Pay + total_Receive) * total_Pay}%" aria-valuenow="\${total_Pay}" aria-valuemin="0" aria-valuemax="\${total_Pay + total_Receive}">- \${total_Pay} €</div>
                `;

            }

            async function datenAbrufen() {
                let url = "${pageContext.request.contextPath}/api/Loans/user/${pageContext.request.userPrincipal.name}/";
                let response = await fetch(url, {
                    method: "get",
                    headers: {
                        "accept": "application/json"
                    }
                });
                let loans = await response.json();
                console.log(loans);
                printResults(loans);
            }
            document.onload = datenAbrufen();
        </script>
    </jsp:attribute>
</template:base>