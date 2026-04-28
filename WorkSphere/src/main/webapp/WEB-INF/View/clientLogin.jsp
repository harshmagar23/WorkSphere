<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Login - WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/worksphere-messages.css">

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

/* ===== NAV - SAME SYSTEM AS INDEX ===== */
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
.mbtn{display:none;background:none;border:none;color:var(--t2);font-size:18px;cursor:pointer;padding:6px}
.mob{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,0.5);backdrop-filter:blur(8px);opacity:0;visibility:hidden;transition:all .25s}
.mob.on{opacity:1;visibility:visible}
.mob-p{position:absolute;top:16px;right:16px;width:280px;background:var(--s2);border-radius:16px;padding:24px;border:1px solid var(--border);transform:translateY(8px);transition:transform .25s}
.mob.on .mob-p{transform:translateY(0)}
.mob-x{background:none;border:none;color:var(--t3);font-size:15px;cursor:pointer;margin-bottom:16px;padding:4px}
.mob-p a{display:block;text-decoration:none;color:var(--t2);font-family:var(--h);font-size:14.5px;font-weight:500;letter-spacing:0.01em;padding:11px 0;border-bottom:1px solid var(--border2);transition:color .15s}
.mob-p a:hover{color:var(--t1)}
.mob-b{margin-top:16px;display:flex;flex-direction:column;gap:8px}
/* ===== PAGE ===== */
.auth-page{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:116px 0 52px;position:relative;overflow:hidden}.auth-page::after{content:'';position:absolute;top:-34%;left:50%;transform:translateX(-50%);width:940px;height:760px;background:radial-gradient(circle,rgba(59,130,246,.20),transparent 64%);opacity:.34;pointer-events:none}
.auth-grid{position:relative;z-index:1;display:grid;grid-template-columns:1.08fr .92fr;gap:36px;align-items:center;width:100%}
.left-copy{padding-right:20px;min-width:0}.pill{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:7px 12px;margin-bottom:18px;color:var(--t2);font-size:12px;font-weight:700;letter-spacing:.02em}.pill i{color:var(--cyan);font-size:11px}
.left-copy h1{font-family:var(--h);font-size:clamp(42px,5.2vw,72px);line-height:.98;font-weight:850;letter-spacing:-2.6px;margin-bottom:20px;max-width:680px;text-wrap:balance}.left-copy h1 em{font-style:normal;font-weight:260;color:var(--t3);letter-spacing:-1.6px}
.left-copy p{font-size:16px;line-height:1.9;color:var(--t2);max-width:560px;margin-bottom:28px}.mini-proof{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;max-width:640px}.proof-card{background:rgba(255,255,255,.035);border:1px solid var(--border);border-radius:16px;padding:17px 18px}.proof-card i{color:var(--sky);font-size:14px;margin-bottom:10px}.proof-card h5{font-family:var(--h);font-size:14px;font-weight:750;margin-bottom:5px;letter-spacing:-.2px}.proof-card span{display:block;color:var(--t3);font-size:12px;line-height:1.55}
.market-row{display:flex;gap:8px;flex-wrap:wrap;margin-top:18px}.market-row span{border:1px solid var(--border2);background:rgba(11,13,20,.68);color:var(--t3);border-radius:999px;padding:7px 11px;font-size:12px;font-weight:600}.market-row span i{color:var(--cyan);font-size:10px;margin-right:6px}

/* ===== LOGIN CARD ===== */
.login-shell{max-width:468px;width:100%;justify-self:end;min-width:0}.login-card{background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(9,12,20,.94));border:1px solid var(--border);border-radius:28px;padding:34px;box-shadow:0 28px 70px rgba(0,0,0,.34);position:relative;overflow:hidden}.login-card::before{content:'';position:absolute;top:-45%;right:-30%;width:420px;height:420px;background:radial-gradient(circle,rgba(34,211,238,.12),transparent 62%);pointer-events:none}.login-card::after{content:'';position:absolute;left:0;right:0;top:0;height:1px;background:linear-gradient(90deg,transparent,rgba(96,165,250,.45),transparent)}
.card-head{position:relative;z-index:1;margin-bottom:28px;text-align:left}.card-tag{width:max-content;display:flex;align-items:center;gap:8px;color:var(--sky);background:var(--pri-soft);border:1px solid var(--border2);border-radius:999px;padding:6px 11px;font-family:var(--h);font-size:11px;font-weight:800;letter-spacing:1.4px;text-transform:uppercase;margin-bottom:16px}.card-head h2{font-family:var(--h);font-size:30px;line-height:1.08;font-weight:850;letter-spacing:-1px;margin-bottom:8px}.card-head p{color:var(--t3);font-size:14px;line-height:1.7;margin:0}
.input-wrap{position:relative;z-index:1;margin-bottom:17px}.form-label{display:block;font-family:var(--h);font-size:13px;font-weight:650;color:var(--t2);margin-bottom:7px;letter-spacing:.01em}.input-box{position:relative}.field-icon{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--t4);font-size:14px;transition:color .2s}.input-box input{width:100%;height:48px;border-radius:12px;border:1px solid var(--border);background:rgba(7,8,13,.62);padding:0 44px 0 42px;color:var(--t1);font-family:var(--b);font-size:14px;outline:none;transition:border-color .2s,box-shadow .2s,background .2s}.input-box input::placeholder{color:var(--t4)}.input-box input:focus{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft);background:rgba(7,8,13,.84)}.input-box:focus-within .field-icon{color:var(--sky)}
.toggle-pw{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:0;color:var(--t4);font-size:13px;padding:5px;cursor:pointer;transition:color .2s}.toggle-pw:hover{color:var(--t2)}
.form-line{display:flex;justify-content:space-between;align-items:center;gap:12px;margin:4px 0 18px;position:relative;z-index:1}.remember{display:flex;align-items:center;gap:8px;color:var(--t3);font-size:12.5px}.remember input{accent-color:var(--pri)}.small-link{font-family:var(--h);font-size:12.5px;font-weight:700;color:var(--sky);text-decoration:none}.small-link:hover{color:var(--cyan)}
.login-btn{width:100%;height:48px;border:0;border-radius:12px;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;font-family:var(--h);font-size:14px;font-weight:800;letter-spacing:.01em;cursor:pointer;position:relative;overflow:hidden;z-index:1;transition:transform .2s,box-shadow .2s}.login-btn:hover{box-shadow:0 18px 45px rgba(59,130,246,.28);transform:translateY(-2px)}.login-btn:active{transform:scale(.985)}.login-btn.loading{pointer-events:none;opacity:.86}.btn-spinner{display:inline-block;width:16px;height:16px;border:2px solid rgba(255,255,255,.28);border-top-color:white;border-radius:50%;animation:spin .6s linear infinite;vertical-align:middle;margin-right:8px}@keyframes spin{to{transform:rotate(360deg)}}
.divider{display:flex;align-items:center;gap:12px;margin:24px 0 18px;position:relative;z-index:1}.divider::before,.divider::after{content:'';height:1px;background:var(--border);flex:1}.divider span{font-family:var(--h);font-size:11px;font-weight:750;letter-spacing:.8px;text-transform:uppercase;color:var(--t4)}
.social-row{display:flex;gap:10px;position:relative;z-index:1}.social-btn{flex:1;height:43px;border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2);display:flex;align-items:center;justify-content:center;font-size:16px;cursor:pointer;transition:all .2s}.social-btn:hover{border-color:rgba(255,255,255,.16);color:var(--t1);background:rgba(255,255,255,.05);transform:translateY(-1px)}
.signup-box{margin-top:20px;padding-top:20px;border-top:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;gap:14px;position:relative;z-index:1}.signup-box span{color:var(--t3);font-size:13px}.signup-box a{font-family:var(--h);font-size:13px;font-weight:800;color:var(--sky);text-decoration:none}.signup-box a:hover{color:var(--cyan)}
.auth-note{margin-top:16px;text-align:center;color:var(--t4);font-size:12px}.auth-note a{color:var(--t3);text-decoration:none}.auth-note a:hover{color:var(--t1)}
.input-wrap.shake-err .input-box input{animation:shake .44s ease;border-color:rgba(239,68,68,.48)!important;box-shadow:0 0 0 4px var(--err-soft)}@keyframes shake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-7px)}40%,80%{transform:translateX(7px)}}

/* ===== INTERESTING POP MESSAGE ===== */
.pop-layer{position:fixed;inset:0;z-index:5000;display:flex;align-items:flex-start;justify-content:center;padding:96px 18px 0;background:rgba(0,0,0,0);pointer-events:none;transition:background .35s ease}.pop-layer.show{background:rgba(0,0,0,.52);pointer-events:auto}.pop-card{width:min(430px,100%);background:linear-gradient(145deg,rgba(16,19,29,.98),rgba(9,12,20,.98));border:1px solid var(--border);border-radius:26px;box-shadow:0 28px 80px rgba(0,0,0,.58);position:relative;overflow:hidden;opacity:0;transform:translateY(-24px) scale(.92)}.pop-layer.show .pop-card{animation:popIn .72s cubic-bezier(.16,1,.3,1) forwards}.pop-card.closing{animation:popOut .25s ease forwards!important}@keyframes popIn{0%{opacity:0;transform:translateY(-34px) scale(.86)}58%{opacity:1;transform:translateY(5px) scale(1.025)}78%{transform:translateY(-2px) scale(.992)}100%{opacity:1;transform:translateY(0) scale(1)}}@keyframes popOut{to{opacity:0;transform:translateY(-16px) scale(.96)}}.pop-card::before{content:'';position:absolute;top:-45%;left:50%;transform:translateX(-50%);width:420px;height:300px;background:radial-gradient(circle,var(--pop-glow,rgba(59,130,246,.25)),transparent 65%);opacity:.65;pointer-events:none}.pop-accent{height:3px;background:linear-gradient(90deg,var(--pri),var(--cyan))}.pop-accent.error{background:linear-gradient(90deg,var(--err),#FB7185)}.pop-accent.success{background:linear-gradient(90deg,var(--ok),#4ADE80)}.pop-accent.warning{background:linear-gradient(90deg,var(--warn),#FBBF24)}.pop-x{position:absolute;top:14px;right:14px;width:30px;height:30px;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t3);cursor:pointer;display:flex;align-items:center;justify-content:center;z-index:5;transition:all .2s}.pop-x:hover{color:var(--t1);background:rgba(255,255,255,.07)}.pop-body{position:relative;z-index:1;text-align:center;padding:34px 28px 28px}.pop-icon{width:76px;height:76px;border-radius:24px;margin:0 auto 18px;display:flex;align-items:center;justify-content:center;position:relative;background:rgba(255,255,255,.035);border:1px solid var(--border)}.pop-icon::before{content:'';position:absolute;inset:-9px;border-radius:31px;border:1px solid var(--pop-ring,rgba(96,165,250,.25));opacity:0;transform:scale(.76)}.pop-layer.show .pop-icon::before{animation:ring .75s cubic-bezier(.16,1,.3,1) .22s forwards}.pop-icon i{font-size:26px;color:var(--pop-color,var(--sky));opacity:0;transform:scale(.5) rotate(-14deg)}.pop-layer.show .pop-icon i{animation:iconPop .48s cubic-bezier(.16,1,.3,1) .34s forwards}@keyframes ring{60%{opacity:1;transform:scale(1.08)}100%{opacity:1;transform:scale(1)}}@keyframes iconPop{to{opacity:1;transform:scale(1) rotate(0)}}.pop-title{font-family:var(--h);font-size:22px;font-weight:850;letter-spacing:-.75px;margin-bottom:8px}.pop-msg{font-size:14px;color:var(--t2);line-height:1.75;margin:0 auto 24px;max-width:330px}.pop-actions{display:flex;gap:10px}.pop-btn{flex:1;height:44px;border-radius:12px;font-family:var(--h);font-size:13px;font-weight:800;cursor:pointer;border:0;transition:all .2s}.pop-btn.main{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}.pop-btn.main:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.22)}.pop-btn.ghost{background:rgba(255,255,255,.035);border:1px solid var(--border);color:var(--t2)}.pop-btn.ghost:hover{background:rgba(255,255,255,.065);color:var(--t1)}.pop-progress{position:absolute;left:0;bottom:0;height:2px;width:100%;transform-origin:left;background:var(--pop-color,var(--sky))}.pop-layer.show .pop-progress{animation:timer 5.4s linear forwards}@keyframes timer{to{transform:scaleX(0)}}.spark-box{position:absolute;inset:0;pointer-events:none;overflow:hidden;border-radius:26px}.spark{position:absolute;left:50%;top:94px;width:var(--sz);height:var(--sz);background:var(--c);border-radius:999px;animation:sparkFly var(--dur) cubic-bezier(.16,.85,.3,1) forwards;opacity:0}@keyframes sparkFly{0%{opacity:1;transform:translate(-50%,-50%) translate(0,0) scale(1)}80%{opacity:1}100%{opacity:0;transform:translate(-50%,-50%) translate(var(--tx),var(--ty)) scale(.1)}}

/* ===== REVEAL ===== */
.rv{opacity:0;transform:translateY(22px);transition:opacity .75s cubic-bezier(.16,1,.3,1),transform .75s cubic-bezier(.16,1,.3,1)}.rv.v{opacity:1;transform:translateY(0)}.d1{transition-delay:.08s}.d2{transition-delay:.16s}.d3{transition-delay:.24s}

@media(max-width:980px){.nav-m{display:none}.auth-grid{grid-template-columns:1fr;gap:28px}.login-shell{justify-self:center;max-width:560px}.left-copy{padding-right:0;text-align:center}.pill{margin-left:auto;margin-right:auto}.left-copy p{margin-left:auto;margin-right:auto}.mini-proof{margin:0 auto}.market-row{justify-content:center}}
@media(max-width:680px){.wrap,.nav-in{padding:0 20px}.nav-r .btn-o{display:none}.auth-page{padding-top:104px}.left-copy h1{font-size:42px;letter-spacing:-2px}.mini-proof{grid-template-columns:1fr}.login-card{padding:26px 20px;border-radius:22px}.card-head h2{font-size:26px}.signup-box{flex-direction:column;text-align:center}.pop-actions{flex-direction:column}.pop-layer{padding-top:76px}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />


<nav class="nav">
  <div class="nav-in">
    <a href="index.jsp" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>
    <div class="nav-m">
      <a href="index#mkt" class="nav-a">Explore</a>
      <a href="index#how" class="nav-a">How it Works</a>
      <a href="index#cat" class="nav-a">Categories</a>
      <a href="index#feat" class="nav-a">Why Us</a>
    </div>
    <div class="nav-r">
      <a href="freelancerLogin" class="btn-o">Freelancer Login</a>
      <a href="clientRegister" class="btn-p">Create Account</a>
    </div>
  </div>
</nav>

<main class="auth-page">
  <div class="wrap auth-grid">
    <section class="left-copy rv">
      <div class="pill"><i class="fa-solid fa-sparkles"></i> Client workspace access</div>
      <h1>Manage your <em>freelance projects</em> with clarity</h1>
      <p>Sign in to post projects, review proposals, track assigned work, request revisions, and complete deliveries inside one professional WorkSphere workflow.</p>

      <div class="mini-proof">
        <div class="proof-card rv d1"><i class="fa-solid fa-file-signature"></i><h5>Post projects</h5><span>Create clear requirements, budget, and timeline for freelancers.</span></div>
        <div class="proof-card rv d2"><i class="fa-solid fa-user-check"></i><h5>Review bids</h5><span>Compare proposals and assign the right freelancer quickly.</span></div>
        <div class="proof-card rv d3"><i class="fa-solid fa-circle-check"></i><h5>Approve work</h5><span>Review submissions, request revisions, and close projects.</span></div>
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
          <div class="card-tag"><i class="fa-solid fa-lock"></i> Client Login</div>
          <h2>Welcome back</h2>
          <p>Continue to your dashboard and manage your hiring flow.</p>
        </div>

        <form action="clientLogin" method="post" id="loginForm" novalidate>
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
              <input name="password" type="password" placeholder="Enter your password" required id="pwInput">
              <button type="button" class="toggle-pw" id="togglePw" aria-label="Show password"><i class="fa-regular fa-eye"></i></button>
            </div>
          </div>

          <div class="form-line">
            <label class="remember"><input type="checkbox"> Remember me</label>
            <a href="clientForgotPassword" class="small-link">Forgot password?</a>
          </div>

          <button type="submit" class="login-btn" id="loginBtn">Sign in to dashboard <i class="fa-solid fa-arrow-right" style="font-size:12px;margin-left:6px"></i></button>
        </form>

        <div class="divider"><span>or continue with</span></div>
        <div class="social-row">
          <button class="social-btn" type="button" data-social="Google"><i class="fa-brands fa-google"></i></button>
          <button class="social-btn" type="button" data-social="GitHub"><i class="fa-brands fa-github"></i></button>
          <button class="social-btn" type="button" data-social="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></button>
        </div>

        <div class="signup-box">
          <span>New to WorkSphere?</span>
          <a href="clientRegister">Create client account <i class="fa-solid fa-arrow-right" style="font-size:10px;margin-left:3px"></i></a>
        </div>
      </div>
      <div class="auth-note">&copy; 2026 WorkSphere &nbsp;&middot;&nbsp; <a href="#">Privacy</a> &nbsp;&middot;&nbsp; <a href="#">Terms</a></div>
    </section>
  </div>
</main>

<script>
(function(){
  var ro=new IntersectionObserver(function(entries){
    entries.forEach(function(e){
      if(e.isIntersecting){
        e.target.classList.add('v');
        ro.unobserve(e.target);
      }
    });
  },{threshold:.06});
  document.querySelectorAll('.rv').forEach(function(el){ro.observe(el);});

  function showThemeToast(type, heading, text){
    var old=document.getElementById('wsLocalToastStack');
    if(old){ old.remove(); }

    var data={
      success:{icon:'fa-solid fa-circle-check',title:'Done successfully'},
      error:{icon:'fa-solid fa-circle-exclamation',title:'Action needed'},
      warning:{icon:'fa-solid fa-triangle-exclamation',title:'Please check this'},
      info:{icon:'fa-solid fa-circle-info',title:'WorkSphere update'}
    }[type || 'info'];

    var stack=document.createElement('div');
    stack.className='ws-toast-stack';
    stack.id='wsLocalToastStack';

    stack.innerHTML =
      '<div class="ws-toast ws-toast-'+(type || 'info')+'" id="wsLocalToast" role="status" aria-live="polite">' +
        '<div class="ws-toast-icon"><i class="'+data.icon+'"></i></div>' +
        '<div class="ws-toast-body">' +
          '<span class="ws-toast-title">'+(heading || data.title)+'</span>' +
          '<span class="ws-toast-text">'+(text || '')+'</span>' +
        '</div>' +
        '<button type="button" class="ws-toast-close" id="wsLocalToastClose" aria-label="Close message"><i class="fa-solid fa-xmark"></i></button>' +
      '</div>';

    document.body.appendChild(stack);

    var toast=document.getElementById('wsLocalToast');
    var close=document.getElementById('wsLocalToastClose');

    function hide(){
      if(!toast) return;
      toast.classList.add('ws-hide');
      setTimeout(function(){
        if(stack && stack.parentNode){ stack.parentNode.removeChild(stack); }
      },280);
    }

    if(close){ close.addEventListener('click',hide); }
    setTimeout(hide,5200);
  }

  var pwInput=document.getElementById('pwInput');
  var togglePw=document.getElementById('togglePw');
  if(togglePw && pwInput){
    togglePw.addEventListener('click',function(){
      var show=pwInput.type==='password';
      pwInput.type=show?'text':'password';
      togglePw.innerHTML=show?'<i class="fa-regular fa-eye-slash"></i>':'<i class="fa-regular fa-eye"></i>';
    });
  }

  var form=document.getElementById('loginForm');
  var loginBtn=document.getElementById('loginBtn');
  var loading=false;

  if(form && loginBtn){
    form.addEventListener('submit',function(e){
      e.preventDefault();

      if(loading) return;

      var email=form.querySelector('input[name="email"]');
      var password=form.querySelector('input[name="password"]');
      var errors=[];

      if(!email.value.trim() || !email.validity.valid) errors.push(email);
      if(!password.value.trim()) errors.push(password);

      if(errors.length){
        errors.forEach(function(inp){
          var wrap=inp.closest('.input-wrap');
          if(wrap){
            wrap.classList.remove('shake-err');
            void wrap.offsetWidth;
            wrap.classList.add('shake-err');
            setTimeout(function(){wrap.classList.remove('shake-err');},520);
          }
        });

        showThemeToast('warning','Please check this','Enter a valid email address and password before signing in.');
        return;
      }

      loading=true;
      loginBtn.classList.add('loading');
      loginBtn.innerHTML='<span class="btn-spinner"></span>Opening dashboard...';

      setTimeout(function(){form.submit();},650);
    });
  }

  document.querySelectorAll('.social-btn').forEach(function(btn){
    btn.addEventListener('click',function(){
      showThemeToast('info','Coming soon',btn.getAttribute('data-social')+' login is designed in the UI, but backend authentication is not connected yet.');
    });
  });
})();
</script>
</body>
</html>
