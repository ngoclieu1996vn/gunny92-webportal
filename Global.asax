<%@ Application Language="C#" %>
<script runat="server">
    void Application_BeginRequest(object sender, EventArgs e)
    {
        string path = Request.AppRelativeCurrentExecutionFilePath;
        if (string.Equals(path, "~/api/Launcher/Login", StringComparison.OrdinalIgnoreCase))
        {
            Context.RewritePath("~/api/Launcher/Login/default.aspx", Request.PathInfo, Request.QueryString.ToString());
        }
        else if (string.Equals(path, "~/api/Oauth/GetBlockApp", StringComparison.OrdinalIgnoreCase))
        {
            Context.RewritePath("~/api/Oauth/GetBlockApp/default.aspx", Request.PathInfo, Request.QueryString.ToString());
        }
        else if (path.EndsWith(".swf", StringComparison.OrdinalIgnoreCase) && !path.StartsWith("~/flash/", StringComparison.OrdinalIgnoreCase))
        {
            string filename = VirtualPathUtility.GetFileName(path);
            Context.RewritePath("~/flash/" + filename, Request.PathInfo, Request.QueryString.ToString());
        }
    }
</script>
