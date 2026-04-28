<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.ClientModel" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Post New Project | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}

:root{
  --pri:#3B82F6;
  --pri-h:#2563EB;
  --sky:#60A5FA;
  --cyan:#22D3EE;
  --pri-soft:rgba(59,130,246,0.08);
  --pri-mid:rgba(59,130,246,0.18);
  --pri-glow:rgba(59,130,246,0.28);
  --bg:#07080D;
  --s1:#0B0D14;
  --s2:#10131D;
  --s3:#171B28;
  --s4:#1D2435;
  --t1:#F8FAFC;
  --t2:#B6C2D3;
  --t3:#7D8AA0;
  --t4:#4B5568;
  --border:rgba(255,255,255,0.08);
  --border2:rgba(255,255,255,0.045);
  --h:'Outfit',sans-serif;
  --b:'Inter',sans-serif;
  --max:1200px;
}

html{scroll-behavior:smooth}

body{
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  min-height:100vh;
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
  text-rendering:optimizeLegibility;
}

body::before{
  content:'';
  position:fixed;
  inset:0;
  z-index:-3;
  background:
    radial-gradient(circle at 18% 8%,rgba(59,130,246,.20),transparent 34%),
    radial-gradient(circle at 82% 24%,rgba(34,211,238,.12),transparent 32%),
    linear-gradient(180deg,#07080D 0%,#090B12 42%,#07080D 100%);
}

body::after{
  content:'';
  position:fixed;
  inset:0;
  z-index:-2;
  background-image:
    linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);
  background-size:52px 52px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.8),rgba(0,0,0,.18),transparent);
  -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.8),rgba(0,0,0,.18),transparent);
}

::selection{background:var(--pri);color:#fff}
a{color:inherit;text-decoration:none}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* ===== TOP PROGRESS ===== */
.prog{
  position:fixed;
  top:0;
  left:0;
  height:2px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  z-index:9999;
  width:0%;
  transition:width .08s linear;
}

/* ===== NAV ===== */
.nav{
  position:fixed;
  top:0;
  left:0;
  right:0;
  z-index:1000;
  transition:background .35s,box-shadow .35s;
}
.nav.s{
  background:rgba(7,8,13,0.78);
  backdrop-filter:blur(18px);
  -webkit-backdrop-filter:blur(18px);
  box-shadow:0 1px 0 var(--border);
}
.nav-in{
  max-width:var(--max);
  margin:0 auto;
  padding:0 32px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  height:68px;
}
.logo{
  font-family:var(--h);
  font-size:20px;
  font-weight:800;
  letter-spacing:-0.75px;
}
.logo .s{color:var(--pri)}
.nav-m{display:flex;gap:0}
.nav-a{
  color:var(--t3);
  font-family:var(--h);
  font-size:13px;
  font-weight:500;
  letter-spacing:.01em;
  padding:7px 14px;
  border-radius:999px;
  transition:all .2s;
}
.nav-a:hover,.nav-a.active{
  color:var(--t1);
  background:rgba(255,255,255,.045);
}
.nav-r{display:flex;gap:8px;align-items:center}
.btn-p,.btn-o{
  border-radius:9px;
  padding:9px 18px;
  font-family:var(--h);
  font-size:13px;
  letter-spacing:.01em;
  display:inline-flex;
  align-items:center;
  gap:7px;
  transition:transform .2s,box-shadow .2s,border-color .2s,background .2s,color .2s;
}
.btn-p{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:#fff;
  border:0;
  font-weight:750;
}
.btn-p:hover{
  transform:translateY(-1px);
  box-shadow:0 14px 34px rgba(59,130,246,.24);
  color:#fff;
}
.btn-o{
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.02);
  font-weight:500;
}
.btn-o:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.04);
}
.mbtn{
  display:none;
  background:none;
  border:0;
  color:var(--t2);
  font-size:18px;
  cursor:pointer;
  padding:6px;
}
.mob{
  display:none;
  position:fixed;
  inset:0;
  z-index:2000;
  background:rgba(0,0,0,.52);
  backdrop-filter:blur(8px);
  opacity:0;
  visibility:hidden;
  transition:all .25s;
}
.mob.on{opacity:1;visibility:visible}
.mob-p{
  position:absolute;
  top:16px;
  right:16px;
  width:286px;
  background:var(--s2);
  border:1px solid var(--border);
  border-radius:16px;
  padding:24px;
  transform:translateY(8px);
  transition:transform .25s;
}
.mob.on .mob-p{transform:translateY(0)}
.mob-x{
  background:none;
  border:0;
  color:var(--t3);
  font-size:15px;
  cursor:pointer;
  margin-bottom:16px;
  padding:4px;
}
.mob-p a{
  display:block;
  color:var(--t2);
  font-family:var(--h);
  font-size:14.5px;
  font-weight:500;
  letter-spacing:.01em;
  padding:11px 0;
  border-bottom:1px solid var(--border2);
}
.mob-p a:hover{color:var(--t1)}
.mob-b{margin-top:16px;display:flex;flex-direction:column;gap:8px}

/* ===== PAGE ===== */
.page{
  min-height:100vh;
  padding:118px 0 70px;
  position:relative;
}

.page::before{
  content:'';
  position:absolute;
  top:-26%;
  left:50%;
  transform:translateX(-50%);
  width:920px;
  height:720px;
  background:radial-gradient(circle,rgba(59,130,246,.18),transparent 65%);
  pointer-events:none;
}

.page-head{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:1fr auto;
  gap:22px;
  align-items:end;
  margin-bottom:30px;
}

.kicker{
  width:max-content;
  display:inline-flex;
  align-items:center;
  gap:9px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  border-radius:999px;
  padding:7px 12px;
  color:var(--t2);
  font-size:12px;
  font-weight:700;
  letter-spacing:.02em;
  margin-bottom:16px;
}
.kicker i{color:var(--cyan);font-size:11px}

.page-title{
  font-family:var(--h);
  font-size:clamp(38px,5vw,62px);
  line-height:1;
  font-weight:850;
  letter-spacing:-2.4px;
  margin-bottom:12px;
}
.page-title span{color:var(--t3);font-weight:280}

.page-desc{
  color:var(--t2);
  font-size:16px;
  line-height:1.85;
  max-width:710px;
  margin:0;
}

.head-actions{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  justify-content:flex-end;
}

/* ===== MAIN GRID ===== */
.project-shell{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:minmax(0,1.05fr) minmax(360px,.95fr);
  gap:28px;
  align-items:start;
}

.form-zone{
  position:relative;
  background:linear-gradient(145deg,rgba(16,19,29,.88),rgba(9,12,20,.88));
  border:1px solid var(--border);
  border-radius:30px;
  padding:30px;
  box-shadow:0 30px 80px rgba(0,0,0,.26);
  overflow:hidden;
}

.form-zone::before{
  content:'';
  position:absolute;
  top:-90px;
  right:-80px;
  width:260px;
  height:260px;
  border-radius:50%;
  background:radial-gradient(circle,rgba(34,211,238,.11),transparent 65%);
  pointer-events:none;
}

.form-top{
  position:relative;
  z-index:1;
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:18px;
  padding-bottom:20px;
  margin-bottom:20px;
  border-bottom:1px solid var(--border);
}

.form-top h2{
  font-family:var(--h);
  font-size:28px;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:7px;
}

.form-top p{
  color:var(--t3);
  font-size:13.5px;
  line-height:1.7;
  margin:0;
}

.step-pill{
  white-space:nowrap;
  background:var(--pri-soft);
  border:1px solid var(--border2);
  color:var(--sky);
  border-radius:999px;
  padding:7px 11px;
  font-family:var(--h);
  font-size:11px;
  font-weight:800;
  letter-spacing:1.2px;
  text-transform:uppercase;
}

.form-section{
  position:relative;
  z-index:1;
  padding:18px 0;
  border-bottom:1px solid var(--border2);
}
.form-section:last-of-type{border-bottom:0}

.field-row{
  display:grid;
  grid-template-columns:44px 1fr;
  gap:16px;
  align-items:start;
}

.field-num{
  width:44px;
  height:44px;
  border-radius:14px;
  background:rgba(255,255,255,.035);
  border:1px solid var(--border);
  color:var(--sky);
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
  display:flex;
  align-items:center;
  justify-content:center;
}

.form-label{
  display:block;
  font-family:var(--h);
  font-size:14px;
  font-weight:750;
  color:var(--t1);
  margin-bottom:8px;
  letter-spacing:-.1px;
}

.form-control{
  min-height:50px;
  border:1px solid var(--border)!important;
  background:rgba(7,8,13,.62)!important;
  color:var(--t1)!important;
  border-radius:14px!important;
  padding:13px 15px!important;
  font-family:var(--b);
  font-size:14px;
  box-shadow:none!important;
  transition:border-color .2s,box-shadow .2s,background .2s;
}

.form-control:focus{
  border-color:var(--pri-mid)!important;
  box-shadow:0 0 0 4px var(--pri-soft)!important;
  background:rgba(7,8,13,.86)!important;
}

.form-control::placeholder{color:var(--t4)!important}
textarea.form-control{resize:vertical;min-height:148px}

.input-help{
  color:var(--t4);
  font-size:12.5px;
  line-height:1.6;
  margin-top:7px;
}

.duo{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:18px;
}

.action-row{
  position:relative;
  z-index:1;
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  padding-top:24px;
}

.submit-btn{
  border:0;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  border-radius:12px;
  min-height:50px;
  padding:0 24px;
  font-family:var(--h);
  font-size:14px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:8px;
  transition:transform .2s,box-shadow .2s;
}

.submit-btn:hover{
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.28);
}

.back-btn{
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
  color:var(--t2);
  border-radius:12px;
  min-height:50px;
  padding:0 20px;
  font-family:var(--h);
  font-size:14px;
  font-weight:750;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:8px;
  transition:all .2s;
}

.back-btn:hover{
  color:var(--t1);
  background:rgba(255,255,255,.055);
  border-color:rgba(255,255,255,.15);
}

/* ===== PREVIEW ===== */
.preview-zone{
  position:sticky;
  top:92px;
}

.preview-card{
  background:linear-gradient(145deg,rgba(16,19,29,.86),rgba(9,12,20,.92));
  border:1px solid var(--border);
  border-radius:30px;
  padding:28px;
  box-shadow:0 30px 80px rgba(0,0,0,.24);
  overflow:hidden;
  position:relative;
}

.preview-card::before{
  content:'';
  position:absolute;
  inset:auto -120px -140px auto;
  width:340px;
  height:340px;
  border-radius:50%;
  background:radial-gradient(circle,rgba(59,130,246,.15),transparent 67%);
  pointer-events:none;
}

.preview-header{
  position:relative;
  z-index:1;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  margin-bottom:22px;
  padding-bottom:18px;
  border-bottom:1px solid var(--border);
}

.preview-header h3{
  font-family:var(--h);
  font-size:22px;
  font-weight:850;
  letter-spacing:-.7px;
  margin:0;
}

.preview-status{
  display:inline-flex;
  align-items:center;
  gap:7px;
  color:var(--sky);
  background:var(--pri-soft);
  border:1px solid var(--border2);
  border-radius:999px;
  padding:7px 10px;
  font-family:var(--h);
  font-size:11px;
  font-weight:800;
  text-transform:uppercase;
  letter-spacing:1px;
}

.project-preview{
  position:relative;
  z-index:1;
}

.preview-title{
  font-family:var(--h);
  font-size:30px;
  line-height:1.08;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:12px;
  color:var(--t1);
}

.preview-desc{
  color:var(--t2);
  font-size:14px;
  line-height:1.85;
  margin-bottom:20px;
  white-space:pre-line;
}

.preview-meta{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:12px;
  margin-bottom:22px;
}

.meta-box{
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  border-radius:18px;
  padding:15px;
}

.meta-box i{
  color:var(--cyan);
  font-size:14px;
  margin-bottom:10px;
}

.meta-label{
  display:block;
  color:var(--t4);
  font-size:11px;
  font-weight:800;
  letter-spacing:1px;
  text-transform:uppercase;
  margin-bottom:4px;
}

.meta-value{
  display:block;
  color:var(--t1);
  font-family:var(--h);
  font-size:15px;
  font-weight:800;
  line-height:1.25;
}

.preview-quality{
  border-top:1px solid var(--border);
  padding-top:20px;
}

.quality-head{
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:12px;
  margin-bottom:10px;
}

.quality-head strong{
  font-family:var(--h);
  font-size:14px;
  color:var(--t1);
}

.quality-head span{
  color:var(--sky);
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
}

.quality-line{
  width:100%;
  height:9px;
  border-radius:999px;
  background:rgba(255,255,255,.06);
  overflow:hidden;
}

.quality-fill{
  height:100%;
  width:25%;
  border-radius:999px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  transition:width .35s cubic-bezier(.16,1,.3,1);
}

.quality-list{
  display:grid;
  gap:10px;
  margin-top:18px;
}

.check-row{
  display:flex;
  align-items:flex-start;
  gap:10px;
  color:var(--t3);
  font-size:13px;
  line-height:1.55;
}

.check-row i{
  color:var(--t4);
  margin-top:2px;
  transition:color .2s;
}

.check-row.done{
  color:var(--t2);
}

.check-row.done i{
  color:var(--cyan);
}

/* ===== SIMPLE TIPS ===== */
.tip-band{
  position:relative;
  z-index:1;
  margin-top:28px;
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:1px;
  background:var(--border);
  border:1px solid var(--border);
  border-radius:24px;
  overflow:hidden;
}

.tip{
  background:rgba(11,13,20,.84);
  padding:24px;
  transition:background .2s;
}

.tip:hover{background:var(--s2)}
.tip i{
  width:42px;
  height:42px;
  border-radius:13px;
  background:var(--pri-soft);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  margin-bottom:14px;
}
.tip h4{
  font-family:var(--h);
  font-size:15px;
  font-weight:800;
  letter-spacing:-.2px;
  margin-bottom:7px;
}
.tip p{
  color:var(--t3);
  font-size:13px;
  line-height:1.75;
  margin:0;
}

/* ===== FOOTER ===== */
footer{
  border-top:1px solid var(--border);
  padding:34px 0;
  background:rgba(255,255,255,.012);
}
.foot-in{
  display:flex;
  align-items:center;
  justify-content:space-between;
  flex-wrap:wrap;
  gap:16px;
}
.foot-l{
  font-family:var(--h);
  font-size:17px;
  font-weight:800;
  letter-spacing:-.5px;
}
.foot-l .s{color:var(--pri)}
.foot-m{display:flex;gap:20px;flex-wrap:wrap}
.foot-m a{
  color:var(--t3);
  font-size:12.5px;
  font-weight:500;
}
.foot-m a:hover{color:var(--t1)}
.foot-r{
  color:var(--t4);
  font-size:11.5px;
}

/* ===== ANIMATION ===== */
.rv{
  opacity:0;
  transform:translateY(24px);
  transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1);
}
.rv.v{
  opacity:1;
  transform:translateY(0);
}
.d1{transition-delay:.08s}
.d2{transition-delay:.16s}
.d3{transition-delay:.24s}

@media(max-width:1080px){
  .nav-m{display:none}
  .mbtn{display:block}
  .mob{display:block}
  .project-shell{grid-template-columns:1fr}
  .preview-zone{position:relative;top:auto}
  .page-head{grid-template-columns:1fr}
  .head-actions{justify-content:flex-start}
}

@media(max-width:680px){
  .wrap,.nav-in{padding:0 20px}
  .nav-r{display:none}
  .page{padding-top:104px}
  .form-zone,.preview-card{border-radius:22px;padding:22px}
  .field-row{grid-template-columns:1fr}
  .field-num{display:none}
  .duo{grid-template-columns:1fr}
  .preview-meta{grid-template-columns:1fr}
  .tip-band{grid-template-columns:1fr}
  .page-title{letter-spacing:-1.7px}
  .foot-in{flex-direction:column;text-align:center}
  .foot-m{justify-content:center}
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<div class="prog" id="prog"></div>

<nav class="nav" id="nav">
  <div class="nav-in">
    <a href="clientDashboard" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>

    <div class="nav-m">
      <a href="clientDashboard" class="nav-a">Dashboard</a>
      <a href="postProjectPage" class="nav-a active">Post Project</a>
      <a href="viewMyProjects" class="nav-a">My Projects</a>
      <a href="clientNotifications" class="nav-a">Notifications</a>
    </div>

    <div class="nav-r">
      <a href="viewMyProjects" class="btn-o"><i class="fa-solid fa-briefcase"></i> Projects</a>
      <a href="logout" class="btn-p"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
    </div>

    <button class="mbtn" id="mbtn"><i class="fa-solid fa-bars"></i></button>
  </div>
</nav>

<div class="mob" id="mob">
  <div class="mob-p">
    <button class="mob-x" id="mobx"><i class="fa-solid fa-xmark"></i></button>
    <a href="clientDashboard">Dashboard</a>
    <a href="postProjectPage">Post Project</a>
    <a href="viewMyProjects">My Projects</a>
    <a href="clientNotifications">Notifications</a>
    <div class="mob-b">
      <a href="viewMyProjects" class="btn-o" style="text-align:center;justify-content:center">Projects</a>
      <a href="logout" class="btn-p" style="text-align:center;justify-content:center">Logout</a>
    </div>
  </div>
</div>

<%
ClientModel client = (ClientModel) session.getAttribute("clientSession");
if(client == null){
    response.sendRedirect("clientLogin");
    return;
}
%>

<main class="page">
  <div class="wrap">

    <div class="page-head rv">
      <div>
        <div class="kicker"><i class="fa-solid fa-sparkles"></i> Client project creation</div>
        <h1 class="page-title">Post a clear <span>project brief</span></h1>
        <p class="page-desc">
          Create a simple project listing that freelancers can understand quickly. Fill the form on the left and use the preview on the right to check how your project will appear.
        </p>
      </div>

      <div class="head-actions">
        <a href="clientDashboard" class="btn-o"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
        <a href="viewMyProjects" class="btn-p"><i class="fa-solid fa-folder-open"></i> My Projects</a>
      </div>
    </div>

    <div class="project-shell">
      <section class="form-zone rv d1">
        <div class="form-top">
          <div>
            <h2>Project details</h2>
            <p>Keep it direct. Good title, clear description, realistic budget, and practical deadline.</p>
          </div>
          <div class="step-pill">4 fields</div>
        </div>

        <form action="saveProject" method="post" id="projectForm">
          <div class="form-section">
            <div class="field-row">
              <div class="field-num">01</div>
              <div>
                <label class="form-label">Project Title</label>
                <input type="text" name="title" id="titleInput" class="form-control" placeholder="Example: Build a responsive portfolio website" required>
                <div class="input-help">Write what you need in one simple sentence.</div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="field-row">
              <div class="field-num">02</div>
              <div>
                <label class="form-label">Project Description</label>
                <textarea name="description" id="descInput" rows="5" class="form-control" placeholder="Explain the scope, required features, expected deliverables, and any important details." required></textarea>
                <div class="input-help">Mention deliverables, pages/features, technology preference, and expected outcome.</div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="field-row">
              <div class="field-num">03</div>
              <div class="duo">
                <div>
                  <label class="form-label">Budget</label>
                  <input type="number" name="budget" id="budgetInput" class="form-control" placeholder="Example: 25000" required>
                  <div class="input-help">Use a realistic number to attract better bids.</div>
                </div>
                <div>
                  <label class="form-label">Deadline</label>
                  <input type="date" name="deadline" id="deadlineInput" class="form-control" required>
                  <div class="input-help">Choose a practical final delivery date.</div>
                </div>
              </div>
            </div>
          </div>

          <div class="action-row">
            <button type="submit" class="submit-btn">
              <i class="fa-solid fa-plus"></i> Post Project
            </button>
            <a href="clientDashboard" class="back-btn">
              <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
          </div>
        </form>
      </section>

      <aside class="preview-zone rv d2">
        <div class="preview-card">
          <div class="preview-header">
            <h3>Live Preview</h3>
            <span class="preview-status"><i class="fa-solid fa-eye"></i> Draft</span>
          </div>

          <div class="project-preview">
            <h2 class="preview-title" id="previewTitle">Your project title will appear here</h2>
            <p class="preview-desc" id="previewDesc">Your project description preview will appear here. This helps you check whether the brief is clear before posting.</p>

            <div class="preview-meta">
              <div class="meta-box">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                <span class="meta-label">Budget</span>
                <span class="meta-value" id="previewBudget">Not added</span>
              </div>
              <div class="meta-box">
                <i class="fa-regular fa-calendar"></i>
                <span class="meta-label">Deadline</span>
                <span class="meta-value" id="previewDeadline">Not selected</span>
              </div>
            </div>

            <div class="preview-quality">
              <div class="quality-head">
                <strong>Brief completeness</strong>
                <span id="qualityText">25%</span>
              </div>
              <div class="quality-line">
                <div class="quality-fill" id="qualityFill"></div>
              </div>

              <div class="quality-list">
                <div class="check-row" id="checkTitle"><i class="fa-solid fa-circle"></i><span>Add a clear project title</span></div>
                <div class="check-row" id="checkDesc"><i class="fa-solid fa-circle"></i><span>Add enough project details</span></div>
                <div class="check-row" id="checkBudget"><i class="fa-solid fa-circle"></i><span>Add a project budget</span></div>
                <div class="check-row" id="checkDeadline"><i class="fa-solid fa-circle"></i><span>Select a deadline</span></div>
              </div>
            </div>
          </div>
        </div>
      </aside>
    </div>

    <div class="tip-band rv d3">
      <div class="tip">
        <i class="fa-solid fa-pen-nib"></i>
        <h4>Clear title wins attention</h4>
        <p>Freelancers scan titles first. Keep it specific and easy to understand.</p>
      </div>
      <div class="tip">
        <i class="fa-solid fa-list-check"></i>
        <h4>Describe deliverables</h4>
        <p>Tell freelancers exactly what output you expect, such as pages, files, features, or reports.</p>
      </div>
      <div class="tip">
        <i class="fa-solid fa-calendar-check"></i>
        <h4>Use a practical deadline</h4>
        <p>Realistic timelines get better proposals and smoother delivery.</p>
      </div>
    </div>

  </div>
</main>

<footer>
  <div class="wrap">
    <div class="foot-in">
      <div class="foot-l">Work<span class="s">Sphere</span></div>
      <div class="foot-m">
        <a href="clientDashboard">Dashboard</a>
        <a href="postProjectPage">Post Project</a>
        <a href="viewMyProjects">My Projects</a>
        <a href="clientNotifications">Notifications</a>
      </div>
      <div class="foot-r">&copy; 2026 WorkSphere</div>
    </div>
  </div>
</footer>

<script>
(function(){
  const nav=document.getElementById('nav');
  const prog=document.getElementById('prog');
  let ticking=false;

  function onScroll(){
    const s=window.scrollY;
    const h=document.documentElement.scrollHeight-window.innerHeight;
    prog.style.width=(h>0?s/h*100:0)+'%';
    nav.classList.toggle('s',s>24);
    ticking=false;
  }

  window.addEventListener('scroll',function(){
    if(!ticking){
      requestAnimationFrame(onScroll);
      ticking=true;
    }
  },{passive:true});
  onScroll();

  const mob=document.getElementById('mob');
  const mbtn=document.getElementById('mbtn');
  const mobx=document.getElementById('mobx');

  if(mbtn){
    mbtn.addEventListener('click',function(){
      mob.classList.add('on');
      document.body.style.overflow='hidden';
    });
  }

  function closeMenu(){
    mob.classList.remove('on');
    document.body.style.overflow='';
  }

  if(mobx){mobx.addEventListener('click',closeMenu)}
  if(mob){mob.addEventListener('click',function(e){if(e.target===mob)closeMenu();})}
  document.querySelectorAll('.mob-p a').forEach(function(a){a.addEventListener('click',closeMenu);});

  const ro=new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        entry.target.classList.add('v');
        ro.unobserve(entry.target);
      }
    });
  },{threshold:.06,rootMargin:'0px 0px -4px 0px'});
  document.querySelectorAll('.rv').forEach(function(el){ro.observe(el);});

  const titleInput=document.getElementById('titleInput');
  const descInput=document.getElementById('descInput');
  const budgetInput=document.getElementById('budgetInput');
  const deadlineInput=document.getElementById('deadlineInput');

  const previewTitle=document.getElementById('previewTitle');
  const previewDesc=document.getElementById('previewDesc');
  const previewBudget=document.getElementById('previewBudget');
  const previewDeadline=document.getElementById('previewDeadline');
  const qualityText=document.getElementById('qualityText');
  const qualityFill=document.getElementById('qualityFill');

  const checkTitle=document.getElementById('checkTitle');
  const checkDesc=document.getElementById('checkDesc');
  const checkBudget=document.getElementById('checkBudget');
  const checkDeadline=document.getElementById('checkDeadline');

  function formatDate(value){
    if(!value) return 'Not selected';
    const parts=value.split('-');
    if(parts.length!==3) return value;
    return parts[2] + '/' + parts[1] + '/' + parts[0];
  }

  function toggleCheck(el,done){
    el.classList.toggle('done',done);
    const icon=el.querySelector('i');
    icon.className=done?'fa-solid fa-circle-check':'fa-solid fa-circle';
  }

  function updatePreview(){
    const title=titleInput.value.trim();
    const desc=descInput.value.trim();
    const budget=budgetInput.value.trim();
    const deadline=deadlineInput.value.trim();

    previewTitle.textContent=title || 'Your project title will appear here';
    previewDesc.textContent=desc || 'Your project description preview will appear here. This helps you check whether the brief is clear before posting.';
    previewBudget.textContent=budget ? '₹' + Number(budget).toLocaleString('en-IN') : 'Not added';
    previewDeadline.textContent=formatDate(deadline);

    const okTitle=title.length>=8;
    const okDesc=desc.length>=40;
    const okBudget=budget.length>0 && Number(budget)>0;
    const okDeadline=deadline.length>0;

    toggleCheck(checkTitle,okTitle);
    toggleCheck(checkDesc,okDesc);
    toggleCheck(checkBudget,okBudget);
    toggleCheck(checkDeadline,okDeadline);

    let score=0;
    if(okTitle) score+=25;
    if(okDesc) score+=25;
    if(okBudget) score+=25;
    if(okDeadline) score+=25;

    if(score===0) score=25;
    qualityText.textContent=score + '%';
    qualityFill.style.width=score + '%';
  }

  [titleInput,descInput,budgetInput,deadlineInput].forEach(function(input){
    input.addEventListener('input',updatePreview);
    input.addEventListener('change',updatePreview);
  });

  updatePreview();
})();
</script>

</body>
</html>