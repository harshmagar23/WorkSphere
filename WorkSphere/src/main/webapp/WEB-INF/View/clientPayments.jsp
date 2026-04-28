<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.PaymentModel" %>
<%@ page import="com.model.ProjectModel" %>
<%@ page import="com.model.ClientModel" %>

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

private double toDouble(Object value){
    if(value == null) return 0.0;
    if(value instanceof Number) return ((Number)value).doubleValue();
    try{return Double.parseDouble(value.toString());}catch(Exception e){return 0.0;}
}

private long toLong(Object value){
    if(value == null) return 0L;
    if(value instanceof Number) return ((Number)value).longValue();
    try{return Long.parseLong(value.toString());}catch(Exception e){return 0L;}
}

private String statusClass(String status){
    if(status == null) return "status-info";
    String s = status.toLowerCase();
    if(s.contains("unpaid")) return "status-warning";
    if(s.contains("escrow")) return "status-funded";
    if(s.contains("released")) return "status-success";
    if(s.contains("refund")) return "status-danger";
    if(s.contains("cancel")) return "status-muted";
    return "status-info";
}
%>

<%
ClientModel client = (ClientModel) session.getAttribute("clientSession");
if(client == null){
    response.sendRedirect("clientLogin");
    return;
}

List<PaymentModel> payments = (List<PaymentModel>) request.getAttribute("payments");

long totalPayments = toLong(request.getAttribute("totalPayments"));
long unpaidCount = toLong(request.getAttribute("unpaidCount"));
long fundedCount = toLong(request.getAttribute("fundedCount"));
long releasedCount = toLong(request.getAttribute("releasedCount"));
long refundedCount = toLong(request.getAttribute("refundedCount"));
long cancelledCount = toLong(request.getAttribute("cancelledCount"));

double totalPaid = 0;
double totalReleased = 0;
double totalFees = 0;

if(payments != null){
    for(PaymentModel payment : payments){
        if(payment == null) continue;
        String st = payment.getPaymentStatus();
        if("Escrow Funded".equalsIgnoreCase(st) || "Released".equalsIgnoreCase(st)){
            totalPaid += payment.getTotalAmount();
            totalFees += payment.getPlatformFee();
        }
        if("Released".equalsIgnoreCase(st)){
            totalReleased += payment.getFreelancerAmount();
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Payments | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --pri:#3B82F6;--cyan:#22D3EE;--violet:#8B5CF6;--bg:#07080D;--s1:#0B0D14;--s2:#10131D;
  --t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--border:rgba(255,255,255,.09);
  --green:#22C55E;--amber:#F59E0B;--red:#EF4444;--h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:1240px;
}
body{
  min-height:100vh;font-family:var(--b);color:var(--t1);background:
  radial-gradient(circle at 15% 8%,rgba(59,130,246,.22),transparent 34%),
  radial-gradient(circle at 85% 20%,rgba(34,211,238,.14),transparent 30%),
  linear-gradient(180deg,#07080D,#090B12 55%,#07080D);overflow-x:hidden;
}
body::after{content:"";position:fixed;inset:0;z-index:-1;background-image:linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);background-size:56px 56px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent)}
a{text-decoration:none;color:inherit}
button{font:inherit}
.wrap{max-width:var(--max);margin:0 auto;padding:0 28px}
.nav{position:fixed;top:0;left:0;right:0;z-index:1000;background:rgba(7,8,13,.76);backdrop-filter:blur(18px);-webkit-backdrop-filter:blur(18px);border-bottom:1px solid var(--border)}
.nav-in{height:68px;max-width:var(--max);margin:0 auto;padding:0 28px;display:flex;align-items:center;justify-content:space-between}
.logo{font-family:var(--h);font-size:20px;font-weight:900;letter-spacing:-.8px}.logo span:last-child{color:var(--pri)}
.nav-links{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.nav-a,.btn-main,.btn-ghost,.btn-danger{min-height:40px;border-radius:12px;padding:0 15px;display:inline-flex;align-items:center;justify-content:center;gap:8px;font-family:var(--h);font-size:13px;font-weight:850;border:1px solid var(--border);background:rgba(255,255,255,.03);color:var(--t2);transition:.2s;cursor:pointer}
.nav-a:hover,.btn-ghost:hover{color:white;background:rgba(255,255,255,.065);transform:translateY(-1px)}
.btn-main{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
.btn-main:hover{color:white;transform:translateY(-2px);box-shadow:0 18px 44px rgba(59,130,246,.24)}
.btn-danger{border:0;background:linear-gradient(135deg,#DC2626,#EF4444);color:white}
.btn-danger:hover{transform:translateY(-2px);box-shadow:0 18px 44px rgba(239,68,68,.22)}
.page{padding:112px 0 70px}
.hero{display:grid;grid-template-columns:1.05fr .95fr;gap:28px;align-items:stretch;margin-bottom:24px}
.hero-card,.stat-card,.pay-card,.empty-card{border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.86),rgba(8,11,18,.76));border-radius:30px;padding:30px;position:relative;overflow:hidden;box-shadow:0 30px 80px rgba(0,0,0,.24)}
.hero-card::before,.pay-card::before{content:"";position:absolute;right:-140px;top:-150px;width:340px;height:340px;border-radius:50%;background:radial-gradient(circle,rgba(59,130,246,.15),transparent 66%)}
.kicker{position:relative;display:inline-flex;align-items:center;gap:8px;border:1px solid rgba(34,211,238,.22);background:rgba(34,211,238,.08);color:#BAE6FD;border-radius:999px;padding:8px 13px;font-size:11px;font-weight:900;letter-spacing:1px;text-transform:uppercase;margin-bottom:18px}
h1{position:relative;font-family:var(--h);font-size:clamp(42px,5.8vw,76px);line-height:.94;letter-spacing:-3px;font-weight:900;margin-bottom:16px}
h1 em{font-style:normal;color:var(--t3);font-weight:300}
.hero-card p{position:relative;color:var(--t2);line-height:1.85;max-width:680px}
.stats-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:14px}
.stat-card{padding:22px;border-radius:24px}
.stat-card i{color:var(--cyan);margin-bottom:14px}
.stat-card small{display:block;color:var(--t3);font-size:11px;font-weight:900;letter-spacing:1px;text-transform:uppercase;margin-bottom:7px}
.stat-card strong{font-family:var(--h);font-size:30px;letter-spacing:-1px}
.summary-strip{display:grid;grid-template-columns:repeat(5,1fr);gap:1px;border:1px solid var(--border);background:var(--border);border-radius:24px;overflow:hidden;margin-bottom:26px}
.summary-strip div{background:rgba(11,13,20,.78);padding:18px}
.summary-strip b{display:block;font-family:var(--h);font-size:24px;margin-bottom:4px}
.summary-strip span{color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:.8px;font-weight:850}
.section-head{display:flex;justify-content:space-between;align-items:end;gap:16px;margin:34px 0 18px}
.section-head h2{font-family:var(--h);font-size:34px;letter-spacing:-1px}
.section-head p{color:var(--t3);font-size:13px;line-height:1.7;max-width:520px}
.pay-list{display:grid;gap:16px}
.pay-card{padding:24px;border-radius:26px}
.pay-top{position:relative;display:flex;justify-content:space-between;align-items:flex-start;gap:16px;margin-bottom:18px}
.pay-title h3{font-family:var(--h);font-size:22px;letter-spacing:-.5px;margin-bottom:8px}
.pay-title p{color:var(--t3);font-size:13px;line-height:1.6;margin:0}
.status{display:inline-flex;align-items:center;gap:7px;border-radius:999px;padding:8px 12px;font-family:var(--h);font-size:12px;font-weight:900;white-space:nowrap}
.status-warning{color:#FDE68A;background:rgba(245,158,11,.10);border:1px solid rgba(245,158,11,.24)}
.status-funded{color:#BAE6FD;background:rgba(34,211,238,.08);border:1px solid rgba(34,211,238,.20)}
.status-success{color:#BBF7D0;background:rgba(34,197,94,.10);border:1px solid rgba(34,197,94,.22)}
.status-danger{color:#FECACA;background:rgba(239,68,68,.10);border:1px solid rgba(239,68,68,.22)}
.status-muted{color:#CBD5E1;background:rgba(148,163,184,.08);border:1px solid rgba(148,163,184,.18)}
.status-info{color:#BFDBFE;background:rgba(59,130,246,.10);border:1px solid rgba(59,130,246,.20)}
.money-grid{position:relative;display:grid;grid-template-columns:repeat(4,1fr);gap:1px;border:1px solid var(--border);background:var(--border);border-radius:20px;overflow:hidden;margin-bottom:18px}
.money-grid div{background:rgba(7,8,13,.58);padding:16px}
.money-grid span{display:block;color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:.7px;font-weight:850;margin-bottom:6px}
.money-grid b{font-family:var(--h);font-size:20px}
.timeline{position:relative;display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin:18px 0}
.step{border:1px solid var(--border);background:rgba(255,255,255,.026);border-radius:15px;padding:12px;color:var(--t3);font-size:12px;line-height:1.5}
.step.active{border-color:rgba(34,211,238,.22);background:rgba(34,211,238,.07);color:#BAE6FD}
.actions{position:relative;display:flex;gap:10px;flex-wrap:wrap}
.refund-box{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.refund-input{min-height:40px;width:min(320px,100%);border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.045);color:white;outline:none;padding:0 12px}
.empty-card{text-align:center;padding:48px}
.empty-card i{font-size:42px;color:var(--cyan);margin-bottom:18px}
.empty-card h3{font-family:var(--h);font-size:28px;margin-bottom:10px}
.empty-card p{color:var(--t3);line-height:1.8;max-width:560px;margin:0 auto 20px}
@media(max-width:980px){.hero{grid-template-columns:1fr}.summary-strip{grid-template-columns:1fr 1fr}.money-grid,.timeline{grid-template-columns:1fr 1fr}.nav-links{display:none}}
@media(max-width:640px){.wrap,.nav-in{padding:0 18px}.hero-card,.pay-card{padding:22px;border-radius:22px}.summary-strip,.money-grid,.timeline{grid-template-columns:1fr}.pay-top{display:grid}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<nav class="nav">
  <div class="nav-in">
    <a href="clientDashboard" class="logo"><span>Work</span><span>Sphere</span></a>
    <div class="nav-links">
      <a href="clientDashboard" class="nav-a"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
      <a href="viewMyProjects" class="nav-a"><i class="fa-solid fa-briefcase"></i> My Projects</a>
      <a href="postProjectPage" class="btn-main"><i class="fa-solid fa-plus"></i> New Project</a>
    </div>
  </div>
</nav>

<main class="page">
  <div class="wrap">
    <section class="hero">
      <div class="hero-card">
        <div class="kicker"><i class="fa-solid fa-wallet"></i> Client Payment Center</div>
        <h1>Fund, track, and verify <em>mock escrow.</em></h1>
        <p>Manage unpaid project funding, escrow-funded work, released payments, refunded work, platform fees, and project payment receipts from one place.</p>
      </div>

      <div class="stats-grid">
        <div class="stat-card"><i class="fa-solid fa-receipt"></i><small>Total records</small><strong><%= totalPayments %></strong></div>
        <div class="stat-card"><i class="fa-solid fa-hourglass-half"></i><small>Unpaid</small><strong><%= unpaidCount %></strong></div>
        <div class="stat-card"><i class="fa-solid fa-vault"></i><small>Escrow funded</small><strong><%= fundedCount %></strong></div>
        <div class="stat-card"><i class="fa-solid fa-indian-rupee-sign"></i><small>Total paid</small><strong>₹<%= String.format("%.0f", totalPaid) %></strong></div>
      </div>
    </section>

    <div class="summary-strip">
      <div><b><%= releasedCount %></b><span>Released</span></div>
      <div><b><%= refundedCount %></b><span>Refunded</span></div>
      <div><b><%= cancelledCount %></b><span>Cancelled</span></div>
      <div><b>₹<%= String.format("%.0f", totalReleased) %></b><span>Freelancer payout</span></div>
      <div><b>₹<%= String.format("%.0f", totalFees) %></b><span>Platform fee</span></div>
    </div>

    <div class="section-head">
      <div>
        <h2>Payment history</h2>
        <p>Unpaid projects can be funded directly here. Escrow-funded projects can be refunded only before the freelancer submits work.</p>
      </div>
      <a href="viewMyProjects" class="btn-ghost"><i class="fa-solid fa-list-check"></i> Manage projects</a>
    </div>

    <% if(payments == null || payments.isEmpty()){ %>
      <div class="empty-card">
        <i class="fa-solid fa-wallet"></i>
        <h3>No payment records yet</h3>
        <p>Accept a freelancer bid first. WorkSphere will create a mock escrow payment record, then you can fund it from this page.</p>
        <a href="viewMyProjects" class="btn-main"><i class="fa-solid fa-briefcase"></i> View My Projects</a>
      </div>
    <% } else { %>
      <div class="pay-list">
        <% for(PaymentModel payment : payments){
            if(payment == null) continue;
            ProjectModel project = payment.getProject();
            String status = safe(payment.getPaymentStatus());
            String projectStatus = project == null ? "" : safe(project.getStatus());
            boolean canFund = "Unpaid".equalsIgnoreCase(status);
            boolean canRefund = "Escrow Funded".equalsIgnoreCase(status)
                    && project != null
                    && "In Progress".equalsIgnoreCase(project.getStatus())
                    && (project.getSubmissionStoredFileName() == null || project.getSubmissionStoredFileName().trim().isEmpty());
        %>
          <article class="pay-card">
            <div class="pay-top">
              <div class="pay-title">
                <h3><%= project == null ? "Project payment" : safe(project.getTitle()) %></h3>
                <p>Payment #<%= payment.getId() %> · Project status: <%= projectStatus.length() == 0 ? "Not Available" : projectStatus %> · Transaction: <%= safe(payment.getTransactionId()).length() == 0 ? "Not generated yet" : safe(payment.getTransactionId()) %></p>
              </div>
              <span class="status <%= statusClass(status) %>"><i class="fa-solid fa-circle"></i> <%= status %></span>
            </div>

            <div class="money-grid">
              <div><span>Bid amount</span><b>₹<%= String.format("%.0f", payment.getBidAmount()) %></b></div>
              <div><span>Platform fee</span><b>₹<%= String.format("%.0f", payment.getPlatformFee()) %></b></div>
              <div><span>Total paid</span><b>₹<%= String.format("%.0f", payment.getTotalAmount()) %></b></div>
              <div><span>Freelancer receives</span><b>₹<%= String.format("%.0f", payment.getFreelancerAmount()) %></b></div>
            </div>

            <div class="timeline">
              <div class="step <%= "Unpaid".equalsIgnoreCase(status) || "Escrow Funded".equalsIgnoreCase(status) || "Released".equalsIgnoreCase(status) ? "active" : "" %>"><strong>1.</strong> Created<br><%= safe(payment.getCreatedAt()) %></div>
              <div class="step <%= "Escrow Funded".equalsIgnoreCase(status) || "Released".equalsIgnoreCase(status) ? "active" : "" %>"><strong>2.</strong> Funded<br><%= safe(payment.getPaidAt()) %></div>
              <div class="step <%= "Released".equalsIgnoreCase(status) ? "active" : "" %>"><strong>3.</strong> Released<br><%= safe(payment.getReleasedAt()) %></div>
              <div class="step <%= "Refunded".equalsIgnoreCase(status) || "Cancelled".equalsIgnoreCase(status) ? "active" : "" %>"><strong>4.</strong> Refund/Cancel<br><%= safe(payment.getRefundedAt()) %></div>
            </div>

            <div class="actions">
              <% if(canFund && project != null){ %>
                <form action="fundProject" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= project.getId() %>">
                  <button type="submit" class="btn-main" onclick="return confirm('Fund this project with mock escrow?');"><i class="fa-solid fa-wallet"></i> Fund Project</button>
                </form>
              <% } %>

              <% if(canRefund && project != null){ %>
                <form action="refundProject" method="post" class="refund-box" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= project.getId() %>">
                  <input type="text" name="refundReason" class="refund-input" placeholder="Optional refund reason">
                  <button type="submit" class="btn-danger" onclick="return confirm('Refund escrow and cancel this project before work submission?');"><i class="fa-solid fa-rotate-left"></i> Refund</button>
                </form>
              <% } %>

              <% if(canFund && project != null){ %>
                <form action="cancelProject" method="post" style="margin:0;">
                  <input type="hidden" name="projectId" value="<%= project.getId() %>">
                  <input type="hidden" name="cancellationReason" value="Cancelled from payment center before escrow funding">
                  <button type="submit" class="btn-ghost" onclick="return confirm('Cancel this unpaid project?');"><i class="fa-solid fa-ban"></i> Cancel Unpaid</button>
                </form>
              <% } %>

              <a href="paymentReceipt?paymentId=<%= payment.getId() %>" class="btn-ghost"><i class="fa-solid fa-file-invoice"></i> View Receipt</a>
            </div>
          </article>
        <% } %>
      </div>
    <% } %>
  </div>
</main>
</body>
</html>
