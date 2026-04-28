<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.net.URLEncoder" %>
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

private int toInt(Object value, int fallback){
    if(value == null) return fallback;
    try{
        if(value instanceof Number) return ((Number)value).intValue();
        return Integer.parseInt(String.valueOf(value));
    }catch(Exception e){
        return fallback;
    }
}

private long toLong(Object value, long fallback){
    if(value == null) return fallback;
    try{
        if(value instanceof Number) return ((Number)value).longValue();
        return Long.parseLong(String.valueOf(value));
    }catch(Exception e){
        return fallback;
    }
}

private String selected(String current, String expected){
    return expected.equalsIgnoreCase(current == null ? "" : current) ? "selected" : "";
}

private String enc(Object value){
    try{
        return URLEncoder.encode(value == null ? "" : String.valueOf(value), "UTF-8");
    }catch(Exception e){
        return "";
    }
}

private String money(double value){
    if(value == Math.rint(value)){
        return String.valueOf((long)value);
    }
    return String.format("%.2f", value);
}
%>

<%
FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");
if(freelancer == null){
    response.sendRedirect("freelancerLogin");
    return;
}

List<ProjectModel> projects = (List<ProjectModel>) request.getAttribute("projects");
String searchQuery = request.getAttribute("searchQuery") == null ? "" : String.valueOf(request.getAttribute("searchQuery"));
String sortOption = request.getAttribute("sortOption") == null ? "latest" : String.valueOf(request.getAttribute("sortOption"));
int currentPage = toInt(request.getAttribute("currentPage"), 1);
int totalPages = toInt(request.getAttribute("totalPages"), 1);
int pageSize = toInt(request.getAttribute("pageSize"), 8);
long totalOpenProjects = toLong(request.getAttribute("totalOpenProjects"), 0L);
long savedCount = toLong(request.getAttribute("savedCount"), 0L);
Set<Integer> savedProjectIds = (Set<Integer>) request.getAttribute("savedProjectIds");
int visibleCount = projects == null ? 0 : projects.size();
String baseParams = "q=" + enc(searchQuery) + "&sort=" + enc(sortOption);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Explore Open Projects | WorkSphere</title>

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
body{
  min-height:100vh;font-family:var(--b);background:var(--bg);color:var(--t1);overflow-x:hidden;
  -webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility;
}
body::before{content:"";position:fixed;inset:0;z-index:-4;background:radial-gradient(circle at 18% 8%,rgba(59,130,246,.22),transparent 33%),radial-gradient(circle at 88% 24%,rgba(34,211,238,.13),transparent 31%),radial-gradient(circle at 30% 92%,rgba(139,92,246,.12),transparent 35%),linear-gradient(180deg,#07080D 0%,#090B12 45%,#07080D 100%)}
body::after{content:"";position:fixed;inset:0;z-index:-3;background-image:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.2),transparent);-webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.2),transparent)}
::selection{background:var(--pri);color:white}
a{color:inherit;text-decoration:none}.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
.progress-top{position:fixed;top:0;left:0;width:0%;height:2px;z-index:5000;background:linear-gradient(90deg,var(--pri),var(--cyan));box-shadow:0 0 18px rgba(59,130,246,.28)}
.ws-nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:background .35s,box-shadow .35s}.ws-nav.scrolled{background:rgba(7,8,13,.80);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-inner{max-width:var(--max);margin:0 auto;height:70px;padding:0 32px;display:flex;align-items:center;justify-content:space-between;gap:24px}.logo{font-family:var(--h);font-size:20px;font-weight:850;letter-spacing:-.75px;white-space:nowrap}.logo .s{color:var(--pri)}
.nav-links{display:flex;align-items:center;gap:2px}.nav-links a{color:var(--t3);font-family:var(--h);font-size:13px;font-weight:650;padding:8px 13px;border-radius:999px;transition:all .2s}.nav-links a:hover,.nav-links a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-actions{display:flex;align-items:center;gap:8px}.nav-btn{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.02);border-radius:10px;padding:9px 15px;font-family:var(--h);font-size:13px;font-weight:750;display:inline-flex;align-items:center;gap:8px;transition:all .2s}.nav-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05)}.nav-btn.primary{background:linear-gradient(135deg,var(--pri),var(--cyan));border-color:transparent;color:white}.nav-btn.primary:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24)}
.menu-btn{display:none;border:0;background:none;color:var(--t2);font-size:19px;cursor:pointer}
.mobile-menu{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,.58);backdrop-filter:blur(9px);-webkit-backdrop-filter:blur(9px);opacity:0;visibility:hidden;transition:all .25s}.mobile-menu.open{opacity:1;visibility:visible}.mobile-panel{position:absolute;top:16px;right:16px;width:min(310px,calc(100% - 32px));background:var(--s2);border:1px solid var(--border);border-radius:18px;padding:22px}.close-menu{border:0;background:none;color:var(--t3);font-size:16px;margin-bottom:12px}.mobile-panel a{display:block;padding:12px 0;border-bottom:1px solid var(--border2);color:var(--t2);font-family:var(--h);font-weight:700}
.page{min-height:100vh;padding-top:108px}.hero{position:relative;padding:34px 0 28px}.hero-grid{display:grid;grid-template-columns:1fr 330px;gap:36px;align-items:end}.eyebrow{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:7px 12px;color:var(--t2);font-size:12px;font-weight:800;letter-spacing:.02em;margin-bottom:17px}.eyebrow i{color:var(--cyan)}
h1{font-family:var(--h);font-size:clamp(42px,5.3vw,76px);line-height:.96;font-weight:880;letter-spacing:-2.9px;margin:0 0 18px;max-width:820px}h1 em{font-style:normal;font-weight:260;color:var(--t3);letter-spacing:-1.8px}.hero p{font-size:16px;line-height:1.85;color:var(--t2);max-width:680px;margin:0 0 26px}
.hero-actions{display:flex;gap:10px;flex-wrap:wrap}.hbtn,.hbtn2{padding:13px 22px;border-radius:12px;font-family:var(--h);font-weight:850;font-size:14px;display:inline-flex;align-items:center;gap:9px;transition:all .2s}.hbtn{background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff}.hbtn:hover{color:#fff;transform:translateY(-2px);box-shadow:0 18px 45px rgba(59,130,246,.28)}.hbtn2{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2)}.hbtn2:hover{color:var(--t1);border-color:rgba(255,255,255,.16);transform:translateY(-2px)}
.hero-card{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(8,11,18,.9));border-radius:26px;padding:24px;position:relative;overflow:hidden}.hero-card::before{content:"";position:absolute;right:-90px;top:-100px;width:220px;height:220px;border-radius:999px;background:radial-gradient(circle,rgba(34,211,238,.14),transparent 66%)}.stat{position:relative;padding:14px 0;border-bottom:1px solid var(--border2)}.stat:last-child{border-bottom:0}.stat strong{display:block;font-family:var(--h);font-size:32px;line-height:1;font-weight:880;color:var(--sky);letter-spacing:-1px}.stat span{display:block;color:var(--t3);font-size:12.5px;font-weight:700;margin-top:7px}
.filters{position:sticky;top:70px;z-index:90;border-top:1px solid transparent;border-bottom:1px solid var(--border);background:linear-gradient(180deg,rgba(7,8,13,.95),rgba(7,8,13,.78));backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);padding:14px 0}.filter-form{display:grid;grid-template-columns:minmax(250px,1fr) 220px auto auto;gap:10px;align-items:center}.field{position:relative}.field i{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:13px}.field input,.field select{width:100%;height:46px;border:1px solid var(--border);border-radius:13px;background:rgba(16,19,29,.78);color:var(--t1);outline:0;font-family:var(--b);font-size:14px;transition:all .2s}.field input{padding:0 16px 0 42px}.field select{padding:0 14px}.field input::placeholder{color:var(--t4)}.field input:focus,.field select:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft)}.filter-btn{height:46px;border:0;border-radius:13px;padding:0 18px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff;font-family:var(--h);font-weight:850;cursor:pointer}.clear-btn{height:46px;border:1px solid var(--border);border-radius:13px;padding:0 16px;color:var(--t2);background:rgba(255,255,255,.025);display:inline-flex;align-items:center;justify-content:center;font-family:var(--h);font-weight:800}
.market{padding:34px 0 78px}.market-head{display:flex;align-items:end;justify-content:space-between;gap:20px;margin-bottom:18px}.section-tag{font-family:var(--h);font-size:11px;font-weight:850;color:var(--sky);letter-spacing:2px;text-transform:uppercase;margin-bottom:8px}.section-title{font-family:var(--h);font-size:clamp(28px,3.1vw,42px);font-weight:880;letter-spacing:-1.5px;margin:0}.section-desc{color:var(--t3);font-size:14px;line-height:1.75;max-width:620px;margin-top:8px}.page-info{color:var(--t3);font-size:13px;font-weight:700}.page-info b{color:var(--t1)}
.project-list{display:grid;gap:16px}.project-row{position:relative;display:grid;grid-template-columns:1fr 230px;gap:24px;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(8,11,18,.90));border-radius:24px;padding:24px;overflow:hidden;transition:transform .22s,border-color .22s,box-shadow .22s}.project-row::before{content:"";position:absolute;left:0;top:0;bottom:0;width:4px;background:linear-gradient(to bottom,var(--pri),var(--cyan))}.project-row::after{content:"";position:absolute;right:-120px;top:-130px;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.10),transparent 67%)}.project-row:hover{transform:translateY(-4px);border-color:var(--pri-mid);box-shadow:0 26px 70px rgba(0,0,0,.28)}.project-content,.project-side{position:relative;z-index:1}.title-line{display:flex;align-items:center;gap:11px;flex-wrap:wrap;margin-bottom:10px}.project-title{font-family:var(--h);font-size:23px;font-weight:850;letter-spacing:-.5px;margin:0}.status-pill{height:28px;border:1px solid rgba(34,197,94,.22);background:rgba(34,197,94,.10);color:var(--ok);border-radius:999px;padding:0 11px;display:inline-flex;align-items:center;gap:7px;font-family:var(--h);font-size:11px;font-weight:900;letter-spacing:.7px;text-transform:uppercase}.project-desc{color:var(--t2);font-size:14.5px;line-height:1.78;max-width:780px;margin:0 0 18px}.meta{display:flex;gap:10px;flex-wrap:wrap}.meta span{display:inline-flex;align-items:center;gap:8px;border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:999px;padding:8px 12px;color:var(--t3);font-size:12.5px;font-weight:700}.meta i{color:var(--sky)}.meta strong{color:var(--t1);font-weight:850}.side-box{border:1px solid var(--border2);background:rgba(255,255,255,.03);border-radius:18px;padding:16px;margin-bottom:12px}.side-box small{display:block;color:var(--t4);font-size:11px;font-weight:850;letter-spacing:1.1px;text-transform:uppercase;margin-bottom:6px}.side-box strong{display:block;font-family:var(--h);font-size:26px;line-height:1;color:var(--t1);letter-spacing:-.7px}.bid-btn{height:44px;width:100%;border-radius:13px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:#fff;display:inline-flex;align-items:center;justify-content:center;gap:9px;font-family:var(--h);font-size:13.5px;font-weight:900;transition:all .2s}.bid-btn:hover{color:#fff;transform:translateY(-2px);box-shadow:0 14px 30px rgba(59,130,246,.22)}.hint{color:var(--t4);font-size:12px;line-height:1.6;margin-top:10px;text-align:center}
.empty{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(8,11,18,.90));border-radius:26px;padding:62px 30px;text-align:center}.empty i{width:74px;height:74px;border-radius:24px;background:var(--pri-soft);border:1px solid var(--pri-mid);color:var(--sky);display:inline-flex;align-items:center;justify-content:center;font-size:28px;margin-bottom:22px}.empty h3{font-family:var(--h);font-size:28px;font-weight:880;margin-bottom:10px}.empty p{color:var(--t3);max-width:520px;margin:0 auto 24px;line-height:1.7}
.pagination{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-top:24px;border:1px solid var(--border);background:rgba(255,255,255,.025);border-radius:18px;padding:14px}.pager-left{color:var(--t3);font-size:13px;font-weight:700}.pager-actions{display:flex;gap:8px;align-items:center}.pager-btn{height:38px;border-radius:11px;padding:0 14px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);display:inline-flex;align-items:center;gap:8px;font-family:var(--h);font-size:12.5px;font-weight:850}.pager-btn:hover{color:var(--t1);background:rgba(255,255,255,.06)}.pager-btn.disabled{opacity:.4;pointer-events:none}.pager-num{height:38px;min-width:38px;border-radius:11px;border:1px solid var(--pri-mid);background:var(--pri-soft);color:var(--sky);display:inline-flex;align-items:center;justify-content:center;font-family:var(--h);font-weight:900}
.footer{border-top:1px solid var(--border);padding:32px 0;background:rgba(255,255,255,.012)}.foot{display:flex;align-items:center;justify-content:space-between;gap:18px;flex-wrap:wrap;color:var(--t4);font-size:12px}.foot strong{font-family:var(--h);font-size:17px;color:var(--t1)}.foot strong span{color:var(--pri)}
.reveal{opacity:0;transform:translateY(22px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.reveal.show{opacity:1;transform:translateY(0)}.d1{transition-delay:.08s}.d2{transition-delay:.16s}.d3{transition-delay:.24s}
@media(max-width:1050px){.nav-links,.nav-actions{display:none}.menu-btn{display:block}.mobile-menu{display:block}.hero-grid{grid-template-columns:1fr}.filter-form{grid-template-columns:1fr 1fr}.project-row{grid-template-columns:1fr}.hero-card{display:grid;grid-template-columns:repeat(3,1fr);gap:1px}.stat{border-bottom:0;border-right:1px solid var(--border2);padding:12px}.stat:last-child{border-right:0}}
@media(max-width:680px){.wrap,.nav-inner{padding:0 20px}.page{padding-top:92px}h1{letter-spacing:-2px}.hero-actions{flex-direction:column}.hbtn,.hbtn2{justify-content:center}.filter-form{grid-template-columns:1fr}.hero-card{grid-template-columns:1fr}.stat{border-right:0;border-bottom:1px solid var(--border2)}.market-head{display:block}.page-info{margin-top:12px}.project-row{padding:20px;border-radius:20px}.project-title{font-size:20px}.pagination{flex-direction:column;align-items:stretch}.pager-actions{justify-content:space-between}.foot{flex-direction:column;text-align:center}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="nav">
  <div class="nav-inner">
    <a href="freelancerDashboard" class="logo">Work<span class="s">Sphere</span></a>
    <div class="nav-links">
      <a href="freelancerDashboard">Dashboard</a>
      <a href="viewAllProjects" class="active">Explore Projects</a>
      <a href="savedProjects">Saved Projects</a>
      <a href="myProposals">My Proposals</a>
      <a href="freelancerAssignedProjects">Assigned</a>
      <a href="freelancerNotifications">Notifications</a>
    </div>
    <div class="nav-actions">
      <a href="myProposals" class="nav-btn primary"><i class="fa-solid fa-paper-plane"></i> Proposals</a>
      <a href="freelancerLogout" class="nav-btn"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
    </div>
    <button class="menu-btn" id="menuBtn"><i class="fa-solid fa-bars"></i></button>
  </div>
</nav>

<div class="mobile-menu" id="mobileMenu">
  <div class="mobile-panel">
    <button class="close-menu" id="closeMenu"><i class="fa-solid fa-xmark"></i></button>
    <a href="freelancerDashboard">Dashboard</a>
    <a href="viewAllProjects">Explore Projects</a>
    <a href="savedProjects">Saved Projects</a>
    <a href="myProposals">My Proposals</a>
    <a href="freelancerAssignedProjects">Assigned Projects</a>
    <a href="freelancerNotifications">Notifications</a>
    <a href="freelancerLogout">Logout</a>
  </div>
</div>

<main class="page">
  <section class="hero">
    <div class="wrap hero-grid">
      <div class="reveal">
        <div class="eyebrow"><i class="fa-solid fa-filter-circle-dollar"></i> Open-project marketplace</div>
        <h1>Explore only <em>available projects</em> ready for bids.</h1>
        <p>This marketplace now loads open projects directly from the database with search, sorting, and pagination, so freelancers do not waste time on closed or completed work.</p>
        <div class="hero-actions">
          <a href="#projectBoard" class="hbtn"><i class="fa-solid fa-magnifying-glass"></i> Browse Open Projects</a>
          <a href="myProposals" class="hbtn2"><i class="fa-solid fa-paper-plane"></i> My Proposals</a>
          <a href="savedProjects" class="hbtn2"><i class="fa-solid fa-bookmark"></i> Saved Projects (<%= savedCount %>)</a>
        </div>
      </div>
      <aside class="hero-card reveal d1">
        <div class="stat"><strong><%= totalOpenProjects %></strong><span>Total matching open projects</span></div>
        <div class="stat"><strong><%= visibleCount %></strong><span>Visible on this page</span></div>
        <div class="stat"><strong><%= currentPage %>/<%= totalPages %></strong><span>Current page</span></div>
      </aside>
    </div>
  </section>

  <section class="filters">
    <div class="wrap">
      <form class="filter-form" action="viewAllProjects" method="get">
        <div class="field">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="<%= safe(searchQuery) %>" placeholder="Search by title, client, or description...">
        </div>
        <div class="field">
          <select name="sort" aria-label="Sort projects">
            <option value="latest" <%= selected(sortOption,"latest") %>>Sort: Latest</option>
            <option value="budgetHigh" <%= selected(sortOption,"budgetHigh") %>>Budget: High to Low</option>
            <option value="budgetLow" <%= selected(sortOption,"budgetLow") %>>Budget: Low to High</option>
            <option value="deadlineSoon" <%= selected(sortOption,"deadlineSoon") %>>Deadline: Soonest</option>
            <option value="titleAZ" <%= selected(sortOption,"titleAZ") %>>Title: A to Z</option>
          </select>
        </div>
        <button type="submit" class="filter-btn"><i class="fa-solid fa-sliders"></i> Apply</button>
        <a href="viewAllProjects" class="clear-btn"><i class="fa-solid fa-rotate-right"></i>&nbsp; Reset</a>
      </form>
    </div>
  </section>

  <section class="market" id="projectBoard">
    <div class="wrap">
      <div class="market-head reveal">
        <div>
          <div class="section-tag">Filtered Marketplace</div>
          <h2 class="section-title">Open projects you can bid on</h2>
          <p class="section-desc">Only projects with <strong>Open</strong> status appear here. In-progress, submitted, revision, and completed projects are hidden automatically.</p>
        </div>
        <div class="page-info"><b><%= visibleCount %></b> shown · <b><%= totalOpenProjects %></b> total</div>
      </div>

      <div class="project-list">
      <%
      if(projects != null && !projects.isEmpty()){
          int index = 0;
          for(ProjectModel p : projects){
              if(p == null) continue;
              index++;
              String clientName = "Client";
              if(p.getClient() != null && p.getClient().getName() != null && p.getClient().getName().trim().length() > 0){
                  clientName = p.getClient().getName();
              }
              boolean alreadySaved = savedProjectIds != null && savedProjectIds.contains(Integer.valueOf(p.getId()));
      %>
        <article class="project-row reveal d<%= (index % 4) %>">
          <div class="project-content">
            <div class="title-line">
              <h3 class="project-title"><%= safe(p.getTitle()) %></h3>
              <span class="status-pill"><i class="fa-solid fa-circle"></i> Open</span>
            </div>
            <p class="project-desc"><%= safe(p.getDescription()) %></p>
            <div class="meta">
              <span><i class="fa-solid fa-user-tie"></i> Client <strong><%= safe(clientName) %></strong></span>
              <span><i class="fa-regular fa-calendar"></i> Deadline <strong><%= safe(p.getDeadline()) %></strong></span>
              <span><i class="fa-solid fa-hashtag"></i> Project <strong>#<%= p.getId() %></strong></span>
            </div>
          </div>
          <aside class="project-side">
            <div class="side-box">
              <small>Project Budget</small>
              <strong>₹<%= money(p.getBudget()) %></strong>
            </div>
            <a href="applyBidPage?projectId=<%= p.getId() %>" class="bid-btn"><i class="fa-solid fa-gavel"></i> Apply Bid</a>

            <% if(alreadySaved){ %>
              <form action="removeSavedProject" method="post" class="save-form">
                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                <input type="hidden" name="returnUrl" value="viewAllProjects?<%= baseParams %>&page=<%= currentPage %>">
                <button type="submit" class="save-btn saved"><i class="fa-solid fa-bookmark"></i> Saved · Remove</button>
              </form>
            <% } else { %>
              <form action="saveProjectBookmark" method="post" class="save-form">
                <input type="hidden" name="projectId" value="<%= p.getId() %>">
                <input type="hidden" name="returnUrl" value="viewAllProjects?<%= baseParams %>&page=<%= currentPage %>">
                <button type="submit" class="save-btn"><i class="fa-regular fa-bookmark"></i> Save for Later</button>
              </form>
            <% } %>

            <div class="hint">Only open projects can receive new proposals.</div>
            <div class="save-note">Saved projects are private to your freelancer account.</div>
          </aside>
        </article>
      <%
          }
      }else{
      %>
        <div class="empty reveal">
          <i class="fa-solid fa-folder-open"></i>
          <h3>No open projects found</h3>
          <% if(searchQuery != null && searchQuery.trim().length() > 0){ %>
            <p>No open project matched your search. Try a different keyword or reset filters.</p>
            <a href="viewAllProjects" class="hbtn"><i class="fa-solid fa-rotate-right"></i> Reset Filters</a>
          <% }else{ %>
            <p>There are no available client projects right now. Check again later from your freelancer dashboard.</p>
            <a href="freelancerDashboard" class="hbtn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
          <% } %>
        </div>
      <%
      }
      %>
      </div>

      <div class="pagination reveal">
        <div class="pager-left">
          Page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong> · <%= pageSize %> projects per page
        </div>
        <div class="pager-actions">
          <a class="pager-btn <%= currentPage <= 1 ? "disabled" : "" %>" href="viewAllProjects?<%= baseParams %>&page=<%= currentPage - 1 %>">
            <i class="fa-solid fa-arrow-left"></i> Previous
          </a>
          <span class="pager-num"><%= currentPage %></span>
          <a class="pager-btn <%= currentPage >= totalPages ? "disabled" : "" %>" href="viewAllProjects?<%= baseParams %>&page=<%= currentPage + 1 %>">
            Next <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
      </div>
    </div>
  </section>
</main>

<footer class="footer">
  <div class="wrap foot">
    <strong>Work<span>Sphere</span></strong>
    <div>Explore open client projects with faster search and pagination.</div>
  </div>
</footer>

<script>
(function(){
  const nav=document.getElementById('nav');
  const progress=document.getElementById('progressTop');
  let ticking=false;

  function onScroll(){
    const y=window.scrollY;
    const h=document.documentElement.scrollHeight-window.innerHeight;
    if(progress){progress.style.width=(h>0?y/h*100:0)+'%';}
    if(nav){nav.classList.toggle('scrolled',y>28);}
    ticking=false;
  }

  window.addEventListener('scroll',function(){
    if(!ticking){requestAnimationFrame(onScroll);ticking=true;}
  },{passive:true});
  onScroll();

  const revealObserver=new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){entry.target.classList.add('show');revealObserver.unobserve(entry.target);}
    });
  },{threshold:.08,rootMargin:'0px 0px -4px 0px'});
  document.querySelectorAll('.reveal').forEach(function(el){revealObserver.observe(el);});

  const menu=document.getElementById('mobileMenu');
  const open=document.getElementById('menuBtn');
  const close=document.getElementById('closeMenu');
  function closeMenu(){if(menu){menu.classList.remove('open');document.body.style.overflow='';}}
  if(open && menu){open.addEventListener('click',function(){menu.classList.add('open');document.body.style.overflow='hidden';});}
  if(close){close.addEventListener('click',closeMenu);}
  if(menu){menu.addEventListener('click',function(e){if(e.target===menu)closeMenu();});}
})();
</script>
</body>
</html>
