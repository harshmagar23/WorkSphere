<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.ClientModel" %>

<%!
private String safe(Object value){
    if(value == null) return "";
    return String.valueOf(value)
        .replace("&","&amp;")
        .replace("<","&lt;")
        .replace(">","&gt;")
        .replace("\"","&quot;")
        .replace("'","&#39;");
}

private String fallback(Object value, String fallback){
    String v = safe(value);
    return v.trim().isEmpty() ? fallback : v;
}

private boolean has(Object value){
    return value != null && String.valueOf(value).trim().length() > 0;
}
%>

<%
ClientModel client = (ClientModel) request.getAttribute("client");
if(client == null){
    client = (ClientModel) session.getAttribute("clientSession");
}

if(client == null){
    response.sendRedirect("clientLogin");
    return;
}

String firstLetter = "C";
if(client.getName() != null && client.getName().trim().length() > 0){
    firstLetter = client.getName().trim().substring(0,1).toUpperCase();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Profile | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--sky:#60A5FA;--cyan:#22D3EE;--violet:#8B5CF6;
  --bg:#07080D;--s1:#0B0D14;--s2:#10131D;--s3:#171B28;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--t4:#4B5568;
  --border:rgba(255,255,255,.08);--border2:rgba(255,255,255,.045);
  --ok:#22C55E;--warn:#F59E0B;--h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1180px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
}
body::before{
  content:"";
  position:fixed;
  inset:0;
  z-index:-4;
  background:
    radial-gradient(circle at 18% 8%,rgba(59,130,246,.23),transparent 34%),
    radial-gradient(circle at 86% 24%,rgba(34,211,238,.13),transparent 32%),
    radial-gradient(circle at 38% 92%,rgba(139,92,246,.11),transparent 34%),
    linear-gradient(180deg,#07080D 0%,#090B12 48%,#07080D 100%);
}
body::after{
  content:"";
  position:fixed;
  inset:0;
  z-index:-3;
  background-image:
    linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);
  background-size:56px 56px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.84),rgba(0,0,0,.22),transparent);
  -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.84),rgba(0,0,0,.22),transparent);
}
a{color:inherit;text-decoration:none}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
.nav{
  position:fixed;top:0;left:0;right:0;z-index:1000;background:rgba(7,8,13,.78);
  backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);border-bottom:1px solid var(--border);
}
.nav-in{max-width:var(--max);height:70px;margin:0 auto;padding:0 32px;display:flex;align-items:center;justify-content:space-between;gap:22px}
.logo{font-family:var(--h);font-size:20px;font-weight:900;letter-spacing:-.8px}
.logo span:last-child{color:var(--pri)}
.nav-links,.nav-actions{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.nav-a,.btn-main,.btn-ghost{
  min-height:40px;border-radius:12px;padding:0 15px;display:inline-flex;align-items:center;justify-content:center;gap:8px;
  font-family:var(--h);font-size:13px;font-weight:850;border:1px solid var(--border);background:rgba(255,255,255,.03);color:var(--t2);transition:.2s;
}
.nav-a:hover,.btn-ghost:hover{color:white;background:rgba(255,255,255,.065);transform:translateY(-1px)}
.nav-a.active{color:white;background:rgba(59,130,246,.12);border-color:rgba(59,130,246,.22)}
.btn-main{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.btn-main:hover{color:white;transform:translateY(-2px);box-shadow:0 18px 44px rgba(59,130,246,.24)}
.page{padding:116px 0 70px}
.hero{
  display:grid;grid-template-columns:.92fr 1.08fr;gap:28px;align-items:stretch;margin-bottom:28px;
}
.identity,.profile-card,.info-card,.quick-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.88),rgba(8,11,18,.78));
  border-radius:30px;
  padding:30px;
  position:relative;
  overflow:hidden;
  box-shadow:0 30px 80px rgba(0,0,0,.24);
}
.identity::before,.profile-card::before{
  content:"";position:absolute;right:-140px;top:-150px;width:340px;height:340px;border-radius:50%;
  background:radial-gradient(circle,rgba(59,130,246,.16),transparent 66%);
}
.identity>* , .profile-card>*{position:relative}
.avatar{
  width:118px;height:118px;border-radius:34px;background:linear-gradient(135deg,var(--pri),var(--cyan));display:flex;align-items:center;justify-content:center;
  font-family:var(--h);font-size:52px;font-weight:900;color:white;box-shadow:0 30px 70px rgba(59,130,246,.24);margin-bottom:22px;
}
.kicker{
  display:inline-flex;gap:8px;align-items:center;border:1px solid rgba(34,211,238,.22);background:rgba(34,211,238,.08);color:#BAE6FD;
  border-radius:999px;padding:8px 13px;font-size:11px;font-weight:900;letter-spacing:1px;text-transform:uppercase;margin-bottom:16px;
}
h1{font-family:var(--h);font-size:clamp(42px,5vw,72px);line-height:.94;letter-spacing:-2.7px;font-weight:900;margin-bottom:14px}
h1 em{font-style:normal;color:var(--t3);font-weight:300}
.identity p,.profile-card p{color:var(--t2);line-height:1.85;font-size:14.5px}
.actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:22px}
.profile-card h2{font-family:var(--h);font-size:34px;letter-spacing:-1px;margin-bottom:10px}
.meta-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-top:24px}
.meta{
  border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:18px;padding:16px;
}
.meta i{color:var(--cyan);margin-bottom:10px}
.meta span{display:block;color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:.8px;font-weight:900;margin-bottom:6px}
.meta strong{display:block;font-family:var(--h);font-size:16px;line-height:1.4;word-break:break-word}
.grid{display:grid;grid-template-columns:1.2fr .8fr;gap:22px}
.info-card h3,.quick-card h3{font-family:var(--h);font-size:26px;letter-spacing:-.8px;margin-bottom:14px}
.bio-box{color:var(--t2);line-height:1.9;border:1px solid var(--border2);background:rgba(255,255,255,.03);border-radius:18px;padding:18px;min-height:124px}
.detail-list{display:grid;gap:12px;margin-top:18px}
.detail{
  display:grid;grid-template-columns:190px 1fr;gap:14px;border-bottom:1px solid var(--border2);padding:0 0 12px;
}
.detail span{color:var(--t3);font-size:13px;font-weight:800}
.detail strong{font-size:14px;color:var(--t1);word-break:break-word}
.quick-list{display:grid;gap:10px}
.quick-list a{
  min-height:48px;border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:15px;padding:0 14px;
  display:flex;align-items:center;justify-content:space-between;color:var(--t2);font-family:var(--h);font-size:13px;font-weight:800;transition:.2s;
}
.quick-list a:hover{color:white;border-color:rgba(59,130,246,.22);background:rgba(59,130,246,.08);transform:translateY(-1px)}
.quick-list i{color:var(--cyan)}
@media(max-width:980px){.hero,.grid{grid-template-columns:1fr}.nav-links{display:none}.meta-grid{grid-template-columns:1fr 1fr}}
@media(max-width:640px){.wrap,.nav-in{padding:0 20px}.identity,.profile-card,.info-card,.quick-card{padding:24px;border-radius:24px}.meta-grid,.detail{grid-template-columns:1fr}.actions{display:grid}.btn-main,.btn-ghost{width:100%}.nav-actions .btn-ghost{display:none}}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<nav class="nav">
  <div class="nav-in">
    <a href="clientDashboard" class="logo"><span>Work</span><span>Sphere</span></a>
    <div class="nav-links">
      <a href="clientDashboard" class="nav-a">Dashboard</a>
      <a href="postProjectPage" class="nav-a">Post Project</a>
      <a href="viewMyProjects" class="nav-a">My Projects</a>
      <a href="clientPayments" class="nav-a">Payments</a>
      <a href="clientProfile" class="nav-a active">Profile</a>
    </div>
    <div class="nav-actions">
      <a href="editClientProfile" class="btn-main"><i class="fa-solid fa-pen-to-square"></i> Edit Profile</a>
      <a href="clientDashboard" class="btn-ghost"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
    </div>
  </div>
</nav>

<main class="page">
  <div class="wrap">
    <section class="hero">
      <aside class="identity">
        <div class="avatar"><%= firstLetter %></div>
        <div class="kicker"><i class="fa-solid fa-user-tie"></i> Client Profile</div>
        <h1><%= safe(client.getName()) %> <em>workspace.</em></h1>
        <p>This profile represents the client side of WorkSphere. A complete client profile improves trust, bid quality, and communication clarity for freelancers.</p>
        <div class="actions">
          <a href="editClientProfile" class="btn-main"><i class="fa-solid fa-pen-to-square"></i> Edit Profile</a>
          <a href="postProjectPage" class="btn-ghost"><i class="fa-solid fa-plus"></i> Post Project</a>
        </div>
      </aside>

      <section class="profile-card">
        <h2>Account overview</h2>
        <p><%= fallback(client.getBio(), "No client bio added yet. Add a short description about your company, project style, and what freelancers should know before working with you.") %></p>

        <div class="meta-grid">
          <div class="meta"><i class="fa-solid fa-envelope"></i><span>Email</span><strong><%= fallback(client.getEmail(), "Not set") %></strong></div>
          <div class="meta"><i class="fa-solid fa-phone"></i><span>Mobile</span><strong><%= fallback(client.getMobile(), "Not set") %></strong></div>
          <div class="meta"><i class="fa-solid fa-building"></i><span>Company</span><strong><%= fallback(client.getCompany(), "Not set") %></strong></div>
          <div class="meta"><i class="fa-solid fa-briefcase"></i><span>Industry</span><strong><%= fallback(client.getIndustry(), "Not set") %></strong></div>
          <div class="meta"><i class="fa-solid fa-globe"></i><span>Website</span><strong><%= fallback(client.getWebsite(), "Not set") %></strong></div>
          <div class="meta"><i class="fa-solid fa-clock-rotate-left"></i><span>Updated</span><strong><%= fallback(client.getUpdatedAt(), "Not updated yet") %></strong></div>
        </div>
      </section>
    </section>

    <section class="grid">
      <div class="info-card">
        <h3>Client information</h3>
        <div class="bio-box"><%= fallback(client.getBio(), "Add your client/company description from the edit profile page.") %></div>

        <div class="detail-list">
          <div class="detail"><span>Full name</span><strong><%= fallback(client.getName(), "Not set") %></strong></div>
          <div class="detail"><span>Company</span><strong><%= fallback(client.getCompany(), "Not set") %></strong></div>
          <div class="detail"><span>Industry</span><strong><%= fallback(client.getIndustry(), "Not set") %></strong></div>
          <div class="detail"><span>Website</span><strong><%= fallback(client.getWebsite(), "Not set") %></strong></div>
          <div class="detail"><span>Address</span><strong><%= fallback(client.getAddress(), "Not set") %></strong></div>
          <div class="detail"><span>City / State</span><strong><%= fallback(client.getCity(), "Not set") %> / <%= fallback(client.getState(), "Not set") %></strong></div>
          <div class="detail"><span>Country / Zipcode</span><strong><%= fallback(client.getCountry(), "Not set") %> / <%= fallback(client.getZipcode(), "Not set") %></strong></div>
        </div>
      </div>

      <aside class="quick-card">
        <h3>Quick actions</h3>
        <div class="quick-list">
          <a href="editClientProfile"><span>Edit client profile</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="postProjectPage"><span>Post new project</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="viewMyProjects"><span>Manage projects</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="clientPayments"><span>Payment center</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="clientNotifications"><span>Notifications</span><i class="fa-solid fa-arrow-right"></i></a>
        </div>
      </aside>
    </section>
  </div>
</main>
</body>
</html>
