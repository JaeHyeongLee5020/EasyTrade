<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>EasyTrade - MainPage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    	html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
        }

        body::-webkit-scrollbar {
            display: none;
        }

        .content {
            flex: 1;
        }

        #recent-view-box {
            width: 200px;
            position: sticky;
            top: 100px;
            height: fit-content;
        }
        
    </style>
</head>
<body>

    <div class="content">
        <jsp:include page="top.jsp" />
        <jsp:include page="top2.jsp" />
        <jsp:include page="keyword.jsp" />
        <jsp:include page="productImg.jsp" />
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>