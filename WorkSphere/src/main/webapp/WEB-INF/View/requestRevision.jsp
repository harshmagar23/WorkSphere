<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>Request Revision | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
:root{
    --pri:#3B82F6;
    --cyan:#22D3EE;
    --bg:#07080D;
    --card:#10131D;
    --text:#F8FAFC;
    --muted:#94A3B8;
    --border:rgba(255,255,255,.09);
    --warn:#F59E0B;
}
*{box-sizing:border-box}
body{
    margin:0;
    min-height:100vh;
    font-family:'Inter',sans-serif;
    background:
        radial-gradient(circle at 15% 10%,rgba(59,130,246,.22),transparent 30%),
        radial-gradient(circle at 85% 20%,rgba(34,211,238,.12),transparent 30%),
        linear-gradient(180deg,#07080D,#090B12);
    color:var(--text);
}
a{text-decoration:none;color:inherit}
.page{
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:94px 20px 40px;
}
.topbar{
    position:fixed;
    top:18px;
    left:50%;
    transform:translateX(-50%);
    width:min(1120px,calc(100% - 36px));
    z-index:50;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    border:1px solid var(--border);
    background:rgba(7,8,13,.72);
    backdrop-filter:blur(18px);
    -webkit-backdrop-filter:blur(18px);
    border-radius:18px;
    padding:12px 14px;
}
.top-brand{
    display:flex;
    align-items:center;
    gap:10px;
    font-family:'Outfit',sans-serif;
    font-weight:900;
    letter-spacing:-.5px;
}
.top-brand span:last-child{color:var(--pri)}
.top-brand i{
    width:34px;
    height:34px;
    border-radius:12px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    background:linear-gradient(135deg,var(--pri),var(--cyan));
}
.top-actions{
    display:flex;
    align-items:center;
    gap:8px;
    flex-wrap:wrap;
}
.top-link{
    min-height:38px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:8px;
    border:1px solid var(--border);
    background:rgba(255,255,255,.035);
    color:var(--text);
    border-radius:12px;
    padding:0 13px;
    font-family:'Outfit',sans-serif;
    font-size:13px;
    font-weight:850;
    transition:.2s ease;
}
.top-link:hover{
    transform:translateY(-1px);
    background:rgba(255,255,255,.06);
    color:white;
}
.box{
    width:100%;
    max-width:760px;
    border:1px solid var(--border);
    background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(8,11,18,.94));
    border-radius:28px;
    padding:34px;
    box-shadow:0 32px 80px rgba(0,0,0,.34);
    position:relative;
    overflow:hidden;
}
.box::before{
    content:"";
    position:absolute;
    right:-140px;
    top:-160px;
    width:360px;
    height:360px;
    border-radius:50%;
    background:radial-gradient(circle,rgba(245,158,11,.16),transparent 68%);
    pointer-events:none;
}
.inner{position:relative;z-index:1}
.badge-top{
    width:max-content;
    display:flex;
    align-items:center;
    gap:8px;
    border:1px solid rgba(245,158,11,.25);
    background:rgba(245,158,11,.10);
    color:#FBBF24;
    border-radius:999px;
    padding:8px 13px;
    font-size:12px;
    font-weight:800;
    margin-bottom:18px;
}
h1{
    font-family:'Outfit',sans-serif;
    font-size:clamp(34px,5vw,46px);
    line-height:1;
    letter-spacing:-1.5px;
    font-weight:900;
    margin:0 0 12px;
}
p{
    color:var(--muted);
    line-height:1.8;
    margin-bottom:24px;
}
.project-card{
    border:1px solid var(--border);
    background:rgba(255,255,255,.035);
    border-radius:18px;
    padding:18px;
    margin-bottom:22px;
}
.project-card strong{
    display:block;
    font-family:'Outfit',sans-serif;
    font-size:21px;
    margin-bottom:8px;
}
.project-card span{
    color:var(--muted);
    font-size:14px;
    line-height:1.7;
}
label{
    display:block;
    font-weight:800;
    margin-bottom:10px;
}
textarea{
    width:100%;
    min-height:180px;
    resize:vertical;
    border-radius:18px;
    border:1px solid var(--border);
    background:rgba(255,255,255,.045);
    color:white;
    padding:16px;
    outline:none;
    line-height:1.7;
}
textarea::placeholder{color:#64748B}
textarea:focus{
    border-color:rgba(59,130,246,.35);
    box-shadow:0 0 0 4px rgba(59,130,246,.08);
}
.actions{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
    margin-top:22px;
}
.btn-main,.btn-ghost{
    min-height:48px;
    border-radius:13px;
    padding:0 20px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:9px;
    text-decoration:none;
    border:none;
    font-weight:850;
    font-family:'Outfit',sans-serif;
    transition:.2s ease;
}
.btn-main{
    background:linear-gradient(135deg,var(--warn),#FBBF24);
    color:#111827;
}
.btn-main:hover{transform:translateY(-2px);box-shadow:0 18px 40px rgba(245,158,11,.22)}
.btn-ghost{
    border:1px solid var(--border);
    color:var(--text);
    background:rgba(255,255,255,.035);
}
.btn-ghost:hover{transform:translateY(-2px);background:rgba(255,255,255,.06);color:white}
.help{
    margin-top:10px;
    color:#64748B;
    font-size:13px;
    line-height:1.7;
    display:flex;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
}
.char-count{
    color:#94A3B8;
    font-weight:800;
}
.revision-meta{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:10px;
    margin:0 0 22px;
}
.meta-card{
    border:1px solid var(--border);
    background:rgba(255,255,255,.028);
    border-radius:16px;
    padding:13px;
}
.meta-card i{
    color:var(--cyan);
    margin-bottom:8px;
}
.meta-card strong{
    display:block;
    font-family:'Outfit',sans-serif;
    font-size:13px;
    margin-bottom:3px;
}
.meta-card span{
    display:block;
    color:var(--muted);
    font-size:12px;
    line-height:1.5;
}
@media(max-width:720px){
    .topbar{
        top:10px;
        width:calc(100% - 20px);
        display:grid;
    }
    .top-actions{
        display:grid;
        grid-template-columns:1fr 1fr;
    }
    .top-link{
        width:100%;
    }
    .page{
        padding-top:142px;
    }
    .box{
        padding:24px;
        border-radius:24px;
    }
    .revision-meta{
        grid-template-columns:1fr;
    }
    .actions{
        display:grid;
    }
}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<header class="topbar">
    <a href="viewMyProjects" class="top-brand">
        <i class="fa-solid fa-briefcase"></i>
        <span>Work</span><span>Sphere</span>
    </a>

    <div class="top-actions">
        <a href="viewMyProjects" class="top-link"><i class="fa-solid fa-arrow-left"></i> My Projects</a>
        <a href="clientDashboard" class="top-link"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
    </div>
</header>

<div class="page">
    <div class="box">
        <div class="inner">
            <div class="badge-top">
                <i class="fa-solid fa-rotate-left"></i>
                Revision Request
            </div>

            <h1>Request changes before completion.</h1>
            <p>Explain clearly what needs to be changed. The freelancer will receive this note and can resubmit the corrected work.</p>

            <div class="project-card">
                <strong><%= safe(project.getTitle()) %></strong>
                <span><%= safe(project.getDescription()) %></span>
            </div>

            <div class="revision-meta">
                <div class="meta-card">
                    <i class="fa-solid fa-bullseye"></i>
                    <strong>Be specific</strong>
                    <span>Mention the exact change needed.</span>
                </div>
                <div class="meta-card">
                    <i class="fa-solid fa-file-arrow-up"></i>
                    <strong>Resubmission</strong>
                    <span>Freelancer can upload corrected files.</span>
                </div>
                <div class="meta-card">
                    <i class="fa-solid fa-clock"></i>
                    <strong>Trackable</strong>
                    <span>The request is saved in project history.</span>
                </div>
            </div>

            <form action="requestRevision" method="post" id="revisionForm">
                <input type="hidden" name="projectId" value="<%= project.getId() %>">

                <label>Revision Message</label>
                <textarea name="revisionMessage"
                          id="revisionMessage"
                          maxlength="3000"
                          placeholder="Example: Please update the homepage layout, fix mobile spacing, replace the screenshots, and upload the corrected final ZIP file."
                          required></textarea>

                <div class="help">
                    <span>Keep the message specific so the freelancer knows exactly what to correct before resubmitting.</span>
                    <span class="char-count" id="revisionCharCount">0 / 3000</span>
                </div>

                <div class="actions">
                    <button type="submit" class="btn-main">
                        <i class="fa-solid fa-paper-plane"></i>
                        Send Revision Request
                    </button>

                    <a href="viewMyProjects" class="btn-ghost">
                        <i class="fa-solid fa-arrow-left"></i>
                        Back to Projects
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
(function(){
    var box = document.getElementById('revisionMessage');
    var count = document.getElementById('revisionCharCount');
    var form = document.getElementById('revisionForm');

    function updateCount(){
        if(count && box){
            count.textContent = box.value.length + ' / 3000';
        }
    }

    if(box){
        box.addEventListener('input', updateCount);
        updateCount();
    }

    if(form && box){
        form.addEventListener('submit', function(e){
            if(box.value.trim().length < 10){
                e.preventDefault();
                box.focus();

                if(window.dispatchEvent){
                    var evt = new CustomEvent('worksphereLocalWarning', {
                        detail: 'Please write a more specific revision message before sending.'
                    });
                    window.dispatchEvent(evt);
                }
            }
        });
    }
})();
</script>
</body>
</html>
