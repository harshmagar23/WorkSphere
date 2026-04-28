<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.ChatMessageModel" %>

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

private String firstLetter(Object value){
    String text = safe(value).trim();
    if(text.length() == 0) return "U";
    return text.substring(0,1).toUpperCase();
}
%>

<%
ProjectModel project = (ProjectModel) request.getAttribute("project");
List<ChatMessageModel> messages = (List<ChatMessageModel>) request.getAttribute("messages");
String currentUserType = (String) request.getAttribute("currentUserType");
Integer currentUserIdObj = (Integer) request.getAttribute("currentUserId");
String currentUserName = (String) request.getAttribute("currentUserName");
String backLink = (String) request.getAttribute("backLink");

int currentUserId = currentUserIdObj == null ? 0 : currentUserIdObj.intValue();
if(project == null){
    response.sendRedirect("clientLogin");
    return;
}
if(backLink == null || backLink.trim().length() == 0){
    backLink = "clientDashboard";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Project Chat | WorkSphere</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
    --pri:#3B82F6;
    --cyan:#22D3EE;
    --violet:#8B5CF6;
    --bg:#07080D;
    --s1:#0B0D14;
    --s2:#10131D;
    --s3:#171B28;
    --text:#F8FAFC;
    --muted:#94A3B8;
    --muted2:#64748B;
    --border:rgba(255,255,255,.09);
    --border2:rgba(255,255,255,.05);
    --ok:#22C55E;
    --warn:#F59E0B;
    --h:'Outfit',sans-serif;
    --b:'Inter',sans-serif;
}
html{scroll-behavior:smooth}
body{
    min-height:100vh;
    font-family:var(--b);
    color:var(--text);
    background:
        radial-gradient(circle at 12% 8%,rgba(59,130,246,.24),transparent 33%),
        radial-gradient(circle at 88% 20%,rgba(34,211,238,.13),transparent 32%),
        radial-gradient(circle at 50% 100%,rgba(139,92,246,.11),transparent 34%),
        linear-gradient(180deg,#07080D,#090B12 52%,#07080D);
    overflow-x:hidden;
}
body::after{
    content:"";
    position:fixed;
    inset:0;
    pointer-events:none;
    background-image:
        linear-gradient(rgba(255,255,255,.025) 1px,transparent 1px),
        linear-gradient(90deg,rgba(255,255,255,.025) 1px,transparent 1px);
    background-size:54px 54px;
    mask-image:linear-gradient(to bottom,rgba(0,0,0,.9),rgba(0,0,0,.16),transparent);
    -webkit-mask-image:linear-gradient(to bottom,rgba(0,0,0,.9),rgba(0,0,0,.16),transparent);
    z-index:-1;
}
a{text-decoration:none;color:inherit}
.wrap{max-width:1180px;margin:0 auto;padding:0 26px}

.nav{
    height:72px;
    border-bottom:1px solid var(--border);
    background:rgba(7,8,13,.74);
    backdrop-filter:blur(18px);
    -webkit-backdrop-filter:blur(18px);
    display:flex;
    align-items:center;
    position:sticky;
    top:0;
    z-index:20;
}
.nav-in{width:100%;max-width:1180px;margin:0 auto;padding:0 26px;display:flex;align-items:center;justify-content:space-between;gap:16px}
.logo{font-family:var(--h);font-weight:900;font-size:20px;letter-spacing:-.7px}.logo span{color:var(--pri)}
.nav-actions{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
.btn-ghost,.btn-main{
    height:42px;
    border-radius:12px;
    padding:0 16px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:8px;
    font-family:var(--h);
    font-weight:800;
    font-size:13px;
    border:1px solid var(--border);
}
.btn-ghost{background:rgba(255,255,255,.03);color:var(--muted)}
.btn-ghost:hover{color:white;background:rgba(255,255,255,.06)}
.btn-main{background:linear-gradient(135deg,var(--pri),var(--cyan));color:white;border:0}

.page{padding:34px 0 48px}
.chat-shell{
    display:grid;
    grid-template-columns:340px 1fr;
    gap:18px;
    align-items:start;
}
.side-card,.chat-card{
    border:1px solid var(--border);
    background:linear-gradient(145deg,rgba(16,19,29,.92),rgba(8,11,18,.92));
    border-radius:26px;
    overflow:hidden;
    box-shadow:0 28px 80px rgba(0,0,0,.24);
}
.side-card{padding:24px;position:sticky;top:96px}
.kicker{
    width:max-content;
    padding:7px 12px;
    border-radius:999px;
    border:1px solid rgba(34,211,238,.2);
    background:rgba(34,211,238,.08);
    color:var(--cyan);
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:1px;
    font-weight:900;
    margin-bottom:18px;
}
.project-title{font-family:var(--h);font-size:28px;line-height:1.05;font-weight:900;letter-spacing:-1px;margin-bottom:12px}
.project-desc{color:var(--muted);font-size:13.5px;line-height:1.75;margin-bottom:18px}
.meta-list{display:grid;gap:10px;margin-top:16px}
.meta{
    border:1px solid var(--border2);
    background:rgba(255,255,255,.03);
    border-radius:16px;
    padding:13px 14px;
    color:var(--muted);
    font-size:13px;
    line-height:1.5;
}
.meta i{color:var(--cyan);margin-right:8px}
.meta strong{display:block;color:white;font-family:var(--h);font-size:13.5px;margin-bottom:3px}

.chat-card{min-height:calc(100vh - 128px);display:flex;flex-direction:column}
.chat-head{
    padding:20px 22px;
    border-bottom:1px solid var(--border);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:14px;
    background:rgba(255,255,255,.02);
}
.peer{display:flex;align-items:center;gap:12px}
.avatar{
    width:46px;
    height:46px;
    border-radius:16px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:linear-gradient(135deg,var(--pri),var(--cyan));
    color:white;
    font-family:var(--h);
    font-weight:900;
    box-shadow:0 12px 34px rgba(59,130,246,.25);
}
.peer h3{font-family:var(--h);font-size:18px;font-weight:900;margin:0;letter-spacing:-.4px}
.peer span{display:block;color:var(--muted2);font-size:12.5px;margin-top:3px}
.status-dot{display:inline-flex;align-items:center;gap:7px;color:var(--ok);font-size:12px;font-weight:800}
.status-dot::before{content:"";width:8px;height:8px;border-radius:50%;background:var(--ok);box-shadow:0 0 0 5px rgba(34,197,94,.10)}

.messages{
    padding:24px;
    flex:1;
    overflow:auto;
    display:flex;
    flex-direction:column;
    gap:14px;
    min-height:430px;
    max-height:calc(100vh - 260px);
}
.day-note{
    align-self:center;
    color:var(--muted2);
    font-size:11px;
    font-weight:800;
    border:1px solid var(--border2);
    background:rgba(255,255,255,.025);
    border-radius:999px;
    padding:7px 12px;
    margin-bottom:4px;
}
.msg-row{display:flex;gap:10px;align-items:flex-end;max-width:78%}
.msg-row.mine{align-self:flex-end;flex-direction:row-reverse}
.msg-row.other{align-self:flex-start}
.msg-avatar{
    width:34px;
    height:34px;
    border-radius:13px;
    display:flex;
    align-items:center;
    justify-content:center;
    flex-shrink:0;
    background:rgba(255,255,255,.06);
    border:1px solid var(--border);
    color:var(--muted);
    font-family:var(--h);
    font-weight:900;
    font-size:13px;
}
.msg-row.mine .msg-avatar{background:rgba(59,130,246,.14);color:#BFDBFE;border-color:rgba(59,130,246,.22)}
.bubble{
    border:1px solid var(--border);
    background:rgba(255,255,255,.04);
    border-radius:20px 20px 20px 6px;
    padding:12px 14px;
    color:#DCE6F5;
    line-height:1.65;
    font-size:14px;
    white-space:pre-wrap;
    word-break:break-word;
}
.msg-row.mine .bubble{
    background:linear-gradient(135deg,rgba(59,130,246,.95),rgba(34,211,238,.85));
    color:white;
    border-color:transparent;
    border-radius:20px 20px 6px 20px;
}
.msg-meta{display:flex;gap:8px;align-items:center;margin-top:6px;color:var(--muted2);font-size:11.5px;font-weight:700}
.msg-row.mine .msg-meta{justify-content:flex-end;color:rgba(255,255,255,.75)}
.empty-chat{
    margin:auto;
    text-align:center;
    max-width:420px;
    padding:42px 20px;
    color:var(--muted);
}
.empty-chat i{
    width:72px;
    height:72px;
    border-radius:24px;
    background:rgba(59,130,246,.10);
    border:1px solid rgba(59,130,246,.18);
    color:var(--cyan);
    display:flex;
    align-items:center;
    justify-content:center;
    margin:0 auto 18px;
    font-size:28px;
}
.empty-chat h4{font-family:var(--h);font-weight:900;color:white;margin-bottom:9px}
.empty-chat p{line-height:1.7;font-size:14px}

.composer{
    padding:18px;
    border-top:1px solid var(--border);
    background:rgba(7,8,13,.7);
}
.composer form{display:grid;grid-template-columns:1fr auto;gap:12px;align-items:end}
textarea{
    width:100%;
    min-height:58px;
    max-height:170px;
    resize:vertical;
    border-radius:18px;
    border:1px solid var(--border);
    background:rgba(255,255,255,.045);
    color:white;
    outline:none;
    padding:14px 16px;
    line-height:1.55;
    font-family:var(--b);
}
textarea::placeholder{color:var(--muted2)}
textarea:focus{border-color:rgba(59,130,246,.4);box-shadow:0 0 0 4px rgba(59,130,246,.08)}
.send-btn{
    height:58px;
    min-width:132px;
    border:none;
    border-radius:18px;
    background:linear-gradient(135deg,var(--pri),var(--cyan));
    color:white;
    font-family:var(--h);
    font-weight:900;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:9px;
    box-shadow:0 18px 40px rgba(59,130,246,.22);
}
.send-btn:hover{transform:translateY(-1px)}
.help-text{color:var(--muted2);font-size:12px;margin-top:10px;line-height:1.6;display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap}
.chat-shortcuts{display:grid;gap:10px;margin-top:18px}
.shortcut-link{border:1px solid var(--border2);background:rgba(255,255,255,.028);border-radius:15px;padding:12px 13px;color:var(--muted);font-family:var(--h);font-size:13px;font-weight:850;display:flex;align-items:center;justify-content:space-between;gap:12px;transition:all .2s}
.shortcut-link:hover{color:white;background:rgba(255,255,255,.055);border-color:rgba(59,130,246,.22);transform:translateX(3px)}
.shortcut-link i{color:var(--cyan)}
.char-live{color:var(--muted2);font-weight:800}

@media(max-width:980px){
    .chat-shell{grid-template-columns:1fr}
    .side-card{position:relative;top:auto}
    .messages{max-height:none;min-height:420px}
}
@media(max-width:640px){
    .wrap,.nav-in{padding:0 18px}
    .nav{height:auto;min-height:72px;padding:12px 0}
    .nav-in{display:grid;gap:10px}
    .nav-actions{justify-content:flex-start}
    .chat-head{display:grid}
    .msg-row{max-width:94%}
    .composer form{grid-template-columns:1fr}
    .send-btn{width:100%}
}
</style>
</head>

<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<nav class="nav">
    <div class="nav-in">
        <a href="<%= safe(backLink) %>" class="logo">Work<span>Sphere</span></a>
        <div class="nav-actions">
            <a href="<%= safe(backLink) %>" class="btn-ghost"><i class="fa-solid fa-arrow-left"></i> Back</a>
            <% if("CLIENT".equalsIgnoreCase(currentUserType)){ %>
                <a href="clientDashboard" class="btn-ghost"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
            <% } else { %>
                <a href="freelancerDashboard" class="btn-ghost"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="page">
    <div class="wrap chat-shell">
        <aside class="side-card">
            <div class="kicker"><i class="fa-regular fa-comments"></i> Project Chat</div>
            <h1 class="project-title"><%= safe(project.getTitle()) %></h1>
            <p class="project-desc"><%= safe(project.getDescription()) %></p>

            <div class="meta-list">
                <div class="meta">
                    <strong><i class="fa-solid fa-circle-info"></i> Project Status</strong>
                    <%= safe(project.getStatus()) %>
                </div>
                <div class="meta">
                    <strong><i class="fa-solid fa-indian-rupee-sign"></i> Budget</strong>
                    ₹<%= safe(project.getBudget()) %>
                </div>
                <div class="meta">
                    <strong><i class="fa-regular fa-calendar"></i> Deadline</strong>
                    <%= safe(project.getDeadline()) %>
                </div>
                <div class="meta">
                    <strong><i class="fa-regular fa-user"></i> You are messaging as</strong>
                    <%= safe(currentUserName) %> — <%= safe(currentUserType) %>
                </div>
            </div>

            <div class="chat-shortcuts">
                <% if("CLIENT".equalsIgnoreCase(currentUserType)){ %>
                    <a href="viewMyProjects" class="shortcut-link"><span><i class="fa-solid fa-folder-open"></i> My Projects</span><i class="fa-solid fa-arrow-right"></i></a>
                    <a href="clientNotifications" class="shortcut-link"><span><i class="fa-regular fa-bell"></i> Notifications</span><i class="fa-solid fa-arrow-right"></i></a>
                <% } else { %>
                    <a href="freelancerAssignedProjects" class="shortcut-link"><span><i class="fa-solid fa-diagram-project"></i> Assigned Projects</span><i class="fa-solid fa-arrow-right"></i></a>
                    <a href="myProposals" class="shortcut-link"><span><i class="fa-solid fa-file-signature"></i> My Proposals</span><i class="fa-solid fa-arrow-right"></i></a>
                <% } %>
            </div>
        </aside>

        <section class="chat-card">
            <div class="chat-head">
                <div class="peer">
                    <div class="avatar"><%= firstLetter(currentUserName) %></div>
                    <div>
                        <h3>Project conversation</h3>
                        <span>Messages are saved under project #<%= project.getId() %></span>
                    </div>
                </div>
                <div class="status-dot">Secure project thread</div>
            </div>

            <div class="messages" id="messages">
                <div class="day-note">Project chat history</div>

                <%
                if(messages != null && !messages.isEmpty()){
                    for(ChatMessageModel msg : messages){
                        if(msg == null) continue;
                        boolean mine = currentUserType != null
                            && currentUserType.equalsIgnoreCase(msg.getSenderType())
                            && currentUserId == msg.getSenderId();
                %>
                <div class="msg-row <%= mine ? "mine" : "other" %>">
                    <div class="msg-avatar"><%= firstLetter(msg.getSenderName()) %></div>
                    <div>
                        <div class="bubble"><%= safe(msg.getMessage()) %></div>
                        <div class="msg-meta">
                            <span><%= mine ? "You" : safe(msg.getSenderName()) %></span>
                            <span>•</span>
                            <span><%= safe(msg.getCreatedAt()) %></span>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="empty-chat">
                    <i class="fa-regular fa-comments"></i>
                    <h4>No messages yet</h4>
                    <p>Start the project discussion here. Use this space for scope clarification, progress updates, file questions, and revision communication.</p>
                </div>
                <%
                }
                %>
            </div>

            <div class="composer">
                <form action="sendProjectMessage" method="post" id="chatForm">
                    <input type="hidden" name="projectId" value="<%= project.getId() %>">
                    <textarea name="message" id="messageBox" placeholder="Write your message about this project..." maxlength="3000" required></textarea>
                    <button type="submit" class="send-btn"><i class="fa-solid fa-paper-plane"></i> Send</button>
                </form>
                <div class="help-text">
                    <span>Tip: Keep messages professional and specific. For final files, continue using Submit Work so files are stored safely.</span>
                    <span class="char-live" id="charLive">0 / 3000</span>
                </div>
            </div>
        </section>
    </div>
</main>

<script>
(function(){
    const messages = document.getElementById('messages');
    const box = document.getElementById('messageBox');
    const form = document.getElementById('chatForm');

    if(messages){
        messages.scrollTop = messages.scrollHeight;
    }

    const counter = document.getElementById('charLive');

    function updateCounter(){
        if(counter && box){
            counter.textContent = box.value.length + ' / 3000';
        }
    }

    if(box){
        box.focus();
        updateCounter();
        box.addEventListener('input', updateCounter);
        box.addEventListener('keydown', function(e){
            if(e.key === 'Enter' && !e.shiftKey){
                e.preventDefault();
                if(form && box.value.trim().length > 0){
                    form.submit();
                }
            }
        });
    }
})();
</script>
</body>
</html>
