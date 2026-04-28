<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String role = request.getParameter("role");
String pageTitle = request.getParameter("pageTitle");
String crumbParent = request.getParameter("crumbParent");
String crumbParentLink = request.getParameter("crumbParentLink");

if(role == null) role = "guest";
if(pageTitle == null) pageTitle = "Page";
if(crumbParent == null) crumbParent = "Dashboard";
if(crumbParentLink == null) crumbParentLink = "#";

String accent = "#1DBF73";
String accentSoft = "#eafaf2";
String accentBorder = "rgba(29,191,115,0.18)";
String accentDark = "#169c5f";
String dashboardLink = "clientDashboard";
String secondLink = "viewMyProjects";
String secondLabel = "My Projects";
String thirdLink = "postProjectPage";
String thirdLabel = "Post Project";
String notificationLink = "clientNotifications";
String logoutLink = "logout";

if("freelancer".equalsIgnoreCase(role)){
    accent = "#1DBF73";
    accentSoft = "#eafaf2";
    accentBorder = "rgba(29,191,115,0.18)";
    accentDark = "#169c5f";
    dashboardLink = "freelancerDashboard";
    secondLink = "viewAllProjects";
    secondLabel = "Explore Projects";
    thirdLink = "myProposals";
    thirdLabel = "My Proposals";
    notificationLink = "freelancerNotifications";
    logoutLink = "freelancerLogout";
}
%>

<style>
.ws-shell{
    max-width:1320px;
    margin:0 auto;
    padding:0 20px;
}

.ws-topbar{
    position:sticky;
    top:0;
    z-index:1100;
    background:rgba(255,255,255,0.92);
    backdrop-filter:blur(14px);
    -webkit-backdrop-filter:blur(14px);
    border-bottom:1px solid rgba(18,23,34,0.08);
    box-shadow:0 8px 24px rgba(15,23,42,0.06);
}

.ws-nav-wrap{
    padding:16px 0;
}

.ws-nav{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:20px;
    flex-wrap:wrap;
}

.ws-nav-left,
.ws-nav-right{
    display:flex;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
}

.ws-brand{
    text-decoration:none;
    display:flex;
    align-items:center;
    gap:10px;
    margin-right:8px;
}

.ws-brand-mark{
    width:42px;
    height:42px;
    border-radius:14px;
    background:linear-gradient(135deg, <%= accent %>, #57d89a);
    color:#ffffff;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:18px;
    font-weight:800;
    box-shadow:0 10px 24px rgba(29,191,115,0.24);
    flex-shrink:0;
}

.ws-brand-text{
    font-size:28px;
    font-weight:800;
    letter-spacing:-0.4px;
    color:#161b22;
    line-height:1;
}

.ws-brand-text span{
    color:<%= accent %>;
}

.ws-link{
    text-decoration:none;
    color:#3c4655;
    padding:10px 16px;
    border-radius:999px;
    font-weight:600;
    border:1px solid transparent;
    background:transparent;
    transition:all 0.25s ease;
}

.ws-link:hover{
    color:#111827;
    background:#f3f6f9;
    border-color:#eef2f6;
    transform:translateY(-1px);
}

.ws-link-active{
    text-decoration:none;
    color:<%= accent %>;
    background:<%= accentSoft %>;
    border:1px solid <%= accentBorder %>;
    padding:10px 16px;
    border-radius:999px;
    font-weight:700;
    transition:all 0.25s ease;
}

.ws-link-active:hover{
    color:<%= accentDark %>;
    background:#dff6e9;
}

.ws-link-outline{
    text-decoration:none;
    color:#ffffff;
    padding:10px 18px;
    border-radius:999px;
    font-weight:700;
    background:linear-gradient(135deg, <%= accent %>, #57d89a);
    border:none;
    box-shadow:0 10px 22px rgba(29,191,115,0.22);
    transition:all 0.25s ease;
}

.ws-link-outline:hover{
    color:#ffffff;
    transform:translateY(-1px);
    box-shadow:0 14px 28px rgba(29,191,115,0.28);
}

.ws-breadcrumb-wrap{
    padding:22px 0 10px;
}

.ws-breadcrumb-card{
    background:#ffffff;
    border:1px solid rgba(18,23,34,0.07);
    border-radius:24px;
    padding:22px 24px;
    box-shadow:0 14px 36px rgba(15,23,42,0.06);
    position:relative;
    overflow:hidden;
}

.ws-breadcrumb-card::before{
    content:"";
    position:absolute;
    top:0;
    left:0;
    width:100%;
    height:5px;
    background:linear-gradient(90deg, <%= accent %>, #57d89a);
}

.ws-breadcrumb-title{
    font-size:30px;
    font-weight:800;
    color:#181d25;
    margin-bottom:8px;
    letter-spacing:-0.4px;
}

.ws-breadcrumb{
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
    color:#7b8794;
    font-size:14px;
    font-weight:500;
}

.ws-breadcrumb a{
    color:<%= accent %>;
    text-decoration:none;
    font-weight:700;
}

.ws-breadcrumb a:hover{
    color:<%= accentDark %>;
    text-decoration:underline;
}

.ws-shortcuts{
    padding:10px 0 0;
}

.ws-shortcuts-card{
    background:#ffffff;
    border:1px solid rgba(18,23,34,0.07);
    border-radius:22px;
    padding:16px 18px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:14px;
    flex-wrap:wrap;
    box-shadow:0 12px 30px rgba(15,23,42,0.05);
}

.ws-shortcuts-title{
    color:#1b2330;
    font-weight:800;
    font-size:15px;
    margin:0;
}

.ws-shortcuts-links{
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
}

.ws-chip{
    text-decoration:none;
    color:#334155;
    background:#f8fafc;
    border:1px solid #edf2f7;
    padding:9px 14px;
    border-radius:999px;
    font-size:14px;
    font-weight:600;
    transition:all 0.25s ease;
}

.ws-chip:hover{
    background:<%= accentSoft %>;
    border-color:<%= accentBorder %>;
    color:<%= accentDark %>;
    transform:translateY(-1px);
}

@media(max-width:991px){
    .ws-nav{
        align-items:flex-start;
    }

    .ws-brand-text{
        font-size:24px;
    }

    .ws-breadcrumb-title{
        font-size:26px;
    }
}

@media(max-width:768px){
    .ws-shell{
        padding:0 14px;
    }

    .ws-nav-wrap{
        padding:14px 0;
    }

    .ws-nav-left,
    .ws-nav-right{
        gap:8px;
    }

    .ws-link,
    .ws-link-active,
    .ws-link-outline,
    .ws-chip{
        font-size:13px;
        padding:9px 13px;
    }

    .ws-breadcrumb-card{
        padding:18px;
    }

    .ws-breadcrumb-title{
        font-size:22px;
    }
}
</style>

<div class="ws-topbar">
    <div class="ws-shell">
        <div class="ws-nav-wrap">
            <div class="ws-nav">
                <div class="ws-nav-left">
                    <a href="<%= dashboardLink %>" class="ws-brand">
                        <div class="ws-brand-mark">W</div>
                        <div class="ws-brand-text">Work<span>Sphere</span></div>
                    </a>

                    <a href="<%= dashboardLink %>" class="ws-link-active">Dashboard</a>
                    <a href="<%= secondLink %>" class="ws-link"><%= secondLabel %></a>
                    <a href="<%= thirdLink %>" class="ws-link"><%= thirdLabel %></a>
                    <a href="<%= notificationLink %>" class="ws-link">Notifications</a>
                </div>

                <div class="ws-nav-right">
                    <a href="<%= logoutLink %>" class="ws-link-outline">Logout</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="ws-shell">
    <div class="ws-breadcrumb-wrap">
        <div class="ws-breadcrumb-card">
            <div class="ws-breadcrumb-title"><%= pageTitle %></div>
            <div class="ws-breadcrumb">
                <a href="index.jsp">Home</a>
                <span>/</span>
                <a href="<%= crumbParentLink %>"><%= crumbParent %></a>
                <span>/</span>
                <span><%= pageTitle %></span>
            </div>
        </div>
    </div>

    <div class="ws-shortcuts">
        <div class="ws-shortcuts-card">
            <p class="ws-shortcuts-title">Quick Navigation</p>

            <div class="ws-shortcuts-links">
                <a href="<%= dashboardLink %>" class="ws-chip">Dashboard</a>
                <a href="<%= secondLink %>" class="ws-chip"><%= secondLabel %></a>
                <a href="<%= thirdLink %>" class="ws-chip"><%= thirdLabel %></a>
                <a href="<%= notificationLink %>" class="ws-chip">Notifications</a>
            </div>
        </div>
    </div>
</div>