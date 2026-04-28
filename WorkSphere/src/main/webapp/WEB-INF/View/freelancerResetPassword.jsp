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
<title>Freelancer Reset Password | WorkSphere</title>

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
      <div class="kicker"><i class="fa-solid fa-laptop-code"></i> Freelancer Password Reset</div>
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
        <div class="role-pill"><i class="fa-solid fa-laptop-code"></i> Freelancer Password Reset</div>

        <h2>Create a new password.</h2>
        <p class="sub">Set a fresh password for your WorkSphere account. Use at least 6 characters.</p>

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

        <form action="freelancerResetPassword" method="post" id="resetForm">
          
          <div class="input-group-x">
            <div class="input-label">
              <label for="password">New password</label>
              <small>Minimum 6 characters</small>
            </div>
            <div class="input-wrap">
              <i class="fa-solid fa-lock"></i>
              <input type="password" id="password" name="password" class="form-control-x password" placeholder="Enter new password" minlength="6" required autocomplete="new-password">
              <i class="fa-regular fa-eye toggle-pass" id="togglePass" title="Show password"></i>
            </div>
            <div class="help">Use a password that is difficult to guess and different from your old password.</div>
          </div>

          <div class="input-group-x">
            <div class="input-label">
              <label for="confirmPassword">Confirm password</label>
              <small>Must match</small>
            </div>
            <div class="input-wrap">
              <i class="fa-solid fa-shield-halved"></i>
              <input type="password" id="confirmPassword" class="form-control-x password" placeholder="Confirm new password" minlength="6" required autocomplete="new-password">
            </div>
            <div class="help" id="matchHelp">Both passwords must match before updating.</div>
          </div>
        
          <button type="submit" class="btn-main-x">
            <i class="fa-solid fa-arrow-right"></i>
            Update Password
          </button>
        </form>

        <div class="link-row">
          <span>Reset complete?</span><a href="freelancerLogin">Go to login</a>
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

<script>
(function(){
  const pass=document.getElementById('password');
  const confirm=document.getElementById('confirmPassword');
  const help=document.getElementById('matchHelp');
  const form=document.getElementById('resetForm');
  const toggle=document.getElementById('togglePass');

  function check(){
    if(!pass || !confirm || !help) return true;
    if(confirm.value.length===0){
      help.textContent='Both passwords must match before updating.';
      help.style.color='';
      return true;
    }
    if(pass.value===confirm.value){
      help.textContent='Passwords match.';
      help.style.color='#86EFAC';
      return true;
    }
    help.textContent='Passwords do not match.';
    help.style.color='#FCA5A5';
    return false;
  }

  if(pass) pass.addEventListener('input',check);
  if(confirm) confirm.addEventListener('input',check);

  if(form){
    form.addEventListener('submit',function(e){
      if(!check()){
        e.preventDefault();
        confirm.focus();
      }
    });
  }

  if(toggle && pass){
    toggle.addEventListener('click',function(){
      const isHidden=pass.type==='password';
      pass.type=isHidden?'text':'password';
      if(confirm) confirm.type=isHidden?'text':'password';
      toggle.className=isHidden?'fa-regular fa-eye-slash toggle-pass':'fa-regular fa-eye toggle-pass';
    });
  }
})();
</script>

</body>
</html>
