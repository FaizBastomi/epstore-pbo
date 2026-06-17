<%-- 
    Document   : index
    Created on : Jun 17, 2026, 7:10:02 AM
    Author     : voliya
--%>

<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ses = request.getSession(false);
    if (ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Beranda</title>
    </head>
    <body>
        <h1>Halo, <%= ses.getAttribute("username")%></h1>
    </body>
</html>
