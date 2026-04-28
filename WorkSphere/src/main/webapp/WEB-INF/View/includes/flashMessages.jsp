<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
private String wsMsgSafe(Object value){
    if(value == null) return "";
    return String.valueOf(value)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}

private boolean wsMsgBlank(Object value){
    return value == null || String.valueOf(value).trim().length() == 0;
}

private String wsMsgInferType(String text){
    if(text == null) return "info";

    String s = text.toLowerCase();

    if((s.contains("successful") || s.contains("success")) &&
       (s.contains("could not") || s.contains("not configured") || s.contains("warning"))){
        return "warning";
    }

    if(s.contains("invalid") || s.contains("failed") || s.contains("error") ||
       s.contains("not found") || s.contains("already registered") ||
       s.contains("expired") || s.contains("denied")){
        return "error";
    }

    if(s.contains("please") || s.contains("required") || s.contains("too large") ||
       s.contains("not configured") || s.contains("could not") || s.contains("try again")){
        return "warning";
    }

    if(s.contains("success") || s.contains("successful") || s.contains("saved") ||
       s.contains("posted") || s.contains("submitted") || s.contains("accepted") ||
       s.contains("rejected") || s.contains("completed") || s.contains("sent") ||
       s.contains("updated") || s.contains("requested")){
        return "success";
    }

    return "info";
}

private String wsMsgTitle(String type){
    if("success".equals(type)) return "Done successfully";
    if("error".equals(type)) return "Action needed";
    if("warning".equals(type)) return "Please check this";
    return "WorkSphere update";
}

private String wsMsgIcon(String type){
    if("success".equals(type)) return "fa-solid fa-circle-check";
    if("error".equals(type)) return "fa-solid fa-circle-exclamation";
    if("warning".equals(type)) return "fa-solid fa-triangle-exclamation";
    return "fa-solid fa-circle-info";
}
%>

<%
String wsMessage = "";
String wsType = "";

if(!wsMsgBlank(request.getAttribute("success"))){
    wsMessage = wsMsgSafe(request.getAttribute("success"));
    wsType = "success";
}else if(!wsMsgBlank(request.getAttribute("error"))){
    wsMessage = wsMsgSafe(request.getAttribute("error"));
    wsType = "error";
}else if(!wsMsgBlank(request.getAttribute("warning"))){
    wsMessage = wsMsgSafe(request.getAttribute("warning"));
    wsType = "warning";
}else if(!wsMsgBlank(request.getAttribute("info"))){
    wsMessage = wsMsgSafe(request.getAttribute("info"));
    wsType = "info";
}else if(!wsMsgBlank(request.getAttribute("msg"))){
    wsMessage = wsMsgSafe(request.getAttribute("msg"));
    wsType = wsMsgInferType(String.valueOf(request.getAttribute("msg")));
}
%>

<% if(wsMessage != null && wsMessage.trim().length() > 0){ %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/worksphere-messages.css">

<div class="ws-toast-stack" id="wsToastStack">
    <div class="ws-toast ws-toast-<%= wsType %>" id="wsToast" role="status" aria-live="polite">
        <div class="ws-toast-icon">
            <i class="<%= wsMsgIcon(wsType) %>"></i>
        </div>

        <div class="ws-toast-body">
            <span class="ws-toast-title"><%= wsMsgTitle(wsType) %></span>
            <span class="ws-toast-text"><%= wsMessage %></span>
        </div>

        <button type="button" class="ws-toast-close" id="wsToastClose" aria-label="Close message">
            <i class="fa-solid fa-xmark"></i>
        </button>
    </div>
</div>

<script>
(function(){
    var toast = document.getElementById('wsToast');
    var close = document.getElementById('wsToastClose');

    function hideToast(){
        if(!toast) return;
        toast.classList.add('ws-hide');
        setTimeout(function(){
            if(toast && toast.parentNode){
                toast.parentNode.remove();
            }
        }, 280);
    }

    if(close){
        close.addEventListener('click', hideToast);
    }

    setTimeout(hideToast, 5200);
})();
</script>
<% } %>


<script>
(function(){
    if(window.__wsLocalWarningHooked) return;
    window.__wsLocalWarningHooked = true;

    function ensureMessageCss(){
        if(document.querySelector('link[href*="worksphere-messages.css"]')) return;
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = window.location.pathname.split('/').slice(0,2).join('/') + '/CSS/worksphere-messages.css';
        document.head.appendChild(link);
    }

    function createToast(message){
        ensureMessageCss();

        var old = document.getElementById('wsLocalWarningStack');
        if(old){ old.remove(); }

        var stack = document.createElement('div');
        stack.className = 'ws-toast-stack';
        stack.id = 'wsLocalWarningStack';
        stack.innerHTML =
            '<div class="ws-toast ws-toast-warning" id="wsLocalWarningToast" role="status" aria-live="polite">' +
                '<div class="ws-toast-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>' +
                '<div class="ws-toast-body">' +
                    '<span class="ws-toast-title">Please check this</span>' +
                    '<span class="ws-toast-text">' + String(message || '').replace(/[<>&"]/g, function(c){return {"<":"&lt;",">":"&gt;","&":"&amp;","\\"":"&quot;"}[c];}) + '</span>' +
                '</div>' +
                '<button type="button" class="ws-toast-close" id="wsLocalWarningClose" aria-label="Close message"><i class="fa-solid fa-xmark"></i></button>' +
            '</div>';

        document.body.appendChild(stack);

        var toast = document.getElementById('wsLocalWarningToast');
        var close = document.getElementById('wsLocalWarningClose');

        function hide(){
            if(!toast) return;
            toast.classList.add('ws-hide');
            setTimeout(function(){
                if(stack && stack.parentNode){ stack.parentNode.removeChild(stack); }
            }, 280);
        }

        if(close){ close.addEventListener('click', hide); }
        setTimeout(hide, 5200);
    }

    window.addEventListener('worksphereLocalWarning', function(e){
        createToast(e.detail || 'Please check this field and try again.');
    });
})();
</script>
