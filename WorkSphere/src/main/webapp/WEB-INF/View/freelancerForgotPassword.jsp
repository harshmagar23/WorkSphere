<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
private String safe(Object value){
    if(value == null) return "";
    return String.valueOf(value)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}
%>

<%
String error = safe(request.getAttribute("error"));
String msg = safe(request.getAttribute("msg"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Freelancer Forgot Password | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/worksphere-auth-ui.css">
</head>

<body>
<div class="auth-shell">

  <section class="brand-panel">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
      <span class="logo-mark"><i class="fa-solid fa-briefcase"></i></span>
      <span>Work</span><span>Sphere</span>
    </a>

    <div class="hero-copy">
      <div class="kicker"><i class="fa-solid fa-laptop-code"></i> Freelancer Recovery</div>
      <h1>Secure access for <em>serious work.</em></h1>
      <p>Recover your account without leaving the WorkSphere experience. Your projects, bids, chats, submissions, and reviews stay protected while you get back in.</p>
    </div>

    <div class="trust-row">
      <div class="trust-item">
        <i class="fa-solid fa-shield-halved"></i>
        <strong>Protected flow</strong>
        <span>Reset screens are separated by role and session state.</span>
      </div>
      <div class="trust-item">
        <i class="fa-solid fa-layer-group"></i>
        <strong>Same platform UI</strong>
        <span>No old-theme interruption during account recovery.</span>
      </div>
      <div class="trust-item">
        <i class="fa-solid fa-arrow-right-to-bracket"></i>
        <strong>Fast return</strong>
        <span>Reset and continue to explore projects and manage proposals.</span>
      </div>
    </div>
  </section>

  <section class="form-panel">
    <div class="form-card">
      <div class="form-content">
        <div class="role-pill"><i class="fa-solid fa-laptop-code"></i> Freelancer Recovery</div>

        <h2>Recover your account.</h2>
        <p class="sub">Enter your registered freelancer email. If it exists, we will open the secure reset screen.</p>

        <% if(error != null && error.trim().length() > 0){ %>
          <div class="alert-x error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <div><%= error %></div>
          </div>
        <% } %>

        <% if(msg != null && msg.trim().length() > 0){ %>
          <div class="alert-x success">
            <i class="fa-solid fa-circle-check"></i>
            <div><%= msg %></div>
          </div>
        <% } %>

        <form action="freelancerCheckEmail" method="post">
          
          <div class="input-group-x">
            <div class="input-label">
              <label for="email">Registered email</label>
              <small>Required</small>
            </div>
            <div class="input-wrap">
              <i class="fa-regular fa-envelope"></i>
              <input type="email" id="email" name="email" class="form-control-x" placeholder="name@example.com" required autocomplete="email">
            </div>
            <div class="help">Use the same email you used during freelancer registration.</div>
          </div>
        
          <button type="submit" class="btn-main-x">
            <i class="fa-solid fa-arrow-right"></i>
            Continue to Reset
          </button>
        </form>

        <div class="link-row">
          <span>Remember your password?</span><a href="freelancerLogin">Back to login</a>
          <a href="freelancerRegister">Create new account</a>
        </div>

        <div class="security-note">
          <i class="fa-solid fa-circle-info"></i>
          <div>For real deployment, use a strong password and avoid sharing account access. Email delivery can be configured with Gmail App Password later.</div>
        </div>
      </div>
    </div>
  </section>
</div>

</body>
</html>
