<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.PaymentModel" %>
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
PaymentModel payment = (PaymentModel) request.getAttribute("payment");
String backLink = (String) request.getAttribute("backLink");

if(payment == null){
    response.sendRedirect("clientPayments");
    return;
}

if(backLink == null || backLink.trim().isEmpty()){
    backLink = "clientPayments";
}

ProjectModel project = payment.getProject();
String status = safe(payment.getPaymentStatus());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment Receipt | WorkSphere</title>

<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--pri:#3B82F6;--cyan:#22D3EE;--bg:#07080D;--s2:#10131D;--t1:#F8FAFC;--t2:#B6C2D3;--t3:#7D8AA0;--border:rgba(255,255,255,.09);--h:'Outfit',sans-serif;--b:'Inter',sans-serif;--max:960px}
body{min-height:100vh;font-family:var(--b);color:var(--t1);background:radial-gradient(circle at 18% 8%,rgba(59,130,246,.22),transparent 34%),radial-gradient(circle at 86% 24%,rgba(34,211,238,.13),transparent 32%),linear-gradient(180deg,#07080D,#090B12 48%,#07080D);padding:86px 20px 42px}
body::after{content:"";position:fixed;inset:0;z-index:-1;background-image:linear-gradient(rgba(255,255,255,.024) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.024) 1px,transparent 1px);background-size:56px 56px;mask-image:linear-gradient(to bottom,rgba(0,0,0,.82),rgba(0,0,0,.22),transparent)}
a{text-decoration:none;color:inherit}.receipt{max-width:var(--max);margin:0 auto;border:1px solid var(--border);background:linear-gradient(145deg,rgba(16,19,29,.94),rgba(8,11,18,.88));border-radius:32px;overflow:hidden;box-shadow:0 34px 90px rgba(0,0,0,.34)}
.top{padding:30px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:flex-start;gap:22px;flex-wrap:wrap}.brand{font-family:var(--h);font-size:26px;font-weight:900;letter-spacing:-1px}.brand span{color:var(--pri)}.tag{display:inline-flex;align-items:center;gap:8px;border:1px solid rgba(34,211,238,.22);background:rgba(34,211,238,.08);color:#BAE6FD;border-radius:999px;padding:8px 13px;font-size:11px;font-weight:900;letter-spacing:1px;text-transform:uppercase;margin-top:10px}.top-right{text-align:right}.top-right h1{font-family:var(--h);font-size:34px;letter-spacing:-1px;margin-bottom:6px}.top-right p{color:var(--t3);font-size:13px}.body{padding:30px}.project-title{font-family:var(--h);font-size:28px;letter-spacing:-.8px;margin-bottom:10px}.muted{color:var(--t3);line-height:1.7}.grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin:24px 0}.box{border:1px solid var(--border);background:rgba(255,255,255,.03);border-radius:18px;padding:18px}.box span{display:block;color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:.8px;font-weight:900;margin-bottom:7px}.box strong{font-family:var(--h);font-size:20px}.money{display:grid;grid-template-columns:repeat(4,1fr);gap:1px;border:1px solid var(--border);background:var(--border);border-radius:20px;overflow:hidden;margin:24px 0}.money div{background:rgba(7,8,13,.62);padding:18px}.money span{display:block;color:var(--t3);font-size:11px;text-transform:uppercase;letter-spacing:.8px;font-weight:900;margin-bottom:7px}.money strong{font-family:var(--h);font-size:22px}.footer{padding:22px 30px;border-top:1px solid var(--border);display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap}.btn{min-height:42px;border-radius:12px;padding:0 16px;display:inline-flex;align-items:center;gap:8px;font-family:var(--h);font-size:13px;font-weight:850;border:1px solid var(--border);background:rgba(255,255,255,.035);color:var(--t2);transition:.2s}.btn:hover{color:white;transform:translateY(-1px)}.btn.print{border:0;background:linear-gradient(135deg,var(--pri),var(--cyan));color:white}
@media(max-width:720px){.grid,.money{grid-template-columns:1fr}.top-right{text-align:left}.receipt{border-radius:24px}}
@media print{body{background:white;color:#111;padding:0}.receipt{box-shadow:none;border:1px solid #ddd}.btn{display:none}.muted,.box span,.money span{color:#444}.body,.top,.footer{background:white}.box,.money div{background:white}}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/View/includes/flashMessages.jsp" />

<section class="receipt">
  <div class="top">
    <div>
      <div class="brand">Work<span>Sphere</span></div>
      <div class="tag"><i class="fa-solid fa-file-invoice"></i> Mock Escrow Receipt</div>
    </div>
    <div class="top-right">
      <h1>Receipt #<%= payment.getId() %></h1>
      <p>Status: <%= status %></p>
    </div>
  </div>

  <div class="body">
    <h2 class="project-title"><%= project == null ? "Project payment" : safe(project.getTitle()) %></h2>
    <p class="muted">This receipt documents the mock escrow transaction inside WorkSphere. It is for project/demo accounting and is not a real bank payment document.</p>

    <div class="grid">
      <div class="box"><span>Transaction ID</span><strong><%= safe(payment.getTransactionId()).length() == 0 ? "Not generated" : safe(payment.getTransactionId()) %></strong></div>
      <div class="box"><span>Payment method</span><strong><%= safe(payment.getPaymentMethod()).length() == 0 ? "Not funded yet" : safe(payment.getPaymentMethod()) %></strong></div>
      <div class="box"><span>Client</span><strong><%= payment.getClient() == null ? "N/A" : safe(payment.getClient().getName()) %></strong></div>
      <div class="box"><span>Freelancer</span><strong><%= payment.getFreelancer() == null ? "N/A" : safe(payment.getFreelancer().getName()) %></strong></div>
      <div class="box"><span>Created at</span><strong><%= safe(payment.getCreatedAt()) %></strong></div>
      <div class="box"><span>Funded at</span><strong><%= safe(payment.getPaidAt()) %></strong></div>
      <div class="box"><span>Released at</span><strong><%= safe(payment.getReleasedAt()) %></strong></div>
      <div class="box"><span>Refunded at</span><strong><%= safe(payment.getRefundedAt()) %></strong></div>
    </div>

    <div class="money">
      <div><span>Bid amount</span><strong>₹<%= String.format("%.0f", payment.getBidAmount()) %></strong></div>
      <div><span>Platform fee</span><strong>₹<%= String.format("%.0f", payment.getPlatformFee()) %></strong></div>
      <div><span>Total paid</span><strong>₹<%= String.format("%.0f", payment.getTotalAmount()) %></strong></div>
      <div><span>Freelancer amount</span><strong>₹<%= String.format("%.0f", payment.getFreelancerAmount()) %></strong></div>
    </div>

    <% if(payment.getRefundReason() != null && payment.getRefundReason().trim().length() > 0){ %>
      <div class="box"><span>Refund reason</span><strong><%= safe(payment.getRefundReason()) %></strong></div>
    <% } %>
  </div>

  <div class="footer">
    <a href="<%= safe(backLink) %>" class="btn"><i class="fa-solid fa-arrow-left"></i> Back</a>
    <button type="button" class="btn print" onclick="window.print()"><i class="fa-solid fa-print"></i> Print Receipt</button>
  </div>
</section>
</body>
</html>
