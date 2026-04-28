<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.model.BidModel" %>
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

private String enc(Object value){
    if(value == null) return "";
    try{
        return URLEncoder.encode(String.valueOf(value), "UTF-8");
    }catch(Exception e){
        return "";
    }
}

private int toInt(Object value){
    if(value == null) return 0;
    if(value instanceof Number) return ((Number)value).intValue();
    try{
        return Integer.parseInt(String.valueOf(value));
    }catch(Exception e){
        return 0;
    }
}

private long toLong(Object value){
    if(value == null) return 0L;
    if(value instanceof Number) return ((Number)value).longValue();
    try{
        return Long.parseLong(String.valueOf(value));
    }catch(Exception e){
        return 0L;
    }
}

private String bidKey(Object status){
    if(status == null) return "pending";
    String s = String.valueOf(status).trim().toLowerCase();
    if(s.contains("accept")) return "accepted";
    if(s.contains("reject") || s.contains("decline")) return "rejected";
    if(s.contains("withdraw")) return "withdrawn";
    return "pending";
}

private String statusIcon(String key){
    if("accepted".equals(key)) return "fa-circle-check";
    if("rejected".equals(key)) return "fa-circle-xmark";
    if("withdrawn".equals(key)) return "fa-circle-minus";
    return "fa-clock";
}

private String pageUrl(String q, String status, String sort, int page){
    return "myProposals?q=" + enc(q) + "&status=" + enc(status) + "&sort=" + enc(sort) + "&page=" + page;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Proposals | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--sky:#60A5FA;--cyan:#22D3EE;--violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,.08);--pri-mid:rgba(59,130,246,.18);
  --bg:#07080D;--s1:#0B0D14;--s2:#10131D;--s3:#171B28;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--t4:#4B5568;
  --border:rgba(255,255,255,.08);--border2:rgba(255,255,255,.045);
  --ok:#22C55E;--warn:#F59E0B;--danger:#EF4444;
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1200px;
}
html{scroll-behavior:smooth}
body{min-height:100vh;font-family:var(--b);background:var(--bg);color:var(--t1);overflow-x:hidden;-webkit-font-smoothing:antialiased}
body::before{content:"";position:fixed;inset:0;z-index:-4;background:radial-gradient(circle at 16% 8%,rgba(59,130,246,.22),transparent 32%),radial-gradient(circle at 88% 20%,rgba(34,211,238,.13),transparent 31%),radial-gradient(circle at 30% 92%,rgba(139,92,246,.12),transparent 38%),linear-gradient(180deg,#07080D 0%,#090B12 48%,#07080D 100%)}
body::after{content:"";position:fixed;inset:0;z-index:-3;background-image:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.22),transparent);-webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.22),transparent)}
a{color:inherit}.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}.progress-top{position:fixed;top:0;left:0;height:2px;width:0%;z-index:5000;background:linear-gradient(90deg,var(--pri),var(--cyan));box-shadow:0 0 18px rgba(59,130,246,.3)}

/* NAV */
.ws-nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:background .35s,box-shadow .35s}.ws-nav.scrolled{background:rgba(7,8,13,.80);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-inner{max-width:var(--max);margin:0 auto;height:70px;padding:0 32px;display:flex;align-items:center;justify-content:space-between;gap:24px}.logo{font-family:var(--h);font-size:20px;font-weight:850;letter-spacing:-.75px;text-decoration:none;white-space:nowrap}.logo .s{color:var(--pri)}
.nav-links{display:flex;align-items:center;gap:2px}.nav-links a{text-decoration:none;color:var(--t3);font-family:var(--h);font-size:13px;font-weight:650;padding:8px 13px;border-radius:999px;transition:all .2s}.nav-links a:hover,.nav-links a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-actions{display:flex;align-items:center;gap:8px}.nav-btn{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.02);border-radius:10px;padding:9px 15px;font-family:var(--h);font-size:13px;font-weight:750;text-decoration:none;display:inline-flex;align-items:center;gap:8px;transition:all .2s;position:relative}.nav-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05)}.nav-btn.primary{background:linear-gradient(135deg,var(--pri),var(--cyan));border-color:transparent;color:#fff}.nav-btn.primary:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24)}
.notif-dot{position:absolute;top:-6px;right:-6px;min-width:18px;height:18px;padding:0 5px;border-radius:999px;background:linear-gradient(135deg,#EF4444,#FB7185);color:#fff;font-size:10px;font-family:var(--h);font-weight:850;display:flex;align-items:center;justify-content:center;border:2px solid var(--bg)}.menu-btn{display:none;background:none;border:0;color:var(--t2);font-size:19px;cursor:pointer}
.mobile-menu{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,.58);backdrop-filter:blur(9px);-webkit-backdrop-filter:blur(9px);opacity:0;visibility:hidden;transition:all .25s}.mobile-menu.open{opacity:1;visibility:visible}.mobile-panel{position:absolute;top:16px;right:16px;width:min(310px,calc(100% - 32px));background:var(--s2);border:1px solid var(--border);border-radius:18px;padding:22px;transform:translateY(10px);transition:transform .25s}.mobile-menu.open .mobile-panel{transform:translateY(0)}.mobile-close{border:0;background:none;color:var(--t3);font-size:16px;margin-bottom:12px}.mobile-panel a{display:block;text-decoration:none;color:var(--t2);font-family:var(--h);font-size:14px;font-weight:650;padding:12px 0;border-bottom:1px solid var(--border2)}.mobile-panel a:hover{color:var(--t1)}.mobile-panel .nav-btn{justify-content:center;margin-top:10px;border-bottom:0;padding:10px 14px}

/* PAGE */
.page{position:relative;padding:118px 0 0}.page::before{content:"";position:absolute;top:54px;left:50%;transform:translateX(-50%);width:920px;height:620px;background:radial-gradient(circle,rgba(59,130,246,.18),transparent 66%);pointer-events:none;opacity:.82}.hero{position:relative;z-index:1;padding:26px 0 30px}.hero-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:46px;align-items:end}.kicker{display:inline-flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:8px 13px;margin-bottom:18px;color:var(--t2);font-size:12px;font-weight:750}.kicker i{color:var(--cyan);font-size:11px}.hero h1{font-family:var(--h);font-size:clamp(42px,5.2vw,72px);line-height:.96;font-weight:850;letter-spacing:-2.7px;max-width:780px;margin-bottom:18px}.hero h1 em{font-style:normal;font-weight:260;color:var(--t3);letter-spacing:-1.7px}.hero p{color:var(--t2);font-size:16px;line-height:1.85;max-width:690px;margin-bottom:26px}.accent-name{color:var(--sky);font-weight:850}.hero-actions{display:flex;gap:10px;flex-wrap:wrap}.action-main,.action-ghost{border-radius:12px;padding:12px 20px;text-decoration:none;font-family:var(--h);font-size:14px;font-weight:850;display:inline-flex;align-items:center;gap:8px;transition:all .2s;border:0}.action-main{background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff}.action-main:hover{color:#fff;transform:translateY(-2px);box-shadow:0 18px 45px rgba(59,130,246,.28)}.action-ghost{color:var(--t2);border:1px solid var(--border);background:rgba(255,255,255,.025)}.action-ghost:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05);transform:translateY(-2px)}
.proposal-focus{border:1px solid var(--border);border-radius:26px;padding:26px;background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));position:relative;overflow:hidden}.proposal-focus::before{content:"";position:absolute;right:-130px;top:-130px;width:310px;height:310px;border-radius:50%;background:radial-gradient(circle,rgba(34,211,238,.18),transparent 67%)}.focus-top{position:relative;z-index:1;display:flex;justify-content:space-between;align-items:flex-start;gap:18px;margin-bottom:22px}.focus-top h3{font-family:var(--h);font-size:26px;font-weight:850;letter-spacing:-.95px;margin-bottom:8px}.focus-top p{color:var(--t3);font-size:13px;line-height:1.7;margin:0}.focus-icon{width:58px;height:58px;border-radius:18px;background:linear-gradient(135deg,var(--pri),var(--cyan));display:flex;align-items:center;justify-content:center;color:#fff;font-size:20px;box-shadow:0 20px 50px rgba(59,130,246,.22);flex-shrink:0}.focus-list{position:relative;z-index:1;display:grid;gap:12px}.focus-item{display:grid;grid-template-columns:38px 1fr auto;align-items:center;gap:13px;padding:12px;border:1px solid var(--border2);border-radius:16px;background:rgba(255,255,255,.035)}.focus-num{width:38px;height:38px;border-radius:13px;background:var(--pri-soft);color:var(--sky);display:flex;align-items:center;justify-content:center;font-family:var(--h);font-weight:850;font-size:13px}.focus-item strong{display:block;font-family:var(--h);font-size:14px;letter-spacing:-.2px;color:var(--t1)}.focus-item span{color:var(--t3);font-size:12px}.focus-item i{color:var(--t4)}

/* SUMMARY */
.summary-grid{position:relative;z-index:1;display:grid;grid-template-columns:repeat(4,1fr);gap:1px;border:1px solid var(--border);background:var(--border);border-radius:24px;overflow:hidden;margin:26px 0 34px}.summary-cell{background:rgba(11,13,20,.78);padding:24px;position:relative}.summary-cell::after{content:"";position:absolute;left:24px;right:24px;bottom:18px;height:4px;border-radius:999px;background:rgba(255,255,255,.055)}.summary-cell[data-type="accepted"]::after{background:linear-gradient(90deg,var(--ok),var(--cyan))}.summary-cell[data-type="pending"]::after{background:linear-gradient(90deg,var(--warn),#FBBF24)}.summary-cell[data-type="rejected"]::after{background:linear-gradient(90deg,var(--danger),#FB7185)}.summary-label{color:var(--t3);font-size:12px;font-weight:750;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:11px}.summary-value{font-family:var(--h);font-size:36px;font-weight:850;letter-spacing:-1px;color:var(--t1);line-height:1}.summary-note{margin-top:9px;color:var(--t3);font-size:12.5px;line-height:1.6;padding-bottom:16px}

/* FILTER BAR */
.command-bar{position:sticky;top:82px;z-index:50;margin-bottom:28px;padding:14px;border:1px solid var(--border);border-radius:22px;background:rgba(8,10,16,.78);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);box-shadow:0 18px 60px rgba(0,0,0,.22)}.filter-form{display:grid;grid-template-columns:minmax(240px,1fr) 170px 210px auto;gap:12px;align-items:center}.field{position:relative}.field i{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:13px}.field input,.field select{width:100%;height:46px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t1);border-radius:14px;padding:0 15px;outline:none;font-family:var(--b);font-size:14px;transition:all .2s}.field input{padding-left:40px}.field input:focus,.field select:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft)}.field input::placeholder{color:var(--t4)}.field select option{background:#10131D;color:#fff}.filter-actions{display:flex;gap:8px}.filter-btn,.reset-btn{height:46px;border-radius:14px;padding:0 16px;font-family:var(--h);font-size:13px;font-weight:850;text-decoration:none;display:inline-flex;align-items:center;justify-content:center;gap:8px;white-space:nowrap;transition:all .2s}.filter-btn{border:0;color:#fff;background:linear-gradient(135deg,var(--pri),var(--cyan))}.filter-btn:hover{transform:translateY(-1px);box-shadow:0 14px 30px rgba(59,130,246,.22)}.reset-btn{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.025)}.reset-btn:hover{color:var(--t1);background:rgba(255,255,255,.055)}
.status-tabs{display:flex;gap:8px;flex-wrap:wrap;margin-top:12px}.status-tab{border:1px solid var(--border);background:rgba(255,255,255,.025);border-radius:999px;padding:8px 13px;color:var(--t3);text-decoration:none;font-family:var(--h);font-size:12.5px;font-weight:800;transition:all .2s}.status-tab:hover,.status-tab.active{color:#fff;border-color:var(--pri-mid);background:linear-gradient(135deg,rgba(59,130,246,.22),rgba(34,211,238,.12))}.status-tab span{color:var(--sky)}

/* MAIN */
.proposal-shell{position:relative;z-index:1;display:grid;grid-template-columns:1fr 330px;gap:28px;align-items:start}.section-title{font-family:var(--h);font-size:clamp(28px,3vw,42px);font-weight:850;letter-spacing:-1.5px;margin-bottom:9px}.section-copy{color:var(--t3);font-size:14.5px;line-height:1.8;margin-bottom:22px;max-width:720px}.result-line{color:var(--t3);font-size:13px;margin-bottom:16px}.result-line strong{color:var(--t1)}.bid-list{display:grid;gap:16px}.bid-row{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));border-radius:26px;padding:24px;position:relative;overflow:hidden;transition:transform .22s,border-color .22s,box-shadow .22s}.bid-row::before{content:"";position:absolute;inset:0;background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);transform:translateX(-110%);transition:transform .75s ease}.bid-row:hover{transform:translateY(-5px);border-color:var(--pri-mid);box-shadow:0 26px 70px rgba(0,0,0,.24)}.bid-row:hover::before{transform:translateX(110%)}.bid-main{position:relative;z-index:1;display:grid;grid-template-columns:1fr auto;gap:18px;align-items:start}.bid-title{font-family:var(--h);font-size:23px;font-weight:850;letter-spacing:-.7px;margin-bottom:12px}.bid-desc{color:var(--t2);font-size:14px;line-height:1.8;max-width:800px;margin:15px 0 0}.status-pill{display:inline-flex;align-items:center;gap:7px;padding:8px 12px;border-radius:999px;font-family:var(--h);font-size:12px;font-weight:850;white-space:nowrap}.status-pill.accepted{color:var(--ok);background:rgba(34,197,94,.10);border:1px solid rgba(34,197,94,.22)}.status-pill.pending{color:var(--warn);background:rgba(245,158,11,.10);border:1px solid rgba(245,158,11,.22)}.status-pill.rejected{color:#FB7185;background:rgba(239,68,68,.10);border:1px solid rgba(239,68,68,.22)}.status-pill.withdrawn{color:#CBD5E1;background:rgba(148,163,184,.08);border:1px solid rgba(148,163,184,.18)}.bid-meta{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:10px}.meta-chip{display:inline-flex;align-items:center;gap:7px;color:var(--t3);background:rgba(255,255,255,.035);border:1px solid var(--border2);border-radius:999px;padding:7px 11px;font-size:12.5px;font-weight:650}.meta-chip i{color:var(--cyan);font-size:11px}.proposal-path{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin:18px 0}.path-step{position:relative;padding:10px 10px 10px 34px;border-radius:13px;color:var(--t4);border:1px solid var(--border2);background:rgba(255,255,255,.025);font-family:var(--h);font-size:12px;font-weight:750}.path-step::before{content:"";position:absolute;left:11px;top:50%;width:12px;height:12px;border-radius:50%;transform:translateY(-50%);background:var(--t4)}.path-step.done{color:var(--t1);border-color:var(--pri-mid);background:rgba(59,130,246,.065)}.path-step.done::before{background:linear-gradient(135deg,var(--pri),var(--cyan))}.path-step.win{color:var(--ok);border-color:rgba(34,197,94,.22);background:rgba(34,197,94,.075)}.path-step.win::before{background:var(--ok)}.path-step.loss{color:#FB7185;border-color:rgba(239,68,68,.22);background:rgba(239,68,68,.075)}.path-step.loss::before{background:var(--danger)}.result-box{margin-top:16px;border-radius:18px;padding:16px;border:1px solid var(--border2);background:rgba(255,255,255,.035);color:var(--t2);font-size:13.5px;line-height:1.75}.result-box.accepted{border-color:rgba(34,197,94,.22);background:rgba(34,197,94,.075)}.result-box.pending{border-color:rgba(245,158,11,.22);background:rgba(245,158,11,.075)}.result-box.rejected{border-color:rgba(239,68,68,.22);background:rgba(239,68,68,.075)}.result-box.withdrawn{border-color:rgba(148,163,184,.22);background:rgba(148,163,184,.075)}.result-box strong{display:block;color:var(--t1);font-family:var(--h);font-size:14px;margin-bottom:5px}.result-box i{margin-right:7px;color:var(--cyan)}.bid-action{display:flex;align-items:center;justify-content:space-between;gap:14px;padding-top:16px;margin-top:16px;border-top:1px solid var(--border2)}.next-note{color:var(--t3);font-size:13px;line-height:1.7}.next-note strong{color:var(--t1);font-family:var(--h)}.action-link{border:0;border-radius:12px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff;padding:11px 18px;font-family:var(--h);font-size:13px;font-weight:850;text-decoration:none;display:inline-flex;align-items:center;gap:8px;white-space:nowrap;transition:all .2s}.action-link:hover{color:#fff;transform:translateY(-2px);box-shadow:0 16px 38px rgba(59,130,246,.26)}.action-link.secondary{background:rgba(255,255,255,.04);border:1px solid var(--border);color:var(--t2)}.action-link.danger{background:rgba(239,68,68,.12);border:1px solid rgba(239,68,68,.22);color:#FCA5A5}button.action-link{cursor:pointer}

/* PAGINATION */
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;gap:14px;margin-top:22px;border:1px solid var(--border);background:rgba(255,255,255,.025);border-radius:18px;padding:14px 16px}.page-info{color:var(--t3);font-size:13px}.page-actions{display:flex;gap:8px;flex-wrap:wrap}.page-link-x{height:38px;min-width:38px;padding:0 13px;border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);display:inline-flex;align-items:center;justify-content:center;text-decoration:none;font-family:var(--h);font-size:13px;font-weight:850;transition:all .2s}.page-link-x:hover,.page-link-x.active{color:#fff;border-color:var(--pri-mid);background:rgba(59,130,246,.15)}.page-link-x.disabled{opacity:.35;pointer-events:none}

/* SIDEBAR */
.side-panel{position:sticky;top:166px;display:grid;gap:16px}.side-card{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.76),rgba(8,10,16,.78));border-radius:24px;padding:22px;overflow:hidden;position:relative}.side-card::before{content:"";position:absolute;right:-80px;top:-90px;width:200px;height:200px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.28),transparent 67%)}.side-card>*{position:relative;z-index:1}.side-title{font-family:var(--h);font-size:18px;font-weight:850;letter-spacing:-.5px;margin-bottom:12px}.side-copy{color:var(--t3);font-size:13px;line-height:1.75;margin-bottom:16px}.check-list{display:grid;gap:10px}.check-list div{display:flex;gap:10px;color:var(--t2);font-size:13px;line-height:1.55}.check-list i{color:var(--cyan);margin-top:3px}.profile-head{display:flex;align-items:center;gap:13px;margin-bottom:16px}.avatar{width:58px;height:58px;border-radius:19px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff;display:flex;align-items:center;justify-content:center;font-family:var(--h);font-size:24px;font-weight:900}.profile-name{font-family:var(--h);font-size:17px;font-weight:850}.profile-role{color:var(--t3);font-size:12.5px;margin-top:3px}.win-meter{height:9px;border-radius:999px;background:rgba(255,255,255,.07);overflow:hidden;margin-top:12px}.win-fill{height:100%;width:0;border-radius:999px;background:linear-gradient(90deg,var(--ok),var(--cyan));transition:width 1.2s cubic-bezier(.16,1,.3,1)}.quick-links{display:grid;gap:9px}.quick-links a{text-decoration:none;color:var(--t2);border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:14px;padding:11px 12px;display:flex;justify-content:space-between;align-items:center;font-family:var(--h);font-size:13px;font-weight:700;transition:all .2s}.quick-links a:hover{color:var(--t1);border-color:var(--pri-mid);background:rgba(59,130,246,.07)}.quick-links i{color:var(--cyan)}
.empty-state{border:1px solid var(--border);border-radius:30px;background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(8,10,16,.8));padding:56px 32px;text-align:center;position:relative;overflow:hidden}.empty-state::before{content:"";position:absolute;left:50%;top:-120px;width:420px;height:420px;transform:translateX(-50%);border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.28),transparent 64%)}.empty-state>*{position:relative}.empty-icon{width:74px;height:74px;border-radius:24px;background:var(--pri-soft);color:var(--sky);border:1px solid var(--pri-mid);display:flex;align-items:center;justify-content:center;margin:0 auto 20px;font-size:26px}.empty-state h3{font-family:var(--h);font-size:28px;font-weight:850;letter-spacing:-1px;margin-bottom:9px}.empty-state p{color:var(--t3);line-height:1.75;margin:0 auto 24px;max-width:520px}.ws-footer{margin-top:84px;border-top:1px solid var(--border);background:rgba(255,255,255,.012)}.footer-grid{max-width:var(--max);margin:0 auto;padding:34px 32px;display:grid;grid-template-columns:1fr auto 1fr;gap:24px;align-items:center}.footer-brand{font-family:var(--h);font-size:18px;font-weight:850;letter-spacing:-.5px}.footer-brand .s{color:var(--pri)}.footer-links{display:flex;gap:18px;justify-content:center;flex-wrap:wrap}.footer-links a{text-decoration:none;color:var(--t3);font-size:12.5px;font-weight:650;transition:color .2s}.footer-links a:hover{color:var(--t1)}.footer-note{text-align:right;color:var(--t4);font-size:12px}.reveal{opacity:0;transform:translateY(24px);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}.reveal.show{opacity:1;transform:translateY(0)}.zoom-reveal{opacity:0;transform:translateY(24px) scale(.97);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}.zoom-reveal.show{opacity:1;transform:translateY(0) scale(1)}.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}.d4{transition-delay:.28s}
@media(max-width:1080px){.nav-links{display:none}.menu-btn{display:block}.mobile-menu{display:block}.hero-grid,.proposal-shell{grid-template-columns:1fr}.proposal-focus{max-width:680px}.summary-grid{grid-template-columns:repeat(2,1fr)}.side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}.filter-form{grid-template-columns:1fr 160px 190px}.filter-actions{grid-column:1/-1}}
@media(max-width:720px){.wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}.nav-actions .nav-btn:not(.primary){display:none}.page{padding-top:98px}.hero h1{letter-spacing:-1.9px}.command-bar{position:relative;top:auto}.filter-form{grid-template-columns:1fr}.filter-actions{display:grid;grid-template-columns:1fr 1fr}.summary-grid,.side-panel{grid-template-columns:1fr}.bid-main,.bid-action{grid-template-columns:1fr;display:grid}.proposal-path{grid-template-columns:1fr 1fr}.pagination-wrap{align-items:flex-start;flex-direction:column}.footer-grid{grid-template-columns:1fr;text-align:center}.footer-note{text-align:center}}
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

List<BidModel> bids = (List<BidModel>) request.getAttribute("bids");
String q = String.valueOf(request.getAttribute("q") == null ? "" : request.getAttribute("q"));
String statusFilter = String.valueOf(request.getAttribute("statusFilter") == null ? "all" : request.getAttribute("statusFilter"));
String sort = String.valueOf(request.getAttribute("sort") == null ? "newest" : request.getAttribute("sort"));
int currentPage = toInt(request.getAttribute("currentPage"));
int totalPages = toInt(request.getAttribute("totalPages"));
long totalFiltered = toLong(request.getAttribute("totalFiltered"));
long totalBids = toLong(request.getAttribute("totalBids"));
long acceptedCount = toLong(request.getAttribute("acceptedCount"));
long pendingCount = toLong(request.getAttribute("pendingCount"));
long rejectedCount = toLong(request.getAttribute("rejectedCount"));
long withdrawnCount = toLong(request.getAttribute("withdrawnCount"));
long unreadCount = toLong(request.getAttribute("unreadNotificationCount"));

if(currentPage < 1) currentPage = 1;
if(totalPages < 1) totalPages = 1;

int winRate = 0;
if(totalBids > 0){
    winRate = (int)Math.round((acceptedCount * 100.0) / totalBids);
}
%>

<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="freelancerDashboard" class="logo"><span>Work</span><span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="freelancerDashboard">Dashboard</a>
      <a href="viewAllProjects">Explore</a>
      <a href="myProposals" class="active">Proposals</a>
      <a href="freelancerAssignedProjects">Assigned</a>
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
          <div class="kicker"><i class="fa-solid fa-paper-plane"></i> Freelancer proposal center</div>
          <h1>Track every <em>proposal</em> from pitch to client decision</h1>
          <p>
            Welcome back, <span class="accent-name"><%= safe(freelancer.getName()) %></span>.
            Search, filter, sort, and manage your proposal history without slowing down the page.
          </p>

          <div class="hero-actions">
            <a href="viewAllProjects" class="action-main"><i class="fa-solid fa-briefcase"></i> Explore More Projects</a>
            <a href="freelancerAssignedProjects" class="action-ghost"><i class="fa-solid fa-diagram-project"></i> Assigned Projects</a>
            <a href="freelancerDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
          </div>
        </div>

        <aside class="proposal-focus zoom-reveal d1">
          <div class="focus-top">
            <div>
              <h3>Proposal performance flow</h3>
              <p>Use each bid outcome to improve your next pitch and win better projects.</p>
            </div>
            <div class="focus-icon"><i class="fa-solid fa-bullseye"></i></div>
          </div>

          <div class="focus-list">
            <div class="focus-item"><div class="focus-num">01</div><div><strong>Pitch submitted</strong><span>Your proposal is visible to the client.</span></div><i class="fa-solid fa-arrow-right"></i></div>
            <div class="focus-item"><div class="focus-num">02</div><div><strong>Client evaluates</strong><span>Track the status and project movement.</span></div><i class="fa-solid fa-arrow-right"></i></div>
            <div class="focus-item"><div class="focus-num">03</div><div><strong>Win and deliver</strong><span>Accepted proposals move into assigned work.</span></div><i class="fa-solid fa-arrow-right"></i></div>
          </div>
        </aside>
      </div>

      <div class="summary-grid zoom-reveal d2">
        <div class="summary-cell"><div class="summary-label">Total Proposals</div><div class="summary-value count-up" data-target="<%= totalBids %>">0</div><div class="summary-note">All valid bids connected to active project records.</div></div>
        <div class="summary-cell" data-type="accepted"><div class="summary-label">Accepted</div><div class="summary-value count-up" data-target="<%= acceptedCount %>">0</div><div class="summary-note">Client-approved proposals ready for delivery.</div></div>
        <div class="summary-cell" data-type="pending"><div class="summary-label">Pending</div><div class="summary-value count-up" data-target="<%= pendingCount %>">0</div><div class="summary-note">Waiting for client review or decision.</div></div>
        <div class="summary-cell" data-type="rejected"><div class="summary-label">Rejected</div><div class="summary-value count-up" data-target="<%= rejectedCount %>">0</div><div class="summary-note">Closed opportunities you can learn from.</div></div>
      </div>
    </div>
  </section>

  <section class="proposal-section">
    <div class="wrap">
      <div class="command-bar zoom-reveal">
        <form action="myProposals" method="get" class="filter-form">
          <div class="field">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="q" value="<%= safe(q) %>" placeholder="Search project, client, status, proposal...">
          </div>

          <div class="field">
            <select name="status" aria-label="Filter by proposal status">
              <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>All Status</option>
              <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
              <option value="accepted" <%= "accepted".equals(statusFilter) ? "selected" : "" %>>Accepted</option>
              <option value="rejected" <%= "rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
              <option value="withdrawn" <%= "withdrawn".equals(statusFilter) ? "selected" : "" %>>Withdrawn</option>
            </select>
          </div>

          <div class="field">
            <select name="sort" aria-label="Sort proposals">
              <option value="newest" <%= "newest".equals(sort) ? "selected" : "" %>>Newest first</option>
              <option value="amounthigh" <%= "amounthigh".equals(sort) ? "selected" : "" %>>Bid: High to Low</option>
              <option value="amountlow" <%= "amountlow".equals(sort) ? "selected" : "" %>>Bid: Low to High</option>
              <option value="projectaz" <%= "projectaz".equals(sort) ? "selected" : "" %>>Project: A to Z</option>
              <option value="status" <%= "status".equals(sort) ? "selected" : "" %>>Status</option>
            </select>
          </div>

          <div class="filter-actions">
            <button type="submit" class="filter-btn"><i class="fa-solid fa-filter"></i> Apply</button>
            <a href="myProposals" class="reset-btn"><i class="fa-solid fa-rotate-left"></i> Reset</a>
          </div>
        </form>

        <div class="status-tabs">
          <a class="status-tab <%= "all".equals(statusFilter) ? "active" : "" %>" href="myProposals?q=<%= enc(q) %>&status=all&sort=<%= enc(sort) %>">All <span><%= totalBids %></span></a>
          <a class="status-tab <%= "pending".equals(statusFilter) ? "active" : "" %>" href="myProposals?q=<%= enc(q) %>&status=pending&sort=<%= enc(sort) %>">Pending <span><%= pendingCount %></span></a>
          <a class="status-tab <%= "accepted".equals(statusFilter) ? "active" : "" %>" href="myProposals?q=<%= enc(q) %>&status=accepted&sort=<%= enc(sort) %>">Accepted <span><%= acceptedCount %></span></a>
          <a class="status-tab <%= "rejected".equals(statusFilter) ? "active" : "" %>" href="myProposals?q=<%= enc(q) %>&status=rejected&sort=<%= enc(sort) %>">Rejected <span><%= rejectedCount %></span></a>
          <a class="status-tab <%= "withdrawn".equals(statusFilter) ? "active" : "" %>" href="myProposals?q=<%= enc(q) %>&status=withdrawn&sort=<%= enc(sort) %>">Withdrawn <span><%= withdrawnCount %></span></a>
        </div>
      </div>

      <div class="proposal-shell">
        <div>
          <h2 class="section-title reveal">Proposal board</h2>
          <p class="section-copy reveal d1">A paginated, server-side proposal board that stays fast even after many bids.</p>
          <div class="result-line reveal d1"><strong><%= totalFiltered %></strong> result(s) found. Page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong>.</div>

          <div class="bid-list" id="bidList">
            <%
            if(bids != null && !bids.isEmpty()){
              int index = 0;
              for(BidModel b : bids){
                index++;
                String key = bidKey(b.getStatus());
                String projectTitle = "Project unavailable";
                String projectStatus = "Unavailable";
                String projectDeadline = "Not set";
                String clientName = "Client";
                int projectId = 0;

                if(b.getProject() != null){
                    projectId = b.getProject().getId();
                    projectTitle = b.getProject().getTitle();
                    projectStatus = b.getProject().getStatus();
                    projectDeadline = b.getProject().getDeadline();
                    if(b.getProject().getClient() != null){
                        clientName = b.getProject().getClient().getName();
                    }
                }
            %>

            <article class="bid-row reveal d<%= (index % 4) + 1 %>">
              <div class="bid-main">
                <div>
                  <h3 class="bid-title"><%= safe(projectTitle) %></h3>
                  <div class="bid-meta">
                    <span class="meta-chip"><i class="fa-solid fa-indian-rupee-sign"></i> Bid: ₹<%= safe(b.getBidAmount()) %></span>
                    <span class="meta-chip"><i class="fa-solid fa-user-tie"></i> Client: <%= safe(clientName) %></span>
                    <span class="meta-chip"><i class="fa-solid fa-diagram-project"></i> Project: <%= safe(projectStatus) %></span>
                    <span class="meta-chip"><i class="fa-regular fa-calendar"></i> Deadline: <%= safe(projectDeadline) %></span>
                    <% if(projectId > 0){ %>
                      <span class="meta-chip"><i class="fa-solid fa-hashtag"></i> Project #<%= projectId %></span>
                    <% } %>
                  </div>
                </div>

                <span class="status-pill <%= key %>">
                  <i class="fa-solid <%= statusIcon(key) %>"></i>
                  <%= safe(b.getStatus()) %>
                </span>
              </div>

              <p class="bid-desc"><%= safe(b.getProposalText()) %></p>

              <div class="proposal-path">
                <div class="path-step done">Drafted</div>
                <div class="path-step done">Submitted</div>
                <div class="path-step <%= "pending".equals(key) ? "done" : ("accepted".equals(key) ? "done" : ("withdrawn".equals(key) ? "loss" : "loss")) %>">Reviewed</div>
                <div class="path-step <%= "accepted".equals(key) ? "win" : ("rejected".equals(key) || "withdrawn".equals(key) ? "loss" : "") %>"><%= "accepted".equals(key) ? "Accepted" : ("rejected".equals(key) ? "Closed" : ("withdrawn".equals(key) ? "Withdrawn" : "Decision")) %></div>
              </div>

              <% if("accepted".equals(key)){ %>
              <div class="result-box accepted">
                <strong><i class="fa-solid fa-trophy"></i> Congratulations! Your bid was accepted.</strong>
                Open assigned projects to continue delivery, chat with the client, and submit work when ready.
              </div>
              <div class="bid-action">
                <div class="next-note"><strong>Next action:</strong> Move this win into delivery and keep the client updated.</div>
                <a href="freelancerAssignedProjects" class="action-link">Open Assigned Work <i class="fa-solid fa-arrow-right"></i></a>
              </div>
              <% } else if("rejected".equals(key)){ %>
              <div class="result-box rejected">
                <strong><i class="fa-solid fa-circle-xmark"></i> Proposal closed.</strong>
                Use this result to improve pricing, timeline, and proposal clarity for your next bid.
              </div>
              <div class="bid-action">
                <div class="next-note"><strong>Next action:</strong> Explore similar open projects and send a stronger proposal.</div>
                <a href="viewAllProjects" class="action-link">Explore Projects <i class="fa-solid fa-briefcase"></i></a>
              </div>
              <% } else if("withdrawn".equals(key)){ %>
              <div class="result-box withdrawn">
                <strong><i class="fa-solid fa-circle-minus"></i> Proposal withdrawn.</strong>
                This proposal is no longer active and the client cannot accept it.
                <% if(b.getWithdrawalReason() != null && b.getWithdrawalReason().trim().length() > 0){ %>
                  <br>Reason: <%= safe(b.getWithdrawalReason()) %>
                <% } %>
              </div>
              <div class="bid-action">
                <div class="next-note"><strong>Next action:</strong> Explore open projects or reapply if the project is still open.</div>
                <a href="viewAllProjects" class="action-link">Explore Projects <i class="fa-solid fa-briefcase"></i></a>
              </div>
              <% } else { %>
              <div class="result-box pending">
                <strong><i class="fa-solid fa-clock"></i> Waiting for client decision.</strong>
                Your proposal is submitted. You can still edit or withdraw it while it is pending.
              </div>
              <div class="bid-action">
                <div class="next-note"><strong>Next action:</strong> Improve this proposal or withdraw it if you no longer want to continue.</div>
                <div class="d-flex gap-2 flex-wrap">
                  <a href="editProposalPage?bidId=<%= b.getId() %>" class="action-link secondary"><i class="fa-solid fa-file-pen"></i> Edit</a>
                  <form action="withdrawProposal" method="post" style="margin:0;">
                    <input type="hidden" name="bidId" value="<%= b.getId() %>">
                    <input type="hidden" name="withdrawalReason" value="Withdrawn by freelancer from proposal board">
                    <button type="submit" class="action-link danger" onclick="return confirm('Withdraw this proposal? The client will not be able to accept it after withdrawal.');"><i class="fa-solid fa-ban"></i> Withdraw</button>
                  </form>
                  <a href="viewAllProjects" class="action-link">Find More Work <i class="fa-solid fa-arrow-right"></i></a>
                </div>
              </div>
              <% } %>
            </article>

            <%
              }
            } else {
            %>

            <div class="empty-state zoom-reveal">
              <div class="empty-icon"><i class="fa-regular fa-paper-plane"></i></div>
              <h3>No proposals found</h3>
              <p>No proposal matches your current filter. Reset filters or explore open projects to send a new proposal.</p>
              <a href="viewAllProjects" class="action-main"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
            </div>

            <%
            }
            %>
          </div>

          <% if(totalPages > 1){ %>
          <div class="pagination-wrap reveal">
            <div class="page-info">Showing page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong></div>
            <div class="page-actions">
              <a class="page-link-x <%= currentPage <= 1 ? "disabled" : "" %>" href="<%= pageUrl(q, statusFilter, sort, currentPage - 1) %>"><i class="fa-solid fa-chevron-left"></i></a>
              <%
                int startPage = currentPage - 2;
                int endPage = currentPage + 2;
                if(startPage < 1) startPage = 1;
                if(endPage > totalPages) endPage = totalPages;
                for(int i = startPage; i <= endPage; i++){
              %>
                <a class="page-link-x <%= i == currentPage ? "active" : "" %>" href="<%= pageUrl(q, statusFilter, sort, i) %>"><%= i %></a>
              <% } %>
              <a class="page-link-x <%= currentPage >= totalPages ? "disabled" : "" %>" href="<%= pageUrl(q, statusFilter, sort, currentPage + 1) %>"><i class="fa-solid fa-chevron-right"></i></a>
            </div>
          </div>
          <% } %>
        </div>

        <aside class="side-panel reveal d2">
          <div class="side-card">
            <div class="profile-head">
              <div class="avatar"><%= firstLetter %></div>
              <div>
                <div class="profile-name"><%= safe(freelancer.getName()) %></div>
                <div class="profile-role">Proposal Workspace</div>
              </div>
            </div>
            <p class="side-copy">Your current proposal win rate is based on accepted bids divided by total submitted proposals.</p>
            <div class="win-meter"><div class="win-fill" data-width="<%= winRate %>%"></div></div>
            <p class="side-copy" style="margin-top:12px;margin-bottom:0;"><strong style="color:var(--t1);font-family:var(--h);"><%= winRate %>%</strong> proposal win rate</p>
          </div>

          <div class="side-card">
            <h3 class="side-title">Winning proposal checklist</h3>
            <p class="side-copy">Before submitting new bids, make your proposal easy for clients to trust.</p>
            <div class="check-list">
              <div><i class="fa-solid fa-check"></i><span>Mention exactly how you will solve the client’s requirement.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Use a realistic price and delivery timeline.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Keep the proposal short, specific, and professional.</span></div>
              <div><i class="fa-solid fa-check"></i><span>Add relevant portfolio proof when possible.</span></div>
            </div>
          </div>

          <div class="side-card">
            <h3 class="side-title">Quick actions</h3>
            <div class="quick-links">
              <a href="viewAllProjects"><span>Explore Projects</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="freelancerAssignedProjects"><span>Assigned Projects</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="viewFreelancerProfile"><span>Improve Profile</span><i class="fa-solid fa-arrow-right"></i></a>
              <a href="freelancerReviews"><span>View Reviews</span><i class="fa-solid fa-arrow-right"></i></a>
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
        <a href="freelancerDashboard">Dashboard</a>
        <a href="viewAllProjects">Explore</a>
        <a href="freelancerAssignedProjects">Assigned</a>
        <a href="freelancerNotifications">Notifications</a>
      </div>
      <div class="footer-note">Freelancer Proposals • 2026</div>
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
    if(progressTop){ progressTop.style.width = (height > 0 ? (scrolled / height) * 100 : 0) + "%"; }
    if(navbar){ navbar.classList.toggle("scrolled", scrolled > 20); }
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

  document.querySelectorAll(".reveal,.zoom-reveal").forEach(function(el){ revealObserver.observe(el); });

  const counterObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        const el = entry.target;
        const target = parseInt(el.getAttribute("data-target"), 10) || 0;
        const start = performance.now();
        const duration = 800;
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

  document.querySelectorAll(".count-up").forEach(function(el){ counterObserver.observe(el); });

  const fillObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        const fill = entry.target;
        fill.style.width = fill.getAttribute("data-width") || "0%";
        fillObserver.unobserve(fill);
      }
    });
  }, {threshold:.4});

  document.querySelectorAll(".win-fill").forEach(function(fill){ fillObserver.observe(fill); });
})();
</script>

</body>
</html>
