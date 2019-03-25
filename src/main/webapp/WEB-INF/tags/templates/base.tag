<%--
    Copyright © 2018 Dennis Schulmeister-Zimolong

    E-Mail: dhbw@windows3.de
    Webseite: https://www.wpvs.de/

    Dieser Quellcode ist lizenziert unter einer
    Creative Commons Namensnennung 4.0 International Lizenz.
--%>
<%@tag pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@attribute name="title"%>
<%@attribute name="head" fragment="true"%>
<%@attribute name="menu" fragment="true"%>
<%@attribute name="main" fragment="true"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />

        <title>CashIt | ${title}</title>

        <!-- https://pixabay.com/de/flach-design-symbol-icon-www-2126884/ -->
        <link rel="shortcut icon" href="<c:url value="/img/favicon.png"/>">

        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="<c:url value="/css/bootstrap/bootstrap-reboot.min.css"/>" >
        <link rel="stylesheet" type="text/css" href="<c:url value="/css/bootstrap/bootstrap-grid.min.css"/>" >
        <link rel="stylesheet" type="text/css" href="<c:url value="/css/bootstrap/bootstrap.min.css"/>" >
        <link rel="stylesheet" type="text/css" href="<c:url value="/css/style.css"/>">

        <jsp:invoke fragment="head"/>
    </head>
    <body class="bg-dark">
        <!-- Menü der Seite -->
        <nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
            <span class="navbar-brand mb-0 h1">CashIt</span>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">

                    <!-- Navbar Items -->
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI eq '/cashIt/WEB-INF/app/dashboard.jsp' ? ' active' : ''}" href="<c:url value="/"/>">Home</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle <c:if test = "${fn:contains(pageContext.request.requestURI, '/cashIt/WEB-INF/app/user/')}">active</c:if>" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Benutzerdaten ändern
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item ${pageContext.request.requestURI eq '/cashIt/WEB-INF/app/user/changeName.jsp' ? ' active' : ''}" href="<c:url value="/app/user/changename/"/>">Name ändern</a>
                            <a class="dropdown-item ${pageContext.request.requestURI eq '/cashIt/WEB-INF/app/user/changePassword.jsp' ? ' active' : ''}" href="<c:url value="/app/user/changepw/"/>">Passwort ändern</a>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI eq '/cashIt/WEB-INF/app/createEintrag.jsp' ? ' active' : ''}" href="<c:url value="/app/create/"/>">Eintrag erstellen</a>
                    </li>
                    <jsp:invoke fragment="menu"/>
                    <!-- /Navbar Items -->
                </ul>

                <!-- Login/Logout Button -->
                <c:choose>
                    <c:when test="${not empty pageContext.request.userPrincipal}">
                        <p class="my-2 my-sm-0 pr-2">${pageContext.request.userPrincipal.name}</p>
                        <form action="<c:url value="/logout/"/>">
                            <button class="btn btn-outline-danger my-2 my-sm-0" type="submit">Logout</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <form action="<c:url value="/login/"/>">
                            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Login</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>

        <%-- Hauptinhalt der Seite --%>
        <main>
            <jsp:invoke fragment="main"/>
        </main>

        <!-- Footer der Seite -->
        <footer class="page-footer fixed-bottom font-small bg-light">
            <div class="footer-copyright text-center">CashIt © 2019
                <a class="float-right text-right pr-5" target="_blank" href="https://github.com/skylinersandre/cashIt"><i class="fab fa-github" style="color:black"></i></a>
            </div>
        </footer>

        <!-- Skripte für Bootstrap -->
        <script type="text/javascript" src="<c:url value="/js/jquery/jquery.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/js/bootstrap/bootstrap.min.js"/>"></script>

        <!-- Skript für Select2 -->
        <script type="text/javascript" src="<c:url value="/js/select2/select2.min.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/js/select2/select2_single.js"/>"></script>

        <!-- Skript für Bootstrap Theme for Select2 -->
        <script type="text/javascript" src="<c:url value="/js/select2/select2_bootstrapTheme.js"/>">></script>
    </body>
</html>