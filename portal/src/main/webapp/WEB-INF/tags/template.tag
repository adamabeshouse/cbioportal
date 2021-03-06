<%@ tag import="org.mskcc.cbio.portal.util.GlobalProperties" %>
<%@ tag import="org.mskcc.cbio.portal.servlet.CheckDarwinAccessServlet" %>
<%@ tag import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<%@tag description="Simple Template" pageEncoding="UTF-8" %>

<%@attribute name="title" %>
<%@attribute name="defaultRightColumn" %>
<%@attribute name="fixedWidth" %>
<%@attribute name="twoColumn" %>
<%@attribute name="noMargin" %>
<%@attribute name="cssClass" %>

<%@attribute name="head_area" fragment="true" %>
<%@attribute name="body_area" fragment="true" %>
<%@attribute name="right_column" fragment="true" %>

<html class="cbioportal-frontend">
<head>
    
<title>${title}</title>
    
<link rel="icon" href="images/cbioportal_icon.png"/>
<link rel="stylesheet" href="css/header.css?<%=GlobalProperties.getAppVersion()%>" />
    
<script type="text/javascript">

window.enableDarwin = <%=CheckDarwinAccessServlet.CheckDarwinAccess.existsDarwinProperties()%>;
window.appVersion = '<%=GlobalProperties.getAppVersion()%>';
window.maxTreeDepth = '<%=GlobalProperties.getMaxTreeDepth()%>';
window.showOncoKB = <%=GlobalProperties.showOncoKB()%>;
window.showCivic = <%=GlobalProperties.showCivic()%>;
window.showHotspot = <%=GlobalProperties.showHotspot()%>;
window.showMyCancerGenome = <%=GlobalProperties.showMyCancerGenomeUrl()%>;

// this prevents react router from messing with hash in a way that could is unecessary (static pages)
// or could conflict
window.historyType = 'memory';

window.skinBlurb = '<%=GlobalProperties.getBlurb()%>';
window.skinExampleStudyQueries = '<%=GlobalProperties.getExampleStudyQueries().replace("\n","\\n")%>'.split("\n");
window.skinDatasetHeader = '<%=GlobalProperties.getDataSetsHeader()%>';
window.skinDatasetFooter = '<%=GlobalProperties.getDataSetsFooter()%>';
window.skinRightNavShowDatasets = <%=GlobalProperties.showRightNavDataSets()%>;
window.skinRightNavShowExamples = <%=GlobalProperties.showRightNavExamples()%>;
window.skinRightNavShowTestimonials = <%=GlobalProperties.showRightNavTestimonials()%>;
window.skinRightNavExamplesHTML = '<%=GlobalProperties.getExamplesRightColumnHtml()%>';
// Prioritized studies for study selector
window.priorityStudies = {};
<%
List<String[]> priorityStudies = GlobalProperties.getPriorityStudies();
for (String[] group : priorityStudies) {
    if (group.length > 1) {
        out.println("window.priorityStudies['"+group[0]+"'] = ");
        out.println("[");
        int i = 1;
        while (i < group.length) {
            if (i >= 2) {
                out.println(",");
            }
            out.println("'"+group[i]+"'");
            i++;
        }
        out.println("];");
    }
}
%>

// Set API root variable for cbioportal-frontend repo
<%
String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath();
baseURL = baseURL.replace("https://", "").replace("http://", "");

String bodyClasses = "";

if (fixedWidth == "true") {
    bodyClasses += "fixedWidth";
} 
if (twoColumn == "true" ||  defaultRightColumn == "true") {
    bodyClasses += " twoColumn";
} 
if (noMargin == "true") {
    bodyClasses += " noMargin";
} 
if (cssClass != null) {
    bodyClasses += " " + cssClass;
}

%>
__API_ROOT__ = '<%=baseURL%>';
    

</script>

<script src="js/src/load-frontend.js?<%=GlobalProperties.getAppVersion()%>"></script>
    
<jsp:invoke fragment="head_area"/>
    
</head>
    
    <body class="<%=bodyClasses.trim()%>">

    
    <div class="pageTopContainer">
    <div class="contentWidth">
        <jsp:include page="/WEB-INF/jsp/global/header_bar.jsp" />
    </div>
    </div>
    
    <div class="contentWrapper">
            <div class="contentWidth">
            <div id="mainColumn"><jsp:invoke fragment="body_area"/></div>
            
            <c:if test="${defaultRightColumn == true || twoColumn==true}">
                <div id="rightColumn"><jsp:invoke fragment="right_column"/></div>
            </c:if>
           
            </div>
    </div>
    
    </div>
    
    <jsp:include page="/WEB-INF/jsp/global/footer.jsp" />

    <c:if test="${defaultRightColumn == true}">
        <script>

        window.renderRightBar(document.getElementById('rightColumn'));

        </script>
    </c:if>
    
    
    <script>
    // mark nav item as selected
    $(document).ready(function() {
        var pathname = window.location.pathname;
        var start = pathname.lastIndexOf("/")+1;
        var filename = pathname.substring(start);
        $('#main-nav ul li').each(function(index) {
            var currentPage = $(this).find('a').attr('href');
            if (currentPage === filename) {
                $('#main-nav ul li').removeClass('selected');
                $(this).addClass('selected');
                return false;
            }
        });
    });
    </script>
    
    </body>
</html>
