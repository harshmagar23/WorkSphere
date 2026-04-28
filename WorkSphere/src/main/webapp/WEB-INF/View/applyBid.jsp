<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.FreelancerModel" %>

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Apply Bid | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;
  --sky:#60A5FA;
  --cyan:#22D3EE;
  --violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,.08);
  --pri-mid:rgba(59,130,246,.18);
  --pri-glow:rgba(59,130,246,.28);
  --cyan-glow:rgba(34,211,238,.18);
  --bg:#07080D;
  --s1:#0B0D14;
  --s2:#10131D;
  --s3:#171B28;
  --t1:#F8FAFC;
  --t2:#B6C2D3;
  --t3:#7D8AA0;
  --t4:#4B5568;
  --border:rgba(255,255,255,.08);
  --border2:rgba(255,255,255,.045);
  --ok:#22C55E;
  --warn:#F59E0B;
  --danger:#EF4444;
  --h:'Outfit',sans-serif;
  --b:'Inter',sans-serif;
  --max:1120px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
  text-rendering:optimizeLegibility;
}
body::before{
  content:"";
  position:fixed;
  inset:0;
  z-index:-4;
  background:
    radial-gradient(circle at 18% 8%,rgba(59,130,246,.22),transparent 33%),
    radial-gradient(circle at 88% 24%,rgba(34,211,238,.13),transparent 31%),
    radial-gradient(circle at 30% 92%,rgba(139,92,246,.12),transparent 35%),
    linear-gradient(180deg,#07080D 0%,#090B12 45%,#07080D 100%);
}
body::after{
  content:"";
  position:fixed;
  inset:0;
  z-index:-3;
  background-image:
    linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);
  background-size:52px 52px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.2),transparent);
  -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.2),transparent);
}
::selection{background:var(--pri);color:white}
a{color:inherit;text-decoration:none}
button,input,textarea{font:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* PROGRESS */
.progress-top{
  position:fixed;
  top:0;
  left:0;
  width:0%;
  height:2px;
  z-index:5000;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  box-shadow:0 0 18px var(--pri-glow);
}

/* NAVBAR */
.ws-nav{
  position:fixed;
  top:0;
  left:0;
  right:0;
  z-index:1000;
  transition:background .35s,box-shadow .35s;
}
.ws-nav.scrolled{
  background:rgba(7,8,13,.80);
  backdrop-filter:blur(18px);
  -webkit-backdrop-filter:blur(18px);
  box-shadow:0 1px 0 var(--border);
}
.nav-inner{
  max-width:var(--max);
  margin:0 auto;
  height:70px;
  padding:0 32px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:24px;
}
.logo{
  font-family:var(--h);
  font-size:20px;
  font-weight:850;
  letter-spacing:-.75px;
  white-space:nowrap;
}
.logo .s{color:var(--pri)}
.nav-links{display:flex;align-items:center;gap:2px}
.nav-links a{
  color:var(--t3);
  font-family:var(--h);
  font-size:13px;
  font-weight:650;
  padding:8px 13px;
  border-radius:999px;
  transition:all .2s;
}
.nav-links a:hover,
.nav-links a.active{
  color:var(--t1);
  background:rgba(255,255,255,.045);
}
.nav-actions{display:flex;align-items:center;gap:8px}
.nav-btn{
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.02);
  border-radius:10px;
  padding:9px 15px;
  font-family:var(--h);
  font-size:13px;
  font-weight:750;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:all .2s;
}
.nav-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05)}
.nav-btn.primary{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  border-color:transparent;
  color:white;
}
.nav-btn.primary:hover{
  transform:translateY(-1px);
  box-shadow:0 14px 34px rgba(59,130,246,.24);
}
.menu-btn{
  display:none;
  border:0;
  background:none;
  color:var(--t2);
  font-size:19px;
  cursor:pointer;
}

/* MOBILE MENU */
.mobile-menu{
  display:none;
  position:fixed;
  inset:0;
  z-index:2000;
  background:rgba(0,0,0,.58);
  backdrop-filter:blur(9px);
  -webkit-backdrop-filter:blur(9px);
  opacity:0;
  visibility:hidden;
  transition:all .25s;
}
.mobile-menu.open{opacity:1;visibility:visible}
.mobile-panel{
  position:absolute;
  top:16px;
  right:16px;
  width:min(310px,calc(100% - 32px));
  background:var(--s2);
  border:1px solid var(--border);
  border-radius:18px;
  padding:22px;
  transform:translateY(10px);
  transition:transform .25s;
}
.mobile-menu.open .mobile-panel{transform:translateY(0)}
.mobile-close{
  border:0;
  background:none;
  color:var(--t3);
  font-size:16px;
  margin-bottom:12px;
}
.mobile-panel a{
  display:block;
  color:var(--t2);
  font-family:var(--h);
  font-size:14px;
  font-weight:650;
  padding:12px 0;
  border-bottom:1px solid var(--border2);
}
.mobile-panel a:hover{color:var(--t1)}

/* PAGE */
.page{
  position:relative;
  padding:118px 0 0;
}
.page::before{
  content:"";
  position:absolute;
  top:54px;
  left:50%;
  transform:translateX(-50%);
  width:900px;
  height:620px;
  background:radial-gradient(circle,rgba(59,130,246,.18),transparent 66%);
  pointer-events:none;
  opacity:.82;
}
.hero{
  position:relative;
  z-index:1;
  padding:26px 0 34px;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.04fr .96fr;
  gap:42px;
  align-items:end;
}
.kicker{
  display:inline-flex;
  align-items:center;
  gap:9px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  border-radius:999px;
  padding:8px 13px;
  margin-bottom:18px;
  color:var(--t2);
  font-size:12px;
  font-weight:750;
  letter-spacing:.02em;
}
.kicker i{color:var(--cyan);font-size:11px}
.hero h1{
  font-family:var(--h);
  font-size:clamp(42px,5.2vw,72px);
  line-height:.96;
  font-weight:850;
  letter-spacing:-2.7px;
  max-width:780px;
  margin-bottom:18px;
}
.hero h1 em{
  font-style:normal;
  font-weight:260;
  color:var(--t3);
}
.hero p{
  color:var(--t2);
  font-size:16px;
  line-height:1.85;
  max-width:690px;
}
.project-summary{
  border:1px solid var(--border);
  border-radius:26px;
  padding:26px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));
  position:relative;
  overflow:hidden;
}
.project-summary::before{
  content:"";
  position:absolute;
  right:-130px;
  top:-130px;
  width:310px;
  height:310px;
  border-radius:50%;
  background:radial-gradient(circle,var(--cyan-glow),transparent 67%);
}
.project-summary>*{position:relative;z-index:1}
.summary-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:18px;
  margin-bottom:20px;
}
.summary-top h3{
  font-family:var(--h);
  font-size:28px;
  line-height:1.08;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:9px;
}
.summary-top p{
  color:var(--t2);
  font-size:14px;
  line-height:1.75;
}
.summary-icon{
  width:58px;
  height:58px;
  border-radius:18px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:20px;
  box-shadow:0 20px 50px rgba(59,130,246,.22);
  flex-shrink:0;
}
.project-desc{
  color:var(--t2);
  font-size:14px;
  line-height:1.85;
  margin-bottom:18px;
}
.meta-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:10px;
}
.meta-box{
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:16px;
  padding:14px;
}
.meta-label{
  color:var(--t4);
  font-size:11px;
  font-weight:850;
  letter-spacing:1px;
  text-transform:uppercase;
  margin-bottom:6px;
}
.meta-value{
  color:var(--t1);
  font-family:var(--h);
  font-weight:800;
  font-size:14px;
}
.proposal-path{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:8px;
  margin-top:18px;
}
.path-step{
  position:relative;
  padding:10px 10px 10px 34px;
  border-radius:13px;
  color:var(--t1);
  border:1px solid var(--pri-mid);
  background:rgba(59,130,246,.065);
  font-family:var(--h);
  font-size:12px;
  font-weight:750;
}
.path-step::before{
  content:"";
  position:absolute;
  left:11px;
  top:50%;
  width:12px;
  height:12px;
  border-radius:50%;
  transform:translateY(-50%);
  background:linear-gradient(135deg,var(--pri),var(--cyan));
}
.path-step.current{
  color:var(--warn);
  border-color:rgba(245,158,11,.22);
  background:rgba(245,158,11,.075);
}
.path-step.current::before{
  background:var(--warn);
  box-shadow:0 0 0 5px rgba(245,158,11,.12);
}

/* FORM SECTION */
.bid-section{
  position:relative;
  z-index:1;
  padding:16px 0 0;
}
.bid-grid{
  display:grid;
  grid-template-columns:1fr 340px;
  gap:28px;
  align-items:start;
}
.form-panel,
.side-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:28px;
  position:relative;
  overflow:hidden;
}
.form-panel{
  padding:30px;
}
.form-panel::before,
.side-card::before{
  content:"";
  position:absolute;
  right:-110px;
  top:-110px;
  width:260px;
  height:260px;
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 67%);
  pointer-events:none;
}
.form-panel>*,
.side-card>*{position:relative;z-index:1}
.form-title{
  font-family:var(--h);
  font-size:clamp(28px,3vw,42px);
  font-weight:850;
  letter-spacing:-1.4px;
  margin-bottom:9px;
}
.form-copy{
  color:var(--t3);
  line-height:1.8;
  font-size:14.5px;
  margin-bottom:24px;
}
.form-group{margin-bottom:24px}
.form-label{
  display:block;
  font-family:var(--h);
  color:var(--t2);
  font-size:13px;
  font-weight:800;
  margin-bottom:10px;
}
.input-wrap{
  position:relative;
}
.input-icon{
  position:absolute;
  left:15px;
  top:50%;
  transform:translateY(-50%);
  color:var(--sky);
  font-size:14px;
}
.form-control{
  width:100%;
  border:1px solid var(--border);
  border-radius:16px;
  background:rgba(255,255,255,.035);
  color:var(--t1);
  padding:14px 16px;
  outline:none;
  transition:all .2s;
}
.input-wrap .form-control{
  padding-left:42px;
}
textarea.form-control{
  min-height:190px;
  resize:vertical;
  line-height:1.75;
}
.form-control:focus{
  border-color:var(--pri-mid);
  box-shadow:0 0 0 4px var(--pri-soft);
  background:rgba(255,255,255,.05);
}
.form-control::placeholder{color:var(--t4)}
.form-help{
  margin-top:10px;
  display:flex;
  justify-content:space-between;
  gap:14px;
  flex-wrap:wrap;
  color:var(--t4);
  font-size:12px;
}
.char-count.good{color:var(--ok)}
.char-count.warn{color:var(--warn)}
.quick-amounts{
  display:flex;
  gap:8px;
  flex-wrap:wrap;
  margin-top:12px;
}
.amount-chip{
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
  color:var(--t2);
  border-radius:999px;
  padding:7px 11px;
  cursor:pointer;
  font-family:var(--h);
  font-size:12px;
  font-weight:750;
  transition:all .2s;
}
.amount-chip:hover{
  border-color:var(--pri-mid);
  color:white;
  background:rgba(59,130,246,.08);
}
.action-row{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-top:24px;
}
.btn-main,
.btn-back{
  min-height:46px;
  border-radius:12px;
  padding:0 18px;
  font-family:var(--h);
  font-size:14px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:9px;
  transition:all .2s;
}
.btn-main{
  border:0;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
}
.btn-main:hover{
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.28);
}
.btn-back{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.btn-back:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.05);
  transform:translateY(-2px);
}

/* SIDE */
.side-panel{
  position:sticky;
  top:92px;
  display:grid;
  gap:16px;
}
.side-card{
  padding:22px;
}
.side-title{
  font-family:var(--h);
  font-size:18px;
  font-weight:850;
  letter-spacing:-.5px;
  margin-bottom:12px;
}
.side-copy{
  color:var(--t3);
  font-size:13px;
  line-height:1.75;
  margin-bottom:16px;
}
.preview-amount{
  font-family:var(--h);
  font-size:32px;
  font-weight:900;
  letter-spacing:-1px;
  color:var(--sky);
  margin-bottom:12px;
}
.preview-text{
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:16px;
  padding:15px;
  min-height:140px;
  color:var(--t2);
  font-size:13px;
  line-height:1.75;
  white-space:pre-line;
}
.preview-text.empty{color:var(--t4)}
.check-list{
  display:grid;
  gap:11px;
}
.check-item{
  display:flex;
  gap:10px;
  color:var(--t2);
  font-size:13px;
  line-height:1.55;
}
.check-icon{
  width:20px;
  height:20px;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
  border:1px solid var(--border);
  color:var(--t4);
  flex-shrink:0;
  margin-top:1px;
  font-size:10px;
}
.check-item.done{color:var(--t1)}
.check-item.done .check-icon{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  border-color:transparent;
}
.quality-meter{
  height:9px;
  border-radius:999px;
  background:rgba(255,255,255,.07);
  overflow:hidden;
  margin:12px 0 10px;
}
.quality-fill{
  height:100%;
  width:0%;
  border-radius:999px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  transition:width .35s cubic-bezier(.16,1,.3,1);
}
.quality-text{
  color:var(--t3);
  font-size:12px;
  line-height:1.6;
}

/* FOOTER */
.ws-footer{
  margin-top:84px;
  border-top:1px solid var(--border);
  background:rgba(255,255,255,.012);
}
.footer-grid{
  max-width:var(--max);
  margin:0 auto;
  padding:34px 32px;
  display:grid;
  grid-template-columns:1fr auto 1fr;
  gap:24px;
  align-items:center;
}
.footer-brand{
  font-family:var(--h);
  font-size:18px;
  font-weight:850;
  letter-spacing:-.5px;
}
.footer-brand .s{color:var(--pri)}
.footer-links{
  display:flex;
  gap:18px;
  justify-content:center;
  flex-wrap:wrap;
}
.footer-links a{
  color:var(--t3);
  font-size:12.5px;
  font-weight:650;
  transition:color .2s;
}
.footer-links a:hover{color:var(--t1)}
.footer-note{
  text-align:right;
  color:var(--t4);
  font-size:12px;
}

/* ANIMATION */
.reveal{
  opacity:0;
  transform:translateY(24px);
  transition:opacity .75s cubic-bezier(.16,1,.3,1), transform .75s cubic-bezier(.16,1,.3,1);
}
.reveal.show{opacity:1;transform:translateY(0)}
.zoom-reveal{
  opacity:0;
  transform:translateY(24px) scale(.97);
  transition:opacity .75s cubic-bezier(.16,1,.3,1), transform .75s cubic-bezier(.16,1,.3,1);
}
.zoom-reveal.show{opacity:1;transform:translateY(0) scale(1)}
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}

@media(max-width:1080px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
  .hero-grid,.bid-grid{grid-template-columns:1fr}
  .project-summary{max-width:760px}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.9px}
  .meta-grid,.proposal-path,.side-panel{grid-template-columns:1fr}
  .form-panel{padding:22px}
  .btn-main,.btn-back{width:100%;justify-content:center}
  .footer-grid{grid-template-columns:1fr;text-align:center}
  .footer-note{text-align:center}
}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<%
FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");
if(freelancer == null){
    response.sendRedirect("freelancerLogin");
    return;
}

ProjectModel project = (ProjectModel) request.getAttribute("project");
%>

<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="freelancerDashboard" class="logo">Work<span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="freelancerDashboard">Dashboard</a>
      <a href="viewAllProjects" class="active">Explore</a>
      <a href="myProposals">Proposals</a>
      <a href="freelancerAssignedProjects">Assigned</a>
      <a href="viewFreelancerProfile">Profile</a>
      <a href="freelancerReviews">Reviews</a>
    </div>

    <div class="nav-actions">
      <a href="viewAllProjects" class="nav-btn"><i class="fa-solid fa-arrow-left"></i> Explore</a>
      <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
      <button class="menu-btn" id="menuBtn" type="button"><i class="fa-solid fa-bars"></i></button>
    </div>
  </div>
</nav>

<div class="mobile-menu" id="mobileMenu">
  <div class="mobile-panel">
    <button class="mobile-close" id="mobileClose" type="button"><i class="fa-solid fa-xmark"></i></button>
    <a href="freelancerDashboard">Dashboard</a>
    <a href="viewAllProjects">Explore Projects</a>
    <a href="myProposals">My Proposals</a>
    <a href="freelancerAssignedProjects">Assigned Projects</a>
    <a href="viewFreelancerProfile">My Profile</a>
    <a href="freelancerReviews">Reviews</a>
    <a href="freelancerNotifications">Notifications</a>
    <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap">
      <div class="hero-grid">
        <div class="hero-copy reveal">
          <div class="kicker"><i class="fa-solid fa-paper-plane"></i> Freelancer proposal studio</div>
          <h1>Write a focused <em>bid proposal</em>.</h1>
          <p>
            Send a clear price and proposal message for this client project. Keep your bid professional, specific, and easy for the client to trust.
          </p>
        </div>

        <aside class="project-summary zoom-reveal d1">
          <div class="summary-top">
            <div>
              <h3><%= safe(project.getTitle()) %></h3>
              <p>Review the project details before submitting your bid.</p>
            </div>
            <div class="summary-icon"><i class="fa-solid fa-briefcase"></i></div>
          </div>

          <div class="project-desc"><%= safe(project.getDescription()) %></div>

          <div class="meta-grid">
            <div class="meta-box">
              <div class="meta-label">Budget</div>
              <div class="meta-value">₹<%= safe(project.getBudget()) %></div>
            </div>
            <div class="meta-box">
              <div class="meta-label">Deadline</div>
              <div class="meta-value"><%= safe(project.getDeadline()) %></div>
            </div>
          </div>

          <div class="proposal-path">
            <div class="path-step">Review Brief</div>
            <div class="path-step current">Prepare Bid</div>
            <div class="path-step">Submit</div>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <section class="bid-section">
    <div class="wrap bid-grid">
      <section class="form-panel reveal">
        <h2 class="form-title">Submit your proposal</h2>
        <p class="form-copy">
          Add your bid amount and a proposal message explaining why you are the right freelancer for this project.
        </p>

        <form action="saveBid" method="post" id="bidForm">
          <input type="hidden" name="projectId" value="<%= project.getId() %>">

          <div class="form-group">
            <label class="form-label">Your Bid Amount</label>
            <div class="input-wrap">
              <i class="fa-solid fa-indian-rupee-sign input-icon"></i>
              <input type="number" name="bidAmount" id="bidAmount" class="form-control"
                     placeholder="Enter your bid amount" required>
            </div>

            <div class="quick-amounts">
              <button type="button" class="amount-chip" data-value="<%= project.getBudget() %>">Use project budget</button>
              <button type="button" class="amount-chip" data-value="">Custom amount</button>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">Proposal Message</label>
            <textarea name="proposalText" id="proposalText" class="form-control"
                      placeholder="Example: I understand your requirement and can complete this project with a clean, reliable solution. I have experience in similar work and can deliver within the deadline." required></textarea>

            <div class="form-help">
              <span>Explain fit, approach, delivery timeline, and confidence.</span>
              <span class="char-count" id="charCount">0 characters</span>
            </div>
          </div>

          <div class="action-row">
            <button type="submit" class="btn-main">
              <i class="fa-solid fa-paper-plane"></i> Submit Bid
            </button>

            <a href="viewAllProjects" class="btn-back">
              <i class="fa-solid fa-arrow-left"></i> Back
            </a>
          </div>
        </form>
      </section>

      <aside class="side-panel">
        <div class="side-card zoom-reveal d1">
          <h3 class="side-title">Live proposal preview</h3>
          <p class="side-copy">Check how your bid will feel before submitting.</p>
          <div class="preview-amount" id="previewAmount">₹0</div>
          <div class="preview-text empty" id="proposalPreview">Your proposal message preview will appear here.</div>
        </div>

        <div class="side-card zoom-reveal d2">
          <h3 class="side-title">Proposal checklist</h3>
          <div class="check-list">
            <div class="check-item" id="checkAmount">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Bid amount entered.</span>
            </div>
            <div class="check-item" id="checkLength">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Proposal has enough detail.</span>
            </div>
            <div class="check-item" id="checkFit">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Mentions experience, approach, delivery, or deadline.</span>
            </div>
          </div>
        </div>

        <div class="side-card zoom-reveal d3">
          <h3 class="side-title">Proposal strength</h3>
          <p class="side-copy">A clear proposal improves your chance of being selected.</p>
          <div class="quality-meter"><div class="quality-fill" id="qualityFill"></div></div>
          <div class="quality-text" id="qualityText">Start writing your proposal.</div>
        </div>
      </aside>
    </div>
  </section>

  <footer class="ws-footer">
    <div class="footer-grid">
      <div class="footer-brand">Work<span class="s">Sphere</span></div>
      <div class="footer-links">
        <a href="freelancerDashboard">Dashboard</a>
        <a href="viewAllProjects">Explore</a>
        <a href="myProposals">Proposals</a>
        <a href="freelancerAssignedProjects">Assigned</a>
      </div>
      <div class="footer-note">Apply Bid • WorkSphere</div>
    </div>
  </footer>
</main>

<script>
(function(){
  const navbar = document.getElementById("navbar");
  const progressTop = document.getElementById("progressTop");

  function onScroll(){
    const scrolled = window.scrollY || document.documentElement.scrollTop;
    const height = document.documentElement.scrollHeight - window.innerHeight;
    if(progressTop){
      progressTop.style.width = (height > 0 ? (scrolled / height) * 100 : 0) + "%";
    }
    if(navbar){
      navbar.classList.toggle("scrolled", scrolled > 20);
    }
  }
  window.addEventListener("scroll", onScroll, {passive:true});
  onScroll();

  const menu = document.getElementById("mobileMenu");
  const menuBtn = document.getElementById("menuBtn");
  const closeBtn = document.getElementById("mobileClose");

  if(menuBtn){
    menuBtn.addEventListener("click", function(){
      menu.classList.add("open");
      document.body.style.overflow = "hidden";
    });
  }

  function closeMenu(){
    if(menu){
      menu.classList.remove("open");
      document.body.style.overflow = "";
    }
  }

  if(closeBtn) closeBtn.addEventListener("click", closeMenu);
  if(menu) menu.addEventListener("click", function(e){ if(e.target === menu) closeMenu(); });
  document.querySelectorAll(".mobile-panel a").forEach(function(a){ a.addEventListener("click", closeMenu); });

  const revealObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        entry.target.classList.add("show");
        revealObserver.unobserve(entry.target);
      }
    });
  }, {threshold:.08, rootMargin:"0px 0px -30px 0px"});

  document.querySelectorAll(".reveal,.zoom-reveal").forEach(function(el){
    revealObserver.observe(el);
  });

  const bidAmount = document.getElementById("bidAmount");
  const proposalText = document.getElementById("proposalText");
  const previewAmount = document.getElementById("previewAmount");
  const proposalPreview = document.getElementById("proposalPreview");
  const charCount = document.getElementById("charCount");
  const checkAmount = document.getElementById("checkAmount");
  const checkLength = document.getElementById("checkLength");
  const checkFit = document.getElementById("checkFit");
  const qualityFill = document.getElementById("qualityFill");
  const qualityText = document.getElementById("qualityText");

  function includesAny(text, words){
    return words.some(function(word){ return text.indexOf(word) !== -1; });
  }

  function updateProposalUI(){
    const amount = bidAmount.value.trim();
    const text = proposalText.value.trim();
    const lower = text.toLowerCase();

    const amountOk = amount !== "" && Number(amount) > 0;
    const lengthOk = text.length >= 70;
    const fitOk = includesAny(lower, ["experience","approach","deliver","delivery","deadline","timeline","complete","requirement","work","project"]);

    previewAmount.textContent = amountOk ? "₹" + amount : "₹0";
    proposalPreview.textContent = text || "Your proposal message preview will appear here.";
    proposalPreview.classList.toggle("empty", !text);

    charCount.textContent = text.length + " characters";
    charCount.classList.toggle("good", text.length >= 100);
    charCount.classList.toggle("warn", text.length > 0 && text.length < 70);

    checkAmount.classList.toggle("done", amountOk);
    checkLength.classList.toggle("done", lengthOk);
    checkFit.classList.toggle("done", fitOk);

    let score = 0;
    if(amountOk) score += 30;
    if(lengthOk) score += 35;
    if(fitOk) score += 35;

    qualityFill.style.width = score + "%";

    if(score === 0){
      qualityText.textContent = "Start writing your proposal.";
    }else if(score < 50){
      qualityText.textContent = "Add more detail so the client understands your proposal.";
    }else if(score < 100){
      qualityText.textContent = "Good. Add delivery approach or timeline for a stronger bid.";
    }else{
      qualityText.textContent = "Excellent. Your proposal is clear and client-ready.";
    }
  }

  document.querySelectorAll(".amount-chip").forEach(function(chip){
    chip.addEventListener("click", function(){
      const value = chip.getAttribute("data-value");
      if(value){
        bidAmount.value = String(value).replace(/[^0-9]/g, "");
      }else{
        bidAmount.focus();
      }
      updateProposalUI();
    });
  });

  if(bidAmount) bidAmount.addEventListener("input", updateProposalUI);
  if(proposalText) proposalText.addEventListener("input", updateProposalUI);
  updateProposalUI();
})();
</script>

</body>
</html>
