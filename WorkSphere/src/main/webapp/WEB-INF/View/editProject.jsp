<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.ClientModel" %>
<%@ page import="com.model.ProjectModel" %>

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
ClientModel client = (ClientModel) session.getAttribute("clientSession");
if(client == null){
    response.sendRedirect("clientLogin");
    return;
}

ProjectModel project = (ProjectModel) request.getAttribute("project");
if(project == null){
    response.sendRedirect("viewMyProjects");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Project | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--cyan:#22D3EE;--bg:#07080D;--s2:#10131D;--s3:#171B28;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--border:rgba(255,255,255,.09);
  --warn:#F59E0B;--h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1180px;
}
body{
  min-height:100vh;font-family:var(--b);color:var(--t1);background:
  radial-gradient(circle at 18% 8%,rgba(59,130,246,.22),transparent 34%),
  radial-gradient(circle at 86% 24%,rgba(34,211,238,.13),transparent 32%),
  linear-gradient(180deg,#07080D,#090B12 48%,#07080D);
  overflow-x:hidden;
}
body::after{
  content:"";position:fixed;inset:0;z-index:-1;background-image:
  linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),
  linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);
  background-size:56px 56px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent);
}
a{text-decoration:none;color:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 28px}
.nav{
  position:fixed;top:0;left:0;right:0;z-index:1000;background:rgba(7,8,13,.76);
  backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);border-bottom:1px solid var(--border);
}
.nav-in{max-width:var(--max);height:68px;margin:0 auto;padding:0 28px;display:flex;align-items:center;justify-content:space-between}
.logo{font-family:var(--h);font-size:20px;font-weight:900;letter-spacing:-.8px}.logo span:last-child{color:var(--pri)}
.nav-actions{display:flex;gap:9px;align-items:center;flex-wrap:wrap}
.btn-o,.btn-p{
  min-height:40px;border-radius:11px;padding:0 15px;font-family:var(--h);font-size:13px;font-weight:850;
  display:inline-flex;align-items:center;gap:8px;transition:.2s;
}
.btn-o{border:1px solid var(--border);background:rgba(255,255,255,.025);color:var(--t2)}
.btn-p{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.btn-o:hover,.btn-p:hover{transform:translateY(-2px);color:white}
.page{padding:118px 0 70px}
.grid{display:grid;grid-template-columns:.88fr 1.12fr;gap:28px;align-items:start}
.side{
  position:sticky;top:96px;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.86),rgba(7,9,15,.76));
  border-radius:30px;padding:30px;overflow:hidden;
}
.side::before,.card::before{content:"";position:absolute;right:-130px;top:-140px;width:300px;height:300px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.14),transparent 66%)}
.kicker{display:inline-flex;gap:8px;align-items:center;color:#BAE6FD;border:1px solid rgba(34,211,238,.22);background:rgba(34,211,238,.08);border-radius:999px;padding:8px 13px;font-size:11px;font-weight:900;letter-spacing:1px;text-transform:uppercase;margin-bottom:18px}
h1{font-family:var(--h);font-size:clamp(42px,5vw,70px);line-height:.95;letter-spacing:-2.8px;font-weight:900;margin-bottom:18px}
h1 em{font-style:normal;color:var(--t3);font-weight:300}
.side p{color:var(--t2);line-height:1.8;font-size:14.5px;margin-bottom:22px}
.rule-list{display:grid;gap:11px;margin-top:24px}
.rule{display:flex;gap:11px;align-items:flex-start;color:var(--t2);font-size:13px;line-height:1.7;border:1px solid rgba(255,255,255,.055);background:rgba(255,255,255,.025);border-radius:16px;padding:13px}
.rule i{color:var(--cyan);margin-top:3px}
.card{
  position:relative;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(8,11,18,.88));
  border-radius:30px;padding:32px;box-shadow:0 32px 90px rgba(0,0,0,.34);overflow:hidden;
}
.form-content{position:relative;z-index:1}
.project-pill{display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;border:1px solid var(--border);background:rgba(255,255,255,.035);border-radius:18px;padding:16px;margin-bottom:24px}
.project-pill strong{font-family:var(--h);font-size:18px}.project-pill span{color:var(--t3);font-size:12px}
.group{margin-bottom:18px}
label{display:flex;justify-content:space-between;gap:12px;color:var(--t1);font-family:var(--h);font-size:13px;font-weight:850;margin-bottom:9px}
label small{color:var(--t3);font-family:var(--b);font-weight:700}
.input,.textarea{
  width:100%;border:1px solid var(--border);background:rgba(255,255,255,.045);color:white;outline:none;
  border-radius:16px;padding:15px 16px;font-size:14px;transition:.2s;font-family:var(--b);
}
.input{height:54px}
.textarea{min-height:190px;resize:vertical;line-height:1.7}
.input:focus,.textarea:focus{border-color:rgba(59,130,246,.42);box-shadow:0 0 0 4px rgba(59,130,246,.10);background:rgba(255,255,255,.06)}
.meta-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.help{color:var(--t3);font-size:12.5px;line-height:1.6;margin-top:8px;display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap}
.actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:24px}
.submit,.ghost{min-height:50px;border-radius:14px;padding:0 20px;border:0;display:inline-flex;align-items:center;justify-content:center;gap:9px;font-family:var(--h);font-size:14px;font-weight:900;cursor:pointer;transition:.2s}
.submit{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;box-shadow:0 20px 48px rgba(59,130,246,.24)}
.ghost{border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t2)}
.submit:hover,.ghost:hover{transform:translateY(-2px);color:white}
@media(max-width:980px){.grid{grid-template-columns:1fr}.side{position:relative;top:auto}.meta-grid{grid-template-columns:1fr}.nav-actions{display:none}}
@media(max-width:640px){.wrap,.nav-in{padding:0 18px}.card,.side{padding:24px;border-radius:24px}.actions{display:grid}.submit,.ghost{width:100%}}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<nav class="nav">
  <div class="nav-in">
    <a href="clientDashboard" class="logo"><span>Work</span><span>Sphere</span></a>
    <div class="nav-actions">
      <a href="viewMyProjects" class="btn-o"><i class="fa-solid fa-arrow-left"></i> My Projects</a>
      <a href="clientDashboard" class="btn-p"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
    </div>
  </div>
</nav>

<main class="page">
  <div class="wrap grid">
    <aside class="side">
      <div class="kicker"><i class="fa-solid fa-pen-to-square"></i> Project Edit</div>
      <h1>Refine your <em>open brief.</em></h1>
      <p>You can edit project details only while the project is still open. Once you accept a bid or fund escrow, the brief is locked for delivery safety.</p>

      <div class="rule-list">
        <div class="rule"><i class="fa-solid fa-circle-check"></i><span>Edit is allowed only when status is <strong>Open</strong>.</span></div>
        <div class="rule"><i class="fa-solid fa-shield-halved"></i><span>Accepted, funded, submitted, revision, and completed projects are protected.</span></div>
        <div class="rule"><i class="fa-solid fa-lightbulb"></i><span>Keep the description clear so freelancers send accurate proposals.</span></div>
      </div>
    </aside>

    <section class="card">
      <div class="form-content">
        <div class="project-pill">
          <strong><%= safe(project.getTitle()) %></strong>
          <span>Project #<%= project.getId() %> · Status: <%= safe(project.getStatus()) %></span>
        </div>

        <form action="updateProject" method="post" id="editProjectForm">
          <input type="hidden" name="projectId" value="<%= project.getId() %>">

          <div class="group">
            <label for="title">Project title <small>Required</small></label>
            <input class="input" type="text" id="title" name="title" maxlength="255" value="<%= safe(project.getTitle()) %>" required>
          </div>

          <div class="group">
            <label for="description">Project description <small id="descCount">0 / 2000</small></label>
            <textarea class="textarea" id="description" name="description" maxlength="2000" required><%= safe(project.getDescription()) %></textarea>
            <div class="help"><span>Explain scope, deliverables, references, and expected outcome.</span><span>Max 2000 characters</span></div>
          </div>

          <div class="meta-grid">
            <div class="group">
              <label for="budget">Budget <small>₹</small></label>
              <input class="input" type="number" id="budget" name="budget" min="1" step="1" value="<%= project.getBudget() %>" required>
            </div>

            <div class="group">
              <label for="deadline">Deadline <small>Required</small></label>
              <input class="input" type="date" id="deadline" name="deadline" value="<%= safe(project.getDeadline()) %>" required>
            </div>
          </div>

          <div class="actions">
            <button type="submit" class="submit"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
            <a href="viewMyProjects" class="ghost"><i class="fa-solid fa-arrow-left"></i> Cancel Editing</a>
          </div>
        </form>
      </div>
    </section>
  </div>
</main>

<script>
(function(){
  var desc = document.getElementById('description');
  var count = document.getElementById('descCount');

  function update(){
    if(desc && count){
      count.textContent = desc.value.length + ' / 2000';
    }
  }

  if(desc){
    desc.addEventListener('input', update);
    update();
  }

  var form = document.getElementById('editProjectForm');
  if(form){
    form.addEventListener('submit', function(e){
      var title = document.getElementById('title');
      var budget = document.getElementById('budget');

      if(!title.value.trim() || !desc.value.trim() || Number(budget.value) <= 0){
        e.preventDefault();
        window.dispatchEvent(new CustomEvent('worksphereLocalWarning', {
          detail: 'Please complete title, description, budget, and deadline before saving.'
        }));
      }
    });
  }
})();
</script>
</body>
</html>
