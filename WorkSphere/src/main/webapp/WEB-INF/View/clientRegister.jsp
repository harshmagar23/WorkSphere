<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Registration - WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
  --err:#EF4444;--ok:#22C55E;--warn:#F59E0B;
  --err-soft:rgba(239,68,68,.10);--ok-soft:rgba(34,197,94,.10);--warn-soft:rgba(245,158,11,.10);
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1200px;
}
html{scroll-behavior:smooth}
body{
  min-height:100vh;font-family:var(--b);background:var(--bg);color:var(--t1);overflow-x:hidden;
  -webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;text-rendering:optimizeLegibility;
  font-feature-settings:'kern' 1,'liga' 1,'calt' 1;
}
body::before{content:'';position:fixed;inset:0;z-index:-3;background:radial-gradient(circle at 20% 10%,rgba(59,130,246,.20),transparent 34%),radial-gradient(circle at 82% 24%,rgba(34,211,238,.13),transparent 32%),linear-gradient(180deg,#07080D 0%,#090B12 42%,#07080D 100%)}
body::after{content:'';position:fixed;inset:0;z-index:-2;background-image:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.8),rgba(0,0,0,.18),transparent);-webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.8),rgba(0,0,0,.18),transparent)}
::selection{background:var(--pri);color:#07080D}a{color:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 32px;width:100%}

/* ===== NAV - SAME AS CLIENT LOGIN ===== */
.nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:background .35s,box-shadow .35s}
.nav.s{background:rgba(7,8,13,0.78);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-in{max-width:var(--max);margin:0 auto;padding:0 32px;display:flex;align-items:center;justify-content:space-between;height:68px}
.logo{font-family:var(--h);font-size:20px;font-weight:800;text-decoration:none;letter-spacing:-0.75px}
.logo .s{color:var(--pri)}
.nav-m{display:flex;gap:0}
.nav-a{text-decoration:none;color:var(--t3);font-family:var(--h);font-size:13px;font-weight:500;letter-spacing:0.01em;padding:7px 14px;border-radius:999px;transition:all .2s}
.nav-a:hover,.nav-a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-r{display:flex;gap:8px;align-items:center}
.btn-p{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;border:none;border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:700;letter-spacing:0.01em;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:transform .2s,box-shadow .2s}
.btn-p:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24);color:white}
.btn-o{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.02);border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:500;letter-spacing:0.01em;cursor:pointer;text-decoration:none;transition:all .2s}
.btn-o:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.04)}

/* ===== AUTH PAGE - SAME STRUCTURE AS CLIENT LOGIN ===== */
.auth-page{min-height:100vh;display:flex;align-items:center;padding:116px 0 52px;position:relative;overflow:hidden}.auth-page::after{content:'';position:absolute;top:-34%;left:50%;transform:translateX(-50%);width:940px;height:760px;background:radial-gradient(circle,rgba(59,130,246,.20),transparent 64%);opacity:.34;pointer-events:none}
.auth-grid{position:relative;z-index:1;display:grid;grid-template-columns:1.02fr .98fr;gap:36px;align-items:center}
.left-copy{padding-right:20px}.pill{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:7px 12px;margin-bottom:18px;color:var(--t2);font-size:12px;font-weight:700;letter-spacing:.02em}.pill i{color:var(--cyan);font-size:11px}
.left-copy h1{font-family:var(--h);font-size:clamp(42px,5.2vw,72px);line-height:.98;font-weight:850;letter-spacing:-2.6px;margin-bottom:20px;max-width:680px}.left-copy h1 em{font-style:normal;font-weight:260;color:var(--t3);letter-spacing:-1.6px}
.left-copy p{font-size:16px;line-height:1.9;color:var(--t2);max-width:560px;margin-bottom:28px}.mini-proof{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;max-width:640px}.proof-card{background:rgba(255,255,255,.035);border:1px solid var(--border);border-radius:16px;padding:17px 18px}.proof-card i{color:var(--sky);font-size:14px;margin-bottom:10px}.proof-card h5{font-family:var(--h);font-size:14px;font-weight:750;margin-bottom:5px;letter-spacing:-.2px}.proof-card span{display:block;color:var(--t3);font-size:12px;line-height:1.55}
.market-row{display:flex;gap:8px;flex-wrap:wrap;margin-top:18px}.market-row span{border:1px solid var(--border2);background:rgba(11,13,20,.68);color:var(--t3);border-radius:999px;padding:7px 11px;font-size:12px;font-weight:600}.market-row span i{color:var(--cyan);font-size:10px;margin-right:6px}

/* ===== REGISTER CARD - SAME CARD FAMILY AS CLIENT LOGIN ===== */
.login-shell{max-width:640px;width:100%;justify-self:end}.login-card{background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(9,12,20,.94));border:1px solid var(--border);border-radius:28px;padding:34px;box-shadow:0 28px 70px rgba(0,0,0,.34);position:relative;overflow:hidden}.login-card::before{content:'';position:absolute;top:-45%;right:-30%;width:420px;height:420px;background:radial-gradient(circle,rgba(34,211,238,.12),transparent 62%);pointer-events:none}.login-card::after{content:'';position:absolute;left:0;right:0;top:0;height:1px;background:linear-gradient(90deg,transparent,rgba(96,165,250,.45),transparent)}
.card-head{position:relative;z-index:1;margin-bottom:24px;text-align:left}.card-tag{width:max-content;display:flex;align-items:center;gap:8px;color:var(--sky);background:var(--pri-soft);border:1px solid var(--border2);border-radius:999px;padding:6px 11px;font-family:var(--h);font-size:11px;font-weight:800;letter-spacing:1.4px;text-transform:uppercase;margin-bottom:16px}.card-head h2{font-family:var(--h);font-size:30px;line-height:1.08;font-weight:850;letter-spacing:-1px;margin-bottom:8px}.card-head p{color:var(--t3);font-size:14px;line-height:1.7;margin:0}
.form-grid{position:relative;z-index:1;display:grid;grid-template-columns:repeat(2,1fr);gap:16px 14px}.input-wrap{position:relative;z-index:1}.input-wrap.full{grid-column:1/-1}.form-label{display:block;font-family:var(--h);font-size:13px;font-weight:650;color:var(--t2);margin-bottom:7px;letter-spacing:.01em}.input-box{position:relative}.field-icon{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:14px;transition:color .2s}.input-box input,.input-box textarea{width:100%;height:48px;border-radius:12px;border:1px solid var(--border);background:rgba(7,8,13,.62);padding:0 14px 0 42px;color:var(--t1);font-family:var(--b);font-size:14px;outline:none;transition:border-color .2s,box-shadow .2s,background .2s;resize:none}.input-box textarea{height:76px;padding-top:13px}.input-box input::placeholder,.input-box textarea::placeholder{color:var(--t4)}.input-box input:focus,.input-box textarea:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft);background:rgba(7,8,13,.84)}.input-box:focus-within .field-icon{color:var(--sky)}.input-box.textarea .field-icon{top:23px;transform:none}
.login-btn{width:100%;height:48px;border:0;border-radius:12px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;font-family:var(--h);font-size:14px;font-weight:800;letter-spacing:.01em;cursor:pointer;position:relative;overflow:hidden;z-index:1;transition:transform .2s,box-shadow .2s;margin-top:18px}.login-btn:hover{box-shadow:0 18px 45px rgba(59,130,246,.28);transform:translateY(-2px)}.login-btn:active{transform:scale(.985)}
.signup-box{margin-top:20px;padding-top:20px;border-top:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;gap:14px;position:relative;z-index:1}.signup-box span{color:var(--t3);font-size:13px}.signup-box a{font-family:var(--h);font-size:13px;font-weight:800;color:var(--sky);text-decoration:none}.signup-box a:hover{color:var(--cyan)}
.auth-note{margin-top:16px;text-align:center;color:var(--t4);font-size:12px}.auth-note a{color:var(--t3);text-decoration:none}.auth-note a:hover{color:var(--t1)}
.input-wrap.shake-err .input-box input,.input-wrap.shake-err .input-box textarea{animation:shake .44s ease;border-color:rgba(239,68,68,.48)!important;box-shadow:0 0 0 4px var(--err-soft)}@keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-7px)}40%,80%{transform:translateX(7px)}}

/* /* ===== INTERESTING POP MESSAGE - SAME AS CLIENT LOGIN ===== */
.pop-layer{position:fixed;inset:0;z-index:5000;display:flex;align-items:flex-start;justify-content:center;padding:96px 18px 0;background:rgba(0,0,0,0);pointer-events:none;transition:background .35s ease}.pop-layer.show{background:rgba(0,0,0,.52);pointer-events:auto}.pop-card{width:min(430px,100%);background:linear-gradient(145deg,rgba(16,19,29,.98),rgba(9,12,20,.98));border:1px solid var(--border);border-radius:26px;box-shadow:0 28px 80px rgba(0,0,0,.58);position:relative;overflow:hidden;opacity:0;transform:translateY(-24px) scale(.92)}.pop-layer.show .pop-card{animation:popIn .72s cubic-bezier(.16,1,.3,1) forwards}.pop-card.closing{animation:popOut .25s ease forwards!important}@keyframes popIn{0%{opacity:0;transform:translateY(-34px) scale(.86)}58%{opacity:1;transform:translateY(5px) scale(1.025)}78%{transform:translateY(-2px) scale(.992)}100%{opacity:1;transform:translateY(0) scale(1)}}@keyframes popOut{to{opacity:0;transform:translateY(-16px) scale(.96)}}.pop-card::before{content:'';position:absolute;top:-45%;left:50%;transform:translateX(-50%);width:420px;height:300px;background:radial-gradient(circle,var(--pop-glow,rgba(59,130,246,.25)),transparent 65%);opacity:.65;pointer-events:none}.pop-accent{height:3px;background:linear-gradient(90deg,var(--pri),var(--cyan))}.pop-accent.error{background:linear-gradient(90deg,var(--err),#FB7185)}.pop-accent.success{background:linear-gradient(90deg,var(--ok),#4ADE80)}.pop-accent.warning{background:linear-gradient(90deg,var(--warn),#FBBF24)}.pop-x{position:absolute;top:14px;right:14px;width:30px;height:30px;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t3);cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:5;transition:all .2s}.pop-x:hover{color:var(--t1);background:rgba(255,255,255,.07)}.pop-body{position:relative;z-index:1;text-align:center;padding:34px 28px 28px}.pop-icon{width:76px;height:76px;border-radius:24px;margin:0 auto 18px;display:flex;align-items:center;justify-content:center;position:relative;background:rgba(255,255,255,.035);border:1px solid var(--border)}.pop-icon::before{content:'';position:absolute;inset:-9px;border-radius:31px;border:1px solid var(--pop-ring,rgba(96,165,250,.25));opacity:0;transform:scale(.76)}.pop-layer.show .pop-icon::before{animation:ring .75s cubic-bezier(.16,1,.3,1) .22s forwards}.pop-icon i{font-size:26px;color:var(--pop-color,var(--sky));opacity:0;transform:scale(.5) rotate(-14deg)}.pop-layer.show .pop-icon i{animation:iconPop .48s cubic-bezier(.16,1,.3,1) .34s forwards}@keyframes ring{60%{opacity:1;transform:scale(1.08)}100%{opacity:1;transform:scale(1)}}@keyframes iconPop{to{opacity:1;transform:scale(1) rotate(0)}}.pop-title{font-family:var(--h);font-size:22px;font-weight:850;letter-spacing:-.75px;margin-bottom:8px}.pop-msg{font-size:14px;color:var(--t2);line-height:1.75;margin:0 auto 24px;max-width:330px}.pop-actions{display:flex;gap:10px}.pop-btn{flex:1;height:44px;border-radius:12px;font-family:var(--h);font-size:13px;font-weight:800;cursor:pointer;border:0;transition:all .2s}.pop-btn.main{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}.pop-btn.main:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.22)}.pop-progress{position:absolute;left:0;bottom:0;height:2px;width:100%;transform-origin:left;background:var(--pop-color,var(--sky))}.pop-layer.show .pop-progress{animation:timer 5.4s linear forwards}@keyframes timer{to{transform:scaleX(0)}}.spark-box{position:absolute;inset:0;pointer-events:none;overflow:hidden;border-radius:26px}.spark{position:absolute;left:50%;top:94px;width:var(--sz);height:var(--sz);background:var(--c);border-radius:999px;animation:sparkFly var(--dur) cubic-bezier(.16,.85,.3,1) forwards;opacity:0}@keyframes sparkFly{0%{opacity:1;transform:translate(-50%,-50%) translate(0,0) scale(1)}80%{opacity:1}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--tx),var(--ty)) scale(.1)}}
 */
/* ===== REVEAL ===== */
.rv{opacity:0;transform:translateY(22px);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}.rv.v{opacity:1;transform:translateY(0)}.d1{transition-delay:.08s}.d2{transition-delay:.16s}.d3{transition-delay:.24s}

@media(max-width:1080px){.auth-grid{grid-template-columns:1fr;gap:28px}.login-shell{justify-self:center;max-width:760px}.left-copy{padding-right:0;text-align:center}.pill{margin-left:auto;margin-right:auto}.left-copy p{margin-left:auto;margin-right:auto}.mini-proof{margin:0 auto}.market-row{justify-content:center}.nav-m{display:none}}
@media(max-width:680px){.wrap,.nav-in{padding:0 20px}.nav-r .btn-o{display:none}.auth-page{padding-top:104px}.left-copy h1{font-size:42px;letter-spacing:-2px}.mini-proof{grid-template-columns:1fr}.login-card{padding:26px 20px;border-radius:22px}.card-head h2{font-size:26px}.form-grid{grid-template-columns:1fr}.signup-box{flex-direction:column;text-align:center}.pop-actions{flex-direction:column}.pop-layer{padding-top:76px}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<nav class="nav" id="nav">
  <div class="nav-in">
    <a href="index.jsp" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>
    <div class="nav-m">
      <a href="index#mkt" class="nav-a">Explore</a>
      <a href="index#how" class="nav-a">How it Works</a>
      <a href="index#cat" class="nav-a">Categories</a>
      <a href="index#feat" class="nav-a">Why Us</a>
    </div>
    <div class="nav-r">
      <a href="clientLogin" class="btn-o">Client Login</a>
      <a href="freelancerLogin" class="btn-p">Freelancer Login</a>
    </div>
  </div>
</nav>

<main class="auth-page">
  <div class="wrap auth-grid">
    <section class="left-copy rv">
      <div class="pill"><i class="fa-solid fa-sparkles"></i> Client workspace setup</div>
      <h1>Create your <em>client account</em> with clarity</h1>
      <p>Register to post projects, review freelancer proposals, assign work, request revisions, and complete deliveries inside one professional WorkSphere workflow.</p>

      <div class="mini-proof">
        <div class="proof-card rv d1"><i class="fa-solid fa-file-signature"></i><h5>Post projects</h5><span>Create clear requirements, budget, and timeline for freelancers.</span></div>
        <div class="proof-card rv d2"><i class="fa-solid fa-user-check"></i><h5>Hire talent</h5><span>Compare proposals and assign the right freelancer quickly.</span></div>
        <div class="proof-card rv d3"><i class="fa-solid fa-circle-check"></i><h5>Track delivery</h5><span>Review submissions, request revisions, and close projects.</span></div>
      </div>

      <div class="market-row rv d2">
        <span><i class="fa-solid fa-shield-halved"></i>Secure workflow</span>
        <span><i class="fa-solid fa-bolt"></i>Fast proposals</span>
        <span><i class="fa-solid fa-chart-line"></i>Project tracking</span>
      </div>
    </section>

    <section class="login-shell rv d1">
      <div class="login-card">
        <div class="card-head">
          <div class="card-tag"><i class="fa-solid fa-user-plus"></i> Client Registration</div>
          <h2>Set up your hiring profile</h2>
          <p>Enter your details to create your WorkSphere client account.</p>
        </div>

        <form action="${pageContext.request.contextPath}/saveClient" method="post" id="registerForm">
          <div class="form-grid">
            <div class="input-wrap">
              <label class="form-label">Full Name</label>
              <div class="input-box">
                <i class="fa-regular fa-user field-icon"></i>
                <input name="name" type="text" placeholder="Enter full name" required>
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Email address</label>
              <div class="input-box">
                <i class="fa-regular fa-envelope field-icon"></i>
                <input name="email" type="email" placeholder="you@company.com" required>
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Password</label>
              <div class="input-box">
                <i class="fa-solid fa-lock field-icon"></i>
                <input name="password" type="password" placeholder="Create password" required>
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Mobile</label>
              <div class="input-box">
                <i class="fa-solid fa-phone field-icon"></i>
                <input name="mobile" type="text" placeholder="Mobile number">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Company</label>
              <div class="input-box">
                <i class="fa-regular fa-building field-icon"></i>
                <input name="company" type="text" placeholder="Company name">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">City</label>
              <div class="input-box">
                <i class="fa-solid fa-city field-icon"></i>
                <input name="city" type="text" placeholder="City">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">State</label>
              <div class="input-box">
                <i class="fa-regular fa-map field-icon"></i>
                <input name="state" type="text" placeholder="State">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Country</label>
              <div class="input-box">
                <i class="fa-solid fa-globe field-icon"></i>
                <input name="country" type="text" placeholder="Country">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Zip Code</label>
              <div class="input-box">
                <i class="fa-solid fa-location-dot field-icon"></i>
                <input name="zipcode" type="text" placeholder="Zip code">
              </div>
            </div>

            <div class="input-wrap">
              <label class="form-label">Address</label>
              <div class="input-box textarea">
                <i class="fa-solid fa-house field-icon"></i>
                <textarea name="address" placeholder="Address"></textarea>
              </div>
            </div>
          </div>

          <button type="submit" class="login-btn">Create client account <i class="fa-solid fa-arrow-right" style="font-size:12px;margin-left:6px"></i></button>
        </form>

        <div class="signup-box">
          <span>Already have an account?</span>
          <a href="${pageContext.request.contextPath}/clientLogin">Sign in <i class="fa-solid fa-arrow-right" style="font-size:10px;margin-left:3px"></i></a>
        </div>
      </div>
      <div class="auth-note">&copy; 2026 WorkSphere &nbsp;&middot;&nbsp; <a href="#">Privacy</a> &nbsp;&middot;&nbsp; <a href="#">Terms</a></div>
    </section>
  </div>
</main>

<div class="pop-layer" id="popLayer">
  <div class="pop-card" id="popCard">
    <button class="pop-x" type="button" id="popClose"><i class="fa-solid fa-xmark"></i></button>
    <div class="pop-accent" id="popAccent"></div>
    <div class="spark-box" id="sparkBox"></div>
    <div class="pop-body">
      <div class="pop-icon" id="popIcon"><i class="fa-solid fa-circle-info" id="popIconI"></i></div>
      <h3 class="pop-title" id="popTitle">Message</h3>
      <p class="pop-msg" id="popMsg">Notification message</p>
      <div class="pop-actions" id="popActions">
        <button class="pop-btn main" type="button" id="popOk">Continue</button>
      </div>
    </div>
    <div class="pop-progress" id="popProgress"></div>
  </div>
</div>

<script>
(function(){
  var nav=document.getElementById('nav');
  function onScroll(){nav.classList.toggle('s',window.scrollY>30)}
  window.addEventListener('scroll',onScroll,{passive:true});
  onScroll();

  var ro=new IntersectionObserver(function(entries){entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add('v');ro.unobserve(e.target);}})},{threshold:.06});
  document.querySelectorAll('.rv').forEach(function(el){ro.observe(el);});

  var layer=document.getElementById('popLayer');
  var card=document.getElementById('popCard');
  var accent=document.getElementById('popAccent');
  var iconI=document.getElementById('popIconI');
  var title=document.getElementById('popTitle');
  var msg=document.getElementById('popMsg');
  var close=document.getElementById('popClose');
  var ok=document.getElementById('popOk');
  var sparkBox=document.getElementById('sparkBox');
  var timer=null;

  function typeData(type){
    if(type==='success')return{cls:'success',ic:'fa-solid fa-check',ttl:'Success',color:'#22C55E',ring:'rgba(34,197,94,.28)',glow:'rgba(34,197,94,.25)',sparks:['#22C55E','#4ADE80','#60A5FA','#F8FAFC']};
    if(type==='error')return{cls:'error',ic:'fa-solid fa-xmark',ttl:'Registration failed',color:'#EF4444',ring:'rgba(239,68,68,.28)',glow:'rgba(239,68,68,.24)',sparks:['#EF4444','#FB7185','#F8FAFC','#60A5FA']};
    if(type==='warning')return{cls:'warning',ic:'fa-solid fa-triangle-exclamation',ttl:'Warning',color:'#F59E0B',ring:'rgba(245,158,11,.28)',glow:'rgba(245,158,11,.24)',sparks:['#F59E0B','#FBBF24','#F8FAFC','#60A5FA']};
    return{cls:'info',ic:'fa-solid fa-circle-info',ttl:'Info',color:'#60A5FA',ring:'rgba(96,165,250,.28)',glow:'rgba(59,130,246,.25)',sparks:['#3B82F6','#60A5FA','#22D3EE','#F8FAFC']};
  }

  window.showPop=function(type,heading,text){
    var d=typeData(type||'info');
    clearTimeout(timer);
    card.classList.remove('closing');
    accent.className='pop-accent '+d.cls;
    iconI.className=d.ic;
    title.textContent=heading||d.ttl;
    msg.textContent=text||'';
    card.style.setProperty('--pop-color',d.color);
    card.style.setProperty('--pop-ring',d.ring);
    card.style.setProperty('--pop-glow',d.glow);
    layer.classList.add('show');
    spawnSparks(d.sparks);
    timer=setTimeout(closePop,5600);
  };

  function closePop(){
    clearTimeout(timer);
    card.classList.add('closing');
    setTimeout(function(){layer.classList.remove('show');card.classList.remove('closing');sparkBox.innerHTML='';},260);
  }
  close.addEventListener('click',closePop);ok.addEventListener('click',closePop);layer.addEventListener('click',function(e){if(e.target===layer)closePop();});document.addEventListener('keydown',function(e){if(e.key==='Escape' && layer.classList.contains('show'))closePop();});

  function spawnSparks(colors){
    sparkBox.innerHTML='';
    for(var i=0;i<34;i++){
      var s=document.createElement('span');s.className='spark';
      var angle=(Math.PI*2/34)*i+(Math.random()-.5)*.75;
      var dist=52+Math.random()*126;
      s.style.setProperty('--tx',(Math.cos(angle)*dist)+'px');
      s.style.setProperty('--ty',(Math.sin(angle)*dist-18)+'px');
      s.style.setProperty('--sz',(3+Math.random()*5)+'px');
      s.style.setProperty('--dur',(.75+Math.random()*.6)+'s');
      s.style.setProperty('--c',colors[Math.floor(Math.random()*colors.length)]);
      s.style.animationDelay=(Math.random()*.16)+'s';
      sparkBox.appendChild(s);
    }
  }

  var serverMsg="${msg}";
  if(serverMsg && serverMsg.trim && serverMsg.trim()!=='' && serverMsg!=='null'){
    var lower=serverMsg.toLowerCase();
    var type='info';
    if(/error|invalid|wrong|incorrect|failed|not found|doesn't exist|expired|denied|unauthorized/i.test(lower))type='error';
    else if(/success|welcome|verified|activated|confirmed|logged in|approved|registered|created/i.test(lower))type='success';
    else if(/warning|warn|expire soon|about to/i.test(lower))type='warning';
    var heading=type==='success'?'Account created':type==='error'?'Registration failed':type==='warning'?'Please check':'WorkSphere message';
    setTimeout(function(){showPop(type,heading,serverMsg);},520);
  }
})();
</script>
</body>
</html>
