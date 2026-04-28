<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>WorkSphere</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
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
  --h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1200px;
}
html{scroll-behavior:smooth}
body{font-family:var(--b);background:var(--bg);color:var(--t1);overflow-x:hidden;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;text-rendering:optimizeLegibility;font-feature-settings:'kern' 1,'liga' 1,'calt' 1}
body::before{content:'';position:fixed;inset:0;z-index:-3;background:radial-gradient(circle at 20% 10%,rgba(59,130,246,.20),transparent 34%),radial-gradient(circle at 82% 24%,rgba(34,211,238,.13),transparent 32%),linear-gradient(180deg,#07080D 0%,#090B12 42%,#07080D 100%)}
body::after{content:'';position:fixed;inset:0;z-index:-2;background-image:linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.8),rgba(0,0,0,.18),transparent)}
::selection{background:var(--pri);color:#fff}
a{color:inherit}.wrap{max-width:var(--max);margin:0 auto;padding:0 32px}

/* ===== LOADER ===== */
.loader{position:fixed;inset:0;z-index:99999;background:var(--bg);display:flex;flex-direction:column;align-items:center;justify-content:center;transition:opacity .6s,visibility .6s}
.loader.done{opacity:0;visibility:hidden}.loader-logo{font-family:var(--h);font-size:34px;font-weight:800;letter-spacing:-1.5px;margin-bottom:40px;opacity:0;animation:lf .6s .1s forwards}.loader-logo .s{color:var(--pri)}@keyframes lf{to{opacity:1}}
.loader-track{width:180px;height:2px;background:var(--border);border-radius:2px;overflow:hidden}.loader-fill{height:100%;width:0;background:linear-gradient(90deg,var(--pri),var(--cyan));border-radius:2px;transition:width .25s}.loader-text{font-family:var(--h);font-size:11px;font-weight:500;color:var(--t3);letter-spacing:2.5px;text-transform:uppercase;margin-top:16px}
.prog{position:fixed;top:0;left:0;height:2px;background:linear-gradient(90deg,var(--pri),var(--cyan));z-index:9998;width:0%;transition:width .08s linear}

/* ===== NAV ===== */
.nav{position:fixed;top:0;left:0;right:0;z-index:1000;transition:background .35s,box-shadow .35s}.nav.s{background:rgba(7,8,13,0.78);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);box-shadow:0 1px 0 var(--border)}
.nav-in{max-width:var(--max);margin:0 auto;padding:0 32px;display:flex;align-items:center;justify-content:space-between;height:68px}.logo{font-family:var(--h);font-size:20px;font-weight:800;text-decoration:none;letter-spacing:-0.75px}.logo .s{color:var(--pri)}
.nav-m{display:flex;gap:0}.nav-a{text-decoration:none;color:var(--t3);font-family:var(--h);font-size:13px;font-weight:500;letter-spacing:0.01em;padding:7px 14px;border-radius:999px;transition:all .2s}.nav-a:hover,.nav-a.active{color:var(--t1);background:rgba(255,255,255,.045)}
.nav-r{display:flex;gap:8px;align-items:center}.btn-p{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;border:none;border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:700;letter-spacing:0.01em;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:transform .2s,box-shadow .2s}.btn-p:hover{transform:translateY(-1px);box-shadow:0 14px 34px rgba(59,130,246,.24)}
.btn-o{border:1px solid var(--border);color:var(--t2);background:rgba(255,255,255,.02);border-radius:9px;padding:9px 18px;font-family:var(--h);font-size:13px;font-weight:500;letter-spacing:0.01em;cursor:pointer;text-decoration:none;transition:all .2s}.btn-o:hover{color:var(--t1);border-color:rgba(255,255,255,.16);background:rgba(255,255,255,.04)}
.mbtn{display:none;background:none;border:none;color:var(--t2);font-size:18px;cursor:pointer;padding:6px}.mob{display:none;position:fixed;inset:0;z-index:2000;background:rgba(0,0,0,0.5);backdrop-filter:blur(8px);opacity:0;visibility:hidden;transition:all .25s}.mob.on{opacity:1;visibility:visible}.mob-p{position:absolute;top:16px;right:16px;width:280px;background:var(--s2);border-radius:16px;padding:24px;border:1px solid var(--border);transform:translateY(8px);transition:transform .25s}.mob.on .mob-p{transform:translateY(0)}.mob-x{background:none;border:none;color:var(--t3);font-size:15px;cursor:pointer;margin-bottom:16px;padding:4px}.mob-p a{display:block;text-decoration:none;color:var(--t2);font-family:var(--h);font-size:14.5px;font-weight:500;letter-spacing:0.01em;padding:11px 0;border-bottom:1px solid var(--border2);transition:color .15s}.mob-p a:hover{color:var(--t1)}.mob-b{margin-top:16px;display:flex;flex-direction:column;gap:8px}

/* ===== GENERAL ===== */
.sec{padding:96px 0}.sec-head{display:flex;align-items:end;justify-content:space-between;gap:28px;margin-bottom:36px}.sec-tag{font-family:var(--h);font-size:11px;font-weight:700;color:var(--sky);letter-spacing:2.2px;text-transform:uppercase;margin-bottom:10px}.sec-t{font-family:var(--h);font-size:clamp(30px,3.5vw,48px);font-weight:850;color:var(--t1);letter-spacing:-1.7px;line-height:1.08;margin-bottom:10px}.sec-d{font-size:15.5px;color:var(--t2);line-height:1.75;max-width:460px;font-weight:400;letter-spacing:0.01em}.mini-link{font-family:var(--h);font-size:13px;color:var(--sky);font-weight:700;text-decoration:none;display:inline-flex;gap:8px;align-items:center}.mini-link i{font-size:11px;transition:transform .2s}.mini-link:hover i{transform:translateX(4px)}

/* ===== HERO ===== */
.hero{min-height:auto;padding:150px 0 92px;position:relative;overflow:hidden}.hero::after{content:'';position:absolute;top:-38%;left:50%;transform:translateX(-50%);width:940px;height:760px;background:radial-gradient(circle,rgba(59,130,246,.22),transparent 64%);opacity:.34;pointer-events:none}.hero-in{max-width:920px;margin:0 auto;text-align:center;display:flex;flex-direction:column;align-items:center;position:relative;z-index:1}.hero-in>div:first-child{display:flex;flex-direction:column;align-items:center;width:100%}.pill{width:max-content;display:flex;align-items:center;gap:9px;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:999px;padding:7px 12px;margin:0 auto 18px;color:var(--t2);font-size:12px;font-weight:600;letter-spacing:.02em;opacity:0;transform:translateY(16px);animation:u .8s cubic-bezier(.16,1,.3,1) .35s forwards}.pill i{color:var(--cyan);font-size:11px}.hero h1{font-family:var(--h);font-size:clamp(46px,6.2vw,84px);line-height:.96;font-weight:850;color:var(--t1);margin-bottom:20px;letter-spacing:-3px;max-width:850px;opacity:0;transform:translateY(22px);animation:u .8s cubic-bezier(.16,1,.3,1) .5s forwards}.hero h1 em{font-style:normal;font-weight:250;color:var(--t3);letter-spacing:-2px}.hero p{font-size:17px;line-height:1.85;color:var(--t2);max-width:650px;margin:0 auto 34px;font-weight:400;letter-spacing:0.005em;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) .65s forwards}@keyframes u{to{opacity:1;transform:translateY(0)}}
.hero-btns{display:flex;gap:10px;margin-bottom:30px;justify-content:center;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) .8s forwards}.hbtn,.hbtn2{text-decoration:none;padding:13px 25px;border-radius:10px;font-family:var(--h);font-weight:700;font-size:14px;letter-spacing:0.01em;transition:all .2s;display:inline-flex;align-items:center;gap:8px}.hbtn{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;border:0}.hbtn:hover{box-shadow:0 18px 45px rgba(59,130,246,.28);transform:translateY(-2px)}.hbtn2{color:var(--t2);border:1px solid var(--border);background:rgba(255,255,255,.025)}.hbtn2:hover{color:var(--t1);border-color:rgba(255,255,255,.16);transform:translateY(-2px)}
.hero-search{width:100%;max-width:560px;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) .95s forwards}.search{display:flex;background:rgba(11,13,20,.84);border:1px solid var(--border);border-radius:12px;overflow:hidden;transition:border-color .25s,box-shadow .25s}.search:focus-within{border-color:var(--pri-mid);box-shadow:0 0 0 4px var(--pri-soft)}.search i{padding:0 0 0 16px;color:var(--t4);font-size:13px;display:flex;align-items:center}.search input{flex:1;border:none;outline:none;padding:14px 11px;font-size:14px;font-family:var(--b);font-weight:400;color:var(--t1);background:transparent;letter-spacing:0.01em}.search input::placeholder{color:var(--t4);letter-spacing:0.01em}.search button{background:var(--t1);border:none;color:#07080D;padding:0 22px;font-family:var(--h);font-size:13px;font-weight:800;letter-spacing:0.01em;cursor:pointer;transition:background .2s}.search button:hover{background:#DDEBFF}.tags{display:flex;gap:6px;flex-wrap:wrap;justify-content:center;margin-top:14px;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) 1.05s forwards}.tags span{font-size:11.5px;color:var(--t4);font-weight:500;letter-spacing:0.02em}.tags a{text-decoration:none;color:var(--t3);border:1px solid var(--border2);border-radius:999px;padding:4px 11px;font-size:12px;font-weight:500;letter-spacing:0.01em;transition:all .15s}.tags a:hover{color:var(--sky);border-color:var(--pri-mid);background:var(--pri-soft)}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:0;width:100%;max-width:760px;border-top:1px solid var(--border);padding-top:30px;margin-top:34px;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) 1.2s forwards}.stat{padding-right:26px;border-right:1px solid var(--border);text-align:left}.stat:last-child{border-right:none;padding-right:0}.stat h4{font-family:var(--h);font-size:28px;font-weight:800;color:var(--t1);letter-spacing:-1px;line-height:1}.stat h4 b{color:var(--sky);font-weight:800}.stat p{font-size:12.5px;color:var(--t3);margin-top:5px;font-weight:500;letter-spacing:0.02em}
.hero-proof{margin-top:30px;width:100%;display:grid;grid-template-columns:repeat(3,1fr);gap:12px;opacity:0;animation:u .8s cubic-bezier(.16,1,.3,1) 1.28s forwards}.proof-item{background:rgba(255,255,255,.035);border:1px solid var(--border);border-radius:14px;padding:16px 18px;text-align:left}.proof-item i{color:var(--sky);font-size:14px;margin-bottom:10px}.proof-item h5{font-family:var(--h);font-size:14px;font-weight:750;color:var(--t1);letter-spacing:-.2px;margin-bottom:5px}.proof-item p{font-size:12.5px;color:var(--t3);line-height:1.55;margin:0}

/* ===== MARQUEE ===== */
.trust{border-top:1px solid var(--border);border-bottom:1px solid var(--border);padding:0;overflow:hidden;background:rgba(255,255,255,.018)}.marquee{display:flex;width:max-content;animation:mar 26s linear infinite}.marquee:hover{animation-play-state:paused}.marquee span,.marquee b{display:flex;align-items:center;height:68px;padding:0 24px;white-space:nowrap}.marquee span{font-size:11px;color:var(--t4);font-weight:700;letter-spacing:1px;text-transform:uppercase}.marquee b{font-family:var(--h);font-size:16px;color:var(--t3);font-weight:700;letter-spacing:.02em}@keyframes mar{to{transform:translateX(-50%)}}

/* ===== CARD GRID ===== */
.card-grid{display:grid;gap:1px;background:var(--border);border:1px solid var(--border);border-radius:18px;overflow:hidden}.card-grid.c4{grid-template-columns:repeat(4,1fr)}.cg{background:rgba(11,13,20,.86);padding:30px;transition:background .2s,transform .2s;cursor:pointer;text-decoration:none;color:inherit;display:block}.cg:hover{background:var(--s2);transform:translateY(-2px)}.cg-icon{width:40px;height:40px;border-radius:12px;background:var(--s3);display:flex;align-items:center;justify-content:center;font-size:15px;color:var(--t3);margin-bottom:16px;transition:all .2s}.cg:hover .cg-icon{background:var(--pri-soft);color:var(--sky)}.cg h4{font-family:var(--h);font-size:15.5px;font-weight:700;color:var(--t1);margin-bottom:7px;letter-spacing:-0.3px;line-height:1.3}.cg p{font-size:13px;color:var(--t3);line-height:1.7;letter-spacing:0.01em}.cg-foot{display:flex;align-items:center;justify-content:space-between;margin-top:18px}.cg-foot span{font-size:11.5px;color:var(--t4);font-weight:500;letter-spacing:0.01em}.cg-foot i{font-size:11px;color:var(--t4);transition:color .2s}.cg:hover .cg-foot i{color:var(--sky)}

/* ===== SERVICE CARDS ===== */
.svc-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.svc{background:var(--s1);border:1px solid var(--border);border-radius:18px;overflow:hidden;transition:border-color .2s,transform .2s,box-shadow .2s;cursor:pointer;text-decoration:none;color:inherit;display:block}.svc:hover{border-color:var(--pri-mid);transform:translateY(-5px);box-shadow:0 24px 60px rgba(0,0,0,.28)}.svc-top{height:150px;display:flex;align-items:flex-start;justify-content:flex-end;flex-direction:column;padding:22px;position:relative;overflow:hidden}.svc-top::after{content:'';position:absolute;inset:auto -20% -55% -20%;height:110px;background:radial-gradient(circle,var(--pri-glow),transparent 65%)}.svc-top i{font-size:44px;opacity:.13;position:absolute;top:18px;left:22px}.svc-top h4{font-family:var(--h);font-size:19px;font-weight:800;color:var(--t1);letter-spacing:-0.6px;line-height:1.2;position:relative;z-index:1}.svc-top span{font-size:11px;color:var(--t2);font-weight:700;letter-spacing:0.8px;text-transform:uppercase;position:relative;z-index:1;margin-bottom:5px}.svc-bot{padding:21px}.svc-bot p{font-size:13px;color:var(--t3);line-height:1.75;letter-spacing:0.01em;margin-bottom:16px}.svc-meta{display:flex;align-items:center;justify-content:space-between}.svc-meta strong{font-family:var(--h);font-size:14px;color:var(--t1);font-weight:700;letter-spacing:-0.2px}.svc-meta em{font-style:normal;font-size:12px;color:var(--t3);font-weight:500;letter-spacing:0.01em}.svc-c1{background:linear-gradient(135deg,#0B1B32,#0F111B)}.svc-c2{background:linear-gradient(135deg,#1E1709,#0F111B)}.svc-c3{background:linear-gradient(135deg,#11142E,#0F111B)}.svc-c4{background:linear-gradient(135deg,#092331,#0F111B)}.svc-c5{background:linear-gradient(135deg,#291010,#0F111B)}.svc-c6{background:linear-gradient(135deg,#0D271F,#0F111B)}

/* ===== TALENT ===== */
.talent-shell{display:grid;grid-template-columns:.85fr 1.15fr;gap:18px}.talent-main{background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(11,13,20,.92));border:1px solid var(--border);border-radius:24px;padding:32px;min-height:380px;position:relative;overflow:hidden}.talent-main::before{content:'';position:absolute;right:-120px;top:-130px;width:300px;height:300px;border-radius:50%;background:radial-gradient(circle,var(--pri-glow),transparent 67%)}.talent-badge{width:78px;height:78px;border-radius:24px;background:linear-gradient(135deg,var(--pri),var(--cyan));display:flex;align-items:center;justify-content:center;font-family:var(--h);font-size:30px;font-weight:900;margin-bottom:26px;box-shadow:0 20px 55px rgba(59,130,246,.24)}.talent-main h3{font-family:var(--h);font-size:34px;line-height:1.02;letter-spacing:-1.4px;margin-bottom:15px}.talent-main p{color:var(--t2);font-size:14.5px;line-height:1.85;max-width:360px}.talent-score{display:flex;gap:18px;margin-top:28px}.talent-score div{border-left:1px solid var(--border);padding-left:16px}.talent-score strong{display:block;font-family:var(--h);font-size:22px;letter-spacing:-.7px}.talent-score span{font-size:12px;color:var(--t3)}.talent-list{display:grid;grid-template-columns:repeat(2,1fr);gap:18px}.person{background:rgba(11,13,20,.86);border:1px solid var(--border);border-radius:22px;padding:22px;transition:all .2s}.person:hover{transform:translateY(-4px);border-color:var(--pri-mid);background:var(--s2)}.person-top{display:flex;align-items:center;gap:13px;margin-bottom:15px}.face{width:46px;height:46px;border-radius:16px;background:linear-gradient(135deg,var(--s4),var(--pri));display:flex;align-items:center;justify-content:center;font-family:var(--h);font-weight:800}.person h4{font-family:var(--h);font-size:15px;letter-spacing:-.2px}.person small{color:var(--t3);font-size:12px}.chips{display:flex;gap:6px;flex-wrap:wrap;margin-top:14px}.chips span{font-size:11px;color:var(--t2);padding:5px 9px;border-radius:999px;background:rgba(255,255,255,.045);border:1px solid var(--border2)}

/* ===== PIPELINE ===== */
.pipeline{background:linear-gradient(145deg,rgba(16,19,29,.9),rgba(8,10,16,.9));border:1px solid var(--border);border-radius:26px;padding:28px;position:relative;overflow:hidden}.pipeline::before{content:'';position:absolute;inset:0;background:linear-gradient(90deg,transparent,rgba(59,130,246,.05),transparent);animation:sweep 5s ease-in-out infinite}@keyframes sweep{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}.pipe-row{display:grid;grid-template-columns:repeat(5,1fr);gap:12px;position:relative}.pipe-step{background:rgba(255,255,255,.035);border:1px solid var(--border2);border-radius:20px;padding:20px;min-height:170px;position:relative;overflow:hidden}.pipe-step::after{content:'';position:absolute;left:20px;right:20px;bottom:18px;height:4px;border-radius:99px;background:rgba(255,255,255,.06)}.pipe-step span{display:inline-flex;width:34px;height:34px;border-radius:11px;align-items:center;justify-content:center;background:var(--pri-soft);color:var(--sky);font-family:var(--h);font-weight:800;margin-bottom:20px}.pipe-step h4{font-family:var(--h);font-size:15px;margin-bottom:7px}.pipe-step p{font-size:12.5px;color:var(--t3);line-height:1.65}.pipe-step.active{border-color:var(--pri-mid);background:rgba(59,130,246,.07)}.pipe-step.active::after{background:linear-gradient(90deg,var(--pri),var(--cyan));box-shadow:0 0 20px var(--pri-glow)}

/* ===== HOW IT WORKS / FEATURES ===== */
.how-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:32px;position:relative}.how-grid::before{content:'';position:absolute;top:24px;left:calc(16.66%);right:calc(16.66%);height:1px;background:var(--border)}.hw{text-align:center;position:relative}.hw-n{width:50px;height:50px;border-radius:15px;background:var(--s1);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-family:var(--h);font-size:15px;font-weight:800;color:var(--t1);letter-spacing:-0.3px;margin:0 auto 20px;position:relative;z-index:1;transition:all .2s}.hw:hover .hw-n{border-color:var(--pri-mid);background:var(--pri-soft);color:var(--sky)}.hw h4{font-family:var(--h);font-size:16px;font-weight:700;color:var(--t1);margin-bottom:8px;letter-spacing:-0.3px;line-height:1.3}.hw p{font-size:13px;color:var(--t3);line-height:1.75;letter-spacing:0.01em;max-width:280px;margin:0 auto}
.feat-list{display:grid;grid-template-columns:1fr 1fr;gap:1px;background:var(--border);border:1px solid var(--border);border-radius:18px;overflow:hidden}.fl{background:rgba(11,13,20,.86);padding:29px 29px 29px 0;display:flex;gap:20px;align-items:flex-start;transition:background .2s}.fl:hover{background:var(--s2)}.fl-icon{width:46px;min-width:46px;height:46px;border-radius:13px;background:var(--s3);display:flex;align-items:center;justify-content:center;font-size:15px;color:var(--t3);margin-left:29px;transition:all .2s}.fl:hover .fl-icon{background:var(--pri-soft);color:var(--sky)}.fl h4{font-family:var(--h);font-size:15.5px;font-weight:700;color:var(--t1);margin-bottom:5px;letter-spacing:-0.3px;line-height:1.3}.fl p{font-size:13px;color:var(--t3);line-height:1.75;letter-spacing:0.01em}

/* ===== TESTIMONIAL / FAQ / CTA ===== */
.quote-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.quote{background:rgba(11,13,20,.86);border:1px solid var(--border);border-radius:22px;padding:26px}.quote i{color:var(--sky);font-size:20px;margin-bottom:18px}.quote p{font-size:14px;line-height:1.85;color:var(--t2);margin-bottom:20px}.quote h4{font-family:var(--h);font-size:14px}.quote span{font-size:12px;color:var(--t3)}.faq{display:grid;grid-template-columns:.7fr 1.3fr;gap:36px}.faq-list{display:grid;gap:10px}.faq-item{border:1px solid var(--border);background:rgba(11,13,20,.82);border-radius:16px;overflow:hidden}.faq-q{width:100%;background:none;border:none;color:var(--t1);padding:18px 20px;display:flex;justify-content:space-between;align-items:center;font-family:var(--h);font-size:15px;font-weight:700;text-align:left;cursor:pointer}.faq-q i{color:var(--t3);transition:transform .25s}.faq-a{max-height:0;overflow:hidden;transition:max-height .25s}.faq-a p{padding:0 20px 18px;color:var(--t3);font-size:13px;line-height:1.75}.faq-item.open .faq-a{max-height:120px}.faq-item.open .faq-q i{transform:rotate(45deg);color:var(--sky)}.cta{background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(9,12,20,.94));border:1px solid var(--border);border-radius:28px;padding:62px 48px;text-align:center;position:relative;overflow:hidden}.cta::before{content:'';position:absolute;top:-60%;left:50%;transform:translateX(-50%);width:700px;height:460px;background:radial-gradient(circle,var(--pri-glow),transparent 60%);opacity:.35;pointer-events:none}.cta h2{font-family:var(--h);font-size:clamp(28px,3.4vw,46px);font-weight:850;color:var(--t1);margin-bottom:12px;letter-spacing:-1.7px;line-height:1.08;position:relative}.cta p{font-size:15.5px;color:var(--t2);margin-bottom:30px;max-width:460px;margin-left:auto;margin-right:auto;line-height:1.75;letter-spacing:0.01em;font-weight:400;position:relative}.cta-btns{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;position:relative}

/* ===== FOOTER ===== */
footer{border-top:1px solid var(--border);padding:34px 0;background:rgba(255,255,255,.012)}.foot-in{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px}.foot-l{font-family:var(--h);font-size:17px;font-weight:800;letter-spacing:-0.5px}.foot-l .s{color:var(--pri)}.foot-m{display:flex;gap:20px}.foot-m a{text-decoration:none;color:var(--t3);font-size:12.5px;font-weight:500;letter-spacing:0.02em;transition:color .15s}.foot-m a:hover{color:var(--t1)}.foot-r{font-size:11.5px;color:var(--t4);font-weight:400;letter-spacing:0.02em}

/* ===== SCROLL REVEAL ===== */
.rv{opacity:0;transform:translateY(24px);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.rv.v{opacity:1;transform:translateY(0)}.rv-scale{opacity:0;transform:translateY(24px) scale(0.97);transition:opacity .7s cubic-bezier(.16,1,.3,1),transform .7s cubic-bezier(.16,1,.3,1)}.rv-scale.v{opacity:1;transform:translateY(0) scale(1)}.d1{transition-delay:.06s}.d2{transition-delay:.12s}.d3{transition-delay:.18s}.d4{transition-delay:.24s}.d5{transition-delay:.3s}.d6{transition-delay:.36s}
.toast-c{position:fixed;bottom:20px;right:20px;z-index:9997;display:flex;flex-direction:column;gap:8px}.toast{background:var(--s2);border:1px solid var(--border);color:var(--t1);padding:10px 18px;border-radius:10px;font-family:var(--h);font-size:13px;font-weight:600;letter-spacing:0.01em;box-shadow:0 8px 32px rgba(0,0,0,0.4);display:flex;align-items:center;gap:8px;transform:translateX(110%);transition:transform .3s ease}.toast.show{transform:translateX(0)}.toast i{color:var(--sky);font-size:11px}

@media(max-width:1080px){.nav-m{display:none}.mbtn{display:block}.card-grid.c4{grid-template-columns:repeat(2,1fr)}.svc-grid,.quote-grid{grid-template-columns:repeat(2,1fr)}.talent-shell,.faq{grid-template-columns:1fr}.pipe-row{grid-template-columns:repeat(2,1fr)}.feat-list{grid-template-columns:1fr}.how-grid{grid-template-columns:1fr;gap:24px}.how-grid::before{display:none}}
@media(max-width:680px){.hero-proof{grid-template-columns:1fr}.wrap,.nav-in{padding:0 20px}.hero{padding-top:118px}.hero h1{letter-spacing:-2px}.card-grid.c4,.svc-grid,.quote-grid,.talent-list,.pipe-row{grid-template-columns:1fr}.stats{grid-template-columns:repeat(2,1fr);gap:16px}.stat{padding:0;border:none;text-align:center}.hero-btns{flex-direction:column;width:100%;max-width:300px}.hbtn,.hbtn2{justify-content:center}.search{flex-direction:column;border-radius:12px}.search i{display:none}.search button{padding:12px;border-radius:0 0 11px 11px}.hero-proof{grid-template-columns:1fr}.sec-head{display:block}.cta{padding:42px 24px}.cta-btns{flex-direction:column}.foot-in{flex-direction:column;text-align:center}.foot-m{flex-wrap:wrap;justify-content:center}.marquee span,.marquee b{height:58px;padding:0 18px}.sec{padding:78px 0}}
</style>
</head>
<body>

<div class="loader" id="loader">
  <div class="loader-logo"><span class="w">Work</span><span class="s">Sphere</span></div>
  <div class="loader-track"><div class="loader-fill" id="lbar"></div></div>
  <div class="loader-text" id="ltxt">Loading</div>
</div>

<div class="prog" id="prog"></div>
<div class="toast-c" id="toastc"></div>

<nav class="nav" id="nav">
  <div class="nav-in">
    <a href="#" class="logo"><span class="w">Work</span><span class="s">Sphere</span></a>
    <div class="nav-m">
      <a href="#mkt" class="nav-a">Explore</a>
      <a href="#how" class="nav-a">How it Works</a>
      <a href="#cat" class="nav-a">Categories</a>
      <a href="#feat" class="nav-a">Why Us</a>
      <a href="#faq" class="nav-a">FAQ</a>
    </div>
    <div class="nav-r">
      <a href="clientLogin" class="btn-o">Client Login</a>
      <a href="freelancerLogin" class="btn-p">Freelancer Login</a>
    </div>
    <button class="mbtn" id="mbtn"><i class="fa-solid fa-bars"></i></button>
  </div>
</nav>

<div class="mob" id="mob">
  <div class="mob-p">
    <button class="mob-x" id="mobx"><i class="fa-solid fa-xmark"></i></button>
    <a href="#mkt">Explore</a>
    <a href="#how">How it Works</a>
    <a href="#cat">Categories</a>
    <a href="#feat">Why Us</a>
    <a href="#faq">FAQ</a>
    <div class="mob-b">
      <a href="clientLogin" class="btn-o" style="text-align:center;justify-content:center">Client Login</a>
      <a href="freelancerLogin" class="btn-p" style="text-align:center;justify-content:center">Freelancer Login</a>
    </div>
  </div>
</div>

<section class="hero">
  <div class="wrap hero-in">
    <div>
      <div class="pill"><i class="fa-solid fa-sparkles"></i> Premium freelance marketplace for modern teams</div>
      <h1>Hire elite <em>freelance talent</em> without the usual chaos</h1>
      <p>WorkSphere connects clients with skilled professionals, tracks project progress, manages proposals, and helps both sides deliver work with confidence.</p>
      <div class="hero-btns">
        <a href="clientRegister" class="hbtn">Hire Talent <i class="fa-solid fa-arrow-right" style="font-size:12px"></i></a>
        <a href="freelancerRegister" class="hbtn2">Become a Freelancer</a>
      </div>
      <div class="hero-search">
        <div class="search">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" placeholder="Search for web design, app dev, SEO..." id="si">
          <button id="sb">Search</button>
        </div>
        <div class="tags">
          <span>Popular:</span>
          <a href="#" class="tg">Web Design</a>
          <a href="#" class="tg">Logo Design</a>
          <a href="#" class="tg">SEO</a>
          <a href="#" class="tg">App Dev</a>
        </div>
      </div>
      <div class="stats">
        <div class="stat"><h4><b>10K</b>+</h4><p>Freelancers</p></div>
        <div class="stat"><h4><b>24</b>/7</h4><p>Support</p></div>
        <div class="stat"><h4><b>99</b>%</h4><p>Satisfaction</p></div>
        <div class="stat"><h4><b>150</b>+</h4><p>Countries</p></div>
      </div>
    </div>

    <div class="hero-proof">
      <div class="proof-item"><i class="fa-solid fa-shield-halved"></i><h5>Safe project workflow</h5><p>Clients and freelancers move through bidding, delivery, review, and completion clearly.</p></div>
      <div class="proof-item"><i class="fa-solid fa-chart-line"></i><h5>Project-first marketplace</h5><p>Every action connects back to real project status, proposals, and assigned work.</p></div>
      <div class="proof-item"><i class="fa-solid fa-handshake-angle"></i><h5>Built for trust</h5><p>Cleaner navigation, focused CTAs, and professional service discovery for both roles.</p></div>
    </div>
  </div>
</section>

<div class="trust rv">
  <div class="marquee">
    <span>Trusted by modern teams</span><b>Google</b><b>Meta</b><b>Stripe</b><b>Shopify</b><b>Vercel</b><b>Notion</b><b>Linear</b>
    <span>Trusted by modern teams</span><b>Google</b><b>Meta</b><b>Stripe</b><b>Shopify</b><b>Vercel</b><b>Notion</b><b>Linear</b>
  </div>
</div>

<section class="sec" id="cat">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Categories</div>
        <h2 class="sec-t">Browse by category</h2>
        <p class="sec-d">Explore popular services and find the right professionals for each project requirement.</p>
      </div>
      <a href="#mkt" class="mini-link">View popular services <i class="fa-solid fa-arrow-right"></i></a>
    </div>
    <div class="card-grid c4">
      <a href="#mkt" class="cg rv d1"><div class="cg-icon"><i class="fa-solid fa-code"></i></div><h4>Web Development</h4><p>Websites, portals, and custom web solutions.</p><div class="cg-foot"><span>2,400+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d2"><div class="cg-icon"><i class="fa-solid fa-pen-nib"></i></div><h4>Logo & Branding</h4><p>Identity systems and visual branding assets.</p><div class="cg-foot"><span>1,800+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d3"><div class="cg-icon"><i class="fa-solid fa-mobile-screen-button"></i></div><h4>App Development</h4><p>iOS, Android, and cross-platform apps.</p><div class="cg-foot"><span>1,600+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d4"><div class="cg-icon"><i class="fa-solid fa-chart-line"></i></div><h4>Digital Marketing</h4><p>SEO, ads, and growth strategy services.</p><div class="cg-foot"><span>2,100+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d1"><div class="cg-icon"><i class="fa-solid fa-feather-pointed"></i></div><h4>Writing & Content</h4><p>Blogs, copy, and professional content.</p><div class="cg-foot"><span>1,900+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d2"><div class="cg-icon"><i class="fa-solid fa-film"></i></div><h4>Video & Animation</h4><p>Reels, promos, and animated content.</p><div class="cg-foot"><span>900+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d3"><div class="cg-icon"><i class="fa-solid fa-briefcase"></i></div><h4>Consulting</h4><p>Strategy, operations, and business guidance.</p><div class="cg-foot"><span>700+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
      <a href="#mkt" class="cg rv d4"><div class="cg-icon"><i class="fa-solid fa-music"></i></div><h4>Music & Audio</h4><p>Production, mixing, and sound design.</p><div class="cg-foot"><span>500+ freelancers</span><i class="fa-solid fa-arrow-right"></i></div></a>
    </div>
  </div>
</section>

<section class="sec" style="padding-top:0" id="mkt">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Featured</div>
        <h2 class="sec-t">Popular services</h2>
        <p class="sec-d">Top-rated services that make the homepage feel like a real marketplace, not a static landing page.</p>
      </div>
      <a href="clientRegister" class="mini-link">Start hiring <i class="fa-solid fa-arrow-right"></i></a>
    </div>
    <div class="svc-grid">
      <a href="clientRegister" class="svc rv-scale d1"><div class="svc-top svc-c1"><i class="fa-solid fa-code"></i><span>Development</span><h4>Full-Stack Web App</h4></div><div class="svc-bot"><p>Custom web applications with clean architecture, responsive UI, and project-ready delivery.</p><div class="svc-meta"><strong>From ₹25,000</strong><em>4.9 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
      <a href="clientRegister" class="svc rv-scale d2"><div class="svc-top svc-c2"><i class="fa-solid fa-pen-nib"></i><span>Branding</span><h4>Brand Identity Kit</h4></div><div class="svc-bot"><p>Logo, typography, color palette, and usage guidelines for modern businesses.</p><div class="svc-meta"><strong>From ₹8,000</strong><em>4.8 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
      <a href="clientRegister" class="svc rv-scale d3"><div class="svc-top svc-c3"><i class="fa-solid fa-chart-line"></i><span>Marketing</span><h4>SEO Audit & Strategy</h4></div><div class="svc-bot"><p>Keyword research, website audit, and a growth plan for visibility and leads.</p><div class="svc-meta"><strong>From ₹6,000</strong><em>4.9 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
      <a href="clientRegister" class="svc rv-scale d4"><div class="svc-top svc-c4"><i class="fa-solid fa-mobile-screen-button"></i><span>Mobile</span><h4>Mobile App Development</h4></div><div class="svc-bot"><p>Android, iOS, and cross-platform apps with polished UI and smooth performance.</p><div class="svc-meta"><strong>From ₹35,000</strong><em>5.0 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
      <a href="clientRegister" class="svc rv-scale d5"><div class="svc-top svc-c5"><i class="fa-solid fa-film"></i><span>Video</span><h4>Product Demo Video</h4></div><div class="svc-bot"><p>Script, voiceover, motion graphics, revisions, and launch-ready product explainers.</p><div class="svc-meta"><strong>From ₹12,000</strong><em>4.7 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
      <a href="clientRegister" class="svc rv-scale d6"><div class="svc-top svc-c6"><i class="fa-solid fa-feather-pointed"></i><span>Content</span><h4>Website Copywriting</h4></div><div class="svc-bot"><p>Conversion-focused copy for landing pages, product pages, and full websites.</p><div class="svc-meta"><strong>From ₹4,000</strong><em>4.8 <i class="fa-solid fa-star" style="font-size:10px;color:var(--sky)"></i></em></div></div></a>
    </div>
  </div>
</section>

<section class="sec" id="talent" style="padding-top:0">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Talent Network</div>
        <h2 class="sec-t">Featured professionals</h2>
        <p class="sec-d">A stronger marketplace section that shows real profile-style talent cards.</p>
      </div>
      <a href="freelancerRegister" class="mini-link">Join network <i class="fa-solid fa-arrow-right"></i></a>
    </div>
    <div class="talent-shell">
      <div class="talent-main rv-scale">
        <div class="talent-badge">WS</div>
        <h3>Curated experts for every project stage.</h3>
        <p>Clients can compare proposals, review profiles, and hire based on skills, rating, budget, and delivery strength.</p>
        <div class="talent-score">
          <div><strong>4.9/5</strong><span>Average rating</span></div>
          <div><strong>86%</strong><span>Repeat clients</span></div>
        </div>
      </div>
      <div class="talent-list">
        <div class="person rv d1"><div class="person-top"><div class="face">A</div><div><h4>Aarav Mehta</h4><small>Full-stack Developer</small></div></div><p style="color:var(--t3);font-size:13px;line-height:1.7">Builds Spring MVC, dashboards, and marketplace platforms.</p><div class="chips"><span>Java</span><span>Spring</span><span>MySQL</span></div></div>
        <div class="person rv d2"><div class="person-top"><div class="face">N</div><div><h4>Nisha Rao</h4><small>UI/UX Designer</small></div></div><p style="color:var(--t3);font-size:13px;line-height:1.7">Designs clean SaaS pages, mobile flows, and brand systems.</p><div class="chips"><span>UI</span><span>Figma</span><span>SaaS</span></div></div>
        <div class="person rv d3"><div class="person-top"><div class="face">R</div><div><h4>Rohan Shah</h4><small>Growth Marketer</small></div></div><p style="color:var(--t3);font-size:13px;line-height:1.7">Handles SEO, campaigns, analytics, and conversion funnels.</p><div class="chips"><span>SEO</span><span>Ads</span><span>Analytics</span></div></div>
        <div class="person rv d4"><div class="person-top"><div class="face">S</div><div><h4>Sara Khan</h4><small>Motion Designer</small></div></div><p style="color:var(--t3);font-size:13px;line-height:1.7">Creates product demos, reels, and smooth motion content.</p><div class="chips"><span>Video</span><span>Motion</span><span>Brand</span></div></div>
      </div>
    </div>
  </div>
</section>

<section class="sec" id="pipeline" style="background:rgba(255,255,255,.018)">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Project Flow</div>
        <h2 class="sec-t">From idea to approved delivery</h2>
        <p class="sec-d">This section gives your homepage a stronger SaaS-product feel and explains your actual project workflow.</p>
      </div>
    </div>
    <div class="pipeline rv-scale">
      <div class="pipe-row">
        <div class="pipe-step active"><span>01</span><h4>Post project</h4><p>Client creates a clear project brief with budget and deadline.</p></div>
        <div class="pipe-step active"><span>02</span><h4>Receive bids</h4><p>Freelancers submit proposals with pricing and timeline.</p></div>
        <div class="pipe-step active"><span>03</span><h4>Accept talent</h4><p>Client compares bids and assigns the project to a freelancer.</p></div>
        <div class="pipe-step"><span>04</span><h4>Submit work</h4><p>Freelancer uploads work and client reviews deliverables.</p></div>
        <div class="pipe-step"><span>05</span><h4>Complete</h4><p>Client approves, reviews, and closes the project successfully.</p></div>
      </div>
    </div>
  </div>
</section>

<section class="sec" id="how">
  <div class="wrap">
    <div style="text-align:center;margin-bottom:44px" class="rv">
      <div class="sec-tag">Process</div>
      <h2 class="sec-t">How it works</h2>
      <p class="sec-d" style="margin:0 auto">Three simple steps to find and hire the right talent.</p>
    </div>
    <div class="how-grid">
      <div class="hw rv d1"><div class="hw-n">01</div><h4>Post a project</h4><p>Describe your needs, set a budget and timeline, and publish to the marketplace.</p></div>
      <div class="hw rv d2"><div class="hw-n">02</div><h4>Review proposals</h4><p>Browse freelancer profiles, compare rates and reviews, and shortlist candidates.</p></div>
      <div class="hw rv d3"><div class="hw-n">03</div><h4>Hire and deliver</h4><p>Collaborate with milestones, track progress, and receive your final deliverables.</p></div>
    </div>
  </div>
</section>

<section class="sec" id="feat">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Why WorkSphere</div>
        <h2 class="sec-t">Built for teams that hire often</h2>
        <p class="sec-d">Everything you need to manage freelance relationships at scale.</p>
      </div>
    </div>
    <div class="feat-list">
      <div class="fl rv d1"><div class="fl-icon"><i class="fa-solid fa-user-check"></i></div><div><h4>Vetted professionals</h4><p>Every freelancer profile is organized around clear skills, service quality, and client-ready details.</p></div></div>
      <div class="fl rv d2"><div class="fl-icon"><i class="fa-solid fa-shield-halved"></i></div><div><h4>Controlled workflow</h4><p>Projects move through bid, acceptance, assigned work, review, revision, and completion states.</p></div></div>
      <div class="fl rv d3"><div class="fl-icon"><i class="fa-solid fa-bolt"></i></div><div><h4>Fast matching</h4><p>Clients can quickly see relevant categories, services, and professionals from the homepage.</p></div></div>
      <div class="fl rv d4"><div class="fl-icon"><i class="fa-solid fa-headset"></i></div><div><h4>Clear communication</h4><p>Layout supports future project chat, notifications, and client-freelancer collaboration features.</p></div></div>
      <div class="fl rv d5"><div class="fl-icon"><i class="fa-solid fa-chart-pie"></i></div><div><h4>Dashboard-ready design</h4><p>The visual language matches SaaS dashboards, analytics, proposals, and marketplace pages.</p></div></div>
      <div class="fl rv d6"><div class="fl-icon"><i class="fa-solid fa-globe"></i></div><div><h4>Scalable marketplace</h4><p>Category, service, talent, and pipeline sections can grow as your project features grow.</p></div></div>
    </div>
  </div>
</section>

<section class="sec" id="reviews" style="padding-top:0">
  <div class="wrap">
    <div class="sec-head rv">
      <div>
        <div class="sec-tag">Reviews</div>
        <h2 class="sec-t">What users can expect</h2>
        <p class="sec-d">Social-proof cards make the page feel complete and more trustworthy.</p>
      </div>
    </div>
    <div class="quote-grid">
      <div class="quote rv d1"><i class="fa-solid fa-quote-left"></i><p>“The project pipeline makes it easy to understand where each assignment stands.”</p><h4>Client team</h4><span>Startup founder</span></div>
      <div class="quote rv d2"><i class="fa-solid fa-quote-left"></i><p>“The marketplace feels clean, fast, and focused on serious freelance work.”</p><h4>Freelancer</h4><span>Full-stack developer</span></div>
      <div class="quote rv d3"><i class="fa-solid fa-quote-left"></i><p>“The dashboard-style design gives confidence before even logging into the platform.”</p><h4>Product team</h4><span>Project manager</span></div>
    </div>
  </div>
</section>

<section class="sec" id="faq" style="padding-top:0">
  <div class="wrap faq">
    <div class="rv">
      <div class="sec-tag">FAQ</div>
      <h2 class="sec-t">Common questions</h2>
      <p class="sec-d">A compact FAQ improves the ending of the homepage and gives users quick answers.</p>
    </div>
    <div class="faq-list rv-scale">
      <div class="faq-item open"><button class="faq-q">How do clients start? <i class="fa-solid fa-plus"></i></button><div class="faq-a"><p>Clients register, post a project, review freelancer bids, and accept the best proposal.</p></div></div>
      <div class="faq-item"><button class="faq-q">How do freelancers get work? <i class="fa-solid fa-plus"></i></button><div class="faq-a"><p>Freelancers register, explore projects, submit bids, and deliver work after assignment.</p></div></div>
      <div class="faq-item"><button class="faq-q">Does this change backend logic? <i class="fa-solid fa-plus"></i></button><div class="faq-a"><p>No. This page only updates layout, styling, links, animation, and static homepage sections.</p></div></div>
      <div class="faq-item"><button class="faq-q">Is it responsive? <i class="fa-solid fa-plus"></i></button><div class="faq-a"><p>Yes. The layout adapts for desktop, tablet, and mobile screens with a mobile menu.</p></div></div>
    </div>
  </div>
</section>

<section class="sec" style="padding:40px 0 96px">
  <div class="wrap">
    <div class="cta rv">
      <h2>Ready to build your next project?</h2>
      <p>Join WorkSphere as a client to hire talent, or as a freelancer to find serious project opportunities.</p>
      <div class="cta-btns">
        <a href="clientRegister" class="hbtn">Hire Talent <i class="fa-solid fa-arrow-right" style="font-size:12px"></i></a>
        <a href="freelancerRegister" class="hbtn2">Join as Freelancer</a>
      </div>
    </div>
  </div>
</section>

<footer>
  <div class="wrap">
    <div class="foot-in">
      <div class="foot-l">Work<span class="s">Sphere</span></div>
      <div class="foot-m">
        <a href="#mkt">Explore</a>
        <a href="#how">How it Works</a>
        <a href="#cat">Categories</a>
        <a href="#feat">Why Us</a>
        <a href="#faq">FAQ</a>
      </div>
      <div class="foot-r">&copy; 2026 WorkSphere</div>
    </div>
  </div>
</footer>

<script>
(function(){
  const loader=document.getElementById('loader'),lbar=document.getElementById('lbar'),ltxt=document.getElementById('ltxt');
  let p=0;document.body.style.overflow='hidden';
  const li=setInterval(()=>{
    p+=Math.random()*15+5;
    if(p>=100){p=100;clearInterval(li);lbar.style.width='100%';ltxt.textContent='Ready';setTimeout(()=>{loader.classList.add('done');document.body.style.overflow=''},280);setTimeout(()=>{loader.style.display='none'},850)}
    else{lbar.style.width=p+'%';ltxt.textContent=Math.round(p)+'%'}
  },90);

  const nav=document.getElementById('nav'),prog=document.getElementById('prog');
  let tk=false;
  function onS(){const s=scrollY,h=document.documentElement.scrollHeight-innerHeight;prog.style.width=(h>0?s/h*100:0)+'%';nav.classList.toggle('s',s>30);setActive();tk=false}
  addEventListener('scroll',()=>{if(!tk){requestAnimationFrame(onS);tk=true}},{passive:true});

  const ro=new IntersectionObserver(es=>{es.forEach(e=>{if(e.isIntersecting){e.target.classList.add('v');ro.unobserve(e.target)}})},{threshold:.05,rootMargin:'0px 0px -4px 0px'});
  document.querySelectorAll('.rv,.rv-scale').forEach(e=>ro.observe(e));

  const si=document.getElementById('si'),sb=document.getElementById('sb');
  function ds(){const q=si.value.trim();q?toast('Searching for "'+q+'"...','fa-solid fa-magnifying-glass'):toast('Enter a search term','fa-solid fa-circle-exclamation')}
  sb.addEventListener('click',ds);si.addEventListener('keydown',e=>{if(e.key==='Enter')ds()});
  document.querySelectorAll('.tg').forEach(t=>{t.addEventListener('click',e=>{e.preventDefault();si.value=t.textContent;toast('Searching for "'+t.textContent+'"...','fa-solid fa-magnifying-glass')})});

  function toast(m,ic){const c=document.getElementById('toastc'),t=document.createElement('div');t.className='toast';t.innerHTML='<i class="'+ic+'"></i> '+m;c.appendChild(t);requestAnimationFrame(()=>requestAnimationFrame(()=>t.classList.add('show')));setTimeout(()=>{t.classList.remove('show');setTimeout(()=>t.remove(),300)},2500)}

  const mob=document.getElementById('mob'),mbtn=document.getElementById('mbtn'),mobx=document.getElementById('mobx');
  mbtn.addEventListener('click',()=>{mob.classList.add('on');document.body.style.overflow='hidden'});
  function cm(){mob.classList.remove('on');document.body.style.overflow=''}
  mobx.addEventListener('click',cm);mob.addEventListener('click',e=>{if(e.target===mob)cm()});
  document.querySelectorAll('.mob-p a').forEach(a=>a.addEventListener('click',cm));

  document.querySelectorAll('a[href^="#"]').forEach(a=>{a.addEventListener('click',function(e){const h=this.getAttribute('href');if(h==='#')return;e.preventDefault();const t=document.querySelector(h);if(t)window.scrollTo({top:t.getBoundingClientRect().top+scrollY-nav.offsetHeight-16,behavior:'smooth'})})});

  document.querySelectorAll('.faq-q').forEach(btn=>{btn.addEventListener('click',()=>{btn.closest('.faq-item').classList.toggle('open')})});

  const sections=[...document.querySelectorAll('section[id]')];
  const navLinks=[...document.querySelectorAll('.nav-a')];
  function setActive(){
    let current='';
    sections.forEach(sec=>{if(scrollY>=sec.offsetTop-120)current=sec.id});
    navLinks.forEach(a=>a.classList.toggle('active',a.getAttribute('href')==='#'+current));
  }
  onS();
})();
</script>
</body>
</html>
