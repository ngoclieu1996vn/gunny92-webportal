<%@ Page Language="C#" AutoEventWireup="true"  ResponseEncoding="utf-8" ContentType="text/html; charset=utf-8" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>

<script runat="server">
    protected string Username = "";
    protected string KeyRand = "";
    protected string ConfigUrl = "http://221.121.4.241:8888/flash/config.xml";
    protected string FlashUrl = "http://221.121.4.241:8888/flash/";

    private const string LoginKey = "taolacuopday_WAN-0668-2555555-7ROAD-dandantang-love777nguyenluulathangloznaothe-gunny92";

    protected void Page_Load(object sender, EventArgs e)
    {
        string auth = Request.Url.Authority;
        if (!auth.Contains(":")) auth = auth + ":8888";
        ConfigUrl = "http://" + auth + "/flash/config.xml";
        FlashUrl = "http://" + auth + "/flash/";
        string token = Request["token"] ?? "";
        if (string.IsNullOrEmpty(token))
        {
            // Try extracting from path e.g. /play2/TOKEN
            string rawUrl = Request.RawUrl;
            int idx = rawUrl.IndexOf("/play2/", StringComparison.OrdinalIgnoreCase);
            if (idx >= 0)
            {
                token = rawUrl.Substring(idx + 7).Split('?')[0].Trim('/');
            }
        }

        Username = HttpRuntime.Cache["LauncherToken_" + token] as string;
        if (string.IsNullOrEmpty(Username))
        {
            Username = Session["LauncherToken_" + token] as string;
        }
        if (string.IsNullOrEmpty(Username))
        {
            Username = Session["Username"] as string;
        }
        if (string.IsNullOrEmpty(Username))
        {
            Username = Request["user"];
        }
        if (string.IsNullOrEmpty(Username))
        {
            Response.Write("<h3 style='color:white;text-align:center;margin-top:50px;'>Phiên đăng nhập không hợp lệ hoặc đã hết hạn! Vui lòng đăng nhập lại Launcher.</h3>");
            Response.End();
            return;
        }

        Random rnd = new Random();
        KeyRand = rnd.Next(111111, 999999).ToString();
        int timeNow = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

        try
        {
            string raw = Username + KeyRand + timeNow.ToString() + LoginKey;
            string hash = Md5Hex(raw);
            string content = Username + "|" + KeyRand + "|" + timeNow + "|" + hash;
            string url = "http://127.0.0.1/request/CreateLogin.aspx?content=" + Uri.EscapeDataString(content);

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            req.Timeout = 5000;
            using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
            using (StreamReader r = new StreamReader(resp.GetResponseStream()))
            {
                r.ReadToEnd();
            }
        }
        catch {}
    }

    private string Md5Hex(string input)
    {
        using (MD5 md5 = MD5.Create())
        {
            byte[] b = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
            StringBuilder sb = new StringBuilder();
            foreach (byte x in b) sb.Append(x.ToString("x2"));
            return sb.ToString();
        }
    }
</script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Gunny 9.2 Launcher Game</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #000;
        }
        #gameEmbed {
            width: 100%;
            height: 100%;
            display: block;
        }
    </style>
</head>
<body>
    <embed src="<%= FlashUrl %>Loading.swf"
           id="gameEmbed"
           quality="high"
           bgcolor="#000000"
           width="100%"
           height="100%"
           name="gameFlash"
           align="middle"
           play="true"
           loop="false"
           allowScriptAccess="always"
           allowFullScreen="true"
           wmode="direct"
           type="application/x-shockwave-flash"
           pluginspage="http://www.macromedia.com/go/getflashplayer"
           flashvars="user=<%= Username %>&key=<%= KeyRand %>&v=104&rand=92386938&config=<%= ConfigUrl %>">
    </embed>
</body>
</html>
