<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.model.SavedProjectModel" %>
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

private String enc(Object value){
    try{
        return URLEncoder.encode(value == null ? "" : String.valueOf(value), "UTF-8");
    }catch(Exception e){
        return "";
    }
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

private String money(double value){
    if(value == Math.rint(value)){
        return String.valueOf((long)value);
    }
    return String.format("%.2f", value);
}

private String statusClass(Object status){
    if(status == null) return "muted";
    String s = String.valueOf(status).toLowerCase();
    if(s.contains("open")) return "open";
    if(s.contains("payment")) return "warning";
    if(s.contains("progress")) return "info";
    if(s.contains("complete")) return "success";
    if(s.contains("cancel")) return "danger";
    return "muted";
}

private String pageUrl(String q, String sort, int page){
    return "savedProjects?q=" + enc(q) + "&sort=" + enc(sort) + "&page=" + page;
}
%>

<%
FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");
if(freelancer == null){
    response.sendRedirect("freelancerLogin");
    return;
}

List<SavedProjectModel> savedProjects = (List<SavedProjectModel>) request.getAttribute("savedProjects");
String searchQuery = request.getAttribute("searchQuery") == null ? "" : String.valueOf(request.getAttribute("searchQuery"));
String sortOption = request.getAttribute("sortOption") == null ? "latest" : String.valueOf(request.getAttribute("sortOption"));
int currentPage = toInt(request.getAttribute("currentPage"), 1);
int totalPages = toInt(request.getAttribute("totalPages"), 1);
int pageSize = toInt(request.getAttribute("pageSize"), 8);
long totalSavedProjects = toLong(request.getAttribute("totalSavedProjects"), 0L);
long allSavedProjects = toLong(request.getAttribute("allSavedProjects"), 0L);

if(currentPage < 1) currentPage = 1;
if(totalPages < 1) totalPages = 1;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Saved Projects | WorkSphere</title>

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
  min-height:100vh;
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
}
body::before{
  content:"";
  position:fixed;
  inset:0;
  z-index:-4;
  background:
    radial-gradient(circle at 18% 8%,rgba(59,130,246,.23),transparent 34%),
    radial-gradient(circle at 88% 24%,rgba(34,211,238,.14),transparent 32%),
    radial-gradient(circle at 35% 92%,rgba(139,92,246,.12),transparent 35%),
    linear-gradient(180deg,#07080D 0%,#090B12 47%,#07080D 100%);
}
body::after{
  content:"";
  position:fixed;
  inset:0;
  z-index:-3;
  background-image:
    linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);
  background-size:54px 54px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.22),transparent);
  -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.86),rgba(0,0,0,.22),transparent);
}
a{color:inherit;text-decoration:none}
button,input,select{font:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
.progress-top{position:fixed;top:0;left:0;height:2px;width:0%;z-index:5000;background:linear-gradient(90deg,var(--pri),var(--cyan));box-shadow:0 0 18px rgba(59,130,246,.3)}

.ws-nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:.3s}
.ws-nav.scrolled{background:rgba(7,8,13,.82);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-inner{max-width:var(--max);height:70px;margin:0 auto;padding:0 32px;display:flex;align-items:center;justify-content:space-between;gap:24px}
.logo{font-family:var(--h);font-size:20px;font-weight:850;letter-spacing:-.75px}
.logo .s{color:var(--pri)}
.nav-links{display:flex;gap:2px;align-items:center}
.nav-links a{color:var(--t3);font-family:var(--h);font-size:13px;font-weight:650;padding:8px 13px;border-radius:999px;transition:.2s}
.nav-links a:hover,.nav-links a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-actions{display:flex;gap:8px;align-items:center}
.nav-btn{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);border-radius:11px;padding:10px 15px;font-family:var(--h);font-size:13px;font-weight:800;display:inline-flex;align-items:center;gap:8px;transition:.2s}
.nav-btn:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.055)}
.nav-btn.primary{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.nav-btn.primary:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24)}

.page{padding:116px 0 72px}
.hero{position:relative;padding:24px 0 28px}
.hero-grid{display:grid;grid-template-columns:1.08fr .92fr;gap:38px;align-items:end}
.eyebrow{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:8px 13px;color:var(--t2);font-size:12px;font-weight:800;margin-bottom:18px}
.eyebrow i{color:var(--cyan)}
h1{font-family:var(--h);font-size:clamp(42px,5.5vw,78px);line-height:.95;font-weight:880;letter-spacing:-3px;margin:0 0 18px}
h1 em{font-style:normal;font-weight:260;color:var(--t3)}
.hero p{font-size:16px;line-height:1.85;color:var(--t2);max-width:720px;margin:0 0 26px}
.hero-actions{display:flex;gap:10px;flex-wrap:wrap}
.hbtn,.hbtn2{padding:13px 22px;border-radius:12px;font-family:var(--h);font-weight:850;font-size:14px;display:inline-flex;align-items:center;gap:9px;transition:.2s;border:0;cursor:pointer}
.hbtn{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.hbtn:hover{color:white;transform:translateY(-2px);box-shadow:0 18px 45px rgba(59,130,246,.28)}
.hbtn2{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2)}
.hbtn2:hover{color:var(--t1);border-color:rgba(255,255,255,.16);transform:translateY(-2px)}
.hero-panel{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.90),rgba(8,11,18,.88));border-radius:28px;padding:26px;position:relative;overflow:hidden}
.hero-panel::before{content:"";position:absolute;right:-100px;top:-110px;width:260px;height:260px;border-radius:50%;background:radial-gradient(circle,rgba(34,211,238,.18),transparent 68%)}
.hero-panel>*{position:relative}
.hero-panel h3{font-family:var(--h);font-size:27px;letter-spacing:-.9px;margin-bottom:10px}
.hero-panel p{font-size:13.5px;color:var(--t3);line-height:1.8;margin:0}
.stat-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:1px;border:1px solid var(--border);background:var(--border);border-radius:24px;overflow:hidden;margin:30px 0}
.stat{background:rgba(11,13,20,.78);padding:22px}
.stat small{display:block;color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:1px;font-weight:850;margin-bottom:8px}
.stat b{font-family:var(--h);font-size:32px;letter-spacing:-1px}

.command{position:sticky;top:82px;z-index:40;border:1px solid var(--border);background:rgba(8,10,16,.80);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border-radius:22px;padding:14px;margin-bottom:28px}
.filter-form{display:grid;grid-template-columns:minmax(240px,1fr) 210px auto;gap:12px;align-items:center}
.field{position:relative}
.field i{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:13px}
.field input,.field select{width:100%;height:46px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t1);border-radius:14px;padding:0 15px;outline:none;font-size:14px;transition:.2s}
.field input{padding-left:40px}
.field input:focus,.field select:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft)}
.field select option{background:#10131D;color:#fff}
.filter-actions{display:flex;gap:8px}
.filter-btn,.reset-btn{height:46px;border-radius:14px;padding:0 16px;font-family:var(--h);font-size:13px;font-weight:850;display:inline-flex;align-items:center;justify-content:center;gap:8px;white-space:nowrap;transition:.2s}
.filter-btn{border:0;color:white;background:linear-gradient(135deg,var(--pri),var(--cyan))}
.reset-btn{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.025)}
.filter-btn:hover,.reset-btn:hover{transform:translateY(-1px);color:white}

.section-title{font-family:var(--h);font-size:clamp(30px,3vw,42px);letter-spacing:-1.4px;margin-bottom:8px}
.section-copy{color:var(--t3);line-height:1.75;margin-bottom:20px;max-width:720px}
.saved-list{display:grid;gap:16px}
.saved-row{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.82),rgba(8,11,18,.78));border-radius:26px;padding:24px;position:relative;overflow:hidden;transition:.24s}
.saved-row::before{content:"";position:absolute;inset:0;background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);transform:translateX(-110%);transition:.75s}
.saved-row:hover{transform:translateY(-5px);border-color:var(--pri-mid);box-shadow:0 26px 70px rgba(0,0,0,.24)}
.saved-row:hover::before{transform:translateX(110%)}
.saved-main{position:relative;z-index:1;display:grid;grid-template-columns:1fr 250px;gap:22px}
.title-line{display:flex;gap:12px;align-items:flex-start;justify-content:space-between;margin-bottom:12px}
.project-title{font-family:var(--h);font-size:24px;letter-spacing:-.7px;margin:0}
.status-pill{display:inline-flex;align-items:center;gap:7px;border-radius:999px;padding:8px 12px;font-family:var(--h);font-size:12px;font-weight:850;white-space:nowrap;border:1px solid var(--border);background:rgba(255,255,255,.035)}
.status-pill.open{color:#BAE6FD;border-color:rgba(34,211,238,.20);background:rgba(34,211,238,.08)}
.status-pill.warning{color:#FDE68A;border-color:rgba(245,158,11,.22);background:rgba(245,158,11,.09)}
.status-pill.info{color:#BFDBFE;border-color:rgba(59,130,246,.22);background:rgba(59,130,246,.09)}
.status-pill.success{color:#BBF7D0;border-color:rgba(34,197,94,.22);background:rgba(34,197,94,.09)}
.status-pill.danger{color:#FECACA;border-color:rgba(239,68,68,.22);background:rgba(239,68,68,.09)}
.status-pill.muted{color:#CBD5E1;border-color:rgba(148,163,184,.18);background:rgba(148,163,184,.08)}
.project-desc{color:var(--t2);font-size:14px;line-height:1.8;margin:0 0 14px;max-width:760px}
.meta{display:flex;gap:8px;flex-wrap:wrap}
.meta span{display:inline-flex;align-items:center;gap:7px;border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:999px;padding:8px 11px;color:var(--t3);font-size:12.5px}
.meta i{color:var(--cyan)}
.side-box{border:1px solid var(--border2);background:rgba(255,255,255,.035);border-radius:18px;padding:17px;text-align:center;margin-bottom:12px}
.side-box small{display:block;color:var(--t3);text-transform:uppercase;letter-spacing:1px;font-size:11px;font-weight:850;margin-bottom:8px}
.side-box strong{display:block;font-family:var(--h);font-size:28px;letter-spacing:-1px}
.row-actions{display:grid;gap:9px}
.action-btn{width:100%;min-height:43px;border-radius:12px;border:0;display:flex;align-items:center;justify-content:center;gap:8px;font-family:var(--h);font-size:13px;font-weight:850;cursor:pointer;transition:.2s}
.apply{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.remove{border:1px solid rgba(239,68,68,.22);background:rgba(239,68,68,.10);color:#FCA5A5}
.disabled{border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t4);cursor:not-allowed}
.action-btn:hover:not(.disabled){transform:translateY(-2px)}
.saved-at{color:var(--t4);font-size:12px;text-align:center;margin-top:8px;line-height:1.5}

.empty{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.82),rgba(8,11,18,.78));border-radius:30px;padding:58px 32px;text-align:center;position:relative;overflow:hidden}
.empty::before{content:"";position:absolute;left:50%;top:-120px;width:420px;height:420px;transform:translateX(-50%);border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.28),transparent 64%)}
.empty>*{position:relative}
.empty i{font-size:42px;color:var(--cyan);margin-bottom:18px}
.empty h3{font-family:var(--h);font-size:30px;letter-spacing:-1px;margin-bottom:10px}
.empty p{color:var(--t3);line-height:1.8;max-width:560px;margin:0 auto 24px}
.pagination{display:flex;justify-content:space-between;align-items:center;gap:16px;border:1px solid var(--border);background:rgba(255,255,255,.025);border-radius:18px;padding:14px 16px;margin-top:22px;color:var(--t3);font-size:13px}
.pager-actions{display:flex;gap:8px;align-items:center}
.pager-btn,.pager-num{height:38px;min-width:38px;padding:0 13px;border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);display:inline-flex;align-items:center;justify-content:center;font-family:var(--h);font-size:13px;font-weight:850;transition:.2s}
.pager-btn:hover{color:white;border-color:var(--pri-mid);background:rgba(59,130,246,.13)}
.pager-btn.disabled{opacity:.35;pointer-events:none}
.footer{border-top:1px solid var(--border);background:rgba(255,255,255,.012);padding:28px 0;margin-top:70px;color:var(--t3)}
.foot{display:flex;justify-content:space-between;gap:20px;flex-wrap:wrap}
.foot strong{font-family:var(--h);font-size:18px;color:var(--t1)}
.foot strong span{color:var(--pri)}
.reveal{opacity:0;transform:translateY(22px);transition:.7s cubic-bezier(.16,1,.3,1)}
.reveal.show{opacity:1;transform:translateY(0)}
@media(max-width:980px){.hero-grid,.saved-main{grid-template-columns:1fr}.nav-links{display:none}.filter-form{grid-template-columns:1fr}.filter-actions{display:grid;grid-template-columns:1fr 1fr}.stat-grid{grid-template-columns:1fr}.command{position:relative;top:auto}}
@media(max-width:640px){.wrap,.nav-inner{padding:0 20px}.nav-actions .nav-btn:not(.primary){display:none}.page{padding-top:98px}.pagination{align-items:flex-start;flex-direction:column}.title-line{display:grid}.hero-actions{display:grid}.hbtn,.hbtn2{justify-content:center}}
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
      <a href="viewAllProjects">Explore Projects</a>
      <a href="savedProjects" class="active">Saved Projects</a>
      <a href="myProposals">My Proposals</a>
      <a href="freelancerAssignedProjects">Assigned</a>
    </div>
    <div class="nav-actions">
      <a href="viewAllProjects" class="nav-btn"><i class="fa-solid fa-magnifying-glass"></i> Explore</a>
      <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
    </div>
  </div>
</nav>

<main class="page">
  <section class="hero">
    <div class="wrap hero-grid">
      <div class="reveal">
        <div class="eyebrow"><i class="fa-solid fa-bookmark"></i> Saved project board</div>
        <h1>Save good projects and <em>apply later.</em></h1>
        <p>Keep interesting open projects in one focused board. Remove projects that no longer fit, apply when you are ready, and avoid losing strong opportunities.</p>
        <div class="hero-actions">
          <a href="viewAllProjects" class="hbtn"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
          <a href="#savedBoard" class="hbtn2"><i class="fa-solid fa-bookmark"></i> View Saved List</a>
        </div>
      </div>

      <aside class="hero-panel reveal">
        <h3>Saved workflow</h3>
        <p>Saved projects are private to the freelancer account. Only open projects can be saved and applied to directly. Closed or funded projects stay visible for reference but cannot be applied to.</p>
      </aside>
    </div>

    <div class="wrap">
      <div class="stat-grid reveal">
        <div class="stat"><small>All saved</small><b><%= allSavedProjects %></b></div>
        <div class="stat"><small>Current results</small><b><%= totalSavedProjects %></b></div>
        <div class="stat"><small>Page size</small><b><%= pageSize %></b></div>
      </div>
    </div>
  </section>

  <section id="savedBoard">
    <div class="wrap">
      <div class="command reveal">
        <form action="savedProjects" method="get" class="filter-form">
          <div class="field">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="q" value="<%= safe(searchQuery) %>" placeholder="Search saved projects, client, status...">
          </div>

          <div class="field">
            <select name="sort" aria-label="Sort saved projects">
              <option value="latest" <%= "latest".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Latest saved</option>
              <option value="budgethigh" <%= "budgethigh".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Budget: High to Low</option>
              <option value="budgetlow" <%= "budgetlow".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Budget: Low to High</option>
              <option value="deadline" <%= "deadline".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Deadline soon</option>
              <option value="projectaz" <%= "projectaz".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Project A-Z</option>
              <option value="status" <%= "status".equalsIgnoreCase(sortOption) ? "selected" : "" %>>Status</option>
            </select>
          </div>

          <div class="filter-actions">
            <button type="submit" class="filter-btn"><i class="fa-solid fa-filter"></i> Apply</button>
            <a href="savedProjects" class="reset-btn"><i class="fa-solid fa-rotate-left"></i> Reset</a>
          </div>
        </form>
      </div>

      <h2 class="section-title reveal">Saved projects</h2>
      <p class="section-copy reveal">Review the projects you saved for later. Apply to open projects or remove items you no longer want to track.</p>

      <% if(savedProjects != null && !savedProjects.isEmpty()){ %>
        <div class="saved-list">
        <% for(SavedProjectModel saved : savedProjects){
            if(saved == null || saved.getProject() == null) continue;
            ProjectModel p = saved.getProject();
            String clientName = "Client";
            if(p.getClient() != null && p.getClient().getName() != null && p.getClient().getName().trim().length() > 0){
                clientName = p.getClient().getName();
            }
            String st = safe(p.getStatus());
            boolean open = "Open".equalsIgnoreCase(p.getStatus());
        %>
          <article class="saved-row reveal">
            <div class="saved-main">
              <div>
                <div class="title-line">
                  <h3 class="project-title"><%= safe(p.getTitle()) %></h3>
                  <span class="status-pill <%= statusClass(p.getStatus()) %>"><i class="fa-solid fa-circle"></i> <%= st %></span>
                </div>
                <p class="project-desc"><%= safe(p.getDescription()) %></p>

                <div class="meta">
                  <span><i class="fa-solid fa-user-tie"></i> Client <strong><%= safe(clientName) %></strong></span>
                  <span><i class="fa-solid fa-indian-rupee-sign"></i> Budget <strong>₹<%= money(p.getBudget()) %></strong></span>
                  <span><i class="fa-regular fa-calendar"></i> Deadline <strong><%= safe(p.getDeadline()) %></strong></span>
                  <span><i class="fa-solid fa-hashtag"></i> Project <strong>#<%= p.getId() %></strong></span>
                </div>
              </div>

              <aside>
                <div class="side-box">
                  <small>Saved on</small>
                  <strong><i class="fa-solid fa-bookmark"></i></strong>
                  <div class="saved-at"><%= safe(saved.getSavedAt()) %></div>
                </div>

                <div class="row-actions">
                  <% if(open){ %>
                    <a href="applyBidPage?projectId=<%= p.getId() %>" class="action-btn apply"><i class="fa-solid fa-gavel"></i> Apply Now</a>
                  <% } else { %>
                    <button type="button" class="action-btn disabled"><i class="fa-solid fa-lock"></i> Not Open</button>
                  <% } %>

                  <form action="removeSavedProject" method="post" style="margin:0;">
                    <input type="hidden" name="projectId" value="<%= p.getId() %>">
                    <input type="hidden" name="returnUrl" value="savedProjects?q=<%= enc(searchQuery) %>&sort=<%= enc(sortOption) %>&page=<%= currentPage %>">
                    <button type="submit" class="action-btn remove" onclick="return confirm('Remove this project from your saved list?');"><i class="fa-solid fa-bookmark-slash"></i> Remove</button>
                  </form>
                </div>
              </aside>
            </div>
          </article>
        <% } %>
        </div>
      <% } else { %>
        <div class="empty reveal">
          <i class="fa-regular fa-bookmark"></i>
          <h3>No saved projects found</h3>
          <% if(searchQuery != null && searchQuery.trim().length() > 0){ %>
            <p>No saved project matched your search. Reset filters or search with a different keyword.</p>
            <a href="savedProjects" class="hbtn"><i class="fa-solid fa-rotate-right"></i> Reset Saved Projects</a>
          <% } else { %>
            <p>Your saved board is empty. Explore open projects and save the ones you want to apply to later.</p>
            <a href="viewAllProjects" class="hbtn"><i class="fa-solid fa-briefcase"></i> Explore Projects</a>
          <% } %>
        </div>
      <% } %>

      <% if(totalPages > 1){ %>
      <div class="pagination reveal">
        <div>Page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong> · <%= pageSize %> saved projects per page</div>
        <div class="pager-actions">
          <a class="pager-btn <%= currentPage <= 1 ? "disabled" : "" %>" href="<%= pageUrl(searchQuery, sortOption, currentPage - 1) %>"><i class="fa-solid fa-arrow-left"></i> Previous</a>
          <span class="pager-num"><%= currentPage %></span>
          <a class="pager-btn <%= currentPage >= totalPages ? "disabled" : "" %>" href="<%= pageUrl(searchQuery, sortOption, currentPage + 1) %>">Next <i class="fa-solid fa-arrow-right"></i></a>
        </div>
      </div>
      <% } %>
    </div>
  </section>
</main>

<footer class="footer">
  <div class="wrap foot">
    <strong>Work<span>Sphere</span></strong>
    <div>Saved Projects • Apply later workspace</div>
  </div>
</footer>

<script>
(function(){
  const nav=document.getElementById('nav');
  const progress=document.getElementById('progressTop');

  function onScroll(){
    const y=window.scrollY;
    const h=document.documentElement.scrollHeight-window.innerHeight;
    if(progress){progress.style.width=(h>0?y/h*100:0)+'%';}
    if(nav){nav.classList.toggle('scrolled',y>28);}
  }

  window.addEventListener('scroll',onScroll,{passive:true});
  onScroll();

  const revealObserver=new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        entry.target.classList.add('show');
        revealObserver.unobserve(entry.target);
      }
    });
  },{threshold:.08,rootMargin:'0px 0px -4px 0px'});

  document.querySelectorAll('.reveal').forEach(function(el){revealObserver.observe(el);});
})();
</script>
</body>
</html>
