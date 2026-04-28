<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%
response.setStatus(403);

String requestUri = "";
String servletName = "";
String exceptionMessage = "";

try {
    Object uriObj = request.getAttribute("javax.servlet.error.request_uri");
    Object servletObj = request.getAttribute("javax.servlet.error.servlet_name");
    Object exceptionObj = request.getAttribute("javax.servlet.error.exception");

    if(uriObj != null) requestUri = String.valueOf(uriObj);
    if(servletObj != null) servletName = String.valueOf(servletObj);
    if(exceptionObj != null) exceptionMessage = exceptionObj.getClass().getSimpleName();
} catch(Exception e) {
    requestUri = "";
    servletName = "";
    exceptionMessage = "";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Access Denied | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

:root{
    --primary:#3B82F6;
    --cyan:#22D3EE;
    --violet:#8B5CF6;
    --bg:#07080D;
    --surface:#10131D;
    --surface2:#171B28;
    --text:#F8FAFC;
    --muted:#B6C2D3;
    --soft:#7D8AA0;
    --border:rgba(255,255,255,.09);
    --accent:#F59E0B;
    --heading:'Outfit',sans-serif;
    --body:'Inter',sans-serif;
}

html{
    scroll-behavior:smooth;
}

body{
    min-height:100vh;
    font-family:var(--body);
    color:var(--text);
    background:
        radial-gradient(circle at 18% 8%, rgba(59,130,246,.24), transparent 34%),
        radial-gradient(circle at 86% 24%, rgba(34,211,238,.13), transparent 32%),
        radial-gradient(circle at 40% 92%, rgba(139,92,246,.12), transparent 34%),
        linear-gradient(180deg,#07080D,#090B12 48%,#07080D);
    overflow-x:hidden;
}

body::after{
    content:"";
    position:fixed;
    inset:0;
    z-index:-1;
    background-image:
        linear-gradient(rgba(255,255,255,.024) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,.024) 1px, transparent 1px);
    background-size:56px 56px;
    mask-image:linear-gradient(to bottom, rgba(0,0,0,.84), rgba(0,0,0,.20), transparent);
    -webkit-mask-image:linear-gradient(to bottom, rgba(0,0,0,.84), rgba(0,0,0,.20), transparent);
}

a{
    color:inherit;
    text-decoration:none;
}

.shell{
    width:min(1120px, calc(100% - 40px));
    min-height:100vh;
    margin:0 auto;
    display:grid;
    grid-template-columns:.95fr 1.05fr;
    align-items:center;
    gap:34px;
    padding:42px 0;
}

.brand{
    position:fixed;
    top:28px;
    left:32px;
    z-index:10;
    font-family:var(--heading);
    font-size:22px;
    font-weight:900;
    letter-spacing:-.8px;
}

.brand span{
    color:var(--primary);
}

.copy{
    padding-top:50px;
}

.kicker{
    width:max-content;
    display:inline-flex;
    align-items:center;
    gap:9px;
    border:1px solid rgba(34,211,238,.22);
    background:rgba(34,211,238,.08);
    color:#BAE6FD;
    border-radius:999px;
    padding:8px 13px;
    font-size:11px;
    font-weight:900;
    letter-spacing:1px;
    text-transform:uppercase;
    margin-bottom:18px;
}

h1{
    font-family:var(--heading);
    font-size:clamp(52px,7vw,104px);
    line-height:.88;
    letter-spacing:-4px;
    font-weight:900;
    margin-bottom:20px;
}

h1 em{
    font-style:normal;
    color:var(--soft);
    font-weight:260;
}

.copy p{
    color:var(--muted);
    line-height:1.85;
    max-width:640px;
    font-size:15.5px;
    margin-bottom:24px;
}

.actions{
    display:flex;
    flex-wrap:wrap;
    gap:10px;
}

.btn{
    min-height:46px;
    border-radius:14px;
    padding:0 18px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:9px;
    font-family:var(--heading);
    font-size:14px;
    font-weight:850;
    transition:.2s;
}

.btn.primary{
    background:linear-gradient(135deg,var(--primary),var(--cyan));
    color:white;
}

.btn.secondary{
    border:1px solid var(--border);
    background:rgba(255,255,255,.035);
    color:var(--muted);
}

.btn:hover{
    transform:translateY(-2px);
    color:white;
}

.card{
    position:relative;
    border:1px solid var(--border);
    background:linear-gradient(145deg, rgba(16,19,29,.92), rgba(8,11,18,.86));
    border-radius:34px;
    padding:34px;
    overflow:hidden;
    box-shadow:0 36px 100px rgba(0,0,0,.38);
}

.card::before{
    content:"";
    position:absolute;
    right:-150px;
    top:-160px;
    width:370px;
    height:370px;
    border-radius:50%;
    background:radial-gradient(circle, rgba(59,130,246,.20), transparent 68%);
}

.card > *{
    position:relative;
}

.code-badge{
    width:132px;
    height:132px;
    border-radius:34px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:linear-gradient(135deg,var(--accent),var(--cyan));
    color:white;
    font-family:var(--heading);
    font-size:48px;
    font-weight:900;
    margin-bottom:24px;
    box-shadow:0 28px 70px rgba(59,130,246,.26);
}

.card h2{
    font-family:var(--heading);
    font-size:34px;
    letter-spacing:-1.1px;
    margin-bottom:12px;
}

.card p{
    color:var(--muted);
    line-height:1.8;
    font-size:14.5px;
    margin-bottom:20px;
}

.info-grid{
    display:grid;
    gap:10px;
}

.info{
    border:1px solid rgba(255,255,255,.055);
    background:rgba(255,255,255,.03);
    border-radius:18px;
    padding:14px;
    color:var(--muted);
    font-size:13px;
    line-height:1.65;
}

.info strong{
    display:block;
    color:var(--text);
    font-family:var(--heading);
    font-size:14px;
    margin-bottom:4px;
}

.uri{
    word-break:break-all;
    color:#BAE6FD;
}

.footer-note{
    position:fixed;
    bottom:18px;
    left:0;
    right:0;
    text-align:center;
    color:rgba(182,194,211,.55);
    font-size:12px;
}

@media(max-width:940px){
    .shell{
        grid-template-columns:1fr;
        padding-top:96px;
    }

    .copy{
        padding-top:0;
    }
}

@media(max-width:620px){
    .shell{
        width:calc(100% - 32px);
    }

    .brand{
        left:18px;
        top:20px;
    }

    .card{
        padding:26px;
        border-radius:26px;
    }

    h1{
        letter-spacing:-2.8px;
    }

    .actions{
        display:grid;
    }

    .btn{
        width:100%;
    }

    .footer-note{
        display:none;
    }
}
</style>
</head>

<body>
<a href="index.jsp" class="brand">Work<span>Sphere</span></a>

<main class="shell">
    <section class="copy">
        <div class="kicker">
            <i class="fa-solid fa-lock"></i>
            WorkSphere System Notice
        </div>

        <h1>Access denied <em>403</em></h1>

        <p>You do not have permission to open this page. Login with the correct role or return to your dashboard.</p>

        <div class="actions">
            <a href="index.jsp" class="btn primary">
                <i class="fa-solid fa-house"></i>
                Go Home
            </a>

            <a href="javascript:history.back()" class="btn secondary">
                <i class="fa-solid fa-arrow-left"></i>
                Go Back
            </a>

            <a href="clientLogin" class="btn secondary">
                <i class="fa-solid fa-user-tie"></i>
                Client Login
            </a>

            <a href="freelancerLogin" class="btn secondary">
                <i class="fa-solid fa-laptop-code"></i>
                Freelancer Login
            </a>
        </div>
    </section>

    <section class="card">
        <div class="code-badge">403</div>

        <h2>Access Denied</h2>

        <p>This custom WorkSphere error page replaces the default Tomcat screen and keeps the user inside a professional platform experience.</p>

        <div class="info-grid">
            <div class="info">
                <strong>What happened?</strong>
                You do not have permission to open this page. Login with the correct role or return to your dashboard.
            </div>

            <div class="info">
                <strong>Requested path</strong>
                <span class="uri"><%= requestUri == null || requestUri.trim().isEmpty() ? "Not available" : requestUri %></span>
            </div>

            <div class="info">
                <strong>Servlet</strong>
                <%= servletName == null || servletName.trim().isEmpty() ? "Not available" : servletName %>
            </div>

            <div class="info">
                <strong>Exception</strong>
                <%= exceptionMessage == null || exceptionMessage.trim().isEmpty() ? "Not exposed" : exceptionMessage %>
            </div>

            <div class="info">
                <strong>Next step</strong>
                Try going back, return to the landing page, or login again with the correct role.
            </div>
        </div>
    </section>
</main>

<div class="footer-note">WorkSphere Marketplace · Custom Error Handling</div>
</body>
</html>
