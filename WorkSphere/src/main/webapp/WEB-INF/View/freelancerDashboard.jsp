<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.FreelancerModel" %>
<%@ page import="com.model.FreelancerProfileModel" %>
<%!
private long toLong(Object value){
    if(value == null) return 0L;
    if(value instanceof Number) return ((Number)value).longValue();
    try{
        return Long.parseLong(value.toString());
    }catch(Exception e){
        return 0L;
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Freelancer Dashboard | WorkSphere</title>

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
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1240px;
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
    radial-gradient(circle at 18% 9%,rgba(59,130,246,.20),transparent 34%),
    radial-gradient(circle at 86% 28%,rgba(34,211,238,.13),transparent 32%),
    radial-gradient(circle at 50% 88%,rgba(139,92,246,.10),transparent 34%),
    linear-gradient(180deg,#07080D 0%,#090B12 45%,#07080D 100%);
}
body::after{
  content:"";
  position:fixed;
  inset:0;
  z-index:-3;
  background-image:
    linear-gradient(rgba(255,255,255,.023) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.023) 1px,transparent 1px);
  background-size:56px 56px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent);
  -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent);
}
::selection{background:var(--pri);color:white}
a{color:inherit;text-decoration:none}
button,input{font:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
.page{position:relative;isolation:isolate}
.parallax-orb{position:fixed;z-index:-2;border-radius:999px;filter:blur(10px);pointer-events:none;opacity:.64;will-change:transform}
.orb-a{width:360px;height:360px;left:-140px;top:220px;background:radial-gradient(circle,rgba(59,130,246,.22),transparent 64%)}
.orb-b{width:320px;height:320px;right:-150px;top:620px;background:radial-gradient(circle,rgba(34,211,238,.18),transparent 64%)}

/* ===== NAVBAR ===== */
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
  display:flex;
  align-items:center;
  gap:0;
}
.logo .s{color:var(--pri)}
.nav-m{display:flex;align-items:center;gap:0}
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
.nav-a:hover,.nav-a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-r{display:flex;gap:8px;align-items:center}
.btn-o,.btn-p{
  border-radius:9px;
  padding:9px 18px;
  font-family:var(--h);
  font-size:13px;
  letter-spacing:.01em;
  display:inline-flex;
  align-items:center;
  gap:7px;
  transition:transform .2s,box-shadow .2s,border-color .2s,background .2s,color .2s;
  white-space:nowrap;
}
.btn-o{
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.02);
  font-weight:500;
}
.btn-o:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.04)}
.btn-p{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  border:0;
  font-weight:800;
}
.btn-p:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24)}
.nav-badge{
  min-width:18px;
  height:18px;
  border-radius:99px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  font-size:10px;
  font-weight:800;
  margin-left:2px;
}
.mbtn{display:none;background:none;border:0;color:var(--t2);font-size:18px;cursor:pointer;padding:6px}
.mob{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,.5);backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);opacity:0;visibility:hidden;transition:all .25s}
.mob.on{opacity:1;visibility:visible}
.mob-p{position:absolute;top:16px;right:16px;width:292px;background:var(--s2);border-radius:16px;padding:24px;border:1px solid var(--border);transform:translateY(8px);transition:transform .25s}
.mob.on .mob-p{transform:translateY(0)}
.mob-x{background:none;border:0;color:var(--t3);font-size:15px;cursor:pointer;margin-bottom:16px;padding:4px}
.mob-p a{display:block;color:var(--t2);font-family:var(--h);font-size:14.5px;font-weight:500;letter-spacing:.01em;padding:11px 0;border-bottom:1px solid var(--border2);transition:color .15s}
.mob-p a:hover{color:var(--t1)}
.mob-b{margin-top:16px;display:flex;flex-direction:column;gap:8px}

/* ===== COMMON ===== */
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
  font-weight:750;
  letter-spacing:.02em;
}
.kicker i{color:var(--cyan);font-size:11px}
.section-kicker{
  font-family:var(--h);
  font-size:11px;
  font-weight:800;
  color:var(--sky);
  letter-spacing:2px;
  text-transform:uppercase;
  margin-bottom:10px;
}
.section-title{
  font-family:var(--h);
  font-size:clamp(30px,4vw,54px);
  font-weight:850;
  letter-spacing:-1.8px;
  line-height:1.04;
}
.section-copy{
  color:var(--t2);
  font-size:15px;
  line-height:1.85;
  max-width:560px;
}
.link-arrow{
  color:var(--sky);
  font-family:var(--h);
  font-size:13px;
  font-weight:800;
  display:inline-flex;
  align-items:center;
  gap:7px;
  transition:color .2s;
}
.link-arrow i{font-size:11px;transition:transform .2s}
.link-arrow:hover{color:var(--cyan)}
.link-arrow:hover i{transform:translateX(4px)}

/* ===== HERO LAYOUT + Z-PATTERN ===== */
.hero{
  min-height:100vh;
  position:relative;
  padding:116px 0 76px;
  display:flex;
  align-items:center;
  overflow:hidden;
}
.hero::before{
  content:"";
  position:absolute;
  inset:0;
  background:
    linear-gradient(125deg,rgba(59,130,246,.10),transparent 38%),
    radial-gradient(circle at 72% 38%,rgba(34,211,238,.13),transparent 32%);
  pointer-events:none;
}
.hero-grid{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:minmax(0,1.05fr) minmax(420px,.95fr);
  align-items:center;
  gap:54px;
}
.hero-copy{text-align:left}
.hero-copy .kicker{margin-bottom:22px}
.hero-copy h1{
  font-family:var(--h);
  font-size:clamp(48px,6.4vw,88px);
  line-height:.94;
  font-weight:850;
  letter-spacing:-3.3px;
  max-width:850px;
  margin-bottom:24px;
}
.hero-copy h1 em{
  font-style:normal;
  color:var(--t3);
  font-weight:260;
  letter-spacing:-2.4px;
}
.hero-copy p{
  color:var(--t2);
  font-size:17px;
  line-height:1.9;
  max-width:670px;
  margin-bottom:30px;
}
.hero-copy strong{color:var(--sky);font-weight:800}
.hero-actions{
  display:flex;
  align-items:center;
  gap:10px;
  flex-wrap:wrap;
  margin-bottom:34px;
}
.hero-primary,.hero-secondary{
  min-height:48px;
  padding:0 22px;
  border-radius:12px;
  font-family:var(--h);
  font-size:14px;
  font-weight:800;
  display:inline-flex;
  align-items:center;
  gap:9px;
  transition:transform .22s,box-shadow .22s,background .22s,border-color .22s,color .22s;
}
.hero-primary{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  box-shadow:0 18px 45px rgba(59,130,246,.25);
}
.hero-primary:hover{transform:translateY(-3px);box-shadow:0 24px 54px rgba(59,130,246,.32)}
.hero-secondary{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.hero-secondary:hover{color:var(--t1);border-color:rgba(255,255,255,.17);background:rgba(255,255,255,.045);transform:translateY(-3px)}
.hero-micro{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:1px;
  max-width:720px;
  border:1px solid var(--border);
  border-radius:20px;
  overflow:hidden;
  background:var(--border);
}
.micro{
  background:rgba(11,13,20,.65);
  padding:18px;
}
.micro b{
  display:block;
  font-family:var(--h);
  font-size:24px;
  font-weight:850;
  letter-spacing:-.8px;
  color:var(--t1);
  margin-bottom:5px;
}
.micro b span{color:var(--sky)}
.micro small{
  color:var(--t3);
  font-size:12px;
  line-height:1.5;
}

/* Hero media area (large image/video style without external files) */
.hero-media{
  position:relative;
  min-height:590px;
  display:flex;
  align-items:center;
  justify-content:center;
  transform-style:preserve-3d;
}
.media-frame{
  width:min(100%,540px);
  height:620px;
  border-radius:34px;
  position:relative;
  overflow:hidden;
  background:
    linear-gradient(145deg,rgba(16,19,29,.92),rgba(7,8,13,.82)),
    radial-gradient(circle at 60% 22%,rgba(34,211,238,.16),transparent 42%);
  border:1px solid var(--border);
  box-shadow:0 36px 90px rgba(0,0,0,.42);
  transform:translateZ(0);
}
.media-frame::before{
  content:"";
  position:absolute;
  inset:-40%;
  background:conic-gradient(from 160deg,transparent,rgba(96,165,250,.22),transparent,rgba(34,211,238,.14),transparent);
  animation:spinGlow 13s linear infinite;
  opacity:.32;
}
@keyframes spinGlow{to{transform:rotate(360deg)}}
.media-grid{
  position:absolute;
  inset:0;
  background-image:
    linear-gradient(rgba(255,255,255,.04) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.04) 1px,transparent 1px);
  background-size:42px 42px;
  opacity:.5;
}
.media-content{
  position:absolute;
  inset:0;
  padding:32px;
  display:flex;
  flex-direction:column;
  justify-content:space-between;
}
.media-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
}
.media-status{
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:8px 12px;
  border-radius:999px;
  background:rgba(59,130,246,.10);
  border:1px solid rgba(96,165,250,.22);
  color:var(--t2);
  font-size:12px;
  font-weight:800;
}
.pulse-dot{
  width:8px;height:8px;border-radius:50%;
  background:var(--cyan);
  box-shadow:0 0 0 0 rgba(34,211,238,.38);
  animation:pulseDot 1.9s ease infinite;
}
@keyframes pulseDot{50%{box-shadow:0 0 0 9px rgba(34,211,238,0)}}
.media-number{
  text-align:right;
}
.media-number b{
  display:block;
  font-family:var(--h);
  font-size:38px;
  font-weight:850;
  letter-spacing:-1.2px;
}
.media-number span{font-size:12px;color:var(--t3)}
.media-visual{
  position:relative;
  height:250px;
}
.ring{
  position:absolute;
  inset:22px;
  border-radius:50%;
  border:1px solid rgba(96,165,250,.16);
}
.ring.r2{inset:54px;border-color:rgba(34,211,238,.16)}
.ring.r3{inset:86px;border-color:rgba(255,255,255,.10)}
.flow-node{
  position:absolute;
  width:76px;
  height:76px;
  border-radius:25px;
  background:rgba(255,255,255,.05);
  border:1px solid var(--border);
  display:flex;
  align-items:center;
  justify-content:center;
  color:var(--sky);
  font-size:21px;
  box-shadow:0 18px 42px rgba(0,0,0,.22);
  animation:floatNode 5.2s ease-in-out infinite;
}
.n1{left:16px;top:62px}
.n2{right:26px;top:18px;animation-delay:.4s}
.n3{left:45%;bottom:20px;animation-delay:.8s}
@keyframes floatNode{0%,100%{transform:translateY(0)}50%{transform:translateY(-12px)}}
.media-bars{
  display:grid;
  gap:12px;
}
.media-bar{
  padding:16px;
  border-radius:18px;
  background:rgba(255,255,255,.045);
  border:1px solid var(--border2);
}
.media-bar-top{
  display:flex;
  justify-content:space-between;
  align-items:center;
  margin-bottom:10px;
  color:var(--t2);
  font-size:12px;
  font-weight:800;
}
.line-bg{height:8px;border-radius:99px;background:rgba(255,255,255,.07);overflow:hidden}
.line-fill{
  height:100%;
  width:var(--w);
  border-radius:99px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  transform-origin:left;
  transform:scaleX(0);
}
.media-frame.in .line-fill{animation:growLine 1.3s cubic-bezier(.16,1,.3,1) forwards}
@keyframes growLine{to{transform:scaleX(1)}}
.float-tag{
  position:absolute;
  display:flex;
  align-items:center;
  gap:9px;
  padding:12px 14px;
  background:rgba(16,19,29,.86);
  border:1px solid var(--border);
  border-radius:18px;
  box-shadow:0 20px 45px rgba(0,0,0,.28);
  color:var(--t2);
  font-size:12px;
  font-weight:800;
  backdrop-filter:blur(14px);
  -webkit-backdrop-filter:blur(14px);
}
.float-tag i{color:var(--cyan)}
.tag-a{left:-22px;top:108px}
.tag-b{right:-18px;bottom:120px}
.tag-c{left:58px;bottom:36px}


/* ===== CLEAN HERO WORKBENCH: NO 3D IMAGE ===== */
.hero-workbench{
  position:relative;
  min-height:590px;
  display:flex;
  flex-direction:column;
  justify-content:center;
  gap:18px;
  padding:0 0 0 8px;
}
.hero-workbench::before{
  content:"";
  position:absolute;
  inset:7% -6% 7% 18%;
  border-radius:44px;
  background:
    radial-gradient(circle at 72% 16%,rgba(34,211,238,.14),transparent 34%),
    linear-gradient(145deg,rgba(16,19,29,.54),rgba(7,8,13,.24));
  border:1px solid rgba(255,255,255,.045);
  opacity:.78;
  pointer-events:none;
  transform:skewY(-2deg);
}
.workbench-top,
.workbench-search,
.workbench-flow,
.workbench-stats,
.workbench-note{
  position:relative;
  z-index:1;
}
.workbench-top{
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:20px;
  padding:0 6px 6px 36px;
}
.workbench-eyebrow{
  display:block;
  font-family:var(--h);
  color:var(--sky);
  font-size:11px;
  font-weight:850;
  letter-spacing:1.8px;
  text-transform:uppercase;
  margin-bottom:8px;
}
.workbench-top h3{
  font-family:var(--h);
  font-size:clamp(30px,3.4vw,48px);
  line-height:.98;
  font-weight:850;
  letter-spacing:-1.8px;
  max-width:380px;
}
.workbench-avatar{
  width:64px;
  height:64px;
  border-radius:22px;
  display:flex;
  align-items:center;
  justify-content:center;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  font-family:var(--h);
  font-size:26px;
  font-weight:900;
  box-shadow:0 22px 48px rgba(59,130,246,.22);
}
.workbench-search{
  margin-left:36px;
  max-width:520px;
  min-height:58px;
  border-radius:999px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.04);
  display:grid;
  grid-template-columns:44px 1fr auto;
  align-items:center;
  padding:6px 8px 6px 8px;
  backdrop-filter:blur(12px);
  -webkit-backdrop-filter:blur(12px);
}
.workbench-search i{color:var(--sky);justify-self:center}
.workbench-search span{color:var(--t3);font-size:13px;font-weight:650}
.workbench-search a{
  min-height:42px;
  padding:0 16px;
  border-radius:999px;
  display:inline-flex;
  align-items:center;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
}
.workbench-flow{
  display:grid;
  gap:10px;
  max-width:560px;
  margin-left:auto;
  width:92%;
}
.workbench-row{
  display:grid;
  grid-template-columns:46px 1fr 34px;
  gap:16px;
  align-items:center;
  min-height:92px;
  padding:16px 18px;
  border-radius:24px;
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(11,13,20,.46));
  transition:transform .24s,border-color .24s,background .24s;
  overflow:hidden;
  position:relative;
}
.workbench-row::before{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(110deg,transparent,rgba(255,255,255,.055),transparent);
  transform:translateX(-120%);
  transition:transform .7s cubic-bezier(.16,1,.3,1);
}
.workbench-row:hover::before{transform:translateX(120%)}
.workbench-row:hover{transform:translateX(-8px);border-color:var(--pri-mid);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(11,13,20,.62))}
.wb-num{
  width:46px;height:46px;border-radius:16px;
  display:flex;align-items:center;justify-content:center;
  background:var(--pri-soft);
  color:var(--sky);
  font-family:var(--h);
  font-weight:900;
  border:1px solid var(--border2);
}
.workbench-row strong{display:block;font-family:var(--h);font-size:16px;font-weight:850;letter-spacing:-.35px;margin-bottom:4px;color:var(--t1)}
.workbench-row small{display:block;color:var(--t3);font-size:12.5px;line-height:1.55}
.workbench-row>i{color:var(--t3);transition:transform .2s,color .2s}
.workbench-row:hover>i{color:var(--cyan);transform:translateX(4px)}
.workbench-stats{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:1px;
  max-width:470px;
  margin:2px 42px 0 auto;
  border:1px solid var(--border);
  border-radius:22px;
  background:var(--border);
  overflow:hidden;
}
.workbench-stats div{background:rgba(11,13,20,.72);padding:18px 16px}
.workbench-stats b{display:block;font-family:var(--h);font-size:28px;line-height:1;font-weight:900;letter-spacing:-.9px;color:var(--t1)}
.workbench-stats small{display:block;color:var(--t3);font-size:11.5px;margin-top:7px;font-weight:750;text-transform:uppercase;letter-spacing:.8px}
.workbench-note{
  max-width:500px;
  margin:0 10px 0 auto;
  display:flex;
  align-items:flex-start;
  gap:12px;
  color:var(--t3);
  font-size:13px;
  line-height:1.7;
  padding:0 32px 0 0;
}
.workbench-note i{color:var(--cyan);margin-top:4px}

/* ===== F-PATTERN DASHBOARD BODY ===== */
.dashboard-body{
  position:relative;
  padding:22px 0 96px;
}
.workspace-head{
  display:grid;
  grid-template-columns:1fr auto;
  gap:28px;
  align-items:end;
  margin-bottom:32px;
}
.workspace-head p{margin-top:12px}
.workspace-actions{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  justify-content:flex-end;
}
.section-btn{
  min-height:44px;
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:0 16px;
  border-radius:12px;
  border:1px solid var(--border);
  color:var(--t2);
  background:rgba(255,255,255,.025);
  font-family:var(--h);
  font-size:13px;
  font-weight:800;
  transition:all .2s;
}
.section-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.17);background:rgba(255,255,255,.045);transform:translateY(-2px)}
.section-btn.primary{background:linear-gradient(135deg,var(--pri),var(--cyan));border-color:transparent;color:white}

/* Grid/Card Layout where browsing stats is useful */
.metrics-grid{
  display:grid;
  grid-template-columns:repeat(12,1fr);
  gap:16px;
}
.metric{
  position:relative;
  min-height:188px;
  border-radius:24px;
  padding:24px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(11,13,20,.72));
  border:1px solid var(--border);
  overflow:hidden;
  transition:transform .25s,border-color .25s,box-shadow .25s;
}
.metric:nth-child(1){grid-column:span 3}
.metric:nth-child(2){grid-column:span 2}
.metric:nth-child(3){grid-column:span 2}
.metric:nth-child(4){grid-column:span 2}
.metric:nth-child(5){grid-column:span 2}
.metric:nth-child(6){grid-column:span 1}
.metric::before{
  content:"";
  position:absolute;
  inset:auto -35% -45% -35%;
  height:130px;
  background:radial-gradient(circle,var(--pri-glow),transparent 64%);
  opacity:.35;
  transition:opacity .25s;
}
.metric:hover{
  transform:translateY(-6px);
  border-color:var(--pri-mid);
  box-shadow:0 24px 60px rgba(0,0,0,.22);
}
.metric:hover::before{opacity:.58}
.metric-icon{
  width:42px;
  height:42px;
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  color:var(--sky);
  background:var(--pri-soft);
  border:1px solid var(--border2);
  margin-bottom:22px;
}
.metric-label{
  color:var(--t3);
  font-size:12px;
  font-weight:800;
  letter-spacing:1.1px;
  text-transform:uppercase;
  margin-bottom:8px;
}
.metric-value{
  font-family:var(--h);
  font-size:42px;
  line-height:1;
  font-weight:850;
  letter-spacing:-1.3px;
  margin-bottom:16px;
}
.metric-note{color:var(--t3);font-size:12.5px;line-height:1.65;max-width:220px}
.meter{height:7px;border-radius:99px;background:rgba(255,255,255,.07);overflow:hidden;margin-top:18px}
.meter span{display:block;width:var(--w);height:100%;border-radius:99px;background:linear-gradient(90deg,var(--pri),var(--cyan));transform-origin:left;transform:scaleX(0)}
.metric.v .meter span{animation:growLine 1.2s cubic-bezier(.16,1,.3,1) forwards}

/* Split Screen Layout */
.split-section{
  margin-top:86px;
  display:grid;
  grid-template-columns:minmax(0,.94fr) minmax(0,1.06fr);
  min-height:560px;
  gap:42px;
  align-items:center;
}
.sticky-panel{
  position:sticky;
  top:104px;
  align-self:start;
  padding:8px 0;
}
.big-number{
  font-family:var(--h);
  font-size:clamp(88px,12vw,168px);
  line-height:.82;
  font-weight:900;
  letter-spacing:-8px;
  color:rgba(248,250,252,.055);
  margin-bottom:-20px;
}
.text-reveal .word{
  color:var(--t4);
  transition:color .25s,text-shadow .25s;
}
.text-reveal.active .word{color:var(--t1)}
.text-reveal.active .word.mark{color:var(--sky);text-shadow:0 0 24px rgba(96,165,250,.18)}
.action-lanes{
  display:grid;
  gap:14px;
}
.lane{
  display:grid;
  grid-template-columns:56px 1fr auto;
  gap:17px;
  align-items:center;
  padding:20px 0;
  position:relative;
}
.lane::after{
  content:"";
  position:absolute;
  left:73px;
  right:0;
  bottom:0;
  height:1px;
  background:linear-gradient(90deg,rgba(255,255,255,.07),transparent);
}
.lane-icon{
  width:56px;
  height:56px;
  border-radius:18px;
  background:rgba(255,255,255,.04);
  border:1px solid var(--border);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:18px;
}
.lane h4{
  font-family:var(--h);
  font-size:18px;
  font-weight:800;
  letter-spacing:-.45px;
  margin-bottom:5px;
}
.lane p{font-size:13px;color:var(--t3);line-height:1.65;margin:0}
.lane-link{
  color:var(--t2);
  width:38px;height:38px;
  border-radius:99px;
  border:1px solid var(--border);
  display:flex;
  align-items:center;
  justify-content:center;
  transition:all .2s;
}
.lane:hover .lane-link{color:white;background:linear-gradient(135deg,var(--pri),var(--cyan));border-color:transparent;transform:translateX(4px)}
.lane:hover .lane-icon{border-color:var(--pri-mid);background:var(--pri-soft)}

/* Asymmetrical Layout */
.asym-section{
  margin-top:96px;
  display:grid;
  grid-template-columns:1.18fr .82fr;
  gap:18px;
  align-items:stretch;
}
.asym-main,.asym-side,.profile-block,.insight-block{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.70),rgba(11,13,20,.56));
  border-radius:30px;
  overflow:hidden;
  position:relative;
}
.asym-main{
  min-height:520px;
  padding:34px;
}
.asym-main::before,.asym-side::before,.profile-block::before,.insight-block::before{
  content:"";
  position:absolute;
  inset:auto -30% -42% -30%;
  height:180px;
  background:radial-gradient(circle,var(--cyan-glow),transparent 66%);
  pointer-events:none;
}
.board-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:24px;
  margin-bottom:30px;
}
.board-top h3{
  font-family:var(--h);
  font-size:31px;
  line-height:1.05;
  font-weight:850;
  letter-spacing:-1.1px;
  max-width:430px;
}
.board-top p{color:var(--t3);font-size:13px;line-height:1.75;max-width:300px}
.pipeline-list{display:grid;gap:0;position:relative}
.pipeline-item{
  display:grid;
  grid-template-columns:42px 1fr 120px;
  gap:18px;
  align-items:start;
  padding:22px 0;
  position:relative;
}
.pipeline-item:not(:last-child)::after{
  content:"";
  position:absolute;
  left:20px;
  top:64px;
  bottom:-18px;
  width:1px;
  background:linear-gradient(to bottom,rgba(96,165,250,.26),rgba(255,255,255,.04));
}
.pipeline-num{
  width:42px;height:42px;
  border-radius:14px;
  background:var(--pri-soft);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:var(--h);
  font-weight:850;
  position:relative;
  z-index:1;
  border:1px solid var(--border2);
}
.pipeline-item h4{font-family:var(--h);font-size:17px;font-weight:800;margin-bottom:6px}
.pipeline-item p{color:var(--t3);font-size:13px;line-height:1.7;margin:0;max-width:520px}
.pipeline-status{
  justify-self:end;
  color:var(--t3);
  border:1px solid var(--border);
  border-radius:999px;
  padding:7px 10px;
  font-size:11px;
  font-weight:800;
  text-transform:uppercase;
  letter-spacing:.7px;
}
.pipeline-item.active .pipeline-status{color:var(--sky);background:var(--pri-soft);border-color:var(--pri-mid)}
.asym-side{
  padding:30px;
  display:flex;
  flex-direction:column;
  justify-content:space-between;
}
.profile-face{
  width:82px;height:82px;
  border-radius:28px;
  display:flex;
  align-items:center;
  justify-content:center;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  font-family:var(--h);
  font-size:34px;
  font-weight:900;
  box-shadow:0 24px 54px rgba(59,130,246,.24);
  margin-bottom:22px;
}
.asym-side h3{
  font-family:var(--h);
  font-size:32px;
  line-height:1.05;
  letter-spacing:-1.2px;
  margin-bottom:8px;
}
.asym-side p{color:var(--t3);font-size:13px;line-height:1.75;margin-bottom:22px}
.profile-meta{display:grid;grid-template-columns:1fr 1fr;gap:1px;background:var(--border);border:1px solid var(--border);border-radius:20px;overflow:hidden}
.profile-meta div{background:rgba(11,13,20,.72);padding:18px}
.profile-meta strong{display:block;font-family:var(--h);font-size:20px;color:var(--t1);margin-bottom:4px}
.profile-meta span{font-size:11.5px;color:var(--t3);line-height:1.5}

/* Horizontal Scroll Layout */
.h-scroll-section{margin-top:98px;overflow:hidden}
.h-scroll-head{display:flex;justify-content:space-between;align-items:end;gap:22px;margin-bottom:28px}
.h-track{
  display:flex;
  gap:18px;
  overflow-x:auto;
  scroll-snap-type:x mandatory;
  padding:4px 32px 18px;
  margin:0 -32px;
  scrollbar-width:thin;
}
.h-card{
  flex:0 0 min(430px,84vw);
  min-height:285px;
  border-radius:28px;
  padding:28px;
  border:1px solid var(--border);
  background:
    linear-gradient(145deg,rgba(16,19,29,.80),rgba(11,13,20,.62)),
    radial-gradient(circle at 80% 18%,rgba(59,130,246,.15),transparent 34%);
  scroll-snap-align:start;
  position:relative;
  overflow:hidden;
  transition:transform .25s,border-color .25s;
}
.h-card:hover{transform:translateY(-6px);border-color:var(--pri-mid)}
.h-card small{color:var(--sky);font-weight:850;letter-spacing:1.2px;text-transform:uppercase}
.h-card h4{font-family:var(--h);font-size:25px;font-weight:850;letter-spacing:-.8px;margin:16px 0 10px}
.h-card p{color:var(--t3);font-size:13.5px;line-height:1.8;max-width:320px}
.h-card i{position:absolute;right:26px;bottom:22px;color:rgba(96,165,250,.18);font-size:56px}

/* Z Pattern CTA */
.z-cta{
  margin-top:92px;
  padding:46px 0;
  display:grid;
  grid-template-columns:1fr auto;
  gap:40px;
  align-items:center;
}
.z-cta h2{
  font-family:var(--h);
  font-size:clamp(34px,5vw,64px);
  line-height:1;
  letter-spacing:-2.2px;
  max-width:760px;
}
.z-cta p{
  color:var(--t2);
  font-size:15.5px;
  line-height:1.8;
  margin-top:14px;
  max-width:560px;
}
.z-actions{display:flex;gap:10px;flex-wrap:wrap;justify-content:flex-end}



/* ===== RESTORED FULL FREELANCER PROFILE SECTION ===== */
.dashboard-profile-section{
  margin-top:96px;
  position:relative;
}
.dashboard-profile-shell{
  display:grid;
  grid-template-columns:.92fr 1.08fr;
  gap:22px;
  align-items:stretch;
}
.profile-showcase,
.profile-details-grid .profile-detail-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(11,13,20,.56));
  border-radius:30px;
  position:relative;
  overflow:hidden;
}
.profile-showcase{
  padding:34px;
  min-height:100%;
}
.profile-showcase::before,
.profile-details-grid .profile-detail-card::before{
  content:"";
  position:absolute;
  inset:auto -34% -44% -34%;
  height:190px;
  background:radial-gradient(circle,var(--pri-glow),transparent 66%);
  pointer-events:none;
}
.profile-showcase-top{
  position:relative;
  display:flex;
  gap:24px;
  align-items:center;
  margin-bottom:26px;
}
.profile-photo,
.profile-photo-fallback{
  width:126px;
  height:126px;
  min-width:126px;
  border-radius:34px;
  border:1px solid var(--pri-mid);
  background:rgba(59,130,246,.10);
  box-shadow:0 26px 60px rgba(59,130,246,.18);
}
.profile-photo{
  object-fit:cover;
}
.profile-photo-fallback{
  display:flex;
  align-items:center;
  justify-content:center;
  color:white;
  font-family:var(--h);
  font-size:42px;
  font-weight:900;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
}
.profile-main-info{
  min-width:0;
}
.profile-main-info h3{
  font-family:var(--h);
  font-size:clamp(30px,3.3vw,46px);
  line-height:1;
  font-weight:900;
  letter-spacing:-1.7px;
  margin-bottom:8px;
}
.profile-main-info .profile-title{
  display:block;
  color:var(--sky);
  font-family:var(--h);
  font-size:15px;
  font-weight:800;
  letter-spacing:.01em;
  margin-bottom:13px;
}
.profile-contact-line{
  display:flex;
  flex-wrap:wrap;
  gap:9px;
}
.profile-contact-line span{
  display:inline-flex;
  align-items:center;
  gap:7px;
  color:var(--t3);
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:999px;
  padding:7px 10px;
  font-size:12px;
  font-weight:700;
}
.profile-contact-line i{
  color:var(--cyan);
}
.profile-rating-row{
  position:relative;
  display:flex;
  flex-wrap:wrap;
  align-items:center;
  gap:10px;
  margin:20px 0 24px;
}
.profile-rating-pill{
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:10px 13px;
  border-radius:999px;
  color:#FDE68A;
  background:rgba(245,158,11,.10);
  border:1px solid rgba(245,158,11,.22);
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
}
.profile-rating-pill span{
  color:var(--t2);
  font-weight:700;
  opacity:.9;
}
.profile-live-pill{
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:10px 13px;
  border-radius:999px;
  color:var(--cyan);
  background:rgba(34,211,238,.08);
  border:1px solid rgba(34,211,238,.18);
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
}
.profile-live-pill::before{
  content:"";
  width:8px;
  height:8px;
  border-radius:99px;
  background:var(--cyan);
  box-shadow:0 0 0 0 rgba(34,211,238,.35);
  animation:pulseDot 1.9s ease infinite;
}
.profile-summary-text{
  position:relative;
  color:var(--t2);
  font-size:14px;
  line-height:1.85;
  margin-bottom:24px;
}
.profile-actions{
  position:relative;
  display:flex;
  gap:10px;
  flex-wrap:wrap;
}
.profile-action-primary,
.profile-action-secondary{
  min-height:44px;
  padding:0 16px;
  border-radius:12px;
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:all .2s;
}
.profile-action-primary{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
}
.profile-action-primary:hover{
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.26);
}
.profile-action-secondary{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.profile-action-secondary:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.05);
  transform:translateY(-2px);
}
.profile-details-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:16px;
}
.profile-detail-card{
  padding:26px;
}
.profile-detail-card.wide{
  grid-column:1 / -1;
}
.profile-detail-card h4{
  position:relative;
  font-family:var(--h);
  font-size:18px;
  font-weight:900;
  letter-spacing:-.45px;
  margin-bottom:13px;
  display:flex;
  align-items:center;
  gap:9px;
}
.profile-detail-card h4 i{
  color:var(--sky);
}
.profile-detail-text{
  position:relative;
  color:var(--t3);
  font-size:13.5px;
  line-height:1.8;
}
.profile-skills{
  position:relative;
  display:flex;
  gap:8px;
  flex-wrap:wrap;
}
.profile-skill-chip{
  display:inline-flex;
  align-items:center;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  color:var(--t2);
  border-radius:999px;
  padding:8px 11px;
  font-size:12.5px;
  font-weight:750;
}
.profile-stat-list{
  position:relative;
  display:grid;
  gap:1px;
  border:1px solid var(--border);
  background:var(--border);
  border-radius:18px;
  overflow:hidden;
}
.profile-stat-row{
  background:rgba(11,13,20,.72);
  padding:15px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
}
.profile-stat-row span{
  color:var(--t3);
  font-size:12.5px;
  font-weight:750;
}
.profile-stat-row strong{
  color:var(--t1);
  font-family:var(--h);
  font-size:18px;
  font-weight:900;
}
.profile-readiness{
  position:relative;
  margin-top:16px;
}
.profile-readiness-top{
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:12px;
  margin-bottom:9px;
}
.profile-readiness-top span{
  color:var(--t3);
  font-size:12px;
  font-weight:800;
  text-transform:uppercase;
  letter-spacing:1px;
}
.profile-readiness-top strong{
  color:var(--sky);
  font-family:var(--h);
}
.profile-readiness-track{
  height:8px;
  border-radius:999px;
  background:rgba(255,255,255,.07);
  overflow:hidden;
}
.profile-readiness-fill{
  display:block;
  height:100%;
  width:var(--profile-ready);
  border-radius:999px;
  background:linear-gradient(90deg,var(--pri),var(--cyan));
  transform-origin:left;
  transform:scaleX(0);
}
.dashboard-profile-section.v .profile-readiness-fill,
.profile-detail-card.v .profile-readiness-fill{
  animation:growLine 1.2s cubic-bezier(.16,1,.3,1) forwards;
}

@media(max-width:1120px){
  .dashboard-profile-shell{
    grid-template-columns:1fr;
  }
}
@media(max-width:760px){
  .profile-showcase-top{
    align-items:flex-start;
    flex-direction:column;
  }
  .profile-details-grid{
    grid-template-columns:1fr;
  }
  .profile-detail-card.wide{
    grid-column:auto;
  }
  .profile-photo,
  .profile-photo-fallback{
    width:112px;
    height:112px;
    min-width:112px;
    border-radius:28px;
  }
}

/* ===== EXTRA PROFESSIONAL SECTIONS ===== */
.quality-section{
  margin-top:96px;
  display:grid;
  grid-template-columns:.9fr 1.1fr;
  gap:42px;
  align-items:start;
}
.quality-copy{position:sticky;top:104px}
.quality-grid{display:grid;gap:14px}
.quality-row{
  display:grid;
  grid-template-columns:54px 1fr 92px;
  gap:16px;
  align-items:center;
  padding:20px 0;
  position:relative;
}
.quality-row::after{
  content:"";
  position:absolute;
  left:70px;
  right:0;
  bottom:0;
  height:1px;
  background:linear-gradient(90deg,rgba(255,255,255,.07),transparent);
}
.quality-icon{
  width:54px;height:54px;border-radius:18px;
  display:flex;align-items:center;justify-content:center;
  border:1px solid var(--border);
  background:rgba(255,255,255,.04);
  color:var(--sky);
}
.quality-row h4{font-family:var(--h);font-size:17px;font-weight:850;letter-spacing:-.4px;margin-bottom:5px}
.quality-row p{color:var(--t3);font-size:13px;line-height:1.65;margin:0}
.quality-score{justify-self:end;font-family:var(--h);font-size:22px;font-weight:900;color:var(--cyan)}
.brief-strip{
  margin-top:90px;
  display:grid;
  grid-template-columns:1.15fr .85fr;
  gap:24px;
  align-items:stretch;
}
.brief-panel{
  min-height:330px;
  border-radius:34px;
  border:1px solid var(--border);
  background:
    linear-gradient(145deg,rgba(16,19,29,.78),rgba(11,13,20,.50)),
    radial-gradient(circle at 75% 20%,rgba(34,211,238,.13),transparent 36%);
  padding:34px;
  position:relative;
  overflow:hidden;
}
.brief-panel::before{
  content:"";
  position:absolute;inset:auto -30% -42% -30%;height:180px;
  background:radial-gradient(circle,var(--pri-glow),transparent 66%);
}
.brief-panel h3{position:relative;font-family:var(--h);font-size:38px;line-height:1.02;font-weight:900;letter-spacing:-1.4px;margin:8px 0 12px;max-width:600px}
.brief-panel p{position:relative;color:var(--t2);font-size:14px;line-height:1.8;max-width:620px}
.brief-points{position:relative;display:flex;gap:8px;flex-wrap:wrap;margin-top:26px}
.brief-points span{border:1px solid var(--border);border-radius:999px;padding:8px 11px;color:var(--t2);font-size:12px;font-weight:750;background:rgba(255,255,255,.035)}
.brief-side{
  display:grid;
  gap:1px;
  border:1px solid var(--border);
  background:var(--border);
  border-radius:30px;
  overflow:hidden;
}
.brief-side a{
  min-height:110px;
  background:rgba(11,13,20,.68);
  padding:22px;
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:20px;
  transition:background .2s,transform .2s;
}
.brief-side a:hover{background:rgba(16,19,29,.90);transform:translateX(5px)}
.brief-side strong{display:block;font-family:var(--h);font-size:16px;font-weight:850;margin-bottom:6px;color:var(--t1)}
.brief-side span{display:block;color:var(--t3);font-size:12.5px;line-height:1.6}
.brief-side i{color:var(--sky)}
.footer-pro{
  position:relative;
  margin-top:30px;
  padding:0 0 48px;
  overflow:hidden;
}
.footer-pro::before{
  content:"";
  position:absolute;
  left:0;right:0;top:0;height:1px;
  background:linear-gradient(90deg,transparent,rgba(96,165,250,.22),transparent);
}
.footer-hero{
  padding:54px 0 38px;
  display:grid;
  grid-template-columns:1.1fr .9fr;
  gap:32px;
  align-items:end;
}
.footer-brand h2{
  font-family:var(--h);
  font-size:clamp(34px,4.5vw,64px);
  line-height:1;
  font-weight:900;
  letter-spacing:-2.3px;
  max-width:720px;
}
.footer-brand h2 span{color:var(--sky)}
.footer-brand p{color:var(--t2);line-height:1.8;max-width:560px;margin-top:16px;font-size:14.5px}
.footer-cta{display:flex;gap:10px;justify-content:flex-end;flex-wrap:wrap}
.footer-grid{
  display:grid;
  grid-template-columns:1.2fr repeat(3,1fr);
  gap:1px;
  border:1px solid var(--border);
  background:var(--border);
  border-radius:28px;
  overflow:hidden;
}
.footer-cell{
  background:rgba(11,13,20,.70);
  padding:26px;
  min-height:190px;
}
.footer-logo{font-family:var(--h);font-size:22px;font-weight:900;letter-spacing:-.8px;margin-bottom:10px}.footer-logo span{color:var(--pri)}
.footer-cell p{color:var(--t3);font-size:13px;line-height:1.75;max-width:310px}
.footer-cell h4{font-family:var(--h);font-size:13px;font-weight:900;letter-spacing:1.2px;text-transform:uppercase;color:var(--sky);margin-bottom:14px}
.footer-cell a{display:block;color:var(--t3);font-size:13px;margin:10px 0;transition:color .2s,transform .2s}
.footer-cell a:hover{color:var(--t1);transform:translateX(4px)}
.footer-bottom{
  display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap;
  color:var(--t4);font-size:12px;padding-top:18px;
}
.footer-bottom b{color:var(--sky);font-family:var(--h)}
@media(max-width:1120px){
  .hero-workbench{min-height:auto;padding-left:0}
  .hero-workbench::before{inset:4% 0 4% 0}
  .workbench-flow,.workbench-stats,.workbench-note{margin-left:0;margin-right:0;width:100%;max-width:none}
  .workbench-top,.workbench-search{margin-left:0;padding-left:0}
  .quality-section,.brief-strip,.footer-hero{grid-template-columns:1fr}
  .quality-copy{position:relative;top:auto}
  .footer-cta{justify-content:flex-start}
  .footer-grid{grid-template-columns:1fr 1fr}
}
@media(max-width:760px){
  .workbench-search{grid-template-columns:38px 1fr;gap:4px;border-radius:22px;padding:13px}
  .workbench-search a{grid-column:1 / -1;justify-content:center;margin-top:6px}
  .workbench-row{grid-template-columns:42px 1fr}
  .workbench-row>i{display:none}
  .workbench-stats{grid-template-columns:1fr}
  .quality-row{grid-template-columns:48px 1fr}
  .quality-score{grid-column:2;justify-self:start}
  .footer-grid{grid-template-columns:1fr}
  .footer-bottom{display:block}
}

/* Footer */
.footer{
  padding:30px 0 42px;
  color:var(--t4);
  font-size:12px;
}
.footer-in{
  display:flex;
  justify-content:space-between;
  gap:16px;
  flex-wrap:wrap;
}
.footer b{color:var(--sky);font-family:var(--h)}
.footer a{color:var(--t3);margin-left:18px}
.footer a:hover{color:var(--t1)}

/* Animations */
.rv{opacity:0;transform:translateY(28px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}
.rv.v{opacity:1;transform:translateY(0)}
.zoom{opacity:0;transform:scale(.94);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}
.zoom.v{opacity:1;transform:scale(1)}
.left-in{opacity:0;transform:translateX(-34px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}
.left-in.v{opacity:1;transform:translateX(0)}
.right-in{opacity:0;transform:translateX(34px);transition:opacity .8s cubic-bezier(.16,1,.3,1),transform .8s cubic-bezier(.16,1,.3,1)}
.right-in.v{opacity:1;transform:translateX(0)}
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}.d4{transition-delay:.28s}.d5{transition-delay:.35s}

/* Responsive */
@media(max-width:1120px){
  .nav-m{display:none}.mbtn{display:block}.mob{display:block}
  .hero-grid{grid-template-columns:1fr;gap:38px}
  .hero-media{min-height:auto}
  .media-frame{height:560px}
  .tag-a{left:12px}.tag-b{right:12px}
  .metrics-grid{grid-template-columns:repeat(6,1fr)}
  .metric:nth-child(n){grid-column:span 2}
  .metric:nth-child(1){grid-column:span 3}
  .metric:nth-child(6){grid-column:span 3}
  .split-section,.asym-section{grid-template-columns:1fr}
  .sticky-panel{position:relative;top:auto}
}
@media(max-width:760px){
  .wrap,.nav-in{padding:0 20px}
  .nav-r{display:none}
  .hero{padding:108px 0 58px;min-height:auto}
  .hero-copy h1{letter-spacing:-2.2px}
  .hero-micro{grid-template-columns:1fr}
  .media-frame{height:auto;min-height:520px;border-radius:26px}
  .media-content{padding:24px}
  .float-tag{display:none}
  .workspace-head,.z-cta,.h-scroll-head{grid-template-columns:1fr;display:grid}
  .workspace-actions,.z-actions{justify-content:flex-start}
  .metrics-grid{grid-template-columns:1fr}
  .metric:nth-child(n){grid-column:auto}
  .lane{grid-template-columns:48px 1fr}
  .lane-link{grid-column:2;justify-self:start}
  .pipeline-item{grid-template-columns:38px 1fr}
  .pipeline-status{grid-column:2;justify-self:start;margin-top:10px}
  .profile-meta{grid-template-columns:1fr}
  .footer-in{display:block}
  .footer a{display:inline-block;margin:14px 14px 0 0}
}

/* ===== ANIMATION COMBINATION LAYER ===== */
.scroll-progress{
  position:fixed;
  top:0;
  left:0;
  height:2px;
  width:100%;
  transform:scaleX(0);
  transform-origin:left;
  background:linear-gradient(90deg,var(--pri),var(--cyan),var(--violet));
  z-index:3000;
  box-shadow:0 0 20px rgba(96,165,250,.34);
  pointer-events:none;
}

/* Hero Layout + Entrance Reveals */
.hero-copy .kicker,
.hero-copy h1,
.hero-copy p,
.hero-actions,
.hero-micro{
  opacity:0;
  transform:translateY(24px);
  animation:heroRise .9s cubic-bezier(.16,1,.3,1) forwards;
}
.hero-copy .kicker{animation-delay:.12s}
.hero-copy h1{animation-delay:.24s}
.hero-copy p{animation-delay:.36s}
.hero-actions{animation-delay:.48s}
.hero-micro{animation-delay:.60s}
.hero-media,
.hero-workbench{
  opacity:0;
  transform:translateX(28px) scale(.96);
  animation:mediaReveal 1s cubic-bezier(.16,1,.3,1) .36s forwards;
}
@keyframes heroRise{
  to{opacity:1;transform:translateY(0)}
}
@keyframes mediaReveal{
  to{opacity:1;transform:translateX(0) scale(1)}
}

/* Split-screen + Parallax/Asynchronous Scroll polish */
.split-section{
  position:relative;
}
.split-section::before{
  content:"";
  position:absolute;
  left:50%;
  top:-80px;
  width:1px;
  height:calc(100% + 160px);
  background:linear-gradient(to bottom,transparent,rgba(96,165,250,.18),transparent);
  opacity:.32;
  transform:translateX(-50%);
  pointer-events:none;
}
.sticky-panel{
  will-change:transform;
}
.action-lanes{
  transform:translateY(var(--lane-shift,0px));
  transition:transform .08s linear;
}

/* Card/Grid Layout + Hover Effects */
.metric,
.h-card,
.asym-main,
.asym-side{
  will-change:transform;
}
.metric::after,
.h-card::before,
.asym-main::after,
.asym-side::after{
  content:"";
  position:absolute;
  inset:0;
  background:linear-gradient(115deg,transparent 0%,rgba(255,255,255,.055) 42%,transparent 64%);
  transform:translateX(-120%);
  transition:transform .7s cubic-bezier(.16,1,.3,1);
  pointer-events:none;
}
.metric:hover::after,
.h-card:hover::before,
.asym-main:hover::after,
.asym-side:hover::after{
  transform:translateX(120%);
}

/* Z-Pattern + Scroll-Triggered Pathing */
.z-cta{
  position:relative;
  isolation:isolate;
}
.z-path-svg{
  position:absolute;
  left:0;
  right:0;
  top:-36px;
  width:100%;
  height:220px;
  z-index:-1;
  opacity:.82;
  pointer-events:none;
  overflow:visible;
}
.z-path{
  fill:none;
  stroke:url(#zGrad);
  stroke-width:2.2;
  stroke-linecap:round;
  stroke-dasharray:1;
  stroke-dashoffset:1;
  filter:drop-shadow(0 0 14px rgba(96,165,250,.22));
}

/* F-pattern + Sticky Navigation */
.nav{
  will-change:background,box-shadow;
}
.nav.s .nav-a.active{
  background:rgba(59,130,246,.11);
  color:var(--t1);
}

/* Single-column progress + reading feedback */
.section-title span,
.text-reveal .word{
  background:linear-gradient(90deg,var(--t1),var(--sky),var(--cyan));
  background-size:220% 100%;
  -webkit-background-clip:text;
  background-clip:text;
}
.text-reveal.active .word.mark{
  animation:textGlow 1.2s ease both;
}
@keyframes textGlow{
  0%{background-position:0% 0;text-shadow:none}
  100%{background-position:100% 0;text-shadow:0 0 28px rgba(96,165,250,.24)}
}

/* Horizontal scrolling with smooth snap feedback */
.h-track{
  scroll-behavior:smooth;
  mask-image:linear-gradient(90deg,transparent,black 5%,black 95%,transparent);
  -webkit-mask-image:linear-gradient(90deg,transparent,black 5%,black 95%,transparent);
}
.h-card{
  transform:translateY(18px) scale(.985);
}
.h-card.v{
  transform:translateY(0) scale(1);
}
.h-card:hover{
  transform:translateY(-8px) scale(1.015);
}

/* Scroll-scrub media feel */
.media-frame{
  will-change:transform,filter;
}
.media-frame.in{
  filter:saturate(1.08) contrast(1.02);
}

/* Seamless reveal variations */
.rv:nth-child(2n).v{transition-delay:.08s}
.rv:nth-child(3n).v{transition-delay:.14s}
.zoom.v{filter:saturate(1.05)}
.left-in.v,.right-in.v{
  transition-duration:.95s;
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce){
  *,
  *::before,
  *::after{
    animation-duration:.01ms!important;
    animation-iteration-count:1!important;
    transition-duration:.01ms!important;
    scroll-behavior:auto!important;
  }
  .scroll-progress{display:none}
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

long unreadCount = toLong(request.getAttribute("unreadNotificationCount"));
long totalBids = toLong(request.getAttribute("totalBids"));
long acceptedBids = toLong(request.getAttribute("acceptedBids"));
long assignedProjects = toLong(request.getAttribute("assignedProjects"));
long completedProjects = toLong(request.getAttribute("completedProjects"));
long winRate = totalBids > 0 ? Math.round((acceptedBids * 100.0) / totalBids) : 0;
long activeScore = Math.min(100, 55 + (assignedProjects * 8) + (completedProjects * 5));

FreelancerProfileModel profile = (FreelancerProfileModel) request.getAttribute("profile");
Double avgRatingObj = (Double) request.getAttribute("avgRating");
Long totalReviewsObj = (Long) request.getAttribute("totalReviews");

double avgRating = avgRatingObj != null ? avgRatingObj.doubleValue() : 0.0;
long totalReviews = totalReviewsObj != null ? totalReviewsObj.longValue() : 0L;

String professionalTitle = "Professional Freelancer";
String profileBio = "No bio added yet.";
String profileSkills = "";
int experienceYears = 0;
Object hourlyRate = 0;
String profileImage = "";

if(profile != null){
    if(profile.getProfessionalTitle() != null && !profile.getProfessionalTitle().trim().isEmpty()){
        professionalTitle = profile.getProfessionalTitle();
    }
    if(profile.getBio() != null && !profile.getBio().trim().isEmpty()){
        profileBio = profile.getBio();
    }
    if(profile.getSkills() != null && !profile.getSkills().trim().isEmpty()){
        profileSkills = profile.getSkills();
    }
    experienceYears = profile.getExperienceYears();
    hourlyRate = profile.getHourlyRate();
    if(profile.getProfileImage() != null && !profile.getProfileImage().trim().isEmpty()){
        profileImage = profile.getProfileImage();
    }
}

long profileReadyScore = 35;
if(profile != null){
    if(!"Professional Freelancer".equals(professionalTitle)) profileReadyScore += 15;
    if(!"No bio added yet.".equals(profileBio)) profileReadyScore += 20;
    if(profileSkills != null && !profileSkills.trim().isEmpty()) profileReadyScore += 15;
    if(experienceYears > 0) profileReadyScore += 8;
    if(!String.valueOf(hourlyRate).equals("0")) profileReadyScore += 7;
}
if(profileReadyScore > 100) profileReadyScore = 100;
%>

<div class="parallax-orb orb-a" data-speed="0.12"></div>
<div class="parallax-orb orb-b" data-speed="-0.09"></div>
<div class="scroll-progress" id="scrollProgress"></div>

<nav class="nav" id="nav">
  <div class="nav-in">
    <a href="freelancerDashboard" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>

    <div class="nav-m">
      <a href="freelancerDashboard" class="nav-a active">Dashboard</a>
      <a href="viewAllProjects" class="nav-a">Explore Projects</a>
      <a href="savedProjects" class="nav-a"><i class="fa-solid fa-bookmark"></i> Saved</a>
      <a href="myProposals" class="nav-a">My Proposals</a>
      <a href="freelancerAssignedProjects" class="nav-a">Assigned</a>
      <a href="freelancerEarnings" class="nav-a"><i class="fa-solid fa-wallet"></i> Earnings</a>
      <a href="freelancerNotifications" class="nav-a">
        Notifications
        <% if(unreadCount > 0){ %>
          <span class="nav-badge"><%= unreadCount %></span>
        <% } %>
      </a>
    </div>

    <div class="nav-r">
      <a href="freelancerNotifications" class="btn-o">
        <i class="fa-regular fa-bell"></i>
        Alerts
        <% if(unreadCount > 0){ %>
          <span class="nav-badge"><%= unreadCount %></span>
        <% } %>
      </a>
      <a href="freelancerLogout" class="btn-p"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
    </div>

    <button class="mbtn" id="mbtn"><i class="fa-solid fa-bars"></i></button>
  </div>
</nav>

<div class="mob" id="mob">
  <div class="mob-p">
    <button class="mob-x" id="mobx"><i class="fa-solid fa-xmark"></i></button>
    <a href="freelancerDashboard">Dashboard</a>
    <a href="viewAllProjects">Explore Projects</a>
    <a href="savedProjects">Saved Projects</a>
    <a href="myProposals">My Proposals</a>
    <a href="freelancerAssignedProjects">Assigned Projects</a>
   <a href="freelancerEarnings">Earnings</a>
    <a href="viewFreelancerProfile">My Profile</a>
    <a href="freelancerReviews">My Reviews</a>
    <a href="freelancerNotifications">
      Notifications
      <% if(unreadCount > 0){ %>
        (<%= unreadCount %>)
      <% } %>
    </a>
    <div class="mob-b">
      <a href="freelancerLogout" class="btn-p" style="justify-content:center">Logout</a>
    </div>
  </div>
</div>

<main class="page">

  <section class="hero">
    <div class="wrap hero-grid">
      <div class="hero-copy left-in">
        <div class="kicker"><i class="fa-solid fa-sparkles"></i> Freelancer command center</div>
        <h1>Win better projects with a <em>professional freelance workflow</em>.</h1>
        <p>
          Welcome back, <strong><%= freelancer.getName() %></strong>. Explore projects, submit sharper proposals,
          manage assigned work, track notifications, and build your reputation from one premium WorkSphere dashboard.
        </p>

        <div class="hero-actions">
          <a href="viewAllProjects" class="hero-primary"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
          <a href="myProposals" class="hero-secondary"><i class="fa-solid fa-paper-plane"></i> My Proposals</a>
          <a href="savedProjects" class="hero-secondary"><i class="fa-solid fa-bookmark"></i> Saved Projects</a>
          <a href="freelancerAssignedProjects" class="hero-secondary"><i class="fa-solid fa-diagram-project"></i> Assigned Work</a>
        <!-- <a href="freelancerEarnings" class="hero-secondary"><i class="fa-solid fa-wallet"></i> Earnings</a> -->
          <a href="freelancerEarnings" class="hero-secondary"><i class="fa-solid fa-wallet"></i> Earnings</a>
          <a href="freelancerNotifications" class="hero-secondary">
            <i class="fa-regular fa-bell"></i> Notifications
            <% if(unreadCount > 0){ %>
              (<%= unreadCount %>)
            <% } %>
          </a>
        </div>

        <div class="hero-micro zoom d1">
          <div class="micro">
            <b><span class="count-up" data-target="<%= totalBids %>">0</span></b>
            <small>Total proposals submitted from your account</small>
          </div>
          <div class="micro">
            <b><span class="count-up" data-target="<%= acceptedBids %>">0</span></b>
            <small>Accepted bids converted into real work</small>
          </div>
          <div class="micro">
            <b><span class="count-up" data-target="<%= unreadCount %>">0</span></b>
            <small>Unread freelancer notifications</small>
          </div>
        </div>
      </div>

      <aside class="hero-workbench right-in d1" aria-label="Freelancer dashboard quick workspace">
        <div class="workbench-top">
          <div>
            <span class="workbench-eyebrow">Today&apos;s workspace</span>
            <h3>Find, pitch, deliver.</h3>
          </div>
          <div class="workbench-avatar"><%= firstLetter %></div>
        </div>

        <div class="workbench-search">
          <i class="fa-solid fa-magnifying-glass"></i>
          <span>Search project opportunities and proposal actions</span>
          <a href="viewAllProjects">Start</a>
        </div>

        <div class="workbench-flow">
          <a href="viewAllProjects" class="workbench-row zoom d1">
            <span class="wb-num">01</span>
            <div>
              <strong>Discover matching projects</strong>
              <small>Browse client briefs, budgets, skills, and timelines.</small>
            </div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
          <a href="myProposals" class="workbench-row zoom d2">
            <span class="wb-num">02</span>
            <div>
              <strong>Review proposal performance</strong>
              <small>Track sent bids, accepted bids, and client responses.</small>
            </div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
          <a href="freelancerAssignedProjects" class="workbench-row zoom d3">
            <span class="wb-num">03</span>
            <div>
              <strong>Deliver assigned projects</strong>
              <small>Open accepted work and move it toward client approval.</small>
            </div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>

        <div class="workbench-stats">
          <div><b><span class="count-up" data-target="<%= acceptedBids %>">0</span></b><small>Accepted</small></div>
          <div><b><span class="count-up" data-target="<%= assignedProjects %>">0</span></b><small>Assigned</small></div>
          <div><b><span class="count-up" data-target="<%= unreadCount %>">0</span></b><small>Alerts</small></div>
        </div>

        <div class="workbench-note">
          <i class="fa-solid fa-wand-magic-sparkles"></i>
          <p>Stronger proposals win stronger clients. Lead with value, timeline clarity, and proof of skill.</p>
        </div>
      </aside>
    </div>
  </section>

  <section class="dashboard-body">
    <div class="wrap">
      <div class="workspace-head rv">
        <div>
          <div class="section-kicker">Dashboard Overview</div>
          <h2 class="section-title">Your freelance workspace, arranged for fast action.</h2>
          <p class="section-copy">
            The top row shows proposal health, assigned work, completion progress, and account signals so you can quickly decide where to focus next.
          </p>
        </div>
        <div class="workspace-actions">
          <a href="viewAllProjects" class="section-btn primary"><i class="fa-solid fa-briefcase"></i> Find Work</a>
          <a href="myProposals" class="section-btn"><i class="fa-solid fa-paper-plane"></i> Track Bids</a>
        </div>
      </div>

      <div class="metrics-grid">
        <div class="metric rv d1" style="--w:86%">
          <div class="metric-icon"><i class="fa-solid fa-gavel"></i></div>
          <div class="metric-label">Total Bids</div>
          <div class="metric-value count-up" data-target="<%= totalBids %>">0</div>
          <div class="metric-note">All proposals submitted from your freelancer account.</div>
          <div class="meter"><span></span></div>
        </div>

        <div class="metric rv d2" style="--w:64%">
          <div class="metric-icon"><i class="fa-solid fa-check"></i></div>
          <div class="metric-label">Accepted Bids</div>
          <div class="metric-value count-up" data-target="<%= acceptedBids %>">0</div>
          <div class="metric-note">Proposals approved by clients.</div>
          <div class="meter"><span></span></div>
        </div>

        <div class="metric rv d3" style="--w:72%">
          <div class="metric-icon"><i class="fa-solid fa-diagram-project"></i></div>
          <div class="metric-label">Assigned Projects</div>
          <div class="metric-value count-up" data-target="<%= assignedProjects %>">0</div>
          <div class="metric-note">Work currently assigned for delivery.</div>
          <div class="meter"><span></span></div>
        </div>

        <div class="metric rv d4" style="--w:82%">
          <div class="metric-icon"><i class="fa-solid fa-circle-check"></i></div>
          <div class="metric-label">Completed</div>
          <div class="metric-value count-up" data-target="<%= completedProjects %>">0</div>
          <div class="metric-note">Finished projects approved by clients.</div>
          <div class="meter"><span></span></div>
        </div>

        <div class="metric rv d5" style="--w:<%= winRate %>%">
          <div class="metric-icon"><i class="fa-solid fa-chart-line"></i></div>
          <div class="metric-label">Win Rate</div>
          <div class="metric-value"><span class="count-up" data-target="<%= winRate %>">0</span>%</div>
          <div class="metric-note">Accepted bids compared to total proposals.</div>
          <div class="meter"><span></span></div>
        </div>

        <div class="metric rv d5" style="--w:46%">
          <div class="metric-icon"><i class="fa-regular fa-bell"></i></div>
          <div class="metric-label">Alerts</div>
          <div class="metric-value count-up" data-target="<%= unreadCount %>">0</div>
          <div class="metric-note">Unread bid, project, and review notifications.</div>
          <div class="meter"><span></span></div>
        </div>
      </div>

      <section class="split-section">
        <div class="sticky-panel left-in">
          <div class="big-number">01</div>
          <div class="section-kicker">Freelancer Flow</div>
          <h2 class="section-title text-reveal" id="textReveal">
            <span class="word mark">Find</span>
            <span class="word">the</span>
            <span class="word mark">right</span>
            <span class="word">projects,</span>
            <span class="word">send</span>
            <span class="word mark">stronger</span>
            <span class="word">proposals,</span>
            <span class="word">and</span>
            <span class="word mark">deliver</span>
            <span class="word">with clarity.</span>
          </h2>
          <p class="section-copy" style="margin-top:18px">
            This section mirrors the client dashboard interaction pattern but focuses on the freelancer journey from discovery to delivery.
          </p>
        </div>

        <div class="action-lanes right-in d1">
          <a href="viewAllProjects" class="lane rv d1">
            <div class="lane-icon"><i class="fa-solid fa-crosshairs"></i></div>
            <div>
              <h4>Discover projects that fit your skills</h4>
              <p>Search available projects and prioritize briefs where your skill set creates a strong match.</p>
            </div>
            <span class="lane-link"><i class="fa-solid fa-arrow-right"></i></span>
          </a>

          <a href="myProposals" class="lane rv d2">
            <div class="lane-icon"><i class="fa-solid fa-paper-plane"></i></div>
            <div>
              <h4>Manage proposals like a sales pipeline</h4>
              <p>Review bids you sent, client decisions, and opportunities that need better follow-up.</p>
            </div>
            <span class="lane-link"><i class="fa-solid fa-arrow-right"></i></span>
          </a>

          <a href="freelancerAssignedProjects" class="lane rv d3">
            <div class="lane-icon"><i class="fa-solid fa-check-double"></i></div>
            <div>
              <h4>Continue assigned work</h4>
              <p>Open active projects, submit deliverables, and keep client expectations organized.</p>
            </div>
            <span class="lane-link"><i class="fa-solid fa-arrow-right"></i></span>
          </a>

          <a href="freelancerReviews" class="lane rv d4">
            <div class="lane-icon"><i class="fa-solid fa-star"></i></div>
            <div>
              <h4>Build reputation signals</h4>
              <p>Use reviews and completed work to improve trust before future clients hire you.</p>
            </div>
            <span class="lane-link"><i class="fa-solid fa-arrow-right"></i></span>
          </a>
        </div>
      </section>

      <section class="asym-section">
        <div class="asym-main zoom">
          <div class="board-top">
            <div>
              <div class="section-kicker">Freelancer Pipeline</div>
              <h3>From project discovery to client approval.</h3>
            </div>
            <p>This keeps the client-dashboard layout language but changes the content for bidding, accepted work, delivery, reviews, and profile growth.</p>
          </div>

          <div class="pipeline-list">
            <div class="pipeline-item active rv d1">
              <div class="pipeline-num">01</div>
              <div><h4>Find opportunities</h4><p>Explore fresh client projects and shortlist work that fits your skills and availability.</p></div>
              <div class="pipeline-status">Start here</div>
            </div>

            <div class="pipeline-item active rv d2">
              <div class="pipeline-num">02</div>
              <div><h4>Send proposal</h4><p>Submit a focused bid with budget, timeline, proof, and client-focused value.</p></div>
              <div class="pipeline-status">Active</div>
            </div>

            <div class="pipeline-item rv d3">
              <div class="pipeline-num">03</div>
              <div><h4>Win project</h4><p>Accepted bids move into assigned projects where delivery work begins.</p></div>
              <div class="pipeline-status">Decision</div>
            </div>

            <div class="pipeline-item rv d4">
              <div class="pipeline-num">04</div>
              <div><h4>Submit work</h4><p>Upload deliverables, respond to feedback, and manage revision requests professionally.</p></div>
              <div class="pipeline-status">Delivery</div>
            </div>

            <div class="pipeline-item rv d5">
              <div class="pipeline-num">05</div>
              <div><h4>Earn review</h4><p>Complete work, build trust, and strengthen your freelancer profile for future projects.</p></div>
              <div class="pipeline-status">Growth</div>
            </div>
          </div>
        </div>

        <div class="asym-side right-in d2">
          <div>
            <div class="profile-face"><%= firstLetter %></div>
            <div class="section-kicker">Freelancer Profile</div>
            <h3><%= freelancer.getName() %></h3>
            <p>Your freelancer workspace is active. Strong proposals, reliable delivery, and consistent communication improve your chances of winning projects.</p>
          </div>

          <div class="profile-meta">
            <div>
              <strong><span class="count-up" data-target="<%= completedProjects %>">0</span></strong>
              <span>Completed projects</span>
            </div>
            <div>
              <strong><span class="count-up" data-target="<%= acceptedBids %>">0</span></strong>
              <span>Accepted bid signals</span>
            </div>
            <div>
              <strong><span class="count-up" data-target="<%= activeScore %>">0</span>%</strong>
              <span>Profile activity level</span>
            </div>
            <div>
              <strong>Live</strong>
              <span>Verified freelancer status</span>
            </div>
          </div>
        </div>
      </section>


      <section class="dashboard-profile-section rv" id="freelancerProfilePreview" style="--profile-ready:<%= profileReadyScore %>%">
        <div class="section-kicker">Freelancer Profile</div>
        <h2 class="section-title">Your profile proof is back inside the dashboard.</h2>
        <p class="section-copy" style="margin-top:14px;margin-bottom:30px">
          This section restores your full freelancer profile overview so you can quickly check profile image, title,
          rating, reviews, bio, skills, experience, and hourly rate without leaving the dashboard.
        </p>

        <div class="dashboard-profile-shell">
          <div class="profile-showcase zoom d1">
            <div class="profile-showcase-top">
              <div>
                <% if(profileImage != null && !profileImage.trim().equals("")){ %>
                  <img src="<%= profileImage %>" class="profile-photo" alt="Profile Image">
                <% } else { %>
                  <div class="profile-photo-fallback"><%= firstLetter %></div>
                <% } %>
              </div>

              <div class="profile-main-info">
                <h3><%= freelancer != null ? freelancer.getName() : "Freelancer Profile" %></h3>
                <span class="profile-title"><%= professionalTitle %></span>

                <div class="profile-contact-line">
                  <% if(freelancer != null && freelancer.getEmail() != null){ %>
                    <span><i class="fa-solid fa-envelope"></i><%= freelancer.getEmail() %></span>
                  <% } %>
                  <% if(freelancer != null && freelancer.getCity() != null){ %>
                    <span><i class="fa-solid fa-location-dot"></i><%= freelancer.getCity() %></span>
                  <% } %>
                </div>
              </div>
            </div>

            <div class="profile-rating-row">
              <span class="profile-rating-pill">
                <i class="fa-solid fa-star"></i>
                <%= String.format("%.1f", avgRating) %> Rating
                <span>| <%= totalReviews %> Reviews</span>
              </span>
              <span class="profile-live-pill">Profile Active</span>
            </div>

            <p class="profile-summary-text"><%= profileBio %></p>

            <div class="profile-actions">
              <a href="editFreelancerProfile" class="profile-action-primary">
                <i class="fa-solid fa-pen-to-square"></i>Edit Profile
              </a>
              <a href="viewFreelancerProfile" class="profile-action-secondary">
                <i class="fa-solid fa-eye"></i>View Full Profile
              </a>
              <a href="freelancerReviews" class="profile-action-secondary">
                <i class="fa-solid fa-star"></i>View Reviews
              </a>
            </div>
          </div>

          <div class="profile-details-grid">
            <div class="profile-detail-card rv d1">
              <h4><i class="fa-solid fa-user"></i> About Me</h4>
              <div class="profile-detail-text"><%= profileBio %></div>
            </div>

            <div class="profile-detail-card rv d2">
              <h4><i class="fa-solid fa-chart-line"></i> Professional Details</h4>
              <div class="profile-stat-list">
                <div class="profile-stat-row">
                  <span>Experience</span>
                  <strong><%= experienceYears %> years</strong>
                </div>
                <div class="profile-stat-row">
                  <span>Hourly Rate</span>
                  <strong>₹ <%= hourlyRate %> / hour</strong>
                </div>
                <div class="profile-stat-row">
                  <span>Total Reviews</span>
                  <strong><%= totalReviews %></strong>
                </div>
              </div>
            </div>

            <div class="profile-detail-card wide rv d3">
              <h4><i class="fa-solid fa-code"></i> Skills</h4>
              <div class="profile-skills">
                <%
                if(profileSkills != null && !profileSkills.trim().equals("")){
                    String[] skills = profileSkills.split(",");
                    for(String skill : skills){
                        if(skill != null && !skill.trim().equals("")){
                %>
                  <span class="profile-skill-chip"><%= skill.trim() %></span>
                <%
                        }
                    }
                } else {
                %>
                  <span class="profile-skill-chip">No skills added yet</span>
                <%
                }
                %>
              </div>

              <div class="profile-readiness">
                <div class="profile-readiness-top">
                  <span>Profile Readiness</span>
                  <strong><%= profileReadyScore %>%</strong>
                </div>
                <div class="profile-readiness-track">
                  <span class="profile-readiness-fill"></span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="h-scroll-section">
        <div class="h-scroll-head rv">
          <div>
            <div class="section-kicker">Horizontal Workspace</div>
            <h2 class="section-title">Freelancer tools arranged like a modern work desk.</h2>
          </div>
          <p class="section-copy">Scroll sideways through the most useful freelancer actions while the page keeps the same animated dashboard rhythm.</p>
        </div>

        <div class="h-track">
          <a href="viewAllProjects" class="h-card rv d1">
            <small>Opportunity Radar</small>
            <h4>Find projects that match your skills</h4>
            <p>Use this when you want to discover new work and submit fresh proposals.</p>
            <i class="fa-solid fa-magnifying-glass-chart"></i>
          </a>

          <a href="myProposals" class="h-card rv d2">
            <small>Proposal Desk</small>
            <h4>Review every bid you sent</h4>
            <p>Track accepted proposals, pending decisions, and rejected bids in one flow.</p>
            <i class="fa-solid fa-paper-plane"></i>
          </a>

          <a href="freelancerAssignedProjects" class="h-card rv d3">
            <small>Delivery Studio</small>
            <h4>Continue assigned work</h4>
            <p>Open active work, prepare deliverables, and submit files to clients.</p>
            <i class="fa-solid fa-cloud-arrow-up"></i>
          </a>

          <a href="savedProjects" class="h-card rv d4">
            <small>Saved Opportunities</small>
            <h4>Apply later from your shortlist</h4>
            <p>Bookmark interesting open projects and return when you are ready to submit a strong proposal.</p>
            <i class="fa-solid fa-bookmark"></i>
          </a>

          <a href="freelancerEarnings" class="h-card rv d4">
            <small>Escrow & Earnings</small>
            <h4>Track funded and released payments</h4>
            <p>See escrow-funded projects, released payments, platform fees, and your freelancer earnings history.</p>
            <i class="fa-solid fa-wallet"></i>
          </a>

          <a href="freelancerReviews" class="h-card rv d4">
            <small>Reputation</small>
            <h4>Strengthen your profile proof</h4>
            <p>Reviews and completed projects make future proposals more believable.</p>
            <i class="fa-solid fa-star"></i>
          </a>

          <a href="viewFreelancerProfile" class="h-card rv d5">
            <small>Profile Polish</small>
            <h4>Improve your public freelancer profile</h4>
            <p>Keep your skills, bio, portfolio, GitHub, and LinkedIn ready for clients.</p>
            <i class="fa-solid fa-user-pen"></i>
          </a>
        </div>
      </section>

      <section class="quality-section">
        <div class="quality-copy left-in">
          <div class="big-number">02</div>
          <div class="section-kicker">Freelancer Growth System</div>
          <h2 class="section-title text-reveal">
            Improve the signals that help <span>clients choose you</span> faster.
          </h2>
          <p class="section-copy" style="margin-top:18px">
            Professional freelancer dashboards guide you toward better proposals, stronger proof, faster delivery, and reputation growth.
          </p>
        </div>

        <div class="quality-grid right-in d1">
          <div class="quality-row rv d1">
            <div class="quality-icon"><i class="fa-solid fa-id-badge"></i></div>
            <div><h4>Profile clarity</h4><p>Make skills, bio, portfolio, GitHub, and LinkedIn easy for clients to trust.</p></div>
            <div class="quality-score">90%</div>
          </div>
          <div class="quality-row rv d2">
            <div class="quality-icon"><i class="fa-solid fa-bullseye"></i></div>
            <div><h4>Proposal quality</h4><p>Connect your skills directly to the client’s requirements and business outcome.</p></div>
            <div class="quality-score">84%</div>
          </div>
          <div class="quality-row rv d3">
            <div class="quality-icon"><i class="fa-solid fa-clock"></i></div>
            <div><h4>Delivery discipline</h4><p>Submit work on time, communicate clearly, and handle revision requests calmly.</p></div>
            <div class="quality-score">78%</div>
          </div>
          <div class="quality-row rv d4">
            <div class="quality-icon"><i class="fa-solid fa-star-half-stroke"></i></div>
            <div><h4>Review readiness</h4><p>Completed work and good client reviews increase trust for future proposals.</p></div>
            <div class="quality-score">72%</div>
          </div>
        </div>
      </section>

      <section class="brief-strip">
        <div class="brief-panel zoom">
          <div class="section-kicker">Proposal Studio</div>
          <h3>Turn a project brief into a proposal clients can say yes to.</h3>
          <p>Use this as a freelancer-side checklist before bidding: match the scope, mention relevant proof, set realistic pricing, explain your timeline, and show how you will reduce client risk.</p>
          <div class="brief-points">
            <span>Scope Match</span><span>Proof</span><span>Budget</span><span>Timeline</span><span>Portfolio</span><span>Client Value</span>
          </div>
        </div>
        <div class="brief-side right-in d2">
          <a href="viewAllProjects">
            <div><strong>Find a matching project</strong><span>Browse available work before writing a proposal.</span></div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
          <a href="myProposals">
            <div><strong>Review sent proposals</strong><span>Track bid status and improve your next pitch.</span></div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
          <a href="freelancerAssignedProjects">
            <div><strong>Continue active delivery</strong><span>Open accepted work and prepare submissions.</span></div>
            <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
      </section>

      <section class="quality-section">
        <div class="quality-copy left-in">
          <div class="big-number">03</div>
          <div class="section-kicker">Freelancer Market Intel</div>
          <h2 class="section-title text-reveal">
            Keep your pipeline active with <span>smart weekly habits</span>.
          </h2>
          <p class="section-copy" style="margin-top:18px">
            A premium freelancer dashboard should not only show stats; it should help you decide what to do next.
          </p>
        </div>

        <div class="quality-grid right-in d1">
          <div class="quality-row rv d1">
            <div class="quality-icon"><i class="fa-solid fa-calendar-days"></i></div>
            <div><h4>Weekly bidding rhythm</h4><p>Apply to high-fit projects consistently instead of sending random proposals.</p></div>
            <div class="quality-score">Plan</div>
          </div>
          <div class="quality-row rv d2">
            <div class="quality-icon"><i class="fa-solid fa-message"></i></div>
            <div><h4>Response speed</h4><p>Fast replies improve client confidence when your bid is being compared.</p></div>
            <div class="quality-score">Fast</div>
          </div>
          <div class="quality-row rv d3">
            <div class="quality-icon"><i class="fa-solid fa-code-branch"></i></div>
            <div><h4>Portfolio proof</h4><p>Use GitHub, LinkedIn, and portfolio links to reduce client uncertainty.</p></div>
            <div class="quality-score">Proof</div>
          </div>
          <div class="quality-row rv d4">
            <div class="quality-icon"><i class="fa-solid fa-award"></i></div>
            <div><h4>Reputation loop</h4><p>Deliver well, ask for reviews, and let completed projects sell future work.</p></div>
            <div class="quality-score">Grow</div>
          </div>
        </div>
      </section>

      <section class="z-cta" id="zCta">
        <svg class="z-path-svg" viewBox="0 0 1000 220" preserveAspectRatio="none" aria-hidden="true">
          <defs>
            <linearGradient id="zGrad" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" stop-color="#3B82F6"/>
              <stop offset="55%" stop-color="#22D3EE"/>
              <stop offset="100%" stop-color="#8B5CF6"/>
            </linearGradient>
          </defs>
          <path class="z-path" id="zPath" pathLength="1" d="M38 46 C205 18 322 30 460 94 C612 166 748 182 962 142"/>
        </svg>
        <div class="left-in">
          <h2>Ready to win the next project?</h2>
          <p>Use the primary CTA to explore available work, then scan proposals and assigned projects from left to right like a focused freelancer command journey.</p>
        </div>
        <div class="z-actions right-in">
          <a href="viewAllProjects" class="hero-primary"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
          <a href="myProposals" class="hero-secondary"><i class="fa-solid fa-paper-plane"></i> View Proposals</a>
        </div>
      </section>

    </div>
  </section>

</main>

<footer class="footer-pro">
  <div class="wrap">
    <div class="footer-hero rv">
      <div class="footer-brand">
        <h2>Keep your freelance pipeline <span>moving forward.</span></h2>
        <p>WorkSphere helps freelancers discover projects, submit proposals, deliver accepted work, build reputation, and manage professional client relationships.</p>
      </div>
      <div class="footer-cta">
        <a href="viewAllProjects" class="hero-primary"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
        <a href="freelancerAssignedProjects" class="hero-secondary"><i class="fa-solid fa-diagram-project"></i> Assigned Work</a>
      </div>
    </div>

    <div class="footer-grid zoom">
      <div class="footer-cell">
        <div class="footer-logo">Work<span>Sphere</span></div>
        <p>A premium freelancer workspace for discovering opportunities, tracking proposals, managing assigned projects, and growing professional reputation.</p>
      </div>
      <div class="footer-cell">
        <h4>Freelancer Tools</h4>
        <a href="freelancerDashboard">Dashboard</a>
        <a href="viewAllProjects">Explore Projects</a>
        <a href="myProposals">My Proposals</a>
        <a href="freelancerAssignedProjects">Assigned Projects</a>
      </div>
      <div class="footer-cell">
        <h4>Growth Flow</h4>
        <a href="viewFreelancerProfile">Update Profile</a>
        <a href="freelancerReviews">My Reviews</a>
        <a href="freelancerNotifications">Notifications</a>
        <a href="viewAllProjects">Find New Work</a>
      </div>
      <div class="footer-cell">
        <h4>Account</h4>
        <a href="freelancerDashboard"><%= freelancer.getName() %></a>
        <a href="freelancerNotifications">Unread Alerts: <%= unreadCount %></a>
        <a href="freelancerLogout">Logout</a>
      </div>
    </div>

    <div class="footer-bottom">
      <div><b>WorkSphere</b> • Freelancer Dashboard • 2026</div>
      <div>Professional freelance opportunity and delivery workspace</div>
    </div>
  </div>
</footer>

<script>
(function(){
  const nav=document.getElementById('nav');
  const mob=document.getElementById('mob');
  const mbtn=document.getElementById('mbtn');
  const mobx=document.getElementById('mobx');
  const media=document.getElementById('heroMedia');
  const textReveal=document.getElementById('textReveal');
  const parallaxEls=document.querySelectorAll('[data-speed]');
  const scrollProgress=document.getElementById('scrollProgress');
  const zCta=document.getElementById('zCta');
  const zPath=document.getElementById('zPath');
  const actionLanes=document.querySelector('.action-lanes');

  if(zPath){zPath.style.strokeDasharray='1';zPath.style.strokeDashoffset='1';}

  function closeMobile(){
    if(mob){
      mob.classList.remove('on');
      document.body.style.overflow='';
    }
  }

  if(mbtn){
    mbtn.addEventListener('click',function(){
      mob.classList.add('on');
      document.body.style.overflow='hidden';
    });
  }
  if(mobx){mobx.addEventListener('click',closeMobile)}
  if(mob){mob.addEventListener('click',function(e){if(e.target===mob)closeMobile()})}
  document.querySelectorAll('.mob-p a').forEach(function(a){a.addEventListener('click',closeMobile)});

  const revealObserver=new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        entry.target.classList.add('v');
        revealObserver.unobserve(entry.target);
      }
    });
  },{threshold:.08,rootMargin:'0px 0px -5% 0px'});

  document.querySelectorAll('.rv,.zoom,.left-in,.right-in,.metric').forEach(function(el){
    revealObserver.observe(el);
  });

  const counterObserver=new IntersectionObserver(function(entries,obs){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        runCounter(entry.target);
        obs.unobserve(entry.target);
      }
    });
  },{threshold:.35});

  document.querySelectorAll('.count-up').forEach(function(counter){
    counterObserver.observe(counter);
  });

  function runCounter(counter){
    const target=parseInt(counter.getAttribute('data-target')) || 0;
    const duration=1150;
    const start=performance.now();

    function update(now){
      const progress=Math.min((now-start)/duration,1);
      const eased=1-Math.pow(1-progress,3);
      counter.textContent=Math.floor(eased*target);
      if(progress<1){requestAnimationFrame(update)}
      else{counter.textContent=target}
    }
    requestAnimationFrame(update);
  }

  let ticking=false;
  function onScroll(){
    const y=window.scrollY || 0;
    const maxScroll=Math.max(1,document.documentElement.scrollHeight-window.innerHeight);
    const pageProgress=Math.max(0,Math.min(1,y/maxScroll));
    if(scrollProgress){scrollProgress.style.transform='scaleX('+pageProgress+')'}
    if(nav){nav.classList.toggle('s',y>26)}

    parallaxEls.forEach(function(el){
      const speed=parseFloat(el.getAttribute('data-speed')) || 0;
      el.style.transform='translate3d(0,'+(y*speed)+'px,0)';
    });

    if(actionLanes){
      const rect=actionLanes.getBoundingClientRect();
      const vh=window.innerHeight || 1;
      const laneProgress=Math.max(-1,Math.min(1,(vh*.5-rect.top)/vh));
      actionLanes.style.setProperty('--lane-shift',(laneProgress*22)+'px');
    }

    if(zCta && zPath){
      const rect=zCta.getBoundingClientRect();
      const vh=window.innerHeight || 1;
      const p=Math.max(0,Math.min(1,(vh-rect.top)/(vh+rect.height*.35)));
      zPath.style.strokeDashoffset=(1-p).toFixed(3);
    }

    if(media){
      const rect=media.getBoundingClientRect();
      const vh=window.innerHeight || 1;
      const progress=Math.max(0,Math.min(1,(vh-rect.top)/(vh+rect.height)));
      const scale=0.96 + progress*0.05;
      const move=(progress-.5)*26;
      media.style.transform='translate3d(0,'+move+'px,0) scale('+scale+')';
      if(progress>.18){media.classList.add('in')}
    }

    if(textReveal){
      const rect=textReveal.getBoundingClientRect();
      const vh=window.innerHeight || 1;
      if(rect.top < vh*.72 && rect.bottom > vh*.18){
        textReveal.classList.add('active');
      }else{
        textReveal.classList.remove('active');
      }
    }

    ticking=false;
  }

  window.addEventListener('scroll',function(){
    if(!ticking){
      requestAnimationFrame(onScroll);
      ticking=true;
    }
  },{passive:true});
  onScroll();

  if(media && window.matchMedia('(min-width: 900px)').matches){
    media.addEventListener('mousemove',function(e){
      const rect=media.getBoundingClientRect();
      const x=e.clientX-rect.left;
      const y=e.clientY-rect.top;
      const rx=((y-rect.height/2)/(rect.height/2))*-3.5;
      const ry=((x-rect.width/2)/(rect.width/2))*3.5;
      media.style.rotate=rx+'deg '+ry+'deg';
    });
    media.addEventListener('mouseleave',function(){
      media.style.rotate='0deg 0deg';
    });
  }
})();
</script>

</body>
</html>
