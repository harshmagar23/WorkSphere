<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.ClientModel" %>
<%@ page import="com.model.PaymentModel" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%!
private String formatFileSize(long bytes){
    if(bytes <= 0) return "Unknown size";
    double kb = bytes / 1024.0;
    if(kb < 1024) return String.format("%.1f KB", kb);
    double mb = kb / 1024.0;
    return String.format("%.1f MB", mb);
}

private String safe(Object value){
    if(value == null) return "";
    return String.valueOf(value)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}

private String cleanStatus(Object value){
    if(value == null) return "Open";
    String status = String.valueOf(value).trim();
    return status.length() == 0 ? "Open" : status;
}

private String statusClass(Object value){
    String s = cleanStatus(value).toLowerCase();
    if(s.contains("complete")) return "completed";
    if(s.contains("submit")) return "submitted";
    if(s.contains("payment") || s.contains("progress") || s.contains("assign") || s.contains("revision")) return "progress";
    if(s.contains("reject") || s.contains("cancel")) return "danger";
    return "open";
}

private int toInt(Object value){
    if(value == null) return 0;
    try{
        if(value instanceof Number){
            return (int)Math.round(((Number)value).doubleValue());
        }
        String text = String.valueOf(value).trim();
        if(text.length() == 0) return 0;
        return (int)Math.round(Double.parseDouble(text));
    }catch(Exception e){
        return 0;
    }
}

private long toLong(Object value){
    if(value == null) return 0L;
    try{
        if(value instanceof Number){
            return ((Number)value).longValue();
        }
        String text = String.valueOf(value).trim();
        if(text.length() == 0) return 0L;
        return Long.parseLong(text);
    }catch(Exception e){
        return 0L;
    }
}

private String enc(Object value){
    if(value == null) return "";
    try{
        return java.net.URLEncoder.encode(String.valueOf(value), "UTF-8");
    }catch(Exception e){
        return "";
    }
}

private String activeClass(String current, String expected){
    if(current == null || current.trim().length() == 0) current = "all";
    return current.equalsIgnoreCase(expected) ? "active" : "";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Projects | WorkSphere</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--pri-h:#2563EB;--sky:#60A5FA;--cyan:#22D3EE;--violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,.08);--pri-mid:rgba(59,130,246,.18);
  --pri-glow:rgba(59,130,246,.28);--cyan-glow:rgba(34,211,238,.18);
  --bg:#07080D;--s1:#0B0D14;--s2:#10131D;--s3:#171B28;--s4:#1D2435;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--t4:#4B5568;--t5:#263043;
  --border:rgba(255,255,255,.08);--border2:rgba(255,255,255,.045);
  --ok:#22C55E;--warn:#F59E0B;--danger:#EF4444;
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1200px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;font-family:var(--b);background:var(--bg);color:var(--t1);overflow-x:hidden;
  -webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;text-rendering:optimizeLegibility;
  font-feature-settings:'kern' 1,'liga' 1,'calt' 1;
}
body::before{content:'';position:fixed;inset:0;z-index:-4;background:radial-gradient(circle at 16% 8%,rgba(59,130,246,.22),transparent 32%),radial-gradient(circle at 86% 18%,rgba(34,211,238,.14),transparent 31%),radial-gradient(circle at 50% 95%,rgba(139,92,246,.10),transparent 38%),linear-gradient(180deg,#07080D 0%,#090B12 44%,#07080D 100%)}
body::after{content:'';position:fixed;inset:0;z-index:-3;background-image:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.24),transparent);-webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.24),transparent)}
::selection{background:var(--pri);color:#fff}
a{color:inherit}.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* ===== TOP PROGRESS ===== */
.prog{position:fixed;top:0;left:0;height:2px;background:linear-gradient(90deg,var(--pri),var(--cyan));z-index:9999;width:0%;transition:width .08s linear}

/* ===== NAV ===== */
.nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:background .35s,box-shadow .35s}.nav.s{background:rgba(7,8,13,.78);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-in{max-width:var(--max);margin:0 auto;padding:0 32px;display:flex;align-items:center;justify-content:space-between;height:68px}.logo{font-family:var(--h);font-size:20px;font-weight:850;text-decoration:none;letter-spacing:-.75px}.logo .s{color:var(--pri)}
.nav-m{display:flex;gap:0}.nav-a{text-decoration:none;color:var(--t3);font-family:var(--h);font-size:13px;font-weight:600;letter-spacing:.01em;padding:7px 14px;border-radius:999px;transition:all .2s}.nav-a:hover,.nav-a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-r{display:flex;gap:8px;align-items:center}.btn-p{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;border:none;border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:800;letter-spacing:.01em;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:transform .2s,box-shadow .2s}.btn-p:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24);color:white}.btn-o{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.02);border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:600;letter-spacing:.01em;cursor:pointer;text-decoration:none;transition:all .2s}.btn-o:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.04)}
.mbtn{display:none;background:none;border:none;color:var(--t2);font-size:18px;cursor:pointer;padding:6px}.mob{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,.5);backdrop-filter:blur(8px);opacity:0;visibility:hidden;transition:all .25s}.mob.on{opacity:1;visibility:visible}.mob-p{position:absolute;top:16px;right:16px;width:280px;background:var(--s2);border-radius:16px;padding:24px;border:1px solid var(--border);transform:translateY(8px);transition:transform .25s}.mob.on .mob-p{transform:translateY(0)}.mob-x{background:none;border:none;color:var(--t3);font-size:15px;cursor:pointer;margin-bottom:16px;padding:4px}.mob-p a{display:block;text-decoration:none;color:var(--t2);font-family:var(--h);font-size:14.5px;font-weight:600;letter-spacing:.01em;padding:11px 0;border-bottom:1px solid var(--border2);transition:color .15s}.mob-p a:hover{color:var(--t1)}.mob-b{margin-top:16px;display:flex;flex-direction:column;gap:8px}
.badge-dot{min-width:20px;height:20px;padding:0 6px;border-radius:999px;background:rgba(34,211,238,.12);border:1px solid rgba(34,211,238,.24);color:var(--cyan);font-size:11px;font-weight:850;display:inline-flex;align-items:center;justify-content:center}

/* ===== PAGE ===== */
.page{position:relative;min-height:100vh;padding:112px 0 0}.orb{position:fixed;border-radius:999px;filter:blur(1px);pointer-events:none;z-index:-2;opacity:.72}.orb.one{width:260px;height:260px;left:-90px;top:160px;background:radial-gradient(circle,rgba(59,130,246,.18),transparent 68%);animation:floatOne 10s ease-in-out infinite}.orb.two{width:240px;height:240px;right:-80px;top:360px;background:radial-gradient(circle,rgba(34,211,238,.13),transparent 68%);animation:floatTwo 12s ease-in-out infinite}.orb.three{width:220px;height:220px;left:48%;bottom:40px;background:radial-gradient(circle,rgba(139,92,246,.10),transparent 68%);animation:floatThree 14s ease-in-out infinite}@keyframes floatOne{50%{transform:translate3d(22px,-26px,0) scale(1.06)}}@keyframes floatTwo{50%{transform:translate3d(-24px,32px,0) scale(.94)}}@keyframes floatThree{50%{transform:translate3d(12px,-24px,0) scale(1.08)}}

/* ===== HERO ===== */
.hero{position:relative;padding:34px 0 34px;overflow:hidden}.hero::after{content:'';position:absolute;top:-60%;left:50%;transform:translateX(-50%);width:960px;height:700px;background:radial-gradient(circle,rgba(59,130,246,.20),transparent 66%);opacity:.45;pointer-events:none}.hero-grid{position:relative;z-index:1;display:grid;grid-template-columns:1fr 340px;gap:36px;align-items:end}.eyebrow{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:7px 12px;color:var(--t2);font-size:12px;font-weight:750;letter-spacing:.02em;margin-bottom:17px}.eyebrow i{color:var(--cyan);font-size:11px}.hero h1{font-family:var(--h);font-size:clamp(42px,5.4vw,76px);line-height:.96;font-weight:850;letter-spacing:-2.9px;margin:0 0 18px;max-width:760px}.hero h1 em{font-style:normal;font-weight:260;color:var(--t3);letter-spacing:-1.8px}.hero p{font-size:16px;line-height:1.85;color:var(--t2);max-width:650px;margin:0 0 26px}.hero-actions{display:flex;gap:10px;flex-wrap:wrap}.hbtn,.hbtn2{text-decoration:none;padding:13px 22px;border-radius:11px;font-family:var(--h);font-weight:800;font-size:14px;letter-spacing:.01em;display:inline-flex;align-items:center;gap:8px;transition:all .2s}.hbtn{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}.hbtn:hover{box-shadow:0 18px 45px rgba(59,130,246,.28);transform:translateY(-2px);color:white}.hbtn2{color:var(--t2);border:1px solid var(--border);background:rgba(255,255,255,.025)}.hbtn2:hover{color:var(--t1);border-color:rgba(255,255,255,.16);transform:translateY(-2px)}
.hero-side{border-left:1px solid var(--border);padding-left:28px}.side-stat{padding:16px 0;border-bottom:1px solid var(--border2)}.side-stat:last-child{border-bottom:0}.side-stat strong{font-family:var(--h);font-size:30px;font-weight:850;letter-spacing:-1px;line-height:1;color:var(--t1)}.side-stat strong b{color:var(--sky)}.side-stat span{display:block;color:var(--t3);font-size:12.5px;margin-top:7px;font-weight:600;letter-spacing:.02em}

/* ===== CONTROL BAR ===== */
.control-shell{position:sticky;top:68px;z-index:80;background:linear-gradient(180deg,rgba(7,8,13,.94),rgba(7,8,13,.76));backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);padding:14px 0;border-top:1px solid transparent;border-bottom:1px solid var(--border)}.control-grid{display:grid;grid-template-columns:minmax(240px,1fr) auto auto;gap:12px;align-items:center}.search-box{position:relative}.search-box i{position:absolute;left:16px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:13px}.search-box input,.sort-select{width:100%;height:46px;border-radius:12px;border:1px solid var(--border);background:rgba(16,19,29,.76);color:var(--t1);outline:none;font-family:var(--b);font-size:14px;transition:all .2s}.search-box input{padding:0 16px 0 42px}.search-box input::placeholder{color:var(--t4)}.search-box input:focus,.sort-select:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft)}.sort-select{padding:0 38px 0 14px;min-width:190px;color:var(--t2)}.tabs{display:flex;gap:7px;flex-wrap:wrap}.tab-btn{height:40px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t3);border-radius:999px;padding:0 13px;font-family:var(--h);font-size:12.5px;font-weight:800;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:7px}.tab-btn:hover,.tab-btn.active{color:var(--t1);background:rgba(255,255,255,.06);border-color:rgba(255,255,255,.14)}.tab-btn .mini-count{color:var(--sky)}

/* ===== SUMMARY BAND ===== */
.summary-band{padding:34px 0 14px}.summary-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:var(--border);border:1px solid var(--border);border-radius:22px;overflow:hidden}.summary-item{background:rgba(11,13,20,.82);padding:24px;position:relative;overflow:hidden}.summary-item::after{content:'';position:absolute;right:-40px;top:-50px;width:130px;height:130px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.10),transparent 65%)}.summary-item i{color:var(--sky);font-size:17px;margin-bottom:14px}.summary-item span{display:block;color:var(--t3);font-size:12px;font-weight:750;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:7px}.summary-item strong{display:block;font-family:var(--h);font-size:32px;font-weight:850;line-height:1;letter-spacing:-1px;color:var(--t1)}

/* ===== PROJECT LIST ===== */
.projects-area{padding:22px 0 72px}.list-head{display:flex;align-items:end;justify-content:space-between;gap:24px;margin-bottom:18px}.section-tag{font-family:var(--h);font-size:11px;font-weight:800;color:var(--sky);letter-spacing:2.1px;text-transform:uppercase;margin-bottom:8px}.section-title{font-family:var(--h);font-size:clamp(28px,3.1vw,42px);font-weight:850;letter-spacing:-1.6px;line-height:1.08;margin:0}.section-desc{color:var(--t3);font-size:14px;line-height:1.75;max-width:560px;margin-top:8px}.visible-count{color:var(--t3);font-size:13px;font-weight:650}.visible-count b{color:var(--t1)}
.project-list{display:grid;gap:16px}.project-row{position:relative;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(9,12,20,.92));border-radius:24px;padding:24px;overflow:hidden;transition:transform .25s,box-shadow .25s,border-color .25s,opacity .2s}.project-row::before{content:'';position:absolute;left:0;top:0;bottom:0;width:4px;background:linear-gradient(to bottom,var(--pri),var(--cyan));opacity:.86}.project-row::after{content:'';position:absolute;right:-120px;top:-130px;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.10),transparent 67%);transition:opacity .2s}.project-row:hover{transform:translateY(-4px);border-color:var(--pri-mid);box-shadow:0 26px 70px rgba(0,0,0,.28)}.project-row:hover::after{opacity:1}.row-main{position:relative;z-index:1;display:grid;grid-template-columns:1fr 220px;gap:24px;align-items:start}.project-title-line{display:flex;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:10px}.project-title{font-family:var(--h);font-size:22px;font-weight:820;line-height:1.2;letter-spacing:-.45px;color:var(--t1);margin:0}.status-badge{display:inline-flex;align-items:center;gap:7px;border-radius:999px;padding:7px 11px;font-family:var(--h);font-size:11.5px;font-weight:850;text-transform:uppercase;letter-spacing:.8px;border:1px solid var(--border)}.status-badge.open{color:var(--sky);background:rgba(96,165,250,.09);border-color:rgba(96,165,250,.20)}.status-badge.progress{color:var(--cyan);background:rgba(34,211,238,.08);border-color:rgba(34,211,238,.20)}.status-badge.submitted{color:var(--warn);background:rgba(245,158,11,.10);border-color:rgba(245,158,11,.22)}.status-badge.completed{color:var(--ok);background:rgba(34,197,94,.10);border-color:rgba(34,197,94,.22)}.status-badge.danger{color:var(--danger);background:rgba(239,68,68,.10);border-color:rgba(239,68,68,.22)}.project-desc{color:var(--t2);font-size:14.5px;line-height:1.8;margin:0 0 18px;max-width:760px}.meta-grid{display:flex;gap:10px;flex-wrap:wrap}.meta-pill{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:999px;padding:8px 12px;color:var(--t3);font-size:12.5px;font-weight:650}.meta-pill i{color:var(--sky);font-size:12px}.meta-pill strong{color:var(--t1);font-weight:800}.project-actions{display:flex;flex-direction:column;gap:10px;align-items:stretch}.action-btn{height:42px;border-radius:11px;text-decoration:none;display:inline-flex;align-items:center;justify-content:center;gap:8px;font-family:var(--h);font-size:13px;font-weight:850;transition:all .2s}.action-primary{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}.action-primary:hover{color:white;transform:translateY(-2px);box-shadow:0 14px 30px rgba(59,130,246,.22)}.action-ghost{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2)}.action-ghost:hover{color:var(--t1);background:rgba(255,255,255,.055);transform:translateY(-2px)}.action-success{background:linear-gradient(135deg,#16A34A,#22C55E);color:white}.action-success:hover{color:white;transform:translateY(-2px);box-shadow:0 14px 30px rgba(34,197,94,.18)}.action-danger{background:linear-gradient(135deg,#DC2626,#EF4444);color:white;border:0}.action-danger:hover{color:white;transform:translateY(-2px);box-shadow:0 14px 30px rgba(239,68,68,.18)}
.project-extra{position:relative;z-index:1;margin-top:16px;display:grid;gap:10px}.info-box{border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:16px;padding:14px 16px;color:var(--t2);font-size:13.5px;line-height:1.7}.info-box strong{color:var(--t1);font-weight:800}.info-box i{color:var(--sky);margin-right:7px}.submitted-box{border-color:rgba(245,158,11,.22);background:rgba(245,158,11,.075)}.submitted-box i{color:var(--warn)}.completed-box{border-color:rgba(34,197,94,.22);background:rgba(34,197,94,.075)}.completed-box i{color:var(--ok)}

/* ===== EMPTY ===== */
.empty-state{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(9,12,20,.92));border-radius:26px;padding:60px 30px;text-align:center;overflow:hidden;position:relative}.empty-state::before{content:'';position:absolute;left:50%;top:-120px;transform:translateX(-50%);width:380px;height:300px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.16),transparent 65%)}.empty-icon{position:relative;width:76px;height:76px;border-radius:24px;background:var(--pri-soft);border:1px solid rgba(59,130,246,.18);display:flex;align-items:center;justify-content:center;color:var(--sky);font-size:28px;margin:0 auto 22px}.empty-state h3{position:relative;font-family:var(--h);font-weight:850;letter-spacing:-.8px;margin-bottom:10px}.empty-state p{position:relative;color:var(--t3);max-width:430px;margin:0 auto 24px;line-height:1.75}



/* ===== UNIQUE PROJECT OPERATIONS BOARD ===== */
.command-lab{padding:18px 0 34px;position:relative}
.command-grid{display:grid;grid-template-columns:1.05fr .95fr;gap:18px;align-items:stretch}
.board-panel,.queue-panel{position:relative;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.86),rgba(9,12,20,.82));border-radius:26px;padding:26px;overflow:hidden}
.board-panel::before,.queue-panel::before{content:'';position:absolute;inset:0;background:linear-gradient(120deg,rgba(59,130,246,.06),transparent 42%,rgba(34,211,238,.035));pointer-events:none}
.board-head{position:relative;display:flex;justify-content:space-between;gap:18px;align-items:flex-start;margin-bottom:22px}
.board-head h3{font-family:var(--h);font-size:25px;font-weight:850;letter-spacing:-.9px;margin:0 0 8px;color:var(--t1)}
.board-head p{color:var(--t3);font-size:13.5px;line-height:1.7;margin:0;max-width:520px}
.board-pulse{height:38px;min-width:38px;border-radius:14px;background:var(--pri-soft);border:1px solid var(--pri-mid);display:flex;align-items:center;justify-content:center;color:var(--sky);box-shadow:0 0 0 0 rgba(96,165,250,.22);animation:pulseRing 2.8s ease-in-out infinite}
@keyframes pulseRing{50%{box-shadow:0 0 0 11px rgba(96,165,250,0)}}
.lane-grid{position:relative;display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.lane{position:relative;min-height:168px;border:1px solid var(--border2);background:rgba(255,255,255,.025);border-radius:20px;padding:17px;overflow:hidden;transition:all .25s}
.lane:hover{transform:translateY(-4px);border-color:var(--pri-mid);background:rgba(255,255,255,.045)}
.lane::after{content:'';position:absolute;left:17px;right:17px;bottom:16px;height:4px;border-radius:999px;background:rgba(255,255,255,.06);overflow:hidden}
.lane.open::before,.lane.active::before,.lane.submitted::before,.lane.completed::before{content:'';position:absolute;left:17px;bottom:16px;height:4px;border-radius:999px;z-index:2;background:linear-gradient(90deg,var(--pri),var(--cyan));box-shadow:0 0 16px rgba(59,130,246,.25);animation:laneGrow 1.4s cubic-bezier(.16,1,.3,1) both}
.lane.open::before{width:48%}.lane.active::before{width:62%}.lane.submitted::before{width:76%;background:linear-gradient(90deg,var(--warn),#FBBF24)}.lane.completed::before{width:90%;background:linear-gradient(90deg,var(--ok),#4ADE80)}
@keyframes laneGrow{from{transform:scaleX(0);transform-origin:left}to{transform:scaleX(1);transform-origin:left}}
.lane-icon{width:38px;height:38px;border-radius:13px;background:var(--pri-soft);display:flex;align-items:center;justify-content:center;color:var(--sky);margin-bottom:18px}
.lane.submitted .lane-icon{color:var(--warn);background:rgba(245,158,11,.10)}.lane.completed .lane-icon{color:var(--ok);background:rgba(34,197,94,.10)}
.lane strong{display:block;font-family:var(--h);font-size:30px;line-height:1;font-weight:850;letter-spacing:-1px;color:var(--t1);margin-bottom:8px}
.lane span{display:block;font-size:12px;color:var(--t3);font-weight:750;letter-spacing:.9px;text-transform:uppercase;margin-bottom:9px}
.lane p{font-size:12.5px;color:var(--t3);line-height:1.62;margin:0}
.queue-list{position:relative;display:grid;gap:11px;margin-top:18px}
.queue-item{display:flex;align-items:center;justify-content:space-between;gap:16px;border:1px solid var(--border2);background:rgba(255,255,255,.025);border-radius:16px;padding:14px 15px;transition:all .2s}
.queue-item:hover{background:rgba(255,255,255,.05);transform:translateX(4px);border-color:var(--pri-mid)}
.queue-left{display:flex;align-items:center;gap:12px;min-width:0}.queue-dot{width:34px;height:34px;border-radius:12px;background:rgba(245,158,11,.10);color:var(--warn);display:flex;align-items:center;justify-content:center;flex-shrink:0}
.queue-item h4{font-family:var(--h);font-size:14.5px;font-weight:800;color:var(--t1);letter-spacing:-.25px;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:270px}.queue-item span{display:block;color:var(--t3);font-size:12px;margin-top:3px}
.queue-link{height:34px;padding:0 12px;border-radius:10px;background:rgba(255,255,255,.035);border:1px solid var(--border);color:var(--t2);display:inline-flex;align-items:center;gap:7px;text-decoration:none;font-family:var(--h);font-size:12px;font-weight:800;white-space:nowrap;transition:all .2s}.queue-link:hover{color:var(--t1);background:rgba(255,255,255,.065);transform:translateY(-1px)}
.empty-queue{position:relative;border:1px dashed var(--border);border-radius:18px;padding:22px;color:var(--t3);font-size:13.5px;line-height:1.7;background:rgba(255,255,255,.018)}
.empty-queue i{color:var(--ok);margin-right:8px}
.project-health{display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin:16px 0 4px}.health-step{height:26px;border-radius:999px;padding:0 10px;border:1px solid var(--border2);background:rgba(255,255,255,.026);color:var(--t4);display:inline-flex;align-items:center;gap:7px;font-family:var(--h);font-size:11.5px;font-weight:800;letter-spacing:.02em}.health-step i{font-size:9px}.health-step.on{color:var(--sky);border-color:rgba(96,165,250,.18);background:rgba(96,165,250,.08)}.health-step.warn{color:var(--warn);border-color:rgba(245,158,11,.20);background:rgba(245,158,11,.09)}.health-step.done{color:var(--ok);border-color:rgba(34,197,94,.20);background:rgba(34,197,94,.09)}
.next-action-card{position:relative;margin-top:14px;border:1px solid var(--border2);background:rgba(255,255,255,.026);border-radius:16px;padding:15px 16px;display:flex;gap:13px;align-items:flex-start;color:var(--t2)}
.next-action-card i{width:32px;height:32px;border-radius:11px;background:var(--pri-soft);color:var(--sky);display:flex;align-items:center;justify-content:center;flex-shrink:0}.next-action-card strong{display:block;color:var(--t1);font-family:var(--h);font-size:13.5px;letter-spacing:-.15px;margin-bottom:3px}.next-action-card span{display:block;color:var(--t3);font-size:12.5px;line-height:1.6}
.project-row[data-status="submitted"] .next-action-card i{background:rgba(245,158,11,.10);color:var(--warn)}.project-row[data-status="completed"] .next-action-card i{background:rgba(34,197,94,.10);color:var(--ok)}
.decision-strip{padding:0 0 76px}.decision-inner{position:relative;border:1px solid var(--border);border-radius:28px;background:linear-gradient(135deg,rgba(59,130,246,.10),rgba(11,13,20,.78) 36%,rgba(34,211,238,.07));padding:32px;overflow:hidden;display:grid;grid-template-columns:1fr auto;gap:24px;align-items:center}.decision-inner::before{content:'';position:absolute;right:-160px;top:-170px;width:380px;height:380px;border-radius:50%;background:radial-gradient(circle,rgba(34,211,238,.14),transparent 68%)}.decision-inner h3{position:relative;font-family:var(--h);font-size:30px;font-weight:850;letter-spacing:-1px;margin:0 0 10px}.decision-inner p{position:relative;color:var(--t3);font-size:14.5px;line-height:1.75;max-width:620px;margin:0}.decision-actions{position:relative;display:flex;gap:10px;flex-wrap:wrap;justify-content:flex-end}
@media(max-width:1080px){.command-grid{grid-template-columns:1fr}.lane-grid{grid-template-columns:repeat(2,1fr)}.decision-inner{grid-template-columns:1fr}.decision-actions{justify-content:flex-start}}
@media(max-width:680px){.lane-grid{grid-template-columns:1fr}.queue-item{align-items:flex-start;flex-direction:column}.queue-item h4{max-width:100%}.decision-inner{padding:24px;border-radius:22px}}

/* ===== INSIGHTS + FOOTER ===== */
.insights{padding:0 0 76px}.insight-grid{display:grid;grid-template-columns:1.15fr .85fr;gap:18px}.insight-panel{border:1px solid var(--border);background:rgba(11,13,20,.74);border-radius:24px;padding:26px;position:relative;overflow:hidden}.insight-panel::after{content:'';position:absolute;right:-100px;bottom:-110px;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(34,211,238,.10),transparent 68%)}.insight-panel h3{font-family:var(--h);font-size:24px;font-weight:850;letter-spacing:-.8px;margin-bottom:14px}.check-list{display:grid;gap:13px}.check-item{display:flex;gap:12px;align-items:flex-start;color:var(--t2);font-size:14px;line-height:1.7}.check-item i{width:30px;height:30px;border-radius:10px;background:var(--pri-soft);color:var(--sky);display:flex;align-items:center;justify-content:center;flex-shrink:0;margin-top:1px}.quick-panel{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(9,12,20,.94));border-radius:24px;padding:26px}.quick-panel h3{font-family:var(--h);font-size:24px;font-weight:850;letter-spacing:-.8px;margin-bottom:10px}.quick-panel p{color:var(--t3);font-size:14px;line-height:1.7;margin-bottom:18px}.quick-links{display:grid;gap:10px}.quick-link{border:1px solid var(--border);background:rgba(255,255,255,.025);border-radius:14px;padding:14px 15px;text-decoration:none;color:var(--t2);font-family:var(--h);font-weight:750;display:flex;align-items:center;justify-content:space-between;transition:all .2s}.quick-link:hover{color:var(--t1);background:rgba(255,255,255,.055);transform:translateX(4px)}.quick-link i{color:var(--sky)}
footer{border-top:1px solid var(--border);padding:34px 0;background:rgba(255,255,255,.012)}.foot-in{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px}.foot-l{font-family:var(--h);font-size:17px;font-weight:850;letter-spacing:-.5px}.foot-l .s{color:var(--pri)}.foot-m{display:flex;gap:20px;flex-wrap:wrap}.foot-m a{text-decoration:none;color:var(--t3);font-size:12.5px;font-weight:600;letter-spacing:.02em;transition:color .15s}.foot-m a:hover{color:var(--t1)}.foot-r{font-size:11.5px;color:var(--t4);font-weight:500;letter-spacing:.02em}


/* ===== PAGINATION ===== */
.pager{display:flex;align-items:center;justify-content:center;gap:9px;flex-wrap:wrap;margin-top:26px}.page-linkx{min-width:42px;height:42px;border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);text-decoration:none;display:inline-flex;align-items:center;justify-content:center;padding:0 14px;font-family:var(--h);font-size:13px;font-weight:850;transition:all .2s}.page-linkx:hover,.page-linkx.active{color:white;background:linear-gradient(135deg,var(--pri),var(--cyan));border-color:transparent;transform:translateY(-2px)}.page-linkx.disabled{opacity:.4;pointer-events:none}.page-info{width:100%;text-align:center;color:var(--t3);font-size:12.5px;font-weight:650;margin-top:4px}

/* ===== ANIMATION ===== */
.rv{opacity:0;transform:translateY(24px);transition:opacity .72s cubic-bezier(.16,1,.3,1),transform .72s cubic-bezier(.16,1,.3,1)}.rv.v{opacity:1;transform:translateY(0)}.d1{transition-delay:.06s}.d2{transition-delay:.12s}.d3{transition-delay:.18s}.d4{transition-delay:.24s}.hidden-filter{display:none!important}.fade-out{opacity:.25;transform:scale(.98)}

@media(max-width:1080px){.nav-m{display:none}.mbtn{display:block}.mob{display:block}.hero-grid{grid-template-columns:1fr}.hero-side{border-left:0;border-top:1px solid var(--border);padding-left:0;padding-top:20px;display:grid;grid-template-columns:repeat(4,1fr);gap:1px}.side-stat{border-bottom:0;border-right:1px solid var(--border2);padding:12px}.side-stat:last-child{border-right:0}.control-grid{grid-template-columns:1fr}.summary-grid{grid-template-columns:repeat(2,1fr)}.row-main{grid-template-columns:1fr}.project-actions{flex-direction:row;flex-wrap:wrap}.action-btn{padding:0 16px}.insight-grid{grid-template-columns:1fr}}
@media(max-width:680px){.wrap,.nav-in{padding:0 20px}.nav-r{display:none}.page{padding-top:96px}.hero h1{letter-spacing:-2px}.hero-actions{flex-direction:column}.hbtn,.hbtn2{justify-content:center}.hero-side{grid-template-columns:repeat(2,1fr)}.summary-grid{grid-template-columns:1fr}.summary-item{padding:20px}.control-shell{top:68px}.tabs{overflow-x:auto;flex-wrap:nowrap;padding-bottom:2px}.tab-btn{white-space:nowrap}.project-row{border-radius:20px;padding:20px}.project-title{font-size:19px}.project-actions{flex-direction:column}.action-btn{width:100%}.list-head{display:block}.visible-count{margin-top:12px}.foot-in{flex-direction:column;text-align:center}.foot-m{justify-content:center}}
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

List<ProjectModel> projects = (List<ProjectModel>) request.getAttribute("projects");
Map<Integer, PaymentModel> paymentMap = (Map<Integer, PaymentModel>) request.getAttribute("paymentMap");
if(paymentMap == null){ paymentMap = new HashMap<Integer, PaymentModel>(); }

String searchRaw = request.getAttribute("searchQuery") == null ? "" : String.valueOf(request.getAttribute("searchQuery"));
String statusRaw = request.getAttribute("statusFilter") == null ? "all" : String.valueOf(request.getAttribute("statusFilter"));
String sortRaw = request.getAttribute("sortOption") == null ? "latest" : String.valueOf(request.getAttribute("sortOption"));

if(statusRaw.trim().length() == 0) statusRaw = "all";
if(sortRaw.trim().length() == 0) sortRaw = "latest";

int currentPage = toInt(request.getAttribute("currentPage"));
int totalPages = toInt(request.getAttribute("totalPages"));
long totalFilteredProjects = toLong(request.getAttribute("totalFilteredProjects"));

if(currentPage < 1) currentPage = 1;
if(totalPages < 1) totalPages = 1;

long total = toLong(request.getAttribute("totalAllProjects"));
long openCount = toLong(request.getAttribute("openCount"));
long activeCount = toLong(request.getAttribute("activeCount"));
long submittedCount = toLong(request.getAttribute("submittedCount"));
long revisionCount = toLong(request.getAttribute("revisionCount"));
long completedCount = toLong(request.getAttribute("completedCount"));
%>

<div class="prog" id="prog"></div>
<div class="orb one"></div>
<div class="orb two"></div>
<div class="orb three"></div>

<nav class="nav" id="nav">
  <div class="nav-in">
    <a href="clientDashboard" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>
    <div class="nav-m">
      <a href="clientDashboard" class="nav-a">Dashboard</a>
      <a href="postProjectPage" class="nav-a">Post Project</a>
      <a href="viewMyProjects" class="nav-a active">My Projects</a>
      <a href="clientPayments" class="nav-a">Payments</a>
      <a href="clientNotifications" class="nav-a">Notifications</a>
    </div>
    <div class="nav-r">
      <a href="postProjectPage" class="btn-p"><i class="fa-solid fa-plus"></i> New Project</a>
      <a href="logout" class="btn-o">Logout</a>
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
    <a href="clientPayments">Payments</a>
    <a href="clientNotifications">Notifications</a>
    <div class="mob-b">
      <a href="postProjectPage" class="btn-p" style="text-align:center;justify-content:center">New Project</a>
      <a href="logout" class="btn-o" style="text-align:center;justify-content:center">Logout</a>
    </div>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap hero-grid">
      <div class="rv">
        <div class="eyebrow"><i class="fa-solid fa-briefcase"></i> Client project workspace</div>
        <h1>Manage every <em>posted project</em> with clarity.</h1>
        <p>Review your projects, track statuses, open bids, verify submitted work, and complete assignments without losing context.</p>
        <div class="hero-actions">
          <a href="postProjectPage" class="hbtn"><i class="fa-solid fa-plus"></i> Post New Project</a>
          <a href="clientDashboard" class="hbtn2"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </div>
      </div>
      <aside class="hero-side rv d1">
        <div class="side-stat"><strong><b><%= total %></b></strong><span>Total projects</span></div>
        <div class="side-stat"><strong><b><%= openCount %></b></strong><span>Open</span></div>
        <div class="side-stat"><strong><b><%= submittedCount %></b></strong><span>Submitted</span></div>
        <div class="side-stat"><strong><b><%= completedCount %></b></strong><span>Completed</span></div>
      </aside>
    </div>
  </section>

  <section class="control-shell">
    <form action="viewMyProjects" method="get" class="wrap control-grid">
      <input type="hidden" name="status" value="<%= safe(statusRaw) %>">
      <input type="hidden" name="page" value="1">

      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="q" id="projectSearch" value="<%= safe(searchRaw) %>" placeholder="Search projects by title, description, freelancer, status...">
      </div>

      <div class="tabs" id="statusTabs">
        <a class="tab-btn <%= activeClass(statusRaw, "all") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=all&sort=<%= enc(sortRaw) %>&page=1">All <span class="mini-count"><%= total %></span></a>
        <a class="tab-btn <%= activeClass(statusRaw, "open") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=open&sort=<%= enc(sortRaw) %>&page=1">Open <span class="mini-count"><%= openCount %></span></a>
        <a class="tab-btn <%= activeClass(statusRaw, "progress") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=progress&sort=<%= enc(sortRaw) %>&page=1">Active <span class="mini-count"><%= activeCount %></span></a>
        <a class="tab-btn <%= activeClass(statusRaw, "submitted") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=submitted&sort=<%= enc(sortRaw) %>&page=1">Submitted <span class="mini-count"><%= submittedCount %></span></a>
        <a class="tab-btn <%= activeClass(statusRaw, "revision") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=revision&sort=<%= enc(sortRaw) %>&page=1">Revision <span class="mini-count"><%= revisionCount %></span></a>
        <a class="tab-btn <%= activeClass(statusRaw, "completed") %>" href="viewMyProjects?q=<%= enc(searchRaw) %>&status=completed&sort=<%= enc(sortRaw) %>&page=1">Completed <span class="mini-count"><%= completedCount %></span></a>
      </div>

      <select class="sort-select" id="sortProjects" name="sort" aria-label="Sort projects" onchange="this.form.submit()">
        <option value="latest" <%= "latest".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Sort: Latest</option>
        <option value="budgetHigh" <%= "budgetHigh".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Budget: High to Low</option>
        <option value="budgetLow" <%= "budgetLow".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Budget: Low to High</option>
        <option value="deadlineSoon" <%= "deadlineSoon".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Deadline: Soonest</option>
        <option value="titleAZ" <%= "titleAZ".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Title: A to Z</option>
        <option value="status" <%= "status".equalsIgnoreCase(sortRaw) ? "selected" : "" %>>Status</option>
      </select>
    </form>
  </section>

  <section class="summary-band">
    <div class="wrap summary-grid rv">
      <div class="summary-item"><i class="fa-solid fa-layer-group"></i><span>Total listed work</span><strong><%= total %></strong></div>
      <div class="summary-item"><i class="fa-solid fa-folder-open"></i><span>Available for bids</span><strong><%= openCount %></strong></div>
      <div class="summary-item"><i class="fa-solid fa-upload"></i><span>Awaiting review</span><strong><%= submittedCount %></strong></div>
      <div class="summary-item"><i class="fa-solid fa-circle-check"></i><span>Finished work</span><strong><%= completedCount %></strong></div>
    </div>
  </section>


  <section class="command-lab">
    <div class="wrap command-grid">
      <div class="board-panel rv">
        <div class="board-head">
          <div>
            <div class="section-tag">Project Command Board</div>
            <h3>Status lanes built for fast decisions</h3>
            <p>Instead of only listing projects, this page now gives you a quick project-management view: what is open, what is active, what needs review, and what is already complete.</p>
          </div>
          <div class="board-pulse"><i class="fa-solid fa-signal"></i></div>
        </div>
        <div class="lane-grid">
          <div class="lane open"><div class="lane-icon"><i class="fa-solid fa-folder-open"></i></div><strong><%= openCount %></strong><span>Open briefs</span><p>Projects waiting for the right freelancer proposals.</p></div>
          <div class="lane active"><div class="lane-icon"><i class="fa-solid fa-diagram-project"></i></div><strong><%= activeCount %></strong><span>Active work</span><p>Projects already assigned or moving through delivery.</p></div>
          <div class="lane submitted"><div class="lane-icon"><i class="fa-solid fa-upload"></i></div><strong><%= submittedCount %></strong><span>Review queue</span><p>Submitted work that needs your decision next.</p></div>
          <div class="lane completed"><div class="lane-icon"><i class="fa-solid fa-circle-check"></i></div><strong><%= completedCount %></strong><span>Completed</span><p>Finished projects that strengthen your hiring history.</p></div>
        </div>
      </div>
      <aside class="queue-panel rv d1">
        <div class="board-head">
          <div>
            <div class="section-tag">Priority Queue</div>
            <h3>Work needing attention</h3>
            <p>Submitted projects are surfaced here so you can review and complete them quickly.</p>
          </div>
        </div>
        <div class="queue-list">
        <%
        boolean hasQueue = false;
        if(projects != null){
            for(ProjectModel qp : projects){
                if(qp != null && "Submitted".equalsIgnoreCase(cleanStatus(qp.getStatus()))){
                    hasQueue = true;
        %>
          <div class="queue-item">
            <div class="queue-left">
              <div class="queue-dot"><i class="fa-solid fa-upload"></i></div>
              <div><h4><%= safe(qp.getTitle()) %></h4><span>Submitted on <%= safe(qp.getSubmissionDate()) %></span></div>
            </div>
            <form action="${pageContext.request.contextPath}/markProjectCompleted" method="post" style="margin:0;">
              <input type="hidden" name="projectId" value="<%= qp.getId() %>">
              <button type="submit" class="queue-link" onclick="return confirm('Mark this project as completed?');">Complete <i class="fa-solid fa-arrow-right"></i></button>
            </form>
          </div>
        <%
                }
            }
        }
        if(!hasQueue){
        %>
          <div class="empty-queue"><i class="fa-solid fa-circle-check"></i>No submitted work is waiting right now. Your review queue is clear.</div>
        <%
        }
        %>
        </div>
      </aside>
    </div>
  </section>

  <section class="projects-area">
    <div class="wrap">
      <div class="list-head rv">
        <div>
          <div class="section-tag">Project List</div>
          <h2 class="section-title">Your posted projects</h2>
          <p class="section-desc">Use the command board above for quick decisions, then scan each project row for status, budget, deadline, assigned freelancer, progress path, submitted work, and next action.</p>
        </div>
        <div class="visible-count"><b id="visibleCount"><%= totalFilteredProjects %></b> matching</div>
      </div>

    <div class="project-list" id="projectList">
  <%
  if(projects != null && !projects.isEmpty()){
      int idx = 0;
      for(ProjectModel p : projects){
          if(p == null) continue;
          idx++;

          String st = cleanStatus(p.getStatus());
          String stClass = statusClass(p.getStatus());

          String assignedName = "";
          if(p.getAssignedFreelancer() != null){
              assignedName = safe(p.getAssignedFreelancer().getName());
          }

          String searchable = (safe(p.getTitle()) + " " 
                  + safe(p.getDescription()) + " " 
                  + safe(st) + " " 
                  + assignedName + " " 
                  + p.getBudget()).toLowerCase();

          int budget = toInt(p.getBudget());
PaymentModel payment = paymentMap.get(p.getId());
          String payStatus = payment != null && payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "Not Created";
  %>
        <article class="project-row rv d<%= (idx % 4) + 1 %>" data-status="<%= stClass %>" data-title="<%= safe(p.getTitle()).toLowerCase() %>" data-budget="<%= budget %>" data-search="<%= searchable %>">
          <div class="row-main">
            <div>
              <div class="project-title-line">
                <h3 class="project-title"><%= safe(p.getTitle()) %></h3>
                <span class="status-badge <%= stClass %>"><i class="fa-solid fa-circle"></i><%= safe(st) %></span>
              </div>
              <p class="project-desc"><%= safe(p.getDescription()) %></p>
              <div class="meta-grid">
                <span class="meta-pill"><i class="fa-solid fa-indian-rupee-sign"></i> Budget <strong>₹<%= safe(p.getBudget()) %></strong></span>
                <span class="meta-pill"><i class="fa-regular fa-calendar"></i> Deadline <strong><%= safe(p.getDeadline()) %></strong></span>
                <span class="meta-pill"><i class="fa-solid fa-hashtag"></i> Project <strong>#<%= p.getId() %></strong></span>
              </div>
              <div class="project-health" aria-label="Project progress path">
                <span class="health-step on"><i class="fa-solid fa-circle"></i> Brief</span>
                <span class="health-step <%= (p.getAssignedFreelancer() != null || "Submitted".equalsIgnoreCase(st) || "Completed".equalsIgnoreCase(st)) ? "on" : "" %>"><i class="fa-solid fa-circle"></i> Talent</span>
                <span class="health-step <%= "Submitted".equalsIgnoreCase(st) || "Revision Requested".equalsIgnoreCase(st) ? "warn" : ("Completed".equalsIgnoreCase(st) ? "done" : "") %>"><i class="fa-solid fa-circle"></i> Review</span>
                <span class="health-step <%= "Completed".equalsIgnoreCase(st) ? "done" : "" %>"><i class="fa-solid fa-circle"></i> Complete</span>
              </div>
            </div>
            <div class="project-actions">
              <a href="viewProjectBids?projectId=<%= p.getId() %>" class="action-btn action-primary"><i class="fa-solid fa-gavel"></i> View Bids</a>
              <a href="clientDashboard" class="action-btn action-ghost"><i class="fa-solid fa-chart-line"></i> Dashboard</a>

              <% if("Open".equalsIgnoreCase(st)){ %>
                <a href="${pageContext.request.contextPath}/editProjectPage?projectId=<%= p.getId() %>" class="action-btn action-ghost"><i class="fa-solid fa-pen-to-square"></i> Edit Project</a>
                <form action="${pageContext.request.contextPath}/cancelProject" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= p.getId() %>">
                  <input type="hidden" name="cancellationReason" value="Cancelled by client before accepting bid">
                  <button type="submit" class="action-btn action-danger" onclick="return confirm('Cancel this open project? Freelancers will no longer see it.');"><i class="fa-solid fa-ban"></i> Cancel Project</button>
                </form>
              <% } %>

              <% if("Payment Pending".equalsIgnoreCase(st) && ("Unpaid".equalsIgnoreCase(payStatus) || "Not Created".equalsIgnoreCase(payStatus))){ %>
                <form action="${pageContext.request.contextPath}/cancelProject" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= p.getId() %>">
                  <input type="hidden" name="cancellationReason" value="Cancelled by client before escrow funding">
                  <button type="submit" class="action-btn action-danger" onclick="return confirm('Cancel this payment-pending project before funding escrow?');"><i class="fa-solid fa-ban"></i> Cancel Project</button>
                </form>
              <% } %>

              <% if(p.getAssignedFreelancer() != null){ %>
                <a href="projectChat?projectId=<%= p.getId() %>" class="action-btn action-ghost"><i class="fa-regular fa-comments"></i> Project Chat</a>
              <% } %>
              <% if("Payment Pending".equalsIgnoreCase(st)){ %>
                <form action="${pageContext.request.contextPath}/fundProject" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= p.getId() %>">
                  <button type="submit" class="action-btn action-primary" onclick="return confirm('Fund this project in mock escrow?');"><i class="fa-solid fa-wallet"></i> Fund Project</button>
                </form>
              <% } %>
              <% if("Submitted".equalsIgnoreCase(st)){ %>
                <form action="${pageContext.request.contextPath}/markProjectCompleted" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= p.getId() %>">
                  <button type="submit" class="action-btn action-success" onclick="return confirm('Mark this project as completed?');"><i class="fa-solid fa-check"></i> Mark Complete</button>
                </form>
                <a href="requestRevisionPage?projectId=<%= p.getId() %>" class="action-btn action-ghost"><i class="fa-solid fa-rotate-left"></i> Request Revision</a>
              <% } %>
            </div>
          </div>

          <div class="project-extra">
            <div class="next-action-card">
              <% if("Submitted".equalsIgnoreCase(st)){ %>
                <i class="fa-solid fa-clipboard-check"></i><div><strong>Next action: Review submitted work</strong><span>Download the submitted file, confirm the output, then complete the project or request a revision.</span></div>
              <% } else if("Revision Requested".equalsIgnoreCase(st)){ %>
                <i class="fa-solid fa-rotate-left"></i><div><strong>Revision requested</strong><span>Your revision note has been sent. Wait for the freelancer to upload the corrected delivery.</span></div>
              <% } else if("Completed".equalsIgnoreCase(st)){ %>
                <i class="fa-solid fa-award"></i><div><strong>Project closed successfully</strong><span>This project is complete. Use the details here as a reference for future hiring decisions.</span></div>
              <% } else if("Payment Pending".equalsIgnoreCase(st)){ %>
                <i class="fa-solid fa-wallet"></i><div><strong>Next action: Fund project</strong><span>The bid is accepted. Fund this project into mock escrow so the freelancer can start delivery.</span></div>
              <% } else if(p.getAssignedFreelancer() != null){ %>
                <i class="fa-solid fa-route"></i><div><strong>Next action: Track delivery</strong><span>A freelancer is assigned. Watch for submitted work and notifications from this project.</span></div>
              <% } else { %>
                <i class="fa-solid fa-gavel"></i><div><strong>Next action: Compare bids</strong><span>Review incoming proposals and choose the freelancer who best matches budget, timeline, and quality.</span></div>
              <% } %>
            </div>
            <% if(p.getAssignedFreelancer() != null){ %>
              <div class="info-box"><i class="fa-solid fa-user-check"></i> Assigned Freelancer: <strong><%= assignedName %></strong></div>
            <% } %>

            <% if("Cancelled".equalsIgnoreCase(st)){ %>
              <div class="info-box submitted-box">
                <i class="fa-solid fa-ban"></i><strong>Project Cancelled</strong><br>
                Date: <%= safe(p.getCancelledAt()) %><br>
                Reason: <%= safe(p.getCancellationReason()) %>
              </div>
            <% } %>

            <% if("Revision Requested".equalsIgnoreCase(st)){ %>
              <div class="info-box submitted-box">
                <i class="fa-solid fa-rotate-left"></i><strong>Revision Requested</strong><br>
                Date: <%= safe(p.getRevisionRequestedDate()) %><br>
                Message: <%= safe(p.getRevisionMessage()) %><br>
                Revision Count: <%= p.getRevisionCount() %>
              </div>
            <% } %>

            <% if("Payment Pending".equalsIgnoreCase(st) && payment != null){ %>
              <div class="info-box submitted-box">
                <i class="fa-solid fa-wallet"></i><strong>Payment Required</strong><br>
                Bid Amount: ₹<%= safe(payment.getBidAmount()) %><br>
                Platform Fee: ₹<%= safe(payment.getPlatformFee()) %><br>
                Total Payable: ₹<%= safe(payment.getTotalAmount()) %><br>
                Status: <%= safe(payStatus) %>
              </div>
            <% } %>

          <% if("Submitted".equalsIgnoreCase(st)){ %>
  <div class="info-box submitted-box">
    <i class="fa-solid fa-upload"></i><strong>Work Submitted</strong><br>
    Date: <%= safe(p.getSubmissionDate()) %><br>
    Message: <%= safe(p.getSubmissionMessage()) %>

    <% if(p.getSubmissionOriginalFileName() != null && !p.getSubmissionOriginalFileName().trim().isEmpty()){ %>
      <div style="margin-top:14px;">
        <a href="downloadSubmittedFile?projectId=<%= p.getId() %>"
           class="action-btn action-primary"
           style="height:38px;width:max-content;padding:0 14px;">
          <i class="fa-solid fa-download"></i>
          Download <%= safe(p.getSubmissionOriginalFileName()) %>
        </a>
        <div style="margin-top:8px;color:var(--t3);font-size:12px;">
          File size: <%= formatFileSize(p.getSubmissionFileSize()) %>
        </div>
      </div>
    <% } %>
  </div>
<% } %>

            <% if("Completed".equalsIgnoreCase(st)){ %>
  <div class="info-box completed-box">
    <i class="fa-solid fa-circle-check"></i><strong>Project Completed</strong><br>
    Date: <%= safe(p.getSubmissionDate()) %><br>
    Final Work: <%= safe(p.getSubmissionMessage()) %>

    <% if(p.getSubmissionOriginalFileName() != null && !p.getSubmissionOriginalFileName().trim().isEmpty()){ %>
      <div style="margin-top:14px;">
        <a href="downloadSubmittedFile?projectId=<%= p.getId() %>"
           class="action-btn action-primary"
           style="height:38px;width:max-content;padding:0 14px;">
          <i class="fa-solid fa-download"></i>
          Download <%= safe(p.getSubmissionOriginalFileName()) %>
        </a>
        <div style="margin-top:8px;color:var(--t3);font-size:12px;">
          File size: <%= formatFileSize(p.getSubmissionFileSize()) %>
        </div>
      </div>
    <% } %>
  </div>
<% } %>
          </div>
        </article>
      <%
          }
      } else {
      %>
        <div class="empty-state rv">
          <div class="empty-icon"><i class="fa-solid fa-folder-open"></i></div>
          <h3>No matching projects found</h3>
          <p>Try changing your search, status filter, or sorting option. If you have not posted a project yet, create your first project brief.</p>
          <a href="postProjectPage" class="hbtn"><i class="fa-solid fa-plus"></i> Post Your First Project</a>
        </div>
      <%
      }
      %>
      </div>

      <% if(totalPages > 1){ %>
        <div class="pager rv">
          <a class="page-linkx <%= currentPage <= 1 ? "disabled" : "" %>"
             href="viewMyProjects?q=<%= enc(searchRaw) %>&status=<%= enc(statusRaw) %>&sort=<%= enc(sortRaw) %>&page=<%= currentPage - 1 %>">
            <i class="fa-solid fa-chevron-left"></i> Prev
          </a>

          <%
          int startPage = currentPage - 2;
          int endPage = currentPage + 2;

          if(startPage < 1) startPage = 1;
          if(endPage > totalPages) endPage = totalPages;

          for(int pg = startPage; pg <= endPage; pg++){
          %>
            <a class="page-linkx <%= pg == currentPage ? "active" : "" %>"
               href="viewMyProjects?q=<%= enc(searchRaw) %>&status=<%= enc(statusRaw) %>&sort=<%= enc(sortRaw) %>&page=<%= pg %>"><%= pg %></a>
          <% } %>

          <a class="page-linkx <%= currentPage >= totalPages ? "disabled" : "" %>"
             href="viewMyProjects?q=<%= enc(searchRaw) %>&status=<%= enc(statusRaw) %>&sort=<%= enc(sortRaw) %>&page=<%= currentPage + 1 %>">
            Next <i class="fa-solid fa-chevron-right"></i>
          </a>

          <div class="page-info">Page <%= currentPage %> of <%= totalPages %> · <%= totalFilteredProjects %> matching projects</div>
        </div>
      <% } %>
    </div>
  </section>

  <section class="insights">
    <div class="wrap insight-grid">
      <div class="insight-panel rv">
        <h3>Project management checklist</h3>
        <div class="check-list">
          <div class="check-item"><i class="fa-solid fa-pen-nib"></i><span>Keep project descriptions specific so freelancers can submit accurate proposals.</span></div>
          <div class="check-item"><i class="fa-solid fa-gavel"></i><span>Open bids regularly and compare price, timeline, and freelancer profile strength.</span></div>
          <div class="check-item"><i class="fa-solid fa-upload"></i><span>When work is submitted, review the final message carefully before marking it completed.</span></div>
          <div class="check-item"><i class="fa-solid fa-star"></i><span>Completed projects improve your hiring history and make future project management easier.</span></div>
        </div>
      </div>
      <aside class="quick-panel rv d1">
        <h3>Quick actions</h3>
        <p>Jump to the next important client workflow without going back through the dashboard.</p>
        <div class="quick-links">
          <a href="postProjectPage" class="quick-link"><span>Post another project</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="clientPayments" class="quick-link"><span>Open payments</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="clientNotifications" class="quick-link"><span>Open notifications</span><i class="fa-solid fa-arrow-right"></i></a>
          <a href="clientDashboard" class="quick-link"><span>Return to dashboard</span><i class="fa-solid fa-arrow-right"></i></a>
        </div>
      </aside>
    </div>
  </section>

  <section class="decision-strip">
    <div class="wrap">
      <div class="decision-inner rv">
        <div>
          <div class="section-tag">Client Decision Center</div>
          <h3>Move the right project forward at the right time.</h3>
          <p>Use the command board for status, the priority queue for submitted work, and the project list for detailed bid and completion actions.</p>
        </div>
        <div class="decision-actions">
          <a href="postProjectPage" class="hbtn"><i class="fa-solid fa-plus"></i> Post Project</a>
          <a href="clientNotifications" class="hbtn2"><i class="fa-regular fa-bell"></i> Notifications</a>
        </div>
      </div>
    </div>
  </section>
</main>

<footer>
  <div class="wrap">
    <div class="foot-in">
      <div class="foot-l">Work<span class="s">Sphere</span></div>
      <div class="foot-m">
        <a href="clientDashboard">Dashboard</a>
        <a href="postProjectPage">Post Project</a>
        <a href="viewMyProjects">My Projects</a>
        <a href="clientPayments">Payments</a>
    <a href="clientNotifications">Notifications</a>
      </div>
      <div class="foot-r">&copy; 2026 WorkSphere Client Workspace</div>
    </div>
  </div>
</footer>

<script>
(function(){
  const nav=document.getElementById('nav'),prog=document.getElementById('prog');
  let ticking=false;
  function onScroll(){
    const s=window.scrollY;
    const h=document.documentElement.scrollHeight-window.innerHeight;
    if(prog) prog.style.width=(h>0?s/h*100:0)+'%';
    if(nav) nav.classList.toggle('s',s>30);
    ticking=false;
  }
  window.addEventListener('scroll',()=>{if(!ticking){requestAnimationFrame(onScroll);ticking=true;}},{passive:true});
  onScroll();

  const ro=new IntersectionObserver(entries=>{
    entries.forEach(entry=>{
      if(entry.isIntersecting){entry.target.classList.add('v');ro.unobserve(entry.target);}
    });
  },{threshold:.06,rootMargin:'0px 0px -4px 0px'});
  document.querySelectorAll('.rv').forEach(el=>ro.observe(el));

  const mob=document.getElementById('mob'),mbtn=document.getElementById('mbtn'),mobx=document.getElementById('mobx');
  if(mbtn && mob){mbtn.addEventListener('click',()=>{mob.classList.add('on');document.body.style.overflow='hidden';});}
  function closeMob(){if(mob){mob.classList.remove('on');document.body.style.overflow='';}}
  if(mobx){mobx.addEventListener('click',closeMob);}
  if(mob){mob.addEventListener('click',e=>{if(e.target===mob)closeMob();});}
  document.querySelectorAll('.mob-p a').forEach(a=>a.addEventListener('click',closeMob));

  const sort=document.getElementById('sortProjects');
  if(sort && sort.form){
    sort.addEventListener('change',()=>sort.form.submit());
  }
})();
</script>
</body>
</html>
