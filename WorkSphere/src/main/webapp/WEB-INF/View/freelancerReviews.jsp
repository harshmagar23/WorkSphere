<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.ReviewModel" %>
<%
List<ReviewModel> reviewList = (List<ReviewModel>) request.getAttribute("reviewList");
Double avgRating = (Double) request.getAttribute("avgRating");
Long totalReviews = (Long) request.getAttribute("totalReviews");

if(avgRating == null) avgRating = 0.0;
if(totalReviews == null) totalReviews = 0L;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Freelancer Reviews | WorkSphere</title>

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
.reviews-layout{display:grid;grid-template-columns:330px 1fr;gap:24px;margin-top:14px;align-items:start}
.rating-panel{padding:28px;position:sticky;top:92px}
.rating-number{font-family:var(--h);font-size:72px;line-height:1;font-weight:900;letter-spacing:-3px;color:var(--sky);margin:16px 0 6px}
.rating-stars{color:#FBBF24;font-size:18px;margin-bottom:12px}
.rating-copy{color:var(--t3);font-size:14px;line-height:1.75}
.review-list{display:grid;gap:16px}
.review-card{padding:24px}
.review-rating{color:#FBBF24;font-size:17px;margin-bottom:12px}
.review-text{color:var(--t2);font-size:14.5px;line-height:1.85}
.empty-box{padding:50px 28px;text-align:center}
.empty-icon{width:72px;height:72px;border-radius:24px;background:var(--pri-soft);border:1px solid var(--pri-mid);color:var(--sky);display:flex;align-items:center;justify-content:center;margin:0 auto 18px;font-size:26px}
@media(max-width:980px){.reviews-layout{grid-template-columns:1fr}.rating-panel{position:relative;top:auto}}
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
      <div class="kicker reveal"><i class="fa-solid fa-star"></i> Separate review page</div>
      <h1 class="reveal d1">Client reviews and <em>work reputation</em>.</h1>
      <p class="reveal d2">This keeps your freelancer reviews as a separate page, connected from your profile and dashboard.</p>

      <div class="reviews-layout">
        <aside class="panel rating-panel zoom d1">
          <div class="section-title">Review Summary</div>
          <div class="rating-number"><%= String.format("%.1f", avgRating) %></div>
          <div class="rating-stars">
            <%
            int rounded = (int)Math.round(avgRating);
            for(int i=1;i<=5;i++){
                if(i <= rounded){
            %>
              <i class="fa-solid fa-star"></i>
            <%
                } else {
            %>
              <i class="fa-regular fa-star"></i>
            <%
                }
            }
            %>
          </div>
          <p class="rating-copy"><strong style="color:var(--t1);font-family:var(--h);"><%= totalReviews %></strong> total reviews from clients who worked with you.</p>

          <div class="action-row">
            <a href="viewFreelancerProfile" class="action-main"><i class="fa-solid fa-arrow-left"></i>Back to Profile</a>
          </div>
        </aside>

        <section class="review-list">
          <%
          if(reviewList != null && !reviewList.isEmpty()){
              int idx = 0;
              for(ReviewModel review : reviewList){
                  idx++;
          %>
            <article class="panel review-card reveal d<%= (idx % 3) + 1 %>">
              <div class="review-rating">
                <%
                for(int i=1;i<=5;i++){
                    if(i <= review.getRating()){
                %>
                  <i class="fa-solid fa-star"></i>
                <%
                    } else {
                %>
                  <i class="fa-regular fa-star"></i>
                <%
                    }
                }
                %>
              </div>
              <div class="review-text"><%= review.getReviewText() %></div>
            </article>
          <%
              }
          } else {
          %>
            <div class="panel empty-box zoom">
              <div class="empty-icon"><i class="fa-regular fa-face-smile"></i></div>
              <div class="section-title">No reviews yet</div>
              <p class="section-copy" style="margin:0 auto">Complete client projects and your reviews will appear here.</p>
            </div>
          <%
          }
          %>
        </section>
      </div>
    </div>
  </section>

  <footer class="footer">
    <div class="wrap footer-in">
      <div><b>WorkSphere</b> • Freelancer Reviews</div>
      <div>Separate reviews page restored</div>
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
