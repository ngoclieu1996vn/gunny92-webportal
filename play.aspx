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
    protected string ErrorMsg = "";
    protected bool IsSuccess = false;

    private const string LoginKey = "taolacuopday_WAN-0668-2555555-7ROAD-dandantang-love777nguyenluulathangloznaothe-gunny92";

    protected void Page_Load(object sender, EventArgs e)
    {
        string auth = Request.Url.Authority;
        if (!auth.Contains(":")) auth = auth + ":8888";
        ConfigUrl = "http://" + auth + "/flash/config.xml";
        FlashUrl = "http://" + auth + "/flash/";
        // Check session or token
        Username = Session["Username"] as string;

        // Support launcher token if passed
        string token = Request["token"];
        if (string.IsNullOrEmpty(Username) && !string.IsNullOrEmpty(token))
        {
            Username = Session["LauncherToken_" + token] as string;
            if (string.IsNullOrEmpty(Username))
            {
                // Fallback to query param user if explicitly provided (e.g. testing)
                Username = Request["user"];
            }
        }

        if (string.IsNullOrEmpty(Username))
        {
            Username = Request["user"];
        }

        if (string.IsNullOrEmpty(Username))
        {
            Response.Redirect("Default.aspx?msg=need_login");
            return;
        }

        // Generate one-time session key for game server
        Random rnd = new Random();
        KeyRand = rnd.Next(111111, 999999).ToString();
        int timeNow = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

        // Prime the Road.Service via CreateLogin.aspx
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
                string res = r.ReadToEnd().Trim();
                if (res == "0")
                {
                    IsSuccess = true;
                }
                else
                {
                    ErrorMsg = "CreateLogin trả về mã lỗi: " + res;
                }
            }
        }
        catch (Exception ex)
        {
            ErrorMsg = "Lỗi kết nối máy chủ xác thực: " + ex.Message;
        }
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
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gunny 9.2 - Chơi Game</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #0a0e17;
            --bg-card: rgba(18, 24, 38, 0.85);
            --primary: #f97316;
            --primary-glow: rgba(249, 115, 22, 0.4);
            --accent: #06b6d4;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-glass: rgba(255, 255, 255, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #0b0114;
            background-image: url('https://gunny2009.xyz/assets/game/images/playbackground.jpg');
            background-repeat: no-repeat;
            background-position: center top;
            background-size: 1920px auto;
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: auto;
        }

        /* Top Bar */
        .topbar {
            height: 50px;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-glass);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            z-index: 100;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 20px;
            background: linear-gradient(135deg, #fb923c, #f97316, #ea580c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .server-badge {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .server-badge::before {
            content: '';
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #10b981;
            box-shadow: 0 0 8px #10b981;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-action {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-glass);
            color: var(--text-main);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            text-decoration: none;
        }

        .btn-action:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .btn-gm {
            background: linear-gradient(135deg, #f97316, #ea580c);
            border: none;
            color: white;
            box-shadow: 0 0 12px var(--primary-glow);
        }

        .btn-gm:hover {
            background: linear-gradient(135deg, #fb923c, #f97316);
            transform: translateY(-1px);
        }

        .user-tag {
            color: var(--text-muted);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .user-tag strong {
            color: #38bdf8;
        }

        /* Game Main Area */
        .game-viewport {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding-top: 246px;
            padding-bottom: 80px;
            min-height: 1150px;
        }

        .game-frame-wrapper {
            position: relative;
            width: 1000px;
            height: 600px;
            background: #000;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.8);
            border: 1px solid rgba(0, 0, 0, 0.7);
        }

        .game-frame-wrapper.fullscreen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            border-radius: 0;
            z-index: 9999;
        }

        #gameFlash {
            width: 100%;
            height: 100%;
            display: block;
        }

        /* Fallback Notice */
        .flash-fallback {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.95);
            padding: 40px;
            text-align: center;
            z-index: 10;
        }

        .flash-fallback h2 {
            font-family: 'Outfit', sans-serif;
            font-size: 26px;
            margin-bottom: 12px;
            color: #fb923c;
        }

        .flash-fallback p {
            color: var(--text-muted);
            max-width: 600px;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .download-btns {
            display: flex;
            gap: 16px;
        }

        .btn-download-client {
            padding: 12px 24px;
            background: linear-gradient(135deg, #0284c7, #0369a1);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }

        .btn-download-client:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(2, 132, 199, 0.4);
        }

        .btn-enable-web {
            padding: 12px 24px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid var(--border-glass);
            color: var(--text-main);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <!-- Header / Control bar -->
    <header class="topbar">
        <div class="topbar-left">
            <a href="Default.aspx" class="brand-logo" id="btnLogo">
                <i class="fa-solid fa-crosshairs"></i> GUNNY 9.2
            </a>
            <div class="server-badge" id="badgeServer">
                Server 1 - Gà Chọi (221.121.4.241)
            </div>
        </div>

        <div class="topbar-right">
            <div class="user-tag" id="userBadge">
                <i class="fa-solid fa-user-circle"></i> Tài khoản: <strong><%= Username %></strong>
            </div>
            <a href="gm.aspx" target="_blank" class="btn-action btn-gm" id="btnOpenGM">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Công Cụ GM
            </a>
            <button class="btn-action" id="btnReload" onclick="reloadGame()">
                <i class="fa-solid fa-rotate-right"></i> Tải lại
            </button>
            <button class="btn-action" id="btnFullscreen" onclick="toggleFullscreen()">
                <i class="fa-solid fa-expand"></i> Toàn màn hình
            </button>
            <a href="Default.aspx?action=logout" class="btn-action" id="btnLogout" onclick="logout(event)">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </header>

    <!-- Game Container -->
    <main class="game-viewport">
        <div class="game-frame-wrapper" id="gameWrapper">
            
            <% if (!string.IsNullOrEmpty(ErrorMsg)) { %>
                <div class="flash-fallback">
                    <h2><i class="fa-solid fa-triangle-exclamation"></i> Lỗi Khởi Động Game</h2>
                    <p><%= ErrorMsg %></p>
                    <button class="btn-download-client" onclick="location.reload()">Thử lại</button>
                </div>
            <% } else { %>
                <!-- Standard Flash Object Embedding -->
                <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                        codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=11,0,0,0"
                        id="gameFlash" width="100%" height="100%">
                    <param name="movie" value="<%= FlashUrl %>Loading.swf" />
                    <param name="base" value="<%= FlashUrl %>" />
                    <param name="quality" value="high" />
                    <param name="bgcolor" value="#000000" />
                    <param name="allowScriptAccess" value="always" />
                    <param name="allowFullScreen" value="true" />
                    <param name="wmode" value="direct" />
                    <param name="flashvars" value="user=<%= Username %>&key=<%= KeyRand %>&v=104&rand=92386938&config=<%= ConfigUrl %>" />
                    
                    <embed src="<%= FlashUrl %>Loading.swf"
                           base="<%= FlashUrl %>"
                           id="gameEmbed"
                           quality="high"
                           bgcolor="#000000"
                           width="100%"
                           height="100%"
                           name="gameFlash"
                           align="middle"
                           play="true"
                           loop="false"
                           quality="high"
                           allowScriptAccess="always"
                           allowFullScreen="true"
                           wmode="direct"
                           type="application/x-shockwave-flash"
                           pluginspage="http://www.macromedia.com/go/getflashplayer"
                           flashvars="user=<%= Username %>&key=<%= KeyRand %>&v=104&rand=92386938&config=<%= ConfigUrl %>">
                    </embed>
                </object>

                <!-- Fallback notice for browsers without Flash Plugin -->
                <div class="flash-fallback" id="flashFallback" style="display: none;">
                    <h2><i class="fa-solid fa-gamepad"></i> Trải Nghiệm Gunny 9.2 Tuyệt Vời Nhất</h2>
                    <p>
                        Trình duyệt hiện tại chưa kích hoạt Adobe Flash Player. 
                        Để chơi game mượt mà 100% không lo lỗi Flash, bạn hãy tải ngay <strong>Launcher Máy Ảo / Windows Client</strong> hoặc dùng trình duyệt có sẵn Flash (Cent Browser, Cốc Cốc, Pale Moon)!
                    </p>
                    <div class="download-btns">
                        <a href="Gunny92_Launcher_Windows.zip" class="btn-download-client" id="btnDownloadWin">
                            <i class="fa-brands fa-windows"></i> Tải Client Windows (.ZIP)
                        </a>
                        <a href="Gunny92_Client_macOS.zip" class="btn-download-client" style="background: linear-gradient(135deg, #475569, #334155);" id="btnDownloadMac">
                            <i class="fa-brands fa-apple"></i> Tải Client macOS (.ZIP)
                        </a>
                        <button class="btn-enable-web" onclick="hideFallback()">
                            <i class="fa-solid fa-play"></i> Thử chạy trên Web
                        </button>
                    </div>
                </div>
            <% } %>

        </div>
    </main>

    <script>
        // Check if Flash is supported in browser
        function hasFlash() {
            var hasFlash = false;
            try {
                var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
                if (fo) hasFlash = true;
            } catch (e) {
                if (navigator.mimeTypes && navigator.mimeTypes['application/x-shockwave-flash'] != undefined && navigator.mimeTypes['application/x-shockwave-flash'].enabledPlugin) {
                    hasFlash = true;
                }
            }
            return hasFlash;
        }

        window.addEventListener('DOMContentLoaded', function () {
            if (!hasFlash()) {
                var fallback = document.getElementById('flashFallback');
                if (fallback) fallback.style.display = 'flex';
            }
        });

        function hideFallback() {
            var fallback = document.getElementById('flashFallback');
            if (fallback) fallback.style.display = 'none';
        }

        function reloadGame() {
            location.reload();
        }

        function toggleFullscreen() {
            var wrapper = document.getElementById('gameWrapper');
            if (!document.fullscreenElement) {
                if (wrapper.requestFullscreen) {
                    wrapper.requestFullscreen();
                } else {
                    wrapper.classList.toggle('fullscreen');
                }
            } else {
                if (document.exitFullscreen) document.exitFullscreen();
            }
        }

        function logout(e) {
            if (e && e.preventDefault) e.preventDefault();
            var xhr = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject('Microsoft.XMLHTTP');
            xhr.open('GET', 'api.ashx?action=logout', true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    window.location.href = 'Default.aspx';
                }
            };
            xhr.send();
            return false;
        }
    </script>
</body>
</html>
