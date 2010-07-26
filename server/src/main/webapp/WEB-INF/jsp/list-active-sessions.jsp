<%--@elvariable id="activeSessions" type="java.util.List"--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<html>
<head>
    <title>Active Sessions</title>
</head>
<h1>Active Sessions</h1>

<table>
    <tr>
        <th width="30"></th>
        <th width="350">Session ID</th>
        <th width="200">E-mail</th>
        <th>Online since</th>
    </tr>
    <c:forEach items="${activeSessions}" var="activeSession">
        <%--@elvariable id="activeSession" type="nl.tomvanzummeren.msnapi.messenger.service.ActiveSession"--%>
        <tr>
            <td>
                <a href="<c:url value="/admin/disconnect?sessionId=${activeSession.sessionId}"/>" title="Disconnect user">
                    <img src="<c:url value="/disconnect.png"/>" width="16" height="16" alt="Disconnect user"/></a>
            </td>
            <td>${activeSession.sessionId}</td>
            <td>${activeSession.email}</td>
            <td>${activeSession.onlineSince}</td>
        </tr>
    </c:forEach>
</table>

</html>