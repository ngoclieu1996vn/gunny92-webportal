<%@ Page Language="C#" AutoEventWireup="true" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string user = Request["user"] ?? "";
        if (!string.IsNullOrEmpty(user))
        {
            Session["Username"] = user;
            Response.Redirect("play.aspx?user=" + Server.UrlEncode(user));
        }
        else
        {
            Response.Redirect("Default.aspx");
        }
    }
</script>
