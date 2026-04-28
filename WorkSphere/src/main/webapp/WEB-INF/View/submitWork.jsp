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
<title>Submit Work | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--pri-h:#2563EB;--sky:#60A5FA;--cyan:#22D3EE;--violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,0.08);--pri-mid:rgba(59,130,246,0.18);
  --pri-glow:rgba(59,130,246,0.28);--cyan-glow:rgba(34,211,238,0.18);
  --bg:#07080D;--s1:#0B0D14;--s2:#10131D;--s3:#171B28;--s4:#1D2435;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--t4:#4B5568;--t5:#263043;
  --border:rgba(255,255,255,0.08);--border2:rgba(255,255,255,0.045);
  --ok:#22C55E;--warn:#F59E0B;--danger:#EF4444;
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1200px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
  text-rendering:optimizeLegibility;
  font-feature-settings:'kern' 1,'liga' 1,'calt' 1;
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
::selection{background:var(--pri);color:#fff}
a{color:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
.progress-top{
  position:fixed;
  top:0;
  left:0;
  height:2px;
  width:0%;
  z-index:5000;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  box-shadow:0 0 18px var(--pri-glow);
}

/* ===== NAVBAR ===== */
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
  text-decoration:none;
  white-space:nowrap;
}
.logo .s{color:var(--pri)}
.nav-links{
  display:flex;
  align-items:center;
  gap:2px;
}
.nav-links a{
  text-decoration:none;
  color:var(--t3);
  font-family:var(--h);
  font-size:13px;
  font-weight:600;
  padding:8px 13px;
  border-radius:999px;
  transition:all .2s;
}
.nav-links a:hover,
.nav-links a.active{
  color:var(--t1);
  background:rgba(255,255,255,.045);
}
.nav-actions{
  display:flex;
  align-items:center;
  gap:8px;
}
.nav-btn{
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.02);
  border-radius:10px;
  padding:9px 15px;
  font-family:var(--h);
  font-size:13px;
  font-weight:700;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:all .2s;
}
.nav-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05)}
.nav-btn.primary{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  border-color:transparent;
  color:#fff;
}
.nav-btn.primary:hover{
  transform:translateY(-1px);
  box-shadow:0 14px 34px rgba(59,130,246,.24);
}
.menu-btn{
  display:none;
  background:none;
  border:0;
  color:var(--t2);
  font-size:19px;
  cursor:pointer;
}

/* ===== MOBILE MENU ===== */
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
  text-decoration:none;
  color:var(--t2);
  font-family:var(--h);
  font-size:14px;
  font-weight:650;
  padding:12px 0;
  border-bottom:1px solid var(--border2);
}
.mobile-panel a:hover{color:var(--t1)}
.mobile-panel .nav-btn{
  justify-content:center;
  margin-top:10px;
  border-bottom:0;
  padding:10px 14px;
}

/* ===== PAGE ===== */
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
  width:920px;
  height:620px;
  background:radial-gradient(circle,rgba(59,130,246,.18),transparent 66%);
  pointer-events:none;
  opacity:.82;
}
.hero{
  position:relative;
  z-index:1;
  padding:26px 0 28px;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.04fr .96fr;
  gap:46px;
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
  font-size:clamp(40px,5vw,68px);
  line-height:.98;
  font-weight:850;
  letter-spacing:-2.5px;
  max-width:740px;
  margin-bottom:18px;
}
.hero h1 em{
  font-style:normal;
  font-weight:260;
  color:var(--t3);
  letter-spacing:-1.5px;
}
.hero p{
  color:var(--t2);
  font-size:16px;
  line-height:1.85;
  max-width:680px;
  margin-bottom:24px;
}
.hero-actions{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
}
.action-main,
.action-ghost{
  border-radius:12px;
  padding:12px 20px;
  text-decoration:none;
  font-family:var(--h);
  font-size:14px;
  font-weight:800;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:all .2s;
}
.action-main{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:#fff;
  border:0;
}
.action-main:hover{
  color:#fff;
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.28);
}
.action-ghost{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.action-ghost:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.05);
  transform:translateY(-2px);
}

/* ===== PROJECT SNAPSHOT ===== */
.project-snapshot{
  border:1px solid var(--border);
  border-radius:26px;
  padding:26px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));
  position:relative;
  overflow:hidden;
}
.project-snapshot::before{
  content:"";
  position:absolute;
  right:-130px;
  top:-130px;
  width:310px;
  height:310px;
  border-radius:50%;
  background:radial-gradient(circle,var(--cyan-glow),transparent 67%);
}
.snapshot-head{
  position:relative;
  z-index:1;
  display:flex;
  justify-content:space-between;
  gap:16px;
  align-items:flex-start;
  margin-bottom:18px;
}
.snapshot-head h3{
  font-family:var(--h);
  font-size:25px;
  font-weight:850;
  letter-spacing:-.9px;
  margin:0;
}
.snapshot-icon{
  width:58px;
  height:58px;
  border-radius:18px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  display:flex;
  align-items:center;
  justify-content:center;
  color:#fff;
  font-size:20px;
  box-shadow:0 20px 50px rgba(59,130,246,.22);
  flex-shrink:0;
}
.snapshot-desc{
  position:relative;
  z-index:1;
  color:var(--t2);
  line-height:1.75;
  font-size:14px;
  margin-bottom:18px;
}
.snapshot-meta{
  position:relative;
  z-index:1;
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
.delivery-path{
  position:relative;
  z-index:1;
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
.path-step.current::before{background:var(--warn);box-shadow:0 0 0 5px rgba(245,158,11,.12)}

/* ===== SUBMISSION SECTION ===== */
.submit-section{
  position:relative;
  z-index:1;
  padding:24px 0 0;
}
.submit-grid{
  display:grid;
  grid-template-columns:1fr 360px;
  gap:30px;
  align-items:start;
}
.form-panel{
  border:1px solid var(--border);
  border-radius:28px;
  padding:30px;
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  position:relative;
  overflow:hidden;
}
.form-panel::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(90deg,transparent,rgba(59,130,246,.04),transparent);
  transform:translateX(-110%);
  animation:sweep 6s ease-in-out infinite;
}
@keyframes sweep{
  0%,100%{transform:translateX(-110%)}
  50%{transform:translateX(110%)}
}
.form-panel>*{position:relative;z-index:1}
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
  max-width:720px;
}
.form-label{
  font-family:var(--h);
  font-size:13px;
  font-weight:750;
  color:var(--t2);
  margin-bottom:9px;
}
.message-wrap{
  position:relative;
}
textarea.form-control{
  min-height:230px;
  border:1px solid var(--border);
  border-radius:18px;
  background:rgba(255,255,255,.035);
  color:var(--t1);
  padding:18px;
  font-family:var(--b);
  line-height:1.75;
  resize:vertical;
  outline:none;
  box-shadow:none!important;
  transition:border-color .2s, box-shadow .2s, background .2s;
}
textarea.form-control:focus{
  border-color:var(--pri-mid);
  box-shadow:0 0 0 4px var(--pri-soft)!important;
  background:rgba(255,255,255,.05);
  color:var(--t1);
}
textarea.form-control::placeholder{color:var(--t4)}
.form-help-row{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  margin-top:10px;
  color:var(--t4);
  font-size:12px;
}
.char-count.good{color:var(--ok)}
.char-count.warn{color:var(--warn)}
.action-row{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-top:24px;
}
.submit-btn{
  border:0;
  border-radius:12px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:#fff;
  padding:13px 20px;
  font-family:var(--h);
  font-size:14px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:9px;
  transition:all .2s;
}
.submit-btn:hover{
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.28);
}
.back-btn{
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.025);
  border-radius:12px;
  padding:13px 20px;
  font-family:var(--h);
  font-size:14px;
  font-weight:800;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:9px;
  transition:all .2s;
}
.back-btn:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.05);
  transform:translateY(-2px);
}

/* ===== SIDE PANEL ===== */
.side-panel{
  position:sticky;
  top:94px;
  display:grid;
  gap:16px;
}
.preview-card,
.checklist-card,
.quality-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.76),rgba(8,10,16,.78));
  border-radius:24px;
  padding:22px;
  overflow:hidden;
  position:relative;
}
.preview-card::before,
.quality-card::before{
  content:"";
  position:absolute;
  right:-80px;
  top:-90px;
  width:200px;
  height:200px;
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 67%);
}
.side-title{
  position:relative;
  z-index:1;
  font-family:var(--h);
  font-size:18px;
  font-weight:850;
  letter-spacing:-.5px;
  margin-bottom:12px;
}
.side-copy{
  position:relative;
  z-index:1;
  color:var(--t3);
  font-size:13px;
  line-height:1.75;
  margin-bottom:16px;
}
.preview-message{
  position:relative;
  z-index:1;
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:16px;
  padding:15px;
  min-height:120px;
  color:var(--t2);
  font-size:13px;
  line-height:1.75;
  white-space:pre-line;
}
.preview-message.empty{
  color:var(--t4);
}
.check-list{
  position:relative;
  z-index:1;
  display:grid;
  gap:11px;
}
.check-item{
  display:flex;
  gap:10px;
  color:var(--t2);
  font-size:13px;
  line-height:1.55;
  transition:color .2s;
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
  color:#fff;
  border-color:transparent;
}
.quality-meter{
  position:relative;
  z-index:1;
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
  position:relative;
  z-index:1;
  color:var(--t3);
  font-size:12px;
  line-height:1.6;
}

/* ===== FOOTER ===== */
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
  text-decoration:none;
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

/* ===== ANIMATION ===== */
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
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}.d4{transition-delay:.28s}

@media(max-width:1080px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
  .hero-grid,.submit-grid{grid-template-columns:1fr}
  .project-snapshot{max-width:760px}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
  .quality-card{grid-column:1/-1}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.8px}
  .snapshot-meta,.delivery-path,.side-panel{grid-template-columns:1fr}
  .form-panel{padding:22px}
  .action-row .submit-btn,.action-row .back-btn{width:100%;justify-content:center}
  .footer-grid{grid-template-columns:1fr;text-align:center}
  .footer-note{text-align:center}
}
</style>
</head>

<body>

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
    <a href="freelancerDashboard" class="logo"><span>Work</span><span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="freelancerDashboard">Dashboard</a>
      <a href="viewAllProjects">Explore</a>
      <a href="myProposals">Proposals</a>
      <a href="freelancerAssignedProjects" class="active">Assigned</a>
      <a href="freelancerReviews">Reviews</a>
    </div>

    <div class="nav-actions">
      <a href="freelancerAssignedProjects" class="nav-btn"><i class="fa-solid fa-arrow-left"></i> Assigned</a>
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
    <a href="freelancerReviews">Reviews</a>
    <a href="viewFreelancerProfile">Profile</a>
    <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap">
      <div class="hero-grid">
        <div class="hero-copy reveal">
          <div class="kicker"><i class="fa-solid fa-paper-plane"></i> Freelancer delivery submission</div>
          <h1>Submit completed <em>work</em> with a clear client message</h1>
          <p>
            Send your delivery for client review. Keep the message simple: what you completed,
            how the client can check it, and any important notes they should know.
          </p>

          <div class="hero-actions">
            <a href="freelancerAssignedProjects" class="action-main"><i class="fa-solid fa-diagram-project"></i> Assigned Projects</a>
            <a href="freelancerDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
          </div>
        </div>

        <aside class="project-snapshot zoom-reveal d1">
          <div class="snapshot-head">
            <h3><%= safe(project.getTitle()) %></h3>
            <div class="snapshot-icon"><i class="fa-solid fa-briefcase"></i></div>
          </div>

          <div class="snapshot-desc"><%= safe(project.getDescription()) %></div>

          <div class="snapshot-meta">
            <div class="meta-box">
              <div class="meta-label">Budget</div>
              <div class="meta-value">₹<%= safe(project.getBudget()) %></div>
            </div>
            <div class="meta-box">
              <div class="meta-label">Deadline</div>
              <div class="meta-value"><%= safe(project.getDeadline()) %></div>
            </div>
          </div>

          <div class="delivery-path">
            <div class="path-step">Assigned</div>
            <div class="path-step">Working</div>
            <div class="path-step current">Submit</div>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <section class="submit-section">
    <div class="wrap submit-grid">
      <section class="form-panel reveal">
        <h2 class="form-title">Delivery message</h2>
        <p class="form-copy">
          This message will be sent to the client with your submitted work. Write it like a professional handoff note.
        </p>
        <% if(request.getAttribute("error") != null){ %>
  <div class="alert alert-danger" style="border-radius:14px;border:0;font-weight:700;">
    <i class="fa-solid fa-circle-exclamation"></i>
    <%= safe(request.getAttribute("error")) %>
  </div>
<% } %>

        <form action="submitWork" method="post" enctype="multipart/form-data" id="submitWorkForm">
          <input type="hidden" name="projectId" value="<%= project.getId() %>">

          <div class="mb-3">
            <label class="form-label">Submission Message</label>
            <div class="message-wrap">
              <textarea name="submissionMessage" id="submissionMessage" class="form-control"
                placeholder="Example: I have completed the requested work. The final files are ready. Please review the delivered work and let me know if any revision is required." required></textarea>
            </div>
            <div class="form-help-row">
              <span>Keep it clear, specific, and client-friendly.</span>
              <span class="char-count" id="charCount">0 characters</span>
            </div>
          </div>
          
          <div class="mb-4">
  <label class="form-label">Upload Final Work File</label>

  <input type="file"
         name="submissionFile"
         class="form-control"
         accept=".zip,.rar,.7z,.pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.png,.jpg,.jpeg,.txt"
         required>

  <div class="form-help-row">
    <span>Allowed: ZIP, RAR, PDF, DOC, PPT, Excel, images, TXT.</span>
    <span>Max: 50 MB</span>
  </div>
</div>

          <div class="action-row">
            <button type="submit" class="submit-btn">
              <i class="fa-solid fa-paper-plane"></i> Submit to Client
            </button>
            <a href="freelancerAssignedProjects" class="back-btn">
              <i class="fa-solid fa-arrow-left"></i> Back to Assigned Projects
            </a>
          </div>
        </form>
      </section>

      <aside class="side-panel">
        <div class="preview-card zoom-reveal d1">
          <h3 class="side-title">Client preview</h3>
          <p class="side-copy">This is how your delivery note will read before submission.</p>
          <div class="preview-message empty" id="messagePreview">Your submission message preview will appear here.</div>
        </div>

        <div class="checklist-card zoom-reveal d2">
          <h3 class="side-title">Before you submit</h3>
          <div class="check-list">
            <div class="check-item" id="checkLength">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Message has enough detail.</span>
            </div>
            <div class="check-item" id="checkCompleted">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Mentions completed work.</span>
            </div>
            <div class="check-item" id="checkReview">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Asks client to review or respond.</span>
            </div>
          </div>
        </div>

        <div class="quality-card zoom-reveal d3">
          <h3 class="side-title">Delivery clarity</h3>
          <p class="side-copy">A clear submission note reduces confusion and revision delays.</p>
          <div class="quality-meter"><div class="quality-fill" id="qualityFill"></div></div>
          <div class="quality-text" id="qualityText">Start writing your delivery message.</div>
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
      <div class="footer-note">Freelancer Submit Work • 2026</div>
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

  const textarea = document.getElementById("submissionMessage");
  const preview = document.getElementById("messagePreview");
  const charCount = document.getElementById("charCount");
  const qualityFill = document.getElementById("qualityFill");
  const qualityText = document.getElementById("qualityText");
  const checkLength = document.getElementById("checkLength");
  const checkCompleted = document.getElementById("checkCompleted");
  const checkReview = document.getElementById("checkReview");

  function includesAny(text, words){
    return words.some(function(word){ return text.indexOf(word) !== -1; });
  }

  function updatePreview(){
    const value = textarea.value.trim();
    const lower = value.toLowerCase();
    const lengthOk = value.length >= 50;
    const completedOk = includesAny(lower, ["completed","done","finished","delivered","ready"]);
    const reviewOk = includesAny(lower, ["review","check","feedback","revision","let me know"]);

    preview.textContent = value || "Your submission message preview will appear here.";
    preview.classList.toggle("empty", !value);

    charCount.textContent = value.length + " characters";
    charCount.classList.toggle("good", value.length >= 80);
    charCount.classList.toggle("warn", value.length > 0 && value.length < 50);

    checkLength.classList.toggle("done", lengthOk);
    checkCompleted.classList.toggle("done", completedOk);
    checkReview.classList.toggle("done", reviewOk);

    let score = 0;
    if(lengthOk) score += 35;
    if(completedOk) score += 35;
    if(reviewOk) score += 30;

    qualityFill.style.width = score + "%";

    if(score === 0){
      qualityText.textContent = "Start writing your delivery message.";
    }else if(score < 50){
      qualityText.textContent = "Add more detail so the client understands your delivery.";
    }else if(score < 100){
      qualityText.textContent = "Good. Add review or revision instructions for a stronger handoff.";
    }else{
      qualityText.textContent = "Excellent. Your submission note is clear and professional.";
    }
  }

  if(textarea){
    textarea.addEventListener("input", updatePreview);
    updatePreview();
  }
})();
</script>

</body>
</html>
