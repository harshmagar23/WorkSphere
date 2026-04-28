<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.NotificationModel" %>
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Notifications | WorkSphere</title>

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
  --max:1160px;
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
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* TOP PROGRESS */
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
.nav-badge{
  min-width:18px;
  height:18px;
  padding:0 5px;
  border-radius:999px;
  background:linear-gradient(135deg,#EF4444,#FB7185);
  color:white;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  font-size:10px;
  font-family:var(--h);
  font-weight:850;
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
.mobile-panel .nav-btn{
  justify-content:center;
  margin-top:10px;
  border-bottom:0;
  padding:10px 14px;
}

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
  padding:26px 0 30px;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.06fr .94fr;
  gap:44px;
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
  max-width:820px;
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
  margin-bottom:26px;
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
  font-family:var(--h);
  font-size:14px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:all .2s;
}
.action-main{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
}
.action-main:hover{
  color:white;
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

/* NOTIFICATION SNAPSHOT */
.alert-snapshot{
  border:1px solid var(--border);
  border-radius:26px;
  padding:26px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));
  position:relative;
  overflow:hidden;
}
.alert-snapshot::before{
  content:"";
  position:absolute;
  right:-130px;
  top:-130px;
  width:310px;
  height:310px;
  border-radius:50%;
  background:radial-gradient(circle,var(--cyan-glow),transparent 67%);
}
.alert-snapshot>*{position:relative;z-index:1}
.snapshot-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:18px;
  margin-bottom:22px;
}
.snapshot-top h3{
  font-family:var(--h);
  font-size:28px;
  line-height:1.04;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:8px;
}
.snapshot-top p{
  color:var(--t3);
  font-size:13px;
  line-height:1.75;
}
.snapshot-icon{
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
}
.snapshot-list{
  display:grid;
  gap:12px;
}
.snapshot-item{
  display:grid;
  grid-template-columns:40px 1fr auto;
  align-items:center;
  gap:13px;
  padding:13px;
  border:1px solid var(--border2);
  border-radius:16px;
  background:rgba(255,255,255,.035);
}
.snapshot-num{
  width:40px;
  height:40px;
  border-radius:14px;
  background:var(--pri-soft);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:var(--h);
  font-weight:900;
}
.snapshot-item strong{
  display:block;
  font-family:var(--h);
  color:var(--t1);
  font-size:14px;
  margin-bottom:3px;
}
.snapshot-item span{
  color:var(--t3);
  font-size:12px;
}
.snapshot-item i{color:var(--t4)}

/* SUMMARY */
.summary-grid{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:1px;
  border:1px solid var(--border);
  background:var(--border);
  border-radius:24px;
  overflow:hidden;
  margin:26px 0 34px;
}
.summary-cell{
  background:rgba(11,13,20,.78);
  padding:24px;
  position:relative;
}
.summary-cell::after{
  content:"";
  position:absolute;
  left:24px;
  right:24px;
  bottom:18px;
  height:4px;
  border-radius:999px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
}
.summary-cell.projects::after{background:linear-gradient(90deg,var(--ok),var(--cyan))}
.summary-cell.bids::after{background:linear-gradient(90deg,var(--warn),#FBBF24)}
.summary-label{
  color:var(--t3);
  font-size:12px;
  font-weight:750;
  text-transform:uppercase;
  letter-spacing:1.2px;
  margin-bottom:11px;
}
.summary-value{
  font-family:var(--h);
  font-size:36px;
  line-height:1;
  font-weight:850;
  letter-spacing:-1px;
  color:var(--t1);
}
.summary-note{
  margin-top:9px;
  color:var(--t3);
  font-size:12.5px;
  line-height:1.6;
  padding-bottom:16px;
}

/* COMMAND BAR */
.command-bar{
  position:sticky;
  top:82px;
  z-index:50;
  display:grid;
  grid-template-columns:1fr auto;
  gap:14px;
  align-items:center;
  margin-bottom:28px;
  padding:13px;
  border:1px solid var(--border);
  border-radius:20px;
  background:rgba(8,10,16,.76);
  backdrop-filter:blur(16px);
  -webkit-backdrop-filter:blur(16px);
  box-shadow:0 18px 60px rgba(0,0,0,.22);
}
.search-box{position:relative}
.search-box i{
  position:absolute;
  left:15px;
  top:50%;
  transform:translateY(-50%);
  color:var(--t4);
  font-size:13px;
}
.search-box input{
  width:100%;
  height:46px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
  color:var(--t1);
  border-radius:14px;
  padding:0 15px 0 40px;
  outline:none;
  font-family:var(--b);
  font-size:14px;
  transition:all .2s;
}
.search-box input:focus{
  border-color:var(--pri-mid);
  box-shadow:0 0 0 4px var(--pri-soft);
}
.search-box input::placeholder{color:var(--t4)}
.filter-tabs{
  display:flex;
  gap:7px;
  flex-wrap:wrap;
}
.filter-btn{
  height:46px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
  color:var(--t3);
  border-radius:14px;
  padding:0 14px;
  font-family:var(--h);
  font-size:12.5px;
  font-weight:750;
  cursor:pointer;
  transition:all .2s;
}
.filter-btn:hover,
.filter-btn.active{
  color:white;
  border-color:var(--pri-mid);
  background:linear-gradient(135deg,rgba(59,130,246,.22),rgba(34,211,238,.12));
}

/* INBOX */
.inbox-shell{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:1fr 320px;
  gap:28px;
  align-items:start;
}
.section-title{
  font-family:var(--h);
  font-size:clamp(28px,3vw,42px);
  font-weight:850;
  letter-spacing:-1.5px;
  margin-bottom:9px;
}
.section-copy{
  color:var(--t3);
  font-size:14.5px;
  line-height:1.8;
  margin-bottom:22px;
  max-width:720px;
}
.notification-list{
  display:grid;
  gap:16px;
}
.note-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:24px;
  padding:22px;
  position:relative;
  overflow:hidden;
  transition:transform .22s,border-color .22s,box-shadow .22s;
}
.note-card::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);
  transform:translateX(-110%);
  transition:transform .75s ease;
}
.note-card:hover{
  transform:translateY(-5px);
  border-color:var(--pri-mid);
  box-shadow:0 26px 70px rgba(0,0,0,.24);
}
.note-card:hover::before{transform:translateX(110%)}
.note-row{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:48px 1fr auto;
  gap:16px;
  align-items:flex-start;
}
.note-icon{
  width:48px;
  height:48px;
  border-radius:16px;
  background:var(--pri-soft);
  border:1px solid var(--pri-mid);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:17px;
}
.note-label{
  display:inline-flex;
  align-items:center;
  gap:7px;
  color:var(--sky);
  background:rgba(59,130,246,.08);
  border:1px solid var(--pri-mid);
  border-radius:999px;
  padding:6px 10px;
  font-family:var(--h);
  font-size:11px;
  font-weight:850;
  letter-spacing:.7px;
  text-transform:uppercase;
  margin-bottom:10px;
}
.note-message{
  color:var(--t2);
  font-size:14.5px;
  line-height:1.85;
  word-break:break-word;
}
.note-time{
  display:inline-flex;
  align-items:center;
  gap:7px;
  white-space:nowrap;
  color:var(--t3);
  background:rgba(255,255,255,.035);
  border:1px solid var(--border2);
  border-radius:999px;
  padding:8px 11px;
  font-size:12px;
  font-weight:700;
}

/* SIDE PANEL */
.side-panel{
  position:sticky;
  top:166px;
  display:grid;
  gap:16px;
}
.side-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.76),rgba(8,10,16,.78));
  border-radius:24px;
  padding:22px;
  overflow:hidden;
  position:relative;
}
.side-card::before{
  content:"";
  position:absolute;
  right:-80px;
  top:-90px;
  width:200px;
  height:200px;
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 67%);
}
.side-card>*{position:relative;z-index:1}
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
.check-list{
  display:grid;
  gap:10px;
}
.check-list div{
  display:flex;
  gap:10px;
  color:var(--t2);
  font-size:13px;
  line-height:1.55;
}
.check-list i{
  color:var(--cyan);
  margin-top:3px;
}
.quick-links{
  display:grid;
  gap:9px;
}
.quick-links a{
  color:var(--t2);
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:14px;
  padding:11px 12px;
  display:flex;
  justify-content:space-between;
  align-items:center;
  font-family:var(--h);
  font-size:13px;
  font-weight:750;
  transition:all .2s;
}
.quick-links a:hover{
  color:var(--t1);
  border-color:var(--pri-mid);
  background:rgba(59,130,246,.07);
}
.quick-links i{color:var(--cyan)}

/* EMPTY */
.empty-state{
  border:1px solid var(--border);
  border-radius:30px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(8,10,16,.8));
  padding:56px 32px;
  text-align:center;
  position:relative;
  overflow:hidden;
}
.empty-state::before{
  content:"";
  position:absolute;
  left:50%;
  top:-120px;
  width:420px;
  height:420px;
  transform:translateX(-50%);
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 64%);
}
.empty-state>*{position:relative}
.empty-icon{
  width:74px;
  height:74px;
  border-radius:24px;
  background:var(--pri-soft);
  color:var(--sky);
  border:1px solid var(--pri-mid);
  display:flex;
  align-items:center;
  justify-content:center;
  margin:0 auto 20px;
  font-size:26px;
}
.empty-state h3{
  font-family:var(--h);
  font-size:28px;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:9px;
}
.empty-state p{
  color:var(--t3);
  line-height:1.75;
  margin:0 auto 24px;
  max-width:520px;
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
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}.d4{transition-delay:.28s}
.hide{display:none!important}

@media(max-width:1080px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
  .hero-grid,.inbox-shell{grid-template-columns:1fr}
  .alert-snapshot{max-width:720px}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.9px}
  .summary-grid,.side-panel{grid-template-columns:1fr}
  .command-bar{position:relative;top:auto;grid-template-columns:1fr}
  .filter-tabs{display:grid;grid-template-columns:1fr}
  .note-row{grid-template-columns:44px 1fr}
  .note-time{grid-column:2;justify-self:start;margin-top:10px}
  .snapshot-item{grid-template-columns:40px 1fr}
  .snapshot-item>i{display:none}
  .footer-grid{grid-template-columns:1fr;text-align:center}
  .footer-note{text-align:center}
}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<%
ClientModel client = (ClientModel) session.getAttribute("clientSession");
if(client == null){
    response.sendRedirect("clientLogin");
    return;
}
List<NotificationModel> notifications = (List<NotificationModel>) request.getAttribute("notifications");

int notificationCount = 0;
if(notifications != null){
    notificationCount = notifications.size();
}
%>

<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="clientDashboard" class="logo">Work<span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="clientDashboard">Dashboard</a>
      <a href="postProjectPage">Post Project</a>
      <a href="viewMyProjects">My Projects</a>
      <a href="clientNotifications" class="active">Notifications</a>
    </div>

    <div class="nav-actions">
      <a href="clientNotifications" class="nav-btn">
        <i class="fa-regular fa-bell"></i>
        Alerts
        <% if(notificationCount > 0){ %>
          <span class="nav-badge"><%= notificationCount %></span>
        <% } %>
      </a>
      <a href="logout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
      <button class="menu-btn" id="menuBtn" type="button"><i class="fa-solid fa-bars"></i></button>
    </div>
  </div>
</nav>

<div class="mobile-menu" id="mobileMenu">
  <div class="mobile-panel">
    <button class="mobile-close" id="mobileClose" type="button"><i class="fa-solid fa-xmark"></i></button>
    <a href="clientDashboard">Dashboard</a>
    <a href="postProjectPage">Post New Project</a>
    <a href="viewMyProjects">My Projects</a>
    <a href="clientNotifications">Notifications</a>
    <a href="logout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap">
      <div class="hero-grid">
        <div class="hero-copy reveal">
          <div class="kicker"><i class="fa-solid fa-bell"></i> Client notification center</div>
          <h1>Track every <em>project update</em> in one clean inbox</h1>
          <p>
            Stay updated with freelancer bids, project movement, work submissions, completion actions, and important client account alerts.
          </p>

          <div class="hero-actions">
            <a href="#notificationInbox" class="action-main"><i class="fa-solid fa-inbox"></i> Open Inbox</a>
            <a href="clientDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
          </div>
        </div>

        <aside class="alert-snapshot zoom-reveal d1">
          <div class="snapshot-top">
            <div>
              <h3>Client alert workflow</h3>
              <p>Use notifications to decide faster and keep your posted projects moving.</p>
            </div>
            <div class="snapshot-icon"><i class="fa-solid fa-bolt"></i></div>
          </div>

          <div class="snapshot-list">
            <div class="snapshot-item">
              <div class="snapshot-num">01</div>
              <div><strong>Review activity</strong><span>Check new bids, submitted work, and project progress.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="snapshot-item">
              <div class="snapshot-num">02</div>
              <div><strong>Take action</strong><span>Open bids, projects, reviews, or completion actions.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="snapshot-item">
              <div class="snapshot-num">03</div>
              <div><strong>Keep projects moving</strong><span>Fast decisions improve freelancer collaboration.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
          </div>
        </aside>
      </div>

      <div class="summary-grid zoom-reveal d2">
        <div class="summary-cell">
          <div class="summary-label">Total Alerts</div>
          <div class="summary-value count-up" data-target="<%= notificationCount %>">0</div>
          <div class="summary-note">All notifications currently available for your client account.</div>
        </div>
        <div class="summary-cell projects">
          <div class="summary-label">Primary Focus</div>
          <div class="summary-value"><i class="fa-solid fa-diagram-project"></i></div>
          <div class="summary-note">Project activity, submitted work, completion and revision updates.</div>
        </div>
        <div class="summary-cell bids">
          <div class="summary-label">Decision Queue</div>
          <div class="summary-value"><i class="fa-solid fa-users"></i></div>
          <div class="summary-note">Bids, freelancer actions, and client review moments.</div>
        </div>
      </div>
    </div>
  </section>

  <section class="notification-section" id="notificationInbox">
    <div class="wrap">
      <div class="command-bar zoom-reveal">
        <div class="search-box">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="notificationSearch" placeholder="Search notifications by message or date...">
        </div>

        <div class="filter-tabs">
          <button type="button" class="filter-btn active" data-filter="all">All Updates</button>
          <button type="button" class="filter-btn" data-filter="bid">Bids</button>
          <button type="button" class="filter-btn" data-filter="project">Project</button>
        </div>
      </div>

      <div class="inbox-shell">
        <div>
          <h2 class="section-title reveal">Notification inbox</h2>
          <p class="section-copy reveal d1">A focused timeline of bids, project updates, submitted work, and important activity from your client workspace.</p>

          <div class="notification-list" id="notificationList">
            <%
            if(notifications != null && !notifications.isEmpty()){
                int index = 0;
                for(NotificationModel n : notifications){
                    index++;
                    String message = n.getMessage() != null ? n.getMessage() : "";
                    String lowerMessage = message.toLowerCase();
                    String category = "general";
                    String icon = "fa-bell";

                    if(lowerMessage.contains("bid") || lowerMessage.contains("proposal") || lowerMessage.contains("freelancer") || lowerMessage.contains("accepted") || lowerMessage.contains("rejected")){
                        category = "bid";
                        icon = "fa-users";
                    }else if(lowerMessage.contains("project") || lowerMessage.contains("work") || lowerMessage.contains("submitted") || lowerMessage.contains("completed") || lowerMessage.contains("revision")){
                        category = "project";
                        icon = "fa-diagram-project";
                    }
            %>
              <article class="note-card reveal d<%= (index % 4) + 1 %>" data-category="<%= category %>">
                <div class="note-row">
                  <div class="note-icon">
                    <i class="fa-solid <%= icon %>"></i>
                  </div>

                  <div class="note-content">
                    <div class="note-label">
                      <i class="fa-solid fa-circle-info"></i>
                      <%= "bid".equals(category) ? "Bid Update" : ("project".equals(category) ? "Project Update" : "New Update") %>
                    </div>
                    <div class="note-message"><%= safe(n.getMessage()) %></div>
                  </div>

                  <div class="note-time">
                    <i class="fa-regular fa-clock"></i>
                    <%= safe(n.getCreatedAt()) %>
                  </div>
                </div>
              </article>
            <%
                }
            } else {
            %>
              <div class="empty-state zoom-reveal">
                <div class="empty-icon"><i class="fa-regular fa-bell-slash"></i></div>
                <h3>No notifications yet</h3>
                <p>When there is new activity on your projects, alerts will appear here.</p>
                <a href="clientDashboard" class="action-main"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
              </div>
            <%
            }
            %>
          </div>
        </div>

        <aside class="side-panel reveal d2">
          <div class="side-card">
            <h3 class="side-title">Client response checklist</h3>
            <p class="side-copy">When you receive an alert, use it as a decision queue for your projects.</p>
            <div class="check-list">
              <div><i class="fa-solid fa-check"></i><span>If a new bid arrives, compare it in your project bid board.</span></div>
              <div><i class="fa-solid fa-check"></i><span>If work is submitted, review it and complete or request revision.</span></div>
              <div><i class="fa-solid fa-check"></i><span>If a project is completed, leave clear feedback for the freelancer.</span></div>
            </div>
          </div>

          <div class="side-card">
            <h3 class="side-title">Quick actions</h3>
            <div class="quick-links">
              <a href="viewMyProjects"><span>My Projects</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="postProjectPage"><span>Post New Project</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="clientDashboard"><span>Dashboard</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="clientNotifications"><span>Refresh Alerts</span><i class="fa-solid fa-arrow-right"></i></a>
            </div>
          </div>

          <div class="side-card">
            <h3 class="side-title">Professional tip</h3>
            <p class="side-copy" style="margin-bottom:0">
              Use this page like your client operations inbox. Fast decisions keep freelancers aligned and projects moving.
            </p>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <footer class="ws-footer">
    <div class="footer-grid">
      <div class="footer-brand">Work<span class="s">Sphere</span></div>
      <div class="footer-links">
        <a href="clientDashboard">Dashboard</a>
        <a href="postProjectPage">Post Project</a>
        <a href="viewMyProjects">My Projects</a>
        <a href="clientNotifications">Notifications</a>
      </div>
      <div class="footer-note">Client Notifications • WorkSphere</div>
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

  const counterObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        const el = entry.target;
        const target = parseInt(el.getAttribute("data-target"), 10) || 0;
        const start = performance.now();
        const duration = 900;
        function tick(now){
          const p = Math.min((now - start) / duration, 1);
          const eased = 1 - Math.pow(1 - p, 3);
          el.textContent = Math.floor(eased * target);
          if(p < 1) requestAnimationFrame(tick);
          else el.textContent = target;
        }
        requestAnimationFrame(tick);
        counterObserver.unobserve(el);
      }
    });
  }, {threshold:.35});

  document.querySelectorAll(".count-up").forEach(function(el){
    counterObserver.observe(el);
  });

  const search = document.getElementById("notificationSearch");
  const filterBtns = document.querySelectorAll(".filter-btn");
  const notes = document.querySelectorAll(".note-card");
  let activeFilter = "all";

  function applyFilters(){
    const q = search ? search.value.toLowerCase().trim() : "";
    notes.forEach(function(note){
      const text = note.innerText.toLowerCase();
      const category = note.getAttribute("data-category") || "general";
      const matchesSearch = !q || text.indexOf(q) !== -1;
      const matchesFilter = activeFilter === "all" || category === activeFilter;
      note.classList.toggle("hide", !(matchesSearch && matchesFilter));
    });
  }

  if(search){
    search.addEventListener("input", applyFilters);
  }

  filterBtns.forEach(function(btn){
    btn.addEventListener("click", function(){
      filterBtns.forEach(function(b){ b.classList.remove("active"); });
      btn.classList.add("active");
      activeFilter = btn.getAttribute("data-filter");
      applyFilters();
    });
  });
})();
</script>

</body>
</html>
