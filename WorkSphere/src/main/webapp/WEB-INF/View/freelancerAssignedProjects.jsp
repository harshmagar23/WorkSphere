<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.FreelancerModel" %>
<%@ page import="com.model.PaymentModel" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

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

private String normalizeStatus(String status){
    if(status == null) return "unknown";
    String s = status.trim().toLowerCase();
    if(s.contains("payment")) return "other";
    if(s.contains("revision")) return "inprogress";
    if(s.contains("progress")) return "inprogress";
    if(s.contains("submitted")) return "submitted";
    if(s.contains("completed")) return "completed";
    return "other";
}

private int progressPercent(String status){
    String raw = status == null ? "" : status.trim().toLowerCase();
    if(raw.contains("payment")) return 20;
    if(raw.contains("revision")) return 58;
    String s = normalizeStatus(status);
    if("inprogress".equals(s)) return 45;
    if("submitted".equals(s)) return 75;
    if("completed".equals(s)) return 100;
    return 25;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Assigned Projects | WorkSphere</title>

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
  --ok:#22C55E;--warn:#F59E0B;--done:#A78BFA;
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

/* ===== SCROLL PROGRESS ===== */
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
  position:relative;
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
.notif-dot{
  position:absolute;
  top:-6px;
  right:-6px;
  min-width:18px;
  height:18px;
  padding:0 5px;
  border-radius:999px;
  background:linear-gradient(135deg,#EF4444,#FB7185);
  color:#fff;
  font-size:10px;
  font-family:var(--h);
  font-weight:850;
  display:flex;
  align-items:center;
  justify-content:center;
  border:2px solid var(--bg);
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
  width:900px;
  height:620px;
  background:radial-gradient(circle,rgba(59,130,246,.18),transparent 66%);
  pointer-events:none;
  opacity:.82;
}
.hero{
  position:relative;
  z-index:1;
  padding:26px 0 36px;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.08fr .92fr;
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
  font-size:clamp(42px,5.2vw,72px);
  line-height:.96;
  font-weight:850;
  letter-spacing:-2.7px;
  max-width:760px;
  margin-bottom:18px;
}
.hero h1 em{
  font-style:normal;
  font-weight:260;
  color:var(--t3);
  letter-spacing:-1.7px;
}
.hero p{
  color:var(--t2);
  font-size:16px;
  line-height:1.85;
  max-width:680px;
  margin-bottom:26px;
}
.accent-name{color:var(--sky);font-weight:850}
.hero-actions{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-bottom:18px;
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
.work-status{
  display:flex;
  gap:8px;
  flex-wrap:wrap;
}
.work-status span{
  display:inline-flex;
  align-items:center;
  gap:7px;
  border:1px solid var(--border2);
  background:rgba(11,13,20,.62);
  color:var(--t3);
  border-radius:999px;
  padding:7px 11px;
  font-size:12px;
  font-weight:650;
}
.work-status i{color:var(--cyan);font-size:10px}

.delivery-focus{
  border:1px solid var(--border);
  border-radius:26px;
  padding:26px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));
  position:relative;
  overflow:hidden;
}
.delivery-focus::before{
  content:"";
  position:absolute;
  right:-130px;
  top:-130px;
  width:310px;
  height:310px;
  border-radius:50%;
  background:radial-gradient(circle,var(--cyan-glow),transparent 67%);
}
.focus-top{
  position:relative;
  z-index:1;
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:18px;
  margin-bottom:26px;
}
.focus-top h3{
  font-family:var(--h);
  font-size:26px;
  font-weight:850;
  letter-spacing:-.95px;
  margin-bottom:8px;
}
.focus-top p{
  color:var(--t3);
  font-size:13px;
  line-height:1.7;
  margin:0;
}
.focus-icon{
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
.focus-list{
  position:relative;
  z-index:1;
  display:grid;
  gap:12px;
}
.focus-item{
  display:grid;
  grid-template-columns:38px 1fr auto;
  align-items:center;
  gap:13px;
  padding:12px;
  border:1px solid var(--border2);
  border-radius:16px;
  background:rgba(255,255,255,.035);
}
.focus-num{
  width:38px;
  height:38px;
  border-radius:13px;
  background:var(--pri-soft);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:var(--h);
  font-weight:850;
  font-size:13px;
}
.focus-item strong{
  display:block;
  font-family:var(--h);
  font-size:14px;
  letter-spacing:-.2px;
  color:var(--t1);
}
.focus-item span{
  color:var(--t3);
  font-size:12px;
}
.focus-item i{color:var(--t4)}

/* ===== SUMMARY ===== */
.summary-grid{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:repeat(4,1fr);
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
  background:rgba(255,255,255,.055);
}
.summary-cell[data-type="inprogress"]::after{background:linear-gradient(90deg,var(--pri),var(--cyan));}
.summary-cell[data-type="submitted"]::after{background:linear-gradient(90deg,var(--warn),#FBBF24);}
.summary-cell[data-type="completed"]::after{background:linear-gradient(90deg,var(--done),var(--cyan));}
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
  font-weight:850;
  letter-spacing:-1px;
  color:var(--t1);
  line-height:1;
}
.summary-note{
  margin-top:9px;
  color:var(--t3);
  font-size:12.5px;
  line-height:1.6;
  padding-bottom:16px;
}

/* ===== COMMAND BAR ===== */
.command-bar{
  position:sticky;
  top:82px;
  z-index:50;
  display:grid;
  grid-template-columns:1fr auto;
  gap:16px;
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
.search-box{
  position:relative;
}
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
  color:#fff;
  border-color:var(--pri-mid);
  background:linear-gradient(135deg,rgba(59,130,246,.22),rgba(34,211,238,.12));
}

/* ===== DELIVERY LAYOUT ===== */
.delivery-shell{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:1fr 330px;
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
.project-list{
  display:grid;
  gap:16px;
}
.project-row{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:26px;
  padding:24px;
  position:relative;
  overflow:hidden;
  transition:transform .22s, border-color .22s, box-shadow .22s;
}
.project-row::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);
  transform:translateX(-110%);
  transition:transform .75s ease;
}
.project-row:hover{
  transform:translateY(-5px);
  border-color:var(--pri-mid);
  box-shadow:0 26px 70px rgba(0,0,0,.24);
}
.project-row:hover::before{transform:translateX(110%)}
.project-main{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:1fr auto;
  gap:18px;
  align-items:start;
}
.project-title{
  font-family:var(--h);
  font-size:23px;
  font-weight:850;
  letter-spacing:-.7px;
  margin-bottom:10px;
}
.project-desc{
  color:var(--t2);
  font-size:14px;
  line-height:1.8;
  max-width:780px;
  margin-bottom:17px;
}
.status-pill{
  display:inline-flex;
  align-items:center;
  gap:7px;
  padding:8px 12px;
  border-radius:999px;
  font-family:var(--h);
  font-size:12px;
  font-weight:850;
  white-space:nowrap;
}
.status-pill.inprogress{color:var(--sky);background:var(--pri-soft);border:1px solid var(--pri-mid)}
.status-pill.submitted{color:var(--warn);background:rgba(245,158,11,.10);border:1px solid rgba(245,158,11,.22)}
.status-pill.completed{color:#C4B5FD;background:rgba(167,139,250,.10);border:1px solid rgba(167,139,250,.22)}
.status-pill.other{color:var(--t2);background:rgba(255,255,255,.04);border:1px solid var(--border)}
.project-meta{
  display:flex;
  flex-wrap:wrap;
  gap:8px;
  margin-bottom:18px;
}
.meta-chip{
  display:inline-flex;
  align-items:center;
  gap:7px;
  color:var(--t3);
  background:rgba(255,255,255,.035);
  border:1px solid var(--border2);
  border-radius:999px;
  padding:7px 11px;
  font-size:12.5px;
  font-weight:650;
}
.meta-chip i{color:var(--cyan);font-size:11px}

.progress-path{
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:8px;
  margin:18px 0;
}
.path-step{
  position:relative;
  padding:10px 10px 10px 34px;
  border-radius:13px;
  color:var(--t4);
  border:1px solid var(--border2);
  background:rgba(255,255,255,.025);
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
  background:var(--t5);
}
.path-step.done,
.path-step.current{
  color:var(--t1);
  border-color:var(--pri-mid);
  background:rgba(59,130,246,.065);
}
.path-step.done::before{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
}
.path-step.current::before{
  background:var(--warn);
  box-shadow:0 0 0 5px rgba(245,158,11,.12);
}

.project-action{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  padding-top:16px;
  border-top:1px solid var(--border2);
}
.next-note{
  color:var(--t3);
  font-size:13px;
  line-height:1.7;
}
.next-note strong{
  color:var(--t1);
  font-family:var(--h);
}
.submit-btn{
  border:0;
  border-radius:12px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:#fff;
  padding:11px 18px;
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:8px;
  white-space:nowrap;
  transition:all .2s;
}
.submit-btn:hover{
  color:#fff;
  transform:translateY(-2px);
  box-shadow:0 16px 38px rgba(59,130,246,.26);
}
.state-box{
  margin-top:16px;
  border-radius:18px;
  padding:16px;
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  color:var(--t2);
  font-size:13.5px;
  line-height:1.75;
}
.state-box.submitted{border-color:rgba(245,158,11,.22);background:rgba(245,158,11,.075)}
.state-box.revision{border-color:rgba(245,158,11,.25);background:rgba(245,158,11,.085)}
.state-box.completed{border-color:rgba(167,139,250,.22);background:rgba(167,139,250,.075)}
.state-box strong{
  display:block;
  color:var(--t1);
  font-family:var(--h);
  font-size:14px;
  margin-bottom:5px;
}
.state-box i{margin-right:7px;color:var(--cyan)}

.side-panel{
  position:sticky;
  top:166px;
  display:grid;
  gap:16px;
}
.playbook,
.profile-mini,
.quality-box{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.76),rgba(8,10,16,.78));
  border-radius:24px;
  padding:22px;
  overflow:hidden;
  position:relative;
}
.playbook::before,
.quality-box::before{
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
.check-list{
  position:relative;
  z-index:1;
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
.profile-head{
  display:flex;
  align-items:center;
  gap:13px;
  margin-bottom:16px;
}
.avatar{
  width:58px;
  height:58px;
  border-radius:19px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:var(--h);
  font-size:24px;
  font-weight:900;
}
.profile-name{
  font-family:var(--h);
  font-size:17px;
  font-weight:850;
}
.profile-role{
  color:var(--t3);
  font-size:12.5px;
  margin-top:3px;
}
.skill-mini{
  display:flex;
  flex-wrap:wrap;
  gap:7px;
}
.skill-mini span{
  color:var(--t2);
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:999px;
  padding:6px 9px;
  font-size:11.5px;
  font-weight:650;
}
.quality-meter{
  height:9px;
  border-radius:999px;
  background:rgba(255,255,255,.07);
  overflow:hidden;
  margin-top:12px;
}
.quality-fill{
  height:100%;
  width:0;
  border-radius:999px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  transition:width 1.2s cubic-bezier(.16,1,.3,1);
}

/* ===== EMPTY ===== */
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
.hide{display:none!important}

@media(max-width:1080px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
  .hero-grid,.delivery-shell{grid-template-columns:1fr}
  .delivery-focus{max-width:680px}
  .summary-grid{grid-template-columns:repeat(2,1fr)}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.9px}
  .command-bar{position:relative;top:auto;grid-template-columns:1fr}
  .filter-tabs{display:grid;grid-template-columns:repeat(2,1fr)}
  .filter-btn{width:100%}
  .summary-grid,.side-panel{grid-template-columns:1fr}
  .project-main,.project-action{grid-template-columns:1fr;display:grid}
  .progress-path{grid-template-columns:1fr 1fr}
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

String firstLetter = "F";
if(freelancer.getName() != null && !freelancer.getName().trim().isEmpty()){
    firstLetter = freelancer.getName().substring(0,1).toUpperCase();
}

Object unreadObj = request.getAttribute("unreadNotificationCount");
long unreadCount = 0;
if(unreadObj != null){
    unreadCount = (Long) unreadObj;
}

List<ProjectModel> projects = (List<ProjectModel>) request.getAttribute("projects");
Map<Integer, PaymentModel> paymentMap = (Map<Integer, PaymentModel>) request.getAttribute("paymentMap");
if(paymentMap == null){ paymentMap = new HashMap<Integer, PaymentModel>(); }

int totalProjects = 0;
int inProgressCount = 0;
int submittedCount = 0;
int completedCount = 0;

if(projects != null){
    totalProjects = projects.size();
    for(ProjectModel p : projects){
        String key = normalizeStatus(p.getStatus());
        if("inprogress".equals(key)) inProgressCount++;
        else if("submitted".equals(key)) submittedCount++;
        else if("completed".equals(key)) completedCount++;
    }
}
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
      <a href="freelancerNotifications" class="nav-btn">
        <i class="fa-regular fa-bell"></i>
        Alerts
        <% if(unreadCount > 0){ %>
          <span class="notif-dot"><%= unreadCount %></span>
        <% } %>
      </a>
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
    <a href="freelancerNotifications">Notifications</a>
    <a href="viewFreelancerProfile">Profile</a>
    <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap">
      <div class="hero-grid">
        <div class="hero-copy reveal">
          <div class="kicker"><i class="fa-solid fa-diagram-project"></i> Freelancer delivery workspace</div>
          <h1>Manage assigned <em>projects</em> with clear delivery focus</h1>
          <p>
            Welcome back, <span class="accent-name"><%= safe(freelancer.getName()) %></span>.
            Track deadlines, submit completed work, and keep every accepted project moving with confidence.
          </p>

          <div class="hero-actions">
            <a href="viewAllProjects" class="action-main"><i class="fa-solid fa-briefcase"></i> Explore More Projects</a>
            <a href="freelancerEarnings" class="action-ghost"><i class="fa-solid fa-paper-plane"></i> Earnings</a>
            <a href="freelancerDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
          </div>

          <div class="work-status">
            <span><i class="fa-solid fa-bolt"></i> Delivery mode active</span>
            <span><i class="fa-solid fa-clock"></i> Deadline focused</span>
            <span><i class="fa-solid fa-check-double"></i> Submission ready</span>
          </div>
        </div>

        <aside class="delivery-focus zoom-reveal d1">
          <div class="focus-top">
            <div>
              <h3>Today’s delivery flow</h3>
              <p>Keep your assigned work organized from execution to final approval.</p>
            </div>
            <div class="focus-icon"><i class="fa-solid fa-rocket"></i></div>
          </div>

          <div class="focus-list">
            <div class="focus-item">
              <div class="focus-num">01</div>
              <div><strong>Review requirement</strong><span>Check scope, budget, deadline, and client notes.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="focus-item">
              <div class="focus-num">02</div>
              <div><strong>Prepare delivery</strong><span>Finish work with proof, files, and clear message.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="focus-item">
              <div class="focus-num">03</div>
              <div><strong>Submit for review</strong><span>Send the completed work through the assigned project flow.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
          </div>
        </aside>
      </div>

      <div class="summary-grid zoom-reveal d2">
        <div class="summary-cell">
          <div class="summary-label">Assigned Total</div>
          <div class="summary-value count-up" data-target="<%= totalProjects %>">0</div>
          <div class="summary-note">Projects assigned to your freelancer workspace.</div>
        </div>
        <div class="summary-cell" data-type="inprogress">
          <div class="summary-label">In Progress</div>
          <div class="summary-value count-up" data-target="<%= inProgressCount %>">0</div>
          <div class="summary-note">Currently active work needing delivery.</div>
        </div>
        <div class="summary-cell" data-type="submitted">
          <div class="summary-label">Submitted</div>
          <div class="summary-value count-up" data-target="<%= submittedCount %>">0</div>
          <div class="summary-note">Work sent to clients for approval.</div>
        </div>
        <div class="summary-cell" data-type="completed">
          <div class="summary-label">Completed</div>
          <div class="summary-value count-up" data-target="<%= completedCount %>">0</div>
          <div class="summary-note">Finished projects from your account.</div>
        </div>
      </div>
    </div>
  </section>

  <section class="delivery-section">
    <div class="wrap">
      <div class="command-bar zoom-reveal">
        <div class="search-box">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="projectSearch" placeholder="Search assigned projects, client, description...">
        </div>
        <div class="filter-tabs" id="filterTabs">
          <button type="button" class="filter-btn active" data-filter="all">All</button>
          <button type="button" class="filter-btn" data-filter="inprogress">In Progress</button>
          <button type="button" class="filter-btn" data-filter="submitted">Submitted</button>
          <button type="button" class="filter-btn" data-filter="completed">Completed</button>
        </div>
      </div>

      <div class="delivery-shell">
        <div>
          <h2 class="section-title reveal">Assigned project board</h2>
          <p class="section-copy reveal d1">A focused workspace for the projects clients have already trusted you with. Submit work when ready and track completed deliveries clearly.</p>

          <div class="project-list" id="projectList">
            <%
            if(projects != null && !projects.isEmpty()){
              int index = 0;
              for(ProjectModel p : projects){
                index++;
                String status = p.getStatus();
                String key = normalizeStatus(status);
                boolean revisionRequested = "Revision Requested".equalsIgnoreCase(status);
                int percent = progressPercent(status);
PaymentModel payment = paymentMap.get(p.getId());
                boolean paymentPending = "Payment Pending".equalsIgnoreCase(status);
                String clientName = "";
                if(p.getClient() != null && p.getClient().getName() != null){
                    clientName = p.getClient().getName();
                }
            %>

            <article class="project-row reveal d<%= (index % 4) + 1 %>" data-status="<%= key %>">
              <div class="project-main">
                <div>
                  <h3 class="project-title"><%= safe(p.getTitle()) %></h3>
                  <p class="project-desc"><%= safe(p.getDescription()) %></p>

                  <div class="project-meta">
                    <span class="meta-chip"><i class="fa-solid fa-indian-rupee-sign"></i> Budget: ₹<%= safe(p.getBudget()) %></span>
                    <span class="meta-chip"><i class="fa-regular fa-calendar"></i> Deadline: <%= safe(p.getDeadline()) %></span>
                    <span class="meta-chip"><i class="fa-regular fa-user"></i> Client: <%= safe(clientName) %></span>
                  </div>
                </div>

                <span class="status-pill <%= key %>">
                  <i class="fa-solid <%= revisionRequested ? "fa-rotate-left" : ("submitted".equals(key) ? "fa-paper-plane" : ("completed".equals(key) ? "fa-circle-check" : "fa-spinner")) %>"></i>
                  <%= safe(status) %>
                </span>
              </div>

              <div class="progress-path">
                <div class="path-step done">Assigned</div>
                <div class="path-step <%= percent >= 45 ? "done" : "" %>">Working</div>
                <div class="path-step <%= revisionRequested ? "current" : ("submitted".equals(key) ? "current" : (percent >= 75 ? "done" : "")) %>">Review</div>
                <div class="path-step <%= "completed".equals(key) ? "done" : "" %>">Complete</div>
              </div>

              <% if(paymentPending){ %>
              <div class="state-box revision">
                <strong><i class="fa-solid fa-wallet"></i> Waiting for client escrow funding</strong><br>
                The client accepted your bid. Work submission unlocks after the client funds this project.
                <% if(payment != null){ %><br>Bid Amount: ₹<%= safe(payment.getBidAmount()) %><br>Payment Status: <%= safe(payment.getPaymentStatus()) %><% } %>
              </div>
              <div class="project-action">
                <div class="next-note"><strong>Next action:</strong> Wait for the client to fund the project. You can still use project chat for clarification.</div>
              </div>
              <% } %>
              <% if("inprogress".equals(key)){ %>
              <% if(revisionRequested){ %>
              <div class="state-box revision">
                <strong><i class="fa-solid fa-rotate-left"></i> Revision requested by client</strong>
                Date: <%= safe(p.getRevisionRequestedDate()) %><br>
                Message: <%= safe(p.getRevisionMessage()) %><br>
                Revision Count: <%= p.getRevisionCount() %>
              </div>
              <% } %>

              <div class="project-action">
                <div class="next-note">
                  <% if(revisionRequested){ %>
                    <strong>Next action:</strong> Review the client's revision note and resubmit the corrected delivery file.
                  <% } else { %>
                    <strong>Next action:</strong> Finish the agreed work and submit your delivery for client review.
                  <% } %>
                </div>
                <a href="submitWorkPage?projectId=<%= p.getId() %>" class="submit-btn">
                  <%= revisionRequested ? "Resubmit Work" : "Submit Work" %> <i class="fa-solid fa-arrow-right"></i>
                </a>
              </div>
              <% } %>

              <% if("submitted".equals(key)){ %>
              <div class="state-box submitted">
                <strong><i class="fa-solid fa-paper-plane"></i> Work submitted</strong>
                Date: <%= safe(p.getSubmissionDate()) %><br>
                Message: <%= safe(p.getSubmissionMessage()) %>
              </div>
              <div class="project-action">
                <div class="next-note">
                  <strong>Next action:</strong> Wait for client approval or be ready to respond if revision is requested.
                </div>
              </div>
              <% } %>

              <% if("completed".equals(key)){ %>
              <div class="state-box completed">
                <strong><i class="fa-solid fa-trophy"></i> Project completed</strong>
                Date: <%= safe(p.getSubmissionDate()) %><br>
                Work: <%= safe(p.getSubmissionMessage()) %>
              </div>
              <div class="project-action">
                <div class="next-note">
                  <strong>Next action:</strong> Use this completed project as proof of quality for future proposals.
                </div>
                <a href="freelancerReviews" class="submit-btn">
                  View Reviews <i class="fa-solid fa-star"></i>
                </a>
              </div>
              <% } %>

              <div class="project-action">
                <div class="next-note">
                  <strong>Project chat:</strong> Message the client about scope, progress, revisions, and delivery details.
                </div>
                <a href="projectChat?projectId=<%= p.getId() %>" class="submit-btn">
                  Open Chat <i class="fa-regular fa-comments"></i>
                </a>
              </div>
            </article>

            <%
              }
            } else {
            %>

            <div class="empty-state zoom-reveal">
              <div class="empty-icon"><i class="fa-solid fa-folder-open"></i></div>
              <h3>No assigned projects yet</h3>
              <p>Once a client accepts your bid, accepted projects will appear here with delivery actions, deadline tracking, and submission status.</p>
              <a href="viewAllProjects" class="action-main"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
            </div>

            <%
            }
            %>
          </div>
        </div>

        <aside class="side-panel reveal d2">
          <div class="profile-mini">
            <div class="profile-head">
              <div class="avatar"><%= firstLetter %></div>
              <div>
                <div class="profile-name"><%= safe(freelancer.getName()) %></div>
                <div class="profile-role">Independent Freelancer</div>
              </div>
            </div>

            <div class="skill-mini">
              <span>Delivery</span>
              <span>Client Review</span>
              <span>Project Flow</span>
              <span>Quality Work</span>
            </div>
          </div>

          <div class="playbook">
            <h3 class="side-title">Delivery checklist</h3>
            <p class="side-copy">Before submitting work, make sure the client can understand what you delivered and how to verify it.</p>
            <div class="check-list">
              <div><i class="fa-solid fa-check"></i><span>Attach or link the final deliverable clearly.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Write a short message explaining what is completed.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Mention setup steps, files, credentials, or usage notes if needed.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Keep revision communication professional and specific.</span></div>
            </div>
          </div>

          <div class="quality-box">
            <h3 class="side-title">Workspace health</h3>
            <p class="side-copy">Complete assigned projects on time to improve profile trust and proposal confidence.</p>
            <div class="quality-meter"><div class="quality-fill" data-width="78%"></div></div>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <footer class="ws-footer">
    <div class="footer-grid">
      <div class="footer-brand">Work<span class="s">Sphere</span></div>
      <div class="footer-links">
        <a href="freelancerDashboard">Dashboard</a>
        <a href="viewAllProjects">Explore</a>
        <a href="myProposals">Proposals</a>
        <a href="freelancerNotifications">Notifications</a>
      </div>
      <div class="footer-note">Freelancer Assigned Projects • 2026</div>
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

  const fillObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        const fill = entry.target;
        fill.style.width = fill.getAttribute("data-width") || "78%";
        fillObserver.unobserve(fill);
      }
    });
  }, {threshold:.4});

  document.querySelectorAll(".quality-fill").forEach(function(fill){
    fillObserver.observe(fill);
  });

  const search = document.getElementById("projectSearch");
  const filterBtns = document.querySelectorAll(".filter-btn");
  const rows = document.querySelectorAll(".project-row");
  let activeFilter = "all";

  function applyFilters(){
    const q = search ? search.value.toLowerCase().trim() : "";
    rows.forEach(function(row){
      const text = row.innerText.toLowerCase();
      const status = row.getAttribute("data-status");
      const matchText = !q || text.indexOf(q) !== -1;
      const matchStatus = activeFilter === "all" || status === activeFilter;
      row.classList.toggle("hide", !(matchText && matchStatus));
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
