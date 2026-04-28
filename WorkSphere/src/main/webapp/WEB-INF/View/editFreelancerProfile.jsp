<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.FreelancerProfileModel" %>

<%
FreelancerProfileModel profile = (FreelancerProfileModel) request.getAttribute("profile");
if(profile == null){
    profile = new FreelancerProfileModel();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Freelancer Profile | WorkSphere</title>

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
.edit-layout{display:grid;grid-template-columns:360px 1fr;gap:24px;margin-top:14px;align-items:start}
.preview-card{padding:28px;text-align:center;position:sticky;top:92px}
.preview-img{
  width:118px;height:118px;border-radius:32px;object-fit:cover;
  border:1px solid var(--pri-mid);box-shadow:0 24px 54px rgba(59,130,246,.18);margin-bottom:16px;
}
.preview-title{font-family:var(--h);font-size:24px;font-weight:900;letter-spacing:-.8px;margin-bottom:5px}
.preview-sub{color:var(--t3);font-size:13px;margin-bottom:16px}
.preview-info{display:grid;gap:1px;border:1px solid var(--border);background:var(--border);border-radius:18px;overflow:hidden;text-align:left}
.preview-info div{background:rgba(11,13,20,.72);padding:14px;color:var(--t3);font-size:13px}
.preview-info strong{display:block;color:var(--t1);font-family:var(--h);font-size:16px;margin-top:3px}
.skill-preview{display:flex;gap:7px;flex-wrap:wrap;margin-top:16px;justify-content:center}
.skill-preview span{border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t2);border-radius:999px;padding:7px 10px;font-size:12px;font-weight:750}
.form-panel{padding:30px}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.field.full{grid-column:1/-1}
label{display:block;font-family:var(--h);font-size:13px;font-weight:750;color:var(--t2);margin-bottom:8px}
.form-control{
  width:100%;border:1px solid var(--border);border-radius:15px;
  background:rgba(255,255,255,.035);color:var(--t1);
  padding:14px 15px;font-family:var(--b);outline:none;transition:all .2s;
}
textarea.form-control{min-height:150px;resize:vertical;line-height:1.7}
.form-control:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft);background:rgba(255,255,255,.05)}
.form-control::placeholder{color:var(--t4)}
@media(max-width:980px){.edit-layout{grid-template-columns:1fr}.preview-card{position:relative;top:auto}}
@media(max-width:720px){.form-grid{grid-template-columns:1fr}.field.full{grid-column:auto}}
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
      <div class="kicker reveal"><i class="fa-solid fa-pen-to-square"></i> Edit separate profile</div>
      <h1 class="reveal d1">Update your <em>freelancer profile</em>.</h1>
      <p class="reveal d2">Keep this separate page for editing your public freelancer profile details.</p>

      <div class="edit-layout">
        <aside class="panel preview-card zoom d1">
          <img src="<%= profile.getProfileImage() != null && !profile.getProfileImage().trim().equals("") ? profile.getProfileImage() : "https://via.placeholder.com/120" %>" class="preview-img" alt="Profile Preview">
          <div class="preview-title"><%= profile.getProfessionalTitle() != null && !profile.getProfessionalTitle().trim().equals("") ? profile.getProfessionalTitle() : "Your Title" %></div>
          <div class="preview-sub">Freelancer profile preview</div>

          <div class="preview-info">
            <div>Experience<strong><%= profile.getExperienceYears() %> years</strong></div>
            <div>Hourly Rate<strong>₹<%= profile.getHourlyRate() %> / hr</strong></div>
          </div>

          <div class="skill-preview">
            <%
            if(profile.getSkills()!=null && !profile.getSkills().trim().equals("")){
                String[] skills = profile.getSkills().split(",");
                for(String sk:skills){
            %>
              <span><%= sk.trim() %></span>
            <%
                }
            } else {
            %>
              <span>No skills added</span>
            <%
            }
            %>
          </div>
        </aside>

        <section class="panel form-panel reveal d2">
          <div class="section-title">Profile Information</div>
          <p class="section-copy" style="margin-bottom:24px">Edit your title, bio, skills, experience, hourly rate, and profile image URL.</p>

          <form action="saveFreelancerProfile" method="post">
            <input type="hidden" name="profileId" value="<%= profile.getProfileId() %>">
            <input type="hidden" name="freelancerId" value="<%= profile.getFreelancerId() %>">

            <div class="form-grid">
              <div class="field full">
                <label>Professional Title</label>
                <input type="text" name="professionalTitle" class="form-control"
                  value="<%= profile.getProfessionalTitle() != null ? profile.getProfessionalTitle() : "" %>">
              </div>

              <div class="field full">
                <label>Bio</label>
                <textarea name="bio" class="form-control"><%= profile.getBio() != null ? profile.getBio() : "" %></textarea>
              </div>

              <div class="field full">
                <label>Skills</label>
                <input type="text" name="skills" class="form-control"
                  value="<%= profile.getSkills() != null ? profile.getSkills() : "" %>">
              </div>

              <div class="field">
                <label>Experience</label>
                <input type="number" name="experienceYears" class="form-control"
                  value="<%= profile.getExperienceYears() %>">
              </div>

              <div class="field">
                <label>Hourly Rate</label>
                <input type="number" name="hourlyRate" class="form-control"
                  value="<%= profile.getHourlyRate() %>">
              </div>

              <div class="field full">
                <label>Profile Image URL</label>
                <input type="text" name="profileImage" class="form-control"
                  value="<%= profile.getProfileImage() != null ? profile.getProfileImage() : "" %>">
              </div>
            </div>

            <div class="action-row">
              <button class="action-main" type="submit"><i class="fa-solid fa-check"></i>Save Profile</button>
              <a href="viewFreelancerProfile" class="action-ghost"><i class="fa-solid fa-eye"></i>View Profile</a>
              <a href="freelancerDashboard" class="action-ghost"><i class="fa-solid fa-arrow-left"></i>Back</a>
            </div>
          </form>
        </section>
      </div>
    </div>
  </section>

  <footer class="footer">
    <div class="wrap footer-in">
      <div><b>WorkSphere</b> • Edit Freelancer Profile</div>
      <div>Separate edit page restored</div>
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
