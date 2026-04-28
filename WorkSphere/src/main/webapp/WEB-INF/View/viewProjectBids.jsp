<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.BidModel" %>
<%@ page import="com.model.ProjectModel" %>
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

private String bidKey(String status){
    if(status == null) return "pending";
    String s = status.trim().toLowerCase();
    if(s.contains("accept")) return "accepted";
    if(s.contains("reject") || s.contains("decline")) return "rejected";
    if(s.contains("withdraw")) return "withdrawn";
    if(s.contains("pending") || s.contains("open") || s.contains("wait")) return "pending";
    return "other";
}

private String statusIcon(String key){
    if("accepted".equals(key)) return "fa-circle-check";
    if("rejected".equals(key)) return "fa-circle-xmark";
    if("withdrawn".equals(key)) return "fa-circle-minus";
    if("pending".equals(key)) return "fa-clock";
    return "fa-circle-info";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Project Bids | WorkSphere</title>

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
  width:920px;
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
  grid-template-columns:1.05fr .95fr;
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
  max-width:780px;
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
  max-width:690px;
  margin-bottom:26px;
}
.accent-name{color:var(--sky);font-weight:850}
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
.assigned-box{
  position:relative;
  z-index:1;
  margin-top:14px;
  border:1px solid rgba(34,197,94,.22);
  background:rgba(34,197,94,.075);
  color:var(--t2);
  border-radius:16px;
  padding:14px;
  font-size:13.5px;
  line-height:1.65;
}
.assigned-box strong{color:var(--ok);font-family:var(--h)}

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
.summary-cell[data-type="accepted"]::after{background:linear-gradient(90deg,var(--ok),var(--cyan));}
.summary-cell[data-type="pending"]::after{background:linear-gradient(90deg,var(--warn),#FBBF24);}
.summary-cell[data-type="rejected"]::after{background:linear-gradient(90deg,var(--danger),#FB7185);}
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
  grid-template-columns:1fr auto auto;
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
.sort-select{
  height:46px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
  color:var(--t2);
  border-radius:14px;
  padding:0 14px;
  font-family:var(--h);
  font-size:12.5px;
  font-weight:750;
  outline:none;
}
.sort-select option{background:var(--s2);color:var(--t1)}

/* ===== BID LAYOUT ===== */
.bid-shell{
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
.bid-list{
  display:grid;
  gap:16px;
}
.bid-row{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:26px;
  padding:24px;
  position:relative;
  overflow:hidden;
  transition:transform .22s, border-color .22s, box-shadow .22s;
}
.bid-row::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);
  transform:translateX(-110%);
  transition:transform .75s ease;
}
.bid-row:hover{
  transform:translateY(-5px);
  border-color:var(--pri-mid);
  box-shadow:0 26px 70px rgba(0,0,0,.24);
}
.bid-row:hover::before{transform:translateX(110%)}
.bid-main{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:1fr auto;
  gap:18px;
  align-items:start;
}
.bid-name{
  font-family:var(--h);
  font-size:24px;
  font-weight:850;
  letter-spacing:-.7px;
  margin-bottom:10px;
}
.bid-desc{
  color:var(--t2);
  font-size:14px;
  line-height:1.8;
  max-width:800px;
  margin:15px 0 0;
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
.status-pill.accepted{color:var(--ok);background:rgba(34,197,94,.10);border:1px solid rgba(34,197,94,.22)}
.status-pill.pending{color:var(--warn);background:rgba(245,158,11,.10);border:1px solid rgba(245,158,11,.22)}
.status-pill.rejected{color:#FB7185;background:rgba(239,68,68,.10);border:1px solid rgba(239,68,68,.22)}
.status-pill.other{color:var(--t2);background:rgba(255,255,255,.04);border:1px solid var(--border)}
.bid-meta{
  display:flex;
  flex-wrap:wrap;
  gap:8px;
  margin-bottom:10px;
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
.decision-path{
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
.path-step.done{
  color:var(--t1);
  border-color:var(--pri-mid);
  background:rgba(59,130,246,.065);
}
.path-step.done::before{background:linear-gradient(135deg,var(--pri),var(--cyan))}
.path-step.win{
  color:var(--ok);
  border-color:rgba(34,197,94,.22);
  background:rgba(34,197,94,.075);
}
.path-step.win::before{background:var(--ok)}
.path-step.loss{
  color:#FB7185;
  border-color:rgba(239,68,68,.22);
  background:rgba(239,68,68,.075);
}
.path-step.loss::before{background:var(--danger)}
.decision-box{
  margin-top:16px;
  border-radius:18px;
  padding:16px;
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  color:var(--t2);
  font-size:13.5px;
  line-height:1.75;
}
.decision-box.accepted{border-color:rgba(34,197,94,.22);background:rgba(34,197,94,.075)}
.decision-box.pending{border-color:rgba(245,158,11,.22);background:rgba(245,158,11,.075)}
.decision-box.rejected{border-color:rgba(239,68,68,.22);background:rgba(239,68,68,.075)}
.decision-box strong{
  display:block;
  color:var(--t1);
  font-family:var(--h);
  font-size:14px;
  margin-bottom:5px;
}
.decision-box i{margin-right:7px;color:var(--cyan)}
.bid-actions{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  padding-top:16px;
  margin-top:16px;
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
.action-btn{
  border:0;
  border-radius:12px;
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
.action-btn.accept{
  background:linear-gradient(135deg,var(--ok),#4ADE80);
  color:#07100B;
}
.action-btn.reject{
  background:rgba(239,68,68,.12);
  color:#FCA5A5;
  border:1px solid rgba(239,68,68,.22);
}
.action-btn.review{
  background:linear-gradient(135deg,var(--warn),#FBBF24);
  color:#111827;
}
.action-btn:hover{
  transform:translateY(-2px);
  filter:brightness(1.05);
}

/* ===== SIDE PANEL ===== */
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
  text-decoration:none;
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
  font-weight:700;
  transition:all .2s;
}
.quick-links a:hover{
  color:var(--t1);
  border-color:var(--pri-mid);
  background:rgba(59,130,246,.07);
}
.quick-links i{color:var(--cyan)}
.rate-box{
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:16px;
  padding:14px;
}
.rate-num{
  font-family:var(--h);
  font-size:28px;
  font-weight:850;
  color:var(--sky);
  line-height:1;
}
.rate-text{
  color:var(--t3);
  font-size:12.5px;
  margin-top:6px;
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
  .hero-grid,.bid-shell{grid-template-columns:1fr}
  .project-snapshot{max-width:760px}
  .summary-grid{grid-template-columns:repeat(2,1fr)}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.9px}
  .snapshot-meta,.summary-grid,.side-panel{grid-template-columns:1fr}
  .command-bar{position:relative;top:auto;grid-template-columns:1fr}
  .filter-tabs{display:grid;grid-template-columns:repeat(2,1fr)}
  .filter-btn{width:100%}
  .bid-main,.bid-actions{grid-template-columns:1fr;display:grid}
  .decision-path{grid-template-columns:1fr 1fr}
  .bid-actions .d-flex{display:grid!important;grid-template-columns:1fr;gap:8px}
  .action-btn{justify-content:center}
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

ProjectModel project = (ProjectModel) request.getAttribute("project");
List<BidModel> bids = (List<BidModel>) request.getAttribute("bids");

Object unreadObj = request.getAttribute("unreadNotificationCount");
long unreadCount = 0;
if(unreadObj != null){
    unreadCount = (Long) unreadObj;
}

int totalBids = 0;
int acceptedCount = 0;
int pendingCount = 0;
int rejectedCount = 0;
int minBid = 0;
int maxBid = 0;

if(bids != null){
    totalBids = bids.size();
    for(BidModel b : bids){
        String key = bidKey(b.getStatus());
        if("accepted".equals(key)) acceptedCount++;
        else if("rejected".equals(key)) rejectedCount++;
        else if("pending".equals(key)) pendingCount++;

        try{
            int amount = Integer.parseInt(String.valueOf(b.getBidAmount()));
            if(minBid == 0 || amount < minBid) minBid = amount;
            if(amount > maxBid) maxBid = amount;
        }catch(Exception e){}
    }
}
%>

<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="clientDashboard" class="logo"><span>Work</span><span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="clientDashboard">Dashboard</a>
      <a href="postProjectPage">Post Project</a>
      <a href="viewMyProjects" class="active">My Projects</a>
      <a href="clientNotifications">Notifications</a>
    </div>

    <div class="nav-actions">
      <a href="clientNotifications" class="nav-btn">
        <i class="fa-regular fa-bell"></i>
        Alerts
        <% if(unreadCount > 0){ %>
          <span class="notif-dot"><%= unreadCount %></span>
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
    <a href="postProjectPage">Post Project</a>
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
          <div class="kicker"><i class="fa-solid fa-users-viewfinder"></i> Client bid decision desk</div>
          <h1>Compare freelancer <em>bids</em> and choose the best fit</h1>
          <p>
            Review proposals for this project, compare pricing and status, then accept the freelancer
            who is most aligned with your work requirements.
          </p>

          <div class="hero-actions">
            <a href="viewMyProjects" class="action-main"><i class="fa-solid fa-arrow-left"></i> Back to Projects</a>
            <a href="postProjectPage" class="action-ghost"><i class="fa-solid fa-plus"></i> Post Another Project</a>
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
            <div class="meta-box">
              <div class="meta-label">Status</div>
              <div class="meta-value"><%= safe(project.getStatus()) %></div>
            </div>
            <div class="meta-box">
              <div class="meta-label">Bids</div>
              <div class="meta-value"><%= totalBids %> received</div>
            </div>
          </div>

          <% if(project.getAssignedFreelancer() != null){ %>
          <div class="assigned-box">
            Assigned Freelancer: <strong><%= safe(project.getAssignedFreelancer().getName()) %></strong>
          </div>
          <% } %>
        </aside>
      </div>

      <div class="summary-grid zoom-reveal d2">
        <div class="summary-cell">
          <div class="summary-label">Total Bids</div>
          <div class="summary-value count-up" data-target="<%= totalBids %>">0</div>
          <div class="summary-note">All proposals received for this project.</div>
        </div>
        <div class="summary-cell" data-type="pending">
          <div class="summary-label">Pending</div>
          <div class="summary-value count-up" data-target="<%= pendingCount %>">0</div>
          <div class="summary-note">Freelancers waiting for your decision.</div>
        </div>
        <div class="summary-cell" data-type="accepted">
          <div class="summary-label">Accepted</div>
          <div class="summary-value count-up" data-target="<%= acceptedCount %>">0</div>
          <div class="summary-note">Selected freelancer proposals.</div>
        </div>
        <div class="summary-cell" data-type="rejected">
          <div class="summary-label">Rejected</div>
          <div class="summary-value count-up" data-target="<%= rejectedCount %>">0</div>
          <div class="summary-note">Closed bids for this project.</div>
        </div>
      </div>
    </div>
  </section>

  <section class="bids-section">
    <div class="wrap">
      <div class="command-bar zoom-reveal">
        <div class="search-box">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="bidSearch" placeholder="Search freelancer, proposal, amount, status...">
        </div>

        <div class="filter-tabs" id="filterTabs">
          <button type="button" class="filter-btn active" data-filter="all">All</button>
          <button type="button" class="filter-btn" data-filter="pending">Pending</button>
          <button type="button" class="filter-btn" data-filter="accepted">Accepted</button>
          <button type="button" class="filter-btn" data-filter="rejected">Rejected</button>
        </div>

        <select class="sort-select" id="sortSelect">
          <option value="default">Sort: Default</option>
          <option value="low">Lowest bid</option>
          <option value="high">Highest bid</option>
          <option value="name">Freelancer name</option>
        </select>
      </div>

      <div class="bid-shell">
        <div>
          <h2 class="section-title reveal">Freelancer bid board</h2>
          <p class="section-copy reveal d1">A focused place to compare proposals, take action on pending bids, and give reviews when a freelancer has been accepted.</p>

          <div class="bid-list" id="bidList">
            <%
            if(bids != null && !bids.isEmpty()){
              int index = 0;
              for(BidModel b : bids){
                index++;
                String key = bidKey(b.getStatus());
                String freelancerName = "";
                int freelancerId = 0;
                if(b.getFreelancer() != null){
                    freelancerName = b.getFreelancer().getName();
                    freelancerId = b.getFreelancer().getId();
                }
                String amountStr = String.valueOf(b.getBidAmount());
            %>

            <article class="bid-row reveal d<%= (index % 4) + 1 %>" data-status="<%= key %>" data-amount="<%= safe(amountStr) %>" data-name="<%= safe(freelancerName).toLowerCase() %>">
              <div class="bid-main">
                <div>
                  <h3 class="bid-name"><%= safe(freelancerName) %></h3>

                  <div class="bid-meta">
                    <span class="meta-chip"><i class="fa-solid fa-indian-rupee-sign"></i> Bid Amount: ₹<%= safe(b.getBidAmount()) %></span>
                    <span class="meta-chip"><i class="fa-solid fa-circle-info"></i> Project Status: <%= safe(project.getStatus()) %></span>
                  </div>
                </div>

                <span class="status-pill <%= key %>">
                  <i class="fa-solid <%= statusIcon(key) %>"></i>
                  <%= safe(b.getStatus()) %>
                </span>
              </div>

              <p class="bid-desc"><%= safe(b.getProposalText()) %></p>

              <div class="decision-path">
                <div class="path-step done">Received</div>
                <div class="path-step done">Reviewed</div>
                <div class="path-step <%= "accepted".equals(key) ? "win" : ("rejected".equals(key) ? "loss" : "done") %>">
                  <%= "accepted".equals(key) ? "Accepted" : ("rejected".equals(key) ? "Rejected" : "Decision") %>
                </div>
                <div class="path-step <%= "accepted".equals(key) ? "done" : "" %>">Work Flow</div>
              </div>

              <% if("pending".equals(key) && !"In Progress".equalsIgnoreCase(project.getStatus())){ %>
              <div class="decision-box pending">
                <strong><i class="fa-solid fa-clock"></i> Decision needed</strong>
                This freelancer is waiting for your response. Review the proposal, pricing, and fit before accepting.
              </div>
              <div class="bid-actions">
                <div class="next-note">
                  <strong>Next action:</strong> Accept the best fit or reject if this proposal is not suitable.
                </div>
                <div class="d-flex gap-2 flex-wrap">
                  <form action="acceptBid" method="post" style="margin:0;">
                    <input type="hidden" name="bidId" value="<%= b.getId() %>">
                    <button type="submit" class="action-btn accept" onclick="return confirm('Accept this bid and assign the project to this freelancer? Other pending bids will be rejected.');">
                      <i class="fa-solid fa-check"></i> Accept
                    </button>
                  </form>
                  <form action="rejectBid" method="post" style="margin:0;">
                    <input type="hidden" name="bidId" value="<%= b.getId() %>">
                    <button type="submit" class="action-btn reject" onclick="return confirm('Reject this bid?');">
                      <i class="fa-solid fa-xmark"></i> Reject
                    </button>
                  </form>
                </div>
              </div>
              <% } else if("accepted".equals(key)){ %>
              <div class="decision-box accepted">
                <strong><i class="fa-solid fa-circle-check"></i> Accepted bid</strong>
                This freelancer has been selected for the project. You can give a review when the workflow requires it.
              </div>
              <div class="bid-actions">
                <div class="next-note">
                  <strong>Next action:</strong> Review the freelancer’s delivery and leave feedback after completion.
                </div>
                <a href="giveReview?projectId=<%= project.getId() %>&freelancerId=<%= freelancerId %>" class="action-btn review">
                  <i class="fa-solid fa-star"></i> Give Review
                </a>
              </div>
              <% } else if("rejected".equals(key)){ %>
              <div class="decision-box rejected">
                <strong><i class="fa-solid fa-circle-xmark"></i> Rejected bid</strong>
                This proposal has been closed and is no longer part of your hiring decision.
              </div>
              <% } else { %>
              <div class="decision-box">
                <strong><i class="fa-solid fa-circle-info"></i> Bid status</strong>
                Current bid status: <%= safe(b.getStatus()) %>.
              </div>
              <% } %>
            </article>

            <%
              }
            } else {
            %>

            <div class="empty-state zoom-reveal">
              <div class="empty-icon"><i class="fa-regular fa-folder-open"></i></div>
              <h3>No bids yet</h3>
              <p>No freelancer has applied yet. Keep the project brief clear and check back later for incoming proposals.</p>
              <a href="viewMyProjects" class="action-main"><i class="fa-solid fa-arrow-left"></i> Back to My Projects</a>
            </div>

            <%
            }
            %>
          </div>
        </div>

        <aside class="side-panel reveal d2">
          <div class="side-card">
            <h3 class="side-title">Decision guide</h3>
            <p class="side-copy">Choose based on clarity, realistic budget, timeline confidence, and freelancer communication quality.</p>
            <div class="check-list">
              <div><i class="fa-solid fa-check"></i><span>Does the proposal directly answer your project need?</span></div>
              <div><i class="fa-solid fa-check"></i><span>Is the bid amount realistic for the scope?</span></div>
              <div><i class="fa-solid fa-check"></i><span>Does the freelancer explain how they will deliver?</span></div>
              <div><i class="fa-solid fa-check"></i><span>Can the deadline be completed with quality?</span></div>
            </div>
          </div>

          <div class="side-card">
            <h3 class="side-title">Bid range</h3>
            <div class="rate-box">
              <div class="rate-num">₹<%= minBid %> - ₹<%= maxBid %></div>
              <div class="rate-text">Current proposal range based on received bids.</div>
            </div>
          </div>

          <div class="side-card">
            <h3 class="side-title">Quick actions</h3>
            <div class="quick-links">
              <a href="viewMyProjects"><span>My Projects</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="postProjectPage"><span>Post New Project</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="clientNotifications"><span>Notifications</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="clientDashboard"><span>Dashboard</span><i class="fa-solid fa-arrow-right"></i></a>
            </div>
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
      <div class="footer-note">Client Project Bids • 2026</div>
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

  const search = document.getElementById("bidSearch");
  const filterBtns = document.querySelectorAll(".filter-btn");
  const rows = Array.from(document.querySelectorAll(".bid-row"));
  const list = document.getElementById("bidList");
  const sortSelect = document.getElementById("sortSelect");
  let activeFilter = "all";

  function amountOf(row){
    const raw = row.getAttribute("data-amount") || "0";
    const n = parseFloat(raw.replace(/[^0-9.]/g, ""));
    return isNaN(n) ? 0 : n;
  }

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

  function applySort(){
    if(!list || !sortSelect) return;
    const value = sortSelect.value;
    const sorted = rows.slice();

    if(value === "low"){
      sorted.sort((a,b) => amountOf(a) - amountOf(b));
    }else if(value === "high"){
      sorted.sort((a,b) => amountOf(b) - amountOf(a));
    }else if(value === "name"){
      sorted.sort((a,b) => (a.getAttribute("data-name") || "").localeCompare(b.getAttribute("data-name") || ""));
    }

    sorted.forEach(function(row){ list.appendChild(row); });
    applyFilters();
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

  if(sortSelect){
    sortSelect.addEventListener("change", applySort);
  }
})();
</script>

</body>
</html>
