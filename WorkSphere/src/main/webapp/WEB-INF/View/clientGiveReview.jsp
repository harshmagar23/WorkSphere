<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
Integer projectId = (Integer) request.getAttribute("projectId");
Integer freelancerId = (Integer) request.getAttribute("freelancerId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Give Review | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;
  --sky:#60A5FA;
  --cyan:#22D3EE;
  --violet:#8B5CF6;
  --pri-soft:rgba(59,130,246,.08);
  --pri-mid:rgba(59,130,246,.18);
  --pri-glow:rgba(59,130,246,.28);
  --cyan-glow:rgba(34,211,238,.18);
  --bg:#07080D;
  --s1:#0B0D14;
  --s2:#10131D;
  --s3:#171B28;
  --t1:#F8FAFC;
  --t2:#B6C2D3;
  --t3:#7D8AA0;
  --t4:#4B5568;
  --border:rgba(255,255,255,.08);
  --border2:rgba(255,255,255,.045);
  --ok:#22C55E;
  --warn:#F59E0B;
  --danger:#EF4444;
  --h:'Outfit',sans-serif;
  --b:'Inter',sans-serif;
  --max:1120px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;
  font-family:var(--b);
  background:var(--bg);
  color:var(--t1);
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
  text-rendering:optimizeLegibility;
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
::selection{background:var(--pri);color:white}
a{color:inherit;text-decoration:none}
button,input,textarea{font:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* PROGRESS */
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

/* NAVBAR */
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
.nav-links a:hover,
.nav-links a.active{
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
.menu-btn{
  display:none;
  border:0;
  background:none;
  color:var(--t2);
  font-size:19px;
  cursor:pointer;
}

/* MOBILE MENU */
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
  color:var(--t2);
  font-family:var(--h);
  font-size:14px;
  font-weight:650;
  padding:12px 0;
  border-bottom:1px solid var(--border2);
}
.mobile-panel a:hover{color:var(--t1)}

/* PAGE */
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
  padding:26px 0 34px;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.05fr .95fr;
  gap:42px;
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
}
.hero p{
  color:var(--t2);
  font-size:16px;
  line-height:1.85;
  max-width:680px;
}
.review-summary{
  border:1px solid var(--border);
  border-radius:26px;
  padding:26px;
  background:linear-gradient(145deg,rgba(16,19,29,.78),rgba(9,12,20,.78));
  position:relative;
  overflow:hidden;
}
.review-summary::before{
  content:"";
  position:absolute;
  right:-130px;
  top:-130px;
  width:310px;
  height:310px;
  border-radius:50%;
  background:radial-gradient(circle,var(--cyan-glow),transparent 67%);
}
.review-summary>*{position:relative;z-index:1}
.summary-top{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:18px;
  margin-bottom:22px;
}
.summary-top h3{
  font-family:var(--h);
  font-size:28px;
  line-height:1.04;
  font-weight:850;
  letter-spacing:-1px;
  margin-bottom:8px;
}
.summary-top p{
  color:var(--t3);
  font-size:13px;
  line-height:1.75;
}
.summary-icon{
  width:58px;
  height:58px;
  border-radius:18px;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:20px;
  box-shadow:0 20px 50px rgba(59,130,246,.22);
}
.summary-list{
  display:grid;
  gap:12px;
}
.summary-item{
  display:grid;
  grid-template-columns:40px 1fr auto;
  align-items:center;
  gap:13px;
  padding:13px;
  border:1px solid var(--border2);
  border-radius:16px;
  background:rgba(255,255,255,.035);
}
.summary-num{
  width:40px;
  height:40px;
  border-radius:14px;
  background:var(--pri-soft);
  color:var(--sky);
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:var(--h);
  font-weight:900;
}
.summary-item strong{
  display:block;
  font-family:var(--h);
  color:var(--t1);
  font-size:14px;
  margin-bottom:3px;
}
.summary-item span{
  color:var(--t3);
  font-size:12px;
}
.summary-item i{color:var(--t4)}

/* FORM */
.review-section{
  position:relative;
  z-index:1;
  padding:16px 0 0;
}
.review-grid{
  display:grid;
  grid-template-columns:1fr 340px;
  gap:28px;
  align-items:start;
}
.form-panel,
.side-card{
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.80),rgba(8,10,16,.82));
  border-radius:28px;
  position:relative;
  overflow:hidden;
}
.form-panel{
  padding:30px;
}
.form-panel::before,
.side-card::before{
  content:"";
  position:absolute;
  right:-110px;
  top:-110px;
  width:260px;
  height:260px;
  border-radius:50%;
  background:radial-gradient(circle,var(--pri-glow),transparent 67%);
  pointer-events:none;
}
.form-panel>*,
.side-card>*{position:relative;z-index:1}
.form-title{
  font-family:var(--h);
  font-size:clamp(28px,3vw,42px);
  font-weight:850;
  letter-spacing:-1.4px;
  margin-bottom:9px;
}
.form-copy{
  color:var(--t3);
  line-height:1.8;
  font-size:14.5px;
  margin-bottom:24px;
}
.form-group{margin-bottom:24px}
.form-label{
  display:block;
  font-family:var(--h);
  color:var(--t2);
  font-size:13px;
  font-weight:800;
  margin-bottom:10px;
}
.star-rating{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
}
.star{
  width:54px;
  height:54px;
  border-radius:17px;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  color:var(--t4);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:23px;
  cursor:pointer;
  transition:all .2s;
}
.star:hover{
  transform:translateY(-3px);
  border-color:rgba(245,158,11,.35);
  color:#FBBF24;
  background:rgba(245,158,11,.08);
}
.star.active{
  color:#FBBF24;
  border-color:rgba(245,158,11,.35);
  background:rgba(245,158,11,.11);
  box-shadow:0 14px 34px rgba(245,158,11,.12);
}
.rating-hint{
  color:var(--t4);
  font-size:12.5px;
  margin-top:10px;
}
.rating-hint strong{
  color:var(--sky);
  font-family:var(--h);
}
textarea.form-control{
  width:100%;
  min-height:180px;
  border:1px solid var(--border);
  border-radius:18px;
  background:rgba(255,255,255,.035);
  color:var(--t1);
  padding:17px;
  resize:vertical;
  outline:none;
  line-height:1.75;
  transition:all .2s;
}
textarea.form-control:focus{
  border-color:var(--pri-mid);
  box-shadow:0 0 0 4px var(--pri-soft);
  background:rgba(255,255,255,.05);
}
textarea.form-control::placeholder{color:var(--t4)}
.form-help{
  margin-top:10px;
  display:flex;
  justify-content:space-between;
  gap:14px;
  flex-wrap:wrap;
  color:var(--t4);
  font-size:12px;
}
.char-count.good{color:var(--ok)}
.char-count.warn{color:var(--warn)}
.action-row{
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  margin-top:24px;
}
.btn-save,
.btn-back{
  min-height:46px;
  border-radius:12px;
  padding:0 18px;
  font-family:var(--h);
  font-size:14px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:9px;
  transition:all .2s;
}
.btn-save{
  border:0;
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
}
.btn-save:hover{
  transform:translateY(-2px);
  box-shadow:0 18px 45px rgba(59,130,246,.28);
}
.btn-back{
  color:var(--t2);
  border:1px solid var(--border);
  background:rgba(255,255,255,.025);
}
.btn-back:hover{
  color:var(--t1);
  border-color:rgba(255,255,255,.16);
  background:rgba(255,255,255,.05);
  transform:translateY(-2px);
}

/* SIDE PANEL */
.side-panel{
  position:sticky;
  top:92px;
  display:grid;
  gap:16px;
}
.side-card{
  padding:22px;
}
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
.preview-rating{
  display:flex;
  gap:5px;
  color:#FBBF24;
  margin-bottom:13px;
  font-size:16px;
}
.preview-text{
  border:1px solid var(--border2);
  background:rgba(255,255,255,.035);
  border-radius:16px;
  padding:15px;
  min-height:120px;
  color:var(--t2);
  font-size:13px;
  line-height:1.75;
  white-space:pre-line;
}
.preview-text.empty{color:var(--t4)}
.check-list{
  display:grid;
  gap:11px;
}
.check-item{
  display:flex;
  gap:10px;
  color:var(--t2);
  font-size:13px;
  line-height:1.55;
}
.check-icon{
  width:20px;
  height:20px;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
  border:1px solid var(--border);
  color:var(--t4);
  flex-shrink:0;
  margin-top:1px;
  font-size:10px;
}
.check-item.done{color:var(--t1)}
.check-item.done .check-icon{
  background:linear-gradient(135deg,var(--pri),var(--cyan));
  color:white;
  border-color:transparent;
}

/* FOOTER */
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

/* ANIMATION */
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
.d1{transition-delay:.07s}.d2{transition-delay:.14s}.d3{transition-delay:.21s}

@media(max-width:1080px){
  .nav-links{display:none}
  .menu-btn{display:block}
  .mobile-menu{display:block}
  .hero-grid,.review-grid{grid-template-columns:1fr}
  .review-summary{max-width:720px}
  .side-panel{position:relative;top:auto;grid-template-columns:repeat(2,1fr)}
}
@media(max-width:720px){
  .wrap,.nav-inner,.footer-grid{padding-left:20px;padding-right:20px}
  .nav-actions .nav-btn:not(.primary){display:none}
  .page{padding-top:98px}
  .hero h1{letter-spacing:-1.9px}
  .summary-item{grid-template-columns:40px 1fr}
  .summary-item>i{display:none}
  .form-panel{padding:22px}
  .star{width:48px;height:48px;border-radius:15px}
  .side-panel{grid-template-columns:1fr}
  .btn-save,.btn-back{width:100%;justify-content:center}
  .footer-grid{grid-template-columns:1fr;text-align:center}
  .footer-note{text-align:center}
}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<div class="progress-top" id="progressTop"></div>

<nav class="ws-nav" id="navbar">
  <div class="nav-inner">
    <a href="clientDashboard" class="logo">Work<span class="s">Sphere</span></a>

    <div class="nav-links">
      <a href="clientDashboard">Dashboard</a>
      <a href="postProjectPage">Post Project</a>
      <a href="viewMyProjects" class="active">My Projects</a>
      <a href="clientNotifications">Notifications</a>
    </div>

    <div class="nav-actions">
      <a href="viewMyProjects" class="nav-btn"><i class="fa-solid fa-arrow-left"></i> My Projects</a>
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
          <div class="kicker"><i class="fa-solid fa-star"></i> Client feedback studio</div>
          <h1>Give a clear <em>freelancer review</em>.</h1>
          <p>
            Rate the freelancer based on completed work, delivery quality, communication, and how well the final result matched your project expectations.
          </p>
        </div>

        <aside class="review-summary zoom-reveal d1">
          <div class="summary-top">
            <div>
              <h3>Review quality guide</h3>
              <p>A good review helps freelancers improve and helps future clients understand their work quality.</p>
            </div>
            <div class="summary-icon"><i class="fa-solid fa-award"></i></div>
          </div>

          <div class="summary-list">
            <div class="summary-item">
              <div class="summary-num">01</div>
              <div><strong>Rate fairly</strong><span>Choose stars based on actual delivery quality.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="summary-item">
              <div class="summary-num">02</div>
              <div><strong>Write specific feedback</strong><span>Mention quality, communication, and timelines.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
            <div class="summary-item">
              <div class="summary-num">03</div>
              <div><strong>Submit once ready</strong><span>Your review will be saved for this freelancer.</span></div>
              <i class="fa-solid fa-arrow-right"></i>
            </div>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <section class="review-section">
    <div class="wrap review-grid">
      <section class="form-panel reveal">
        <h2 class="form-title">Review freelancer work</h2>
        <p class="form-copy">Select a rating and write a short professional review message. Keep it helpful and specific.</p>

        <form action="saveReview" method="post" id="reviewForm">
          <input type="hidden" name="projectId" value="<%= projectId %>">
          <input type="hidden" name="freelancerId" value="<%= freelancerId %>">

          <div class="form-group">
            <label class="form-label">Rating</label>
            <div class="star-rating" id="stars">
              <i class="fa-solid fa-star star" data-value="1"></i>
              <i class="fa-solid fa-star star" data-value="2"></i>
              <i class="fa-solid fa-star star" data-value="3"></i>
              <i class="fa-solid fa-star star" data-value="4"></i>
              <i class="fa-solid fa-star star" data-value="5"></i>
            </div>

            <input type="hidden" name="rating" id="ratingValue" required>
            <div class="rating-hint" id="ratingHint">Select a star rating before submitting.</div>
          </div>

          <div class="form-group">
            <label class="form-label">Review Message</label>
            <textarea name="reviewText" id="reviewText" class="form-control"
                      placeholder="Example: The freelancer delivered the work on time, communicated clearly, and completed the requirements professionally." required></textarea>

            <div class="form-help">
              <span>Helpful reviews are clear, honest, and specific.</span>
              <span class="char-count" id="charCount">0 characters</span>
            </div>
          </div>

          <div class="action-row">
            <button type="submit" class="btn-save">
              <i class="fa-solid fa-star"></i> Submit Review
            </button>

            <a href="clientDashboard" class="btn-back">
              <i class="fa-solid fa-arrow-left"></i> Back
            </a>
          </div>
        </form>
      </section>

      <aside class="side-panel">
        <div class="side-card zoom-reveal d1">
          <h3 class="side-title">Live review preview</h3>
          <p class="side-copy">Preview your feedback before submitting it.</p>
          <div class="preview-rating" id="previewStars">
            <i class="fa-regular fa-star"></i>
            <i class="fa-regular fa-star"></i>
            <i class="fa-regular fa-star"></i>
            <i class="fa-regular fa-star"></i>
            <i class="fa-regular fa-star"></i>
          </div>
          <div class="preview-text empty" id="reviewPreview">Your review message preview will appear here.</div>
        </div>

        <div class="side-card zoom-reveal d2">
          <h3 class="side-title">Before submitting</h3>
          <div class="check-list">
            <div class="check-item" id="checkRating">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Star rating selected.</span>
            </div>
            <div class="check-item" id="checkLength">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Review has enough detail.</span>
            </div>
            <div class="check-item" id="checkSpecific">
              <span class="check-icon"><i class="fa-solid fa-check"></i></span>
              <span>Feedback mentions work, quality, delivery, or communication.</span>
            </div>
          </div>
        </div>

        <div class="side-card zoom-reveal d3">
          <h3 class="side-title">Review tip</h3>
          <p class="side-copy" style="margin-bottom:0">
            Strong reviews do not need to be long. A few clear lines about quality, communication, and delivery are enough.
          </p>
        </div>
      </aside>
    </div>
  </section>

  <footer class="ws-footer">
    <div class="footer-grid">
      <div class="footer-brand">Work<span class="s">Sphere</span></div>
      <div class="footer-links">
        <a href="clientDashboard">Dashboard</a>
        <a href="viewMyProjects">My Projects</a>
        <a href="postProjectPage">Post Project</a>
        <a href="clientNotifications">Notifications</a>
      </div>
      <div class="footer-note">Client Review • WorkSphere</div>
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

  const stars = document.querySelectorAll(".star");
  const ratingInput = document.getElementById("ratingValue");
  const ratingHint = document.getElementById("ratingHint");
  const previewStars = document.getElementById("previewStars");
  const reviewText = document.getElementById("reviewText");
  const reviewPreview = document.getElementById("reviewPreview");
  const charCount = document.getElementById("charCount");
  const checkRating = document.getElementById("checkRating");
  const checkLength = document.getElementById("checkLength");
  const checkSpecific = document.getElementById("checkSpecific");

  let selectedRating = 0;

  const labels = {
    1: "Needs improvement",
    2: "Below expectations",
    3: "Good work",
    4: "Very good delivery",
    5: "Excellent freelancer"
  };

  function includesAny(text, words){
    return words.some(function(word){ return text.indexOf(word) !== -1; });
  }

  function renderPreviewStars(value){
    let html = "";
    for(let i = 1; i <= 5; i++){
      html += '<i class="' + (i <= value ? 'fa-solid' : 'fa-regular') + ' fa-star"></i>';
    }
    previewStars.innerHTML = html;
  }

  function updateChecks(){
    const text = reviewText.value.trim();
    const lower = text.toLowerCase();
    const ratingOk = selectedRating > 0;
    const lengthOk = text.length >= 40;
    const specificOk = includesAny(lower, ["work","quality","delivery","delivered","communication","deadline","time","requirements","project"]);

    checkRating.classList.toggle("done", ratingOk);
    checkLength.classList.toggle("done", lengthOk);
    checkSpecific.classList.toggle("done", specificOk);

    charCount.textContent = text.length + " characters";
    charCount.classList.toggle("good", text.length >= 80);
    charCount.classList.toggle("warn", text.length > 0 && text.length < 40);

    reviewPreview.textContent = text || "Your review message preview will appear here.";
    reviewPreview.classList.toggle("empty", !text);
  }

  stars.forEach(function(star){
    star.addEventListener("click", function(){
      selectedRating = parseInt(star.getAttribute("data-value"), 10);
      ratingInput.value = selectedRating;

      stars.forEach(function(s, index){
        s.classList.toggle("active", index < selectedRating);
      });

      ratingHint.innerHTML = "<strong>" + selectedRating + "/5</strong> — " + labels[selectedRating];
      renderPreviewStars(selectedRating);
      updateChecks();
    });
  });

  if(reviewText){
    reviewText.addEventListener("input", updateChecks);
    updateChecks();
  }

  const form = document.getElementById("reviewForm");
  if(form){
    form.addEventListener("submit", function(e){
      if(!ratingInput.value){
        e.preventDefault();
        ratingHint.innerHTML = "<strong>Please select a rating</strong> before submitting.";
        ratingHint.style.color = "var(--warn)";
      }
    });
  }
})();
</script>

</body>
</html>
