<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.FreelancerModel" %>
<%@ page import="com.model.FreelancerProfileModel" %>
<%
FreelancerProfileModel profile = (FreelancerProfileModel) request.getAttribute("profile");
FreelancerModel freelancer = (FreelancerModel) request.getAttribute("freelancer");
Double avgRating = (Double) request.getAttribute("avgRating");
Long totalReviews = (Long) request.getAttribute("totalReviews");

if(avgRating == null) avgRating = 0.0;
if(totalReviews == null) totalReviews = 0L;

String firstLetter = "F";
if(freelancer != null && freelancer.getName() != null && !freelancer.getName().trim().isEmpty()){
    firstLetter = freelancer.getName().substring(0,1).toUpperCase();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Freelancer Profile | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--sky:#60A5FA;--cyan:#22D3EE;--violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,.08);--pri-mid:rgba(59,130,246,.18);
  --pri-glow:rgba(59,130,246,.28);--cyan-glow:rgba(34,211,238,.18);
  --bg:#07080D;--s1:#0B0D14;--s2:#10131D;--s3:#171B28;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--t4:#4B5568;
  --border:rgba(255,255,255,.08);--border2:rgba(255,255,255,.045);
  --ok:#22C55E;--warn:#F59E0B;
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1180px;
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
a{color:inherit;text-decoration:none}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}
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
.ws-nav{
  position:fixed;
  inset:0 0 auto 0;
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
  height:70px;
  margin:0 auto;
  padding:0 32px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:22px;
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
.nav-links a:hover,.nav-links a.active{
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
.menu-btn{display:none;border:0;background:none;color:var(--t2);font-size:19px;cursor:pointer}
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
.mobile-close{border:0;background:none;color:var(--t3);font-size:16px;margin-bottom:12px}
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
.page{position:relative;padding:118px 0 0}
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
}
.kicker{
  display:inline-flex;
  align-items:center;
  gap:9px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  border-radius:999px;
  padding:8px 13px;
  color:var(--t2);
  font-size:12px;
  font-weight:750;
  letter-spacing:.02em;
}
.kicker i{color:var(--cyan);font-size:11px}
.hero{
  position:relative;
  z-index:1;
  padding:24px 0 34px;
}
.hero h1{
  font-family:var(--h);
  font-size:clamp(42px,5vw,72px);
  line-height:.96;
  font-weight:850;
  letter-spacing:-2.7px;
  max-width:850px;
  margin:18px 0;
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
  max-width:720px;
}
.action-row{display:flex;gap:10px;flex-wrap:wrap;margin-top:24px}
.action-main,.action-ghost{
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
.action-main:hover{color:white;transform:translateY(-2px);box-shadow:0 18px 45px rgba(59,130,246,.28)}
.action-ghost{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.action-ghost:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.05);transform:translateY(-2px)}
.panel{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:30px;
  position:relative;
  overflow:hidden;
}
.panel::before{
  content:"";
  position:absolute;
  right:-110px;
  top:-110px;
  width:280px;
  height:280px;
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 67%);
  pointer-events:none;
}
.panel>*{position:relative;z-index:1}
.section-title{
  font-family:var(--h);
  font-size:24px;
  font-weight:850;
  letter-spacing:-.8px;
  margin-bottom:14px;
}
.section-copy{
  color:var(--t3);
  font-size:14px;
  line-height:1.8;
}
.footer{
  margin-top:80px;
  border-top:1px solid var(--border);
  padding:30px 0;
  color:var(--t4);
  font-size:12px;
}
.footer-in{display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap}
.footer b{color:var(--sky);font-family:var(--h)}
.reveal{opacity:0;transform:translateY(24px);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}
.reveal.show{opacity:1;transform:translateY(0)}
.zoom{opacity:0;transform:translateY(24px) scale(.97);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}
.zoom.show{opacity:1;transform:translateY(0) scale(1)}
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}
@media(max-width:980px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
}
@media(max-width:720px){
  .wrap,.nav-inner{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.8px}
  .footer-in{display:block}
}
</style>

<style>
.profile-layout{
  display:grid;
  grid-template-columns:.92fr 1.08fr;
  gap:22px;
  align-items:stretch;
  margin-top:14px;
}
.profile-showcase{padding:34px;min-height:100%}
.profile-top{display:flex;gap:24px;align-items:center;margin-bottom:26px}
.avatar,.avatar-fallback{
  width:132px;height:132px;min-width:132px;
  border-radius:36px;
  border:1px solid var(--pri-mid);
  box-shadow:0 26px 60px rgba(59,130,246,.18);
}
.avatar{object-fit:cover;background:rgba(255,255,255,.04)}
.avatar-fallback{
  display:flex;align-items:center;justify-content:center;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  font-family:var(--h);
  font-size:44px;
  font-weight:900;
}
.profile-name{
  font-family:var(--h);
  font-size:clamp(34px,4vw,54px);
  line-height:1;
  font-weight:900;
  letter-spacing:-2px;
  margin-bottom:8px;
}
.profile-title{
  color:var(--sky);
  font-family:var(--h);
  font-size:16px;
  font-weight:850;
  margin-bottom:13px;
}
.profile-tags{display:flex;flex-wrap:wrap;gap:8px}
.profile-tags span{
  display:inline-flex;align-items:center;gap:7px;
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  color:var(--t3);
  border-radius:999px;
  padding:7px 10px;
  font-size:12px;
  font-weight:700;
}
.profile-tags i{color:var(--cyan)}
.rating-line{display:flex;flex-wrap:wrap;gap:10px;margin:22px 0}
.rating-pill,.live-pill{
  display:inline-flex;align-items:center;gap:8px;
  padding:10px 13px;
  border-radius:999px;
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
}
.rating-pill{color:#FDE68A;background:rgba(245,158,11,.10);border:1px solid rgba(245,158,11,.22)}
.rating-pill span{color:var(--t2);opacity:.9}
.live-pill{color:var(--cyan);background:rgba(34,211,238,.08);border:1px solid rgba(34,211,238,.18)}
.profile-bio{color:var(--t2);font-size:14px;line-height:1.85;margin-bottom:24px}
.details-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.detail-card{padding:26px}
.detail-card.wide{grid-column:1/-1}
.detail-card h3{
  font-family:var(--h);
  font-size:18px;
  font-weight:900;
  letter-spacing:-.45px;
  margin-bottom:13px;
  display:flex;
  align-items:center;
  gap:9px;
}
.detail-card h3 i{color:var(--sky)}
.detail-text{color:var(--t3);font-size:13.5px;line-height:1.8}
.skill-list{display:flex;gap:8px;flex-wrap:wrap}
.skill-chip{
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
.stat-list{display:grid;gap:1px;border:1px solid var(--border);background:var(--border);border-radius:18px;overflow:hidden}
.stat-row{background:rgba(11,13,20,.72);padding:15px;display:flex;justify-content:space-between;gap:12px}
.stat-row span{color:var(--t3);font-size:12.5px;font-weight:750}
.stat-row strong{color:var(--t1);font-family:var(--h);font-size:18px;font-weight:900}
@media(max-width:980px){.profile-layout{grid-template-columns:1fr}}
@media(max-width:720px){.profile-top{flex-direction:column;align-items:flex-start}.details-grid{grid-template-columns:1fr}.detail-card.wide{grid-column:auto}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />



<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="freelancerDashboard" class="logo">Work<span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="freelancerDashboard">Dashboard</a>
      <a href="viewAllProjects">Explore</a>
      <a href="myProposals">Proposals</a>
      <a href="freelancerAssignedProjects">Assigned</a>
      <a href="viewFreelancerProfile" class="active">Profile</a>
      <a href="freelancerReviews">Reviews</a>
    </div>

    <div class="nav-actions">
      <a href="freelancerNotifications" class="nav-btn"><i class="fa-regular fa-bell"></i> Alerts</a>
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
    <a href="viewFreelancerProfile">My Profile</a>
    <a href="freelancerReviews">Reviews</a>
    <a href="freelancerNotifications">Notifications</a>
    <a href="freelancerLogout" class="nav-btn primary"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
  </div>
</div>


<main class="page">
  <section class="hero">
    <div class="wrap">
      <div class="kicker reveal"><i class="fa-solid fa-user"></i> Separate freelancer profile</div>
      <h1 class="reveal d1">Your professional <em>freelancer profile</em>.</h1>
      <p class="reveal d2">This is the separate profile page from your old dashboard flow, rebuilt in the new WorkSphere dark theme.</p>

      <div class="profile-layout">
        <section class="panel profile-showcase zoom d1">
          <div class="profile-top">
            <div>
              <% if(profile != null && profile.getProfileImage() != null && !profile.getProfileImage().trim().equals("")){ %>
                <img src="<%= profile.getProfileImage() %>" class="avatar" alt="Profile Image">
              <% } else { %>
                <div class="avatar-fallback"><%= firstLetter %></div>
              <% } %>
            </div>

            <div>
              <div class="profile-name"><%= freelancer != null ? freelancer.getName() : "Freelancer Profile" %></div>
              <div class="profile-title">
                <%= (profile != null && profile.getProfessionalTitle() != null && !profile.getProfessionalTitle().trim().equals("")) ? profile.getProfessionalTitle() : "Professional Freelancer" %>
              </div>

              <div class="profile-tags">
                <% if(freelancer != null && freelancer.getEmail() != null){ %>
                  <span><i class="fa-solid fa-envelope"></i><%= freelancer.getEmail() %></span>
                <% } %>
                <% if(freelancer != null && freelancer.getCity() != null){ %>
                  <span><i class="fa-solid fa-location-dot"></i><%= freelancer.getCity() %></span>
                <% } %>
              </div>
            </div>
          </div>

          <div class="rating-line">
            <span class="rating-pill">
              <i class="fa-solid fa-star"></i>
              <%= String.format("%.1f", avgRating) %> Rating
              <span>| <%= totalReviews %> Reviews</span>
            </span>
            <span class="live-pill"><i class="fa-solid fa-circle-check"></i> Profile Active</span>
          </div>

          <div class="profile-bio">
            <%= (profile != null && profile.getBio() != null && !profile.getBio().trim().equals("")) ? profile.getBio() : "No bio added yet." %>
          </div>

          <div class="action-row">
            <a href="editFreelancerProfile" class="action-main"><i class="fa-solid fa-pen-to-square"></i>Edit Profile</a>
            <a href="freelancerReviews" class="action-ghost"><i class="fa-solid fa-star"></i>View Reviews</a>
            <a href="freelancerDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i>Back</a>
          </div>
        </section>

        <section class="details-grid">
          <div class="panel detail-card reveal d1">
            <h3><i class="fa-solid fa-user"></i> About Me</h3>
            <div class="detail-text">
              <%= (profile != null && profile.getBio() != null && !profile.getBio().trim().equals("")) ? profile.getBio() : "No bio added yet." %>
            </div>
          </div>

          <div class="panel detail-card reveal d2">
            <h3><i class="fa-solid fa-chart-line"></i> Professional Details</h3>
            <div class="stat-list">
              <div class="stat-row">
                <span>Experience</span>
                <strong><%= profile != null ? profile.getExperienceYears() : 0 %> years</strong>
              </div>
              <div class="stat-row">
                <span>Hourly Rate</span>
                <strong>₹ <%= profile != null ? profile.getHourlyRate() : 0 %> / hr</strong>
              </div>
              <div class="stat-row">
                <span>Reviews</span>
                <strong><%= totalReviews %></strong>
              </div>
            </div>
          </div>

          <div class="panel detail-card wide reveal d3">
            <h3><i class="fa-solid fa-code"></i> Skills</h3>
            <div class="skill-list">
              <%
              if(profile != null && profile.getSkills() != null && !profile.getSkills().trim().equals("")){
                  String[] skills = profile.getSkills().split(",");
                  for(String skill : skills){
              %>
                <span class="skill-chip"><%= skill.trim() %></span>
              <%
                  }
              } else {
              %>
                <span class="skill-chip">No skills added yet</span>
              <%
              }
              %>
            </div>
          </div>
        </section>
      </div>
    </div>
  </section>

  <footer class="footer">
    <div class="wrap footer-in">
      <div><b>WorkSphere</b> • Freelancer Profile</div>
      <div>Separate profile page restored</div>
    </div>
  </footer>
</main>


<script>
(function(){
  const navbar=document.getElementById("navbar");
  const progressTop=document.getElementById("progressTop");
  function onScroll(){
    const scrolled=window.scrollY||document.documentElement.scrollTop;
    const height=document.documentElement.scrollHeight-window.innerHeight;
    if(progressTop){progressTop.style.width=(height>0?(scrolled/height)*100:0)+"%";}
    if(navbar){navbar.classList.toggle("scrolled",scrolled>20);}
  }
  window.addEventListener("scroll",onScroll,{passive:true});
  onScroll();

  const menu=document.getElementById("mobileMenu");
  const menuBtn=document.getElementById("menuBtn");
  const closeBtn=document.getElementById("mobileClose");
  if(menuBtn){menuBtn.addEventListener("click",function(){menu.classList.add("open");document.body.style.overflow="hidden";});}
  function closeMenu(){if(menu){menu.classList.remove("open");document.body.style.overflow="";}}
  if(closeBtn) closeBtn.addEventListener("click",closeMenu);
  if(menu) menu.addEventListener("click",function(e){if(e.target===menu)closeMenu();});
  document.querySelectorAll(".mobile-panel a").forEach(function(a){a.addEventListener("click",closeMenu);});

  const obs=new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if(entry.isIntersecting){
        entry.target.classList.add("show");
        obs.unobserve(entry.target);
      }
    });
  },{threshold:.08,rootMargin:"0px 0px -30px 0px"});
  document.querySelectorAll(".reveal,.zoom").forEach(function(el){obs.observe(el);});
})();
</script>

</body>
</html>
