<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.BidModel" %>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.FreelancerModel" %>

<%!
private String safe(Object value){
    if(value == null) return "";
    return String.valueOf(value)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}
%>

<%
FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");
if(freelancer == null){
    response.sendRedirect("freelancerLogin");
    return;
}

BidModel bid = (BidModel) request.getAttribute("bid");
if(bid == null){
    response.sendRedirect("myProposals");
    return;
}

ProjectModel project = bid.getProject();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Proposal | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--cyan:#22D3EE;--bg:#07080D;--s2:#10131D;--t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;
  --border:rgba(255,255,255,.09);--h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1160px;
}
body{
  min-height:100vh;
  font-family:var(--b);
  color:var(--t1);
  background:
    radial-gradient(circle at 18% 8%,rgba(59,130,246,.22),transparent 34%),
    radial-gradient(circle at 86% 24%,rgba(34,211,238,.13),transparent 32%),
    linear-gradient(180deg,#07080D,#090B12 48%,#07080D);
  overflow-x:hidden;
}
body::after{
  content:"";
  position:fixed;
  inset:0;
  z-index:-1;
  background-image:
    linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);
  background-size:56px 56px;
  mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent);
}
a{text-decoration:none;color:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 28px}
.nav{
  position:fixed;
  top:0;
  left:0;
  right:0;
  z-index:1000;
  background:rgba(7,8,13,.76);
  backdrop-filter:blur(18px);
  -webkit-backdrop-filter:blur(18px);
  border-bottom:1px solid var(--border);
}
.nav-in{
  height:68px;
  max-width:var(--max);
  margin:0 auto;
  padding:0 28px;
  display:flex;
  align-items:center;
  justify-content:space-between;
}
.logo{font-family:var(--h);font-size:20px;font-weight:900;letter-spacing:-.8px}
.logo span:last-child{color:var(--pri)}
.nav-actions{display:flex;gap:9px;align-items:center;flex-wrap:wrap}
.btn-o,.btn-p{
  min-height:40px;
  border-radius:11px;
  padding:0 15px;
  font-family:var(--h);
  font-size:13px;
  font-weight:850;
  display:inline-flex;
  align-items:center;
  gap:8px;
  transition:.2s;
}
.btn-o{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2)}
.btn-p{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.btn-o:hover,.btn-p:hover{transform:translateY(-2px);color:white}
.page{padding:118px 0 70px}
.grid{display:grid;grid-template-columns:.86fr 1.14fr;gap:28px;align-items:start}
.side,.card{
  position:relative;
  border:1px solid var(--border);
  background:linear-gradient(145deg,rgba(16,19,29,.88),rgba(8,11,18,.78));
  border-radius:30px;
  padding:30px;
  overflow:hidden;
  box-shadow:0 30px 80px rgba(0,0,0,.24);
}
.side{position:sticky;top:96px}
.side::before,.card::before{
  content:"";
  position:absolute;
  right:-140px;
  top:-150px;
  width:330px;
  height:330px;
  border-radius:50%;
  background:radial-gradient(circle,rgba(59,130,246,.16),transparent 66%);
}
.content{position:relative;z-index:1}
.kicker{
  display:inline-flex;
  align-items:center;
  gap:8px;
  border:1px solid rgba(34,211,238,.22);
  background:rgba(34,211,238,.08);
  color:#BAE6FD;
  border-radius:999px;
  padding:8px 13px;
  font-size:11px;
  font-weight:900;
  letter-spacing:1px;
  text-transform:uppercase;
  margin-bottom:18px;
}
h1{font-family:var(--h);font-size:clamp(42px,5vw,70px);line-height:.95;letter-spacing:-2.8px;font-weight:900;margin-bottom:18px}
h1 em{font-style:normal;color:var(--t3);font-weight:300}
.side p{color:var(--t2);line-height:1.8;font-size:14.5px;margin-bottom:22px}
.rule-list{display:grid;gap:11px;margin-top:24px}
.rule{display:flex;gap:11px;align-items:flex-start;color:var(--t2);font-size:13px;line-height:1.7;border:1px solid rgba(255,255,255,.055);background:rgba(255,255,255,.025);border-radius:16px;padding:13px}
.rule i{color:var(--cyan);margin-top:3px}
.project-pill{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  flex-wrap:wrap;
  border:1px solid var(--border);
  background:rgba(255,255,255,.035);
  border-radius:18px;
  padding:16px;
  margin-bottom:24px;
}
.project-pill strong{font-family:var(--h);font-size:18px}
.project-pill span{color:var(--t3);font-size:12px}
.group{margin-bottom:18px}
label{display:flex;justify-content:space-between;gap:12px;color:var(--t1);font-family:var(--h);font-size:13px;font-weight:850;margin-bottom:9px}
label small{color:var(--t3);font-family:var(--b);font-weight:700}
.input,.textarea{
  width:100%;
  border:1px solid var(--border);
  background:rgba(255,255,255,.045);
  color:white;
  outline:none;
  border-radius:16px;
  padding:15px 16px;
  font-size:14px;
  transition:.2s;
  font-family:var(--b);
}
.input{height:54px}
.textarea{min-height:230px;resize:vertical;line-height:1.7}
.input:focus,.textarea:focus{border-color:rgba(59,130,246,.42);box-shadow:0 0 0 4px rgba(59,130,246,.10);background:rgba(255,255,255,.06)}
.help{color:var(--t3);font-size:12.5px;line-height:1.6;margin-top:8px;display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap}
.actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:24px}
.submit,.ghost{
  min-height:50px;
  border-radius:14px;
  padding:0 20px;
  border:0;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:9px;
  font-family:var(--h);
  font-size:14px;
  font-weight:900;
  cursor:pointer;
  transition:.2s;
}
.submit{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;box-shadow:0 20px 48px rgba(59,130,246,.24)}
.ghost{border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t2)}
.submit:hover,.ghost:hover{transform:translateY(-2px);color:white}
@media(max-width:980px){.grid{grid-template-columns:1fr}.side{position:relative;top:auto}.nav-actions{display:none}}
@media(max-width:640px){.wrap,.nav-in{padding:0 18px}.card,.side{padding:24px;border-radius:24px}.actions{display:grid}.submit,.ghost{width:100%}}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<nav class="nav">
  <div class="nav-in">
    <a href="freelancerDashboard" class="logo"><span>Work</span><span>Sphere</span></a>
    <div class="nav-actions">
      <a href="myProposals" class="btn-o"><i class="fa-solid fa-arrow-left"></i> My Proposals</a>
      <a href="viewAllProjects" class="btn-p"><i class="fa-solid fa-magnifying-glass"></i> Explore</a>
    </div>
  </div>
</nav>

<main class="page">
  <div class="wrap grid">
    <aside class="side">
      <div class="content">
        <div class="kicker"><i class="fa-solid fa-file-pen"></i> Proposal Edit</div>
        <h1>Improve your <em>pending bid.</em></h1>
        <p>You can edit your bid amount and proposal only while the client has not accepted or rejected it. Once a decision is made, the proposal becomes locked.</p>

        <div class="rule-list">
          <div class="rule"><i class="fa-solid fa-circle-check"></i><span>Edit is allowed only when proposal status is <strong>Pending</strong>.</span></div>
          <div class="rule"><i class="fa-solid fa-lock"></i><span>Accepted, rejected, and withdrawn proposals cannot be edited.</span></div>
          <div class="rule"><i class="fa-solid fa-lightbulb"></i><span>Keep your proposal clear, specific, and aligned to the client’s project scope.</span></div>
        </div>
      </div>
    </aside>

    <section class="card">
      <div class="content">
        <div class="project-pill">
          <strong><%= project == null ? "Project unavailable" : safe(project.getTitle()) %></strong>
          <span>Bid #<%= bid.getId() %> · Status: <%= safe(bid.getStatus()) %></span>
        </div>

        <form action="updateProposal" method="post" id="proposalForm">
          <input type="hidden" name="bidId" value="<%= bid.getId() %>">

          <div class="group">
            <label for="bidAmount">Bid amount <small>₹</small></label>
            <input class="input" type="number" id="bidAmount" name="bidAmount" min="1" step="1" value="<%= bid.getBidAmount() %>" required>
          </div>

          <div class="group">
            <label for="proposalText">Proposal message <small id="proposalCount">0 / 3000</small></label>
            <textarea class="textarea" id="proposalText" name="proposalText" maxlength="3000" required><%= safe(bid.getProposalText()) %></textarea>
            <div class="help"><span>Explain your approach, timeline, and what the client will receive.</span><span>Minimum 20 characters</span></div>
          </div>

          <div class="actions">
            <button type="submit" class="submit"><i class="fa-solid fa-floppy-disk"></i> Save Proposal</button>
            <a href="myProposals" class="ghost"><i class="fa-solid fa-arrow-left"></i> Cancel Editing</a>
          </div>
        </form>
      </div>
    </section>
  </div>
</main>

<script>
(function(){
  var text = document.getElementById('proposalText');
  var count = document.getElementById('proposalCount');

  function update(){
    if(text && count){
      count.textContent = text.value.length + ' / 3000';
    }
  }

  if(text){
    text.addEventListener('input', update);
    update();
  }

  var form = document.getElementById('proposalForm');
  if(form){
    form.addEventListener('submit', function(e){
      var amount = document.getElementById('bidAmount');
      if(Number(amount.value) <= 0 || !text.value.trim() || text.value.trim().length < 20){
        e.preventDefault();
        window.dispatchEvent(new CustomEvent('worksphereLocalWarning', {
          detail: 'Please enter a valid bid amount and a proposal message of at least 20 characters.'
        }));
      }
    });
  }
})();
</script>
</body>
</html>
