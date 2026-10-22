<%@ Page Language="C#" AutoEventWireup="true"  ResponseEncoding="utf-8" ContentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gunny 9.2 - Đẳng Cấp Gà Chọi | Chơi Ngay Trên Web & Client</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #070a12;
            --bg-panel: rgba(15, 23, 42, 0.75);
            --bg-card: rgba(30, 41, 59, 0.6);
            --primary: #f97316;
            --primary-glow: rgba(249, 115, 22, 0.4);
            --secondary: #06b6d4;
            --accent: #e11d48;
            --success: #10b981;
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
            background-color: var(--bg-dark);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            background-image: 
                radial-gradient(circle at 15% 15%, rgba(249, 115, 22, 0.12) 0%, transparent 45%),
                radial-gradient(circle at 85% 85%, rgba(6, 182, 212, 0.12) 0%, transparent 45%),
                linear-gradient(to bottom, #070a12, #0d1322);
        }

        /* Header */
        .navbar {
            height: 72px;
            background: rgba(10, 14, 26, 0.85);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-glass);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 900;
            font-size: 26px;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #fb923c, #f97316, #ef4444);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav-item {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 8px;
        }

        .nav-item:hover, .nav-item.active {
            color: #f8fafc;
            background: rgba(255, 255, 255, 0.06);
        }

        .btn-nav-gm {
            background: rgba(249, 115, 22, 0.15);
            color: #fb923c;
            border: 1px solid rgba(249, 115, 22, 0.3);
        }

        .btn-nav-gm:hover {
            background: var(--primary);
            color: white;
            box-shadow: 0 0 15px var(--primary-glow);
        }

        /* Hero Section */
        .hero {
            position: relative;
            padding: 60px 48px 40px;
            max-width: 1280px;
            margin: 0 auto;
            width: 100%;
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 40px;
            align-items: center;
        }

        .hero-info h1 {
            font-family: 'Outfit', sans-serif;
            font-size: 48px;
            font-weight: 900;
            line-height: 1.15;
            margin-bottom: 16px;
            background: linear-gradient(135deg, #ffffff 0%, #cbd5e1 50%, #94a3b8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-info h1 span {
            background: linear-gradient(135deg, #fb923c, #f97316);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-desc {
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 28px;
            max-width: 520px;
        }

        /* Server Status Widget */
        .server-status-card {
            background: var(--bg-panel);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border-glass);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            max-width: 520px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .server-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .server-indicator {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: #10b981;
            box-shadow: 0 0 12px #10b981;
            position: relative;
        }

        .server-indicator::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: #10b981;
            animation: ping 2s cubic-bezier(0, 0, 0.2, 1) infinite;
        }

        @keyframes ping {
            75%, 100% {
                transform: scale(2.2);
                opacity: 0;
            }
        }

        .server-name {
            font-family: 'Outfit', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: #f8fafc;
        }

        .server-ip {
            font-size: 12px;
            color: var(--text-muted);
        }

        .server-players-badge {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            padding: 6px 14px;
            border-radius: 9999px;
            font-size: 13px;
            font-weight: 700;
        }

        /* Auth Card */
        .auth-card {
            background: var(--bg-panel);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-glass);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5), 0 0 30px rgba(249, 115, 22, 0.1);
        }

        .auth-tabs {
            display: flex;
            background: rgba(15, 23, 42, 0.6);
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 24px;
            border: 1px solid var(--border-glass);
        }

        .auth-tab-btn {
            flex: 1;
            padding: 12px 0;
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 15px;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .auth-tab-btn.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 15px var(--primary-glow);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 18px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
        }

        .form-input {
            width: 100%;
            background: rgba(10, 14, 26, 0.7);
            border: 1px solid var(--border-glass);
            color: var(--text-main);
            padding: 13px 16px;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.2);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #fb923c, #f97316, #ea580c);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 6px 20px var(--primary-glow);
            margin-top: 6px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px var(--primary-glow);
        }

        .auth-notice {
            font-size: 12px;
            color: #64748b;
            text-align: center;
            margin-top: 16px;
            line-height: 1.5;
        }

        /* Logged In Card State */
        .logged-card {
            display: none;
            flex-direction: column;
            align-items: center;
            text-align: center;
            padding: 20px 0;
            gap: 16px;
        }

        .user-avatar-large {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: rgba(249, 115, 22, 0.2);
            border: 3px solid #fb923c;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #fb923c;
            box-shadow: 0 0 20px var(--primary-glow);
        }

        .btn-play-now {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
            transition: all 0.2s;
        }

        .btn-play-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.5);
        }

        /* Download Section */
        .section-downloads {
            max-width: 1280px;
            margin: 40px auto 60px;
            padding: 0 48px;
            width: 100%;
        }

        .section-title {
            text-align: center;
            margin-bottom: 36px;
        }

        .section-title h2 {
            font-family: 'Outfit', sans-serif;
            font-size: 32px;
            font-weight: 800;
            color: #f8fafc;
            margin-bottom: 8px;
        }

        .section-title p {
            color: var(--text-muted);
            font-size: 15px;
        }

        .downloads-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .download-card {
            background: var(--bg-panel);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border-glass);
            border-radius: 18px;
            padding: 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .download-card:hover {
            transform: translateY(-6px);
            border-color: rgba(249, 115, 22, 0.4);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        .download-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin-bottom: 20px;
        }

        .icon-windows { background: rgba(2, 132, 199, 0.2); color: #38bdf8; }
        .icon-mac { background: rgba(148, 163, 184, 0.2); color: #cbd5e1; }
        .icon-web { background: rgba(249, 115, 22, 0.2); color: #fb923c; }

        .download-card h3 {
            font-family: 'Outfit', sans-serif;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #f8fafc;
        }

        .download-card p {
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 24px;
            flex: 1;
        }

        .btn-card-download {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-win {
            background: linear-gradient(135deg, #0284c7, #0369a1);
            color: white;
        }

        .btn-win:hover {
            box-shadow: 0 6px 20px rgba(2, 132, 199, 0.4);
        }

        .btn-mac {
            background: linear-gradient(135deg, #475569, #334155);
            color: white;
        }

        .btn-mac:hover {
            box-shadow: 0 6px 20px rgba(71, 85, 105, 0.4);
        }

        .btn-web {
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: white;
        }

        .btn-web:hover {
            box-shadow: 0 6px 20px var(--primary-glow);
        }

        /* Footer */
        .footer {
            margin-top: auto;
            border-top: 1px solid var(--border-glass);
            padding: 24px 48px;
            background: rgba(10, 14, 26, 0.95);
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: var(--text-muted);
            font-size: 13px;
        }

        /* Toast */
        #homeToast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #1e293b;
            color: white;
            padding: 14px 20px;
            border-radius: 10px;
            border-left: 4px solid var(--success);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            z-index: 9999;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <a href="Default.aspx" class="brand-logo" id="mainLogo">
            <i class="fa-solid fa-crosshairs"></i> GUNNY 9.2
        </a>
        <div class="nav-menu">
            <a href="#downloads" class="nav-item" id="navDownloads">
                <i class="fa-solid fa-download"></i> Tải Client
            </a>
            <a href="play.aspx" class="nav-item" id="navPlay">
                <i class="fa-solid fa-play"></i> Vào Chơi
            </a>
            <a href="gm.aspx" class="nav-item btn-nav-gm" id="navGm">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Trang GM
            </a>
        </div>
    </nav>

    <!-- Hero Content -->
    <div class="hero">
        <div class="hero-info">
            <h1>Huyền Thoại <span>Gunny 9.2</span> Sống Lại</h1>
            <p class="hero-desc">
                Máy chủ Gunny 9.2 chuẩn phiên bản gốc. Tốc độ mượt mà, hỗ trợ chơi trên cả 
                <strong>Web Browser, Client Windows và Client macOS</strong>. Đăng ký tài khoản chỉ với 1 bước!
            </p>

            <!-- Server Status -->
            <div class="server-status-card" id="serverCard">
                <div class="server-title">
                    <div class="server-indicator"></div>
                    <div>
                        <div class="server-name" id="serverNameText">Server 1: Gà Chọi</div>
                        <div class="server-ip">IP: 221.121.4.241 | Port: 9200</div>
                    </div>
                </div>
                <div class="server-players-badge">
                    <i class="fa-solid fa-signal"></i> Hoạt Động
                </div>
            </div>
        </div>

        <!-- Right Side: Auth / Play Card -->
        <div class="auth-card" id="authBox">
            
            <!-- When NOT logged in -->
            <div id="unloggedForm">
                <div class="auth-tabs">
                    <button class="auth-tab-btn active" id="tabBtnLogin" onclick="switchAuthTab('login')">
                        <i class="fa-solid fa-right-to-bracket"></i> Đăng Nhập
                    </button>
                    <button class="auth-tab-btn" id="tabBtnRegister" onclick="switchAuthTab('register')">
                        <i class="fa-solid fa-user-plus"></i> Đăng Ký
                    </button>
                </div>

                <!-- Login Form -->
                <form id="formLogin" onsubmit="handleLoginSubmit(event)">
                    <div class="form-group">
                        <label for="loginUser">Tài khoản</label>
                        <input type="text" id="loginUser" class="form-input" placeholder="Nhập tài khoản của bạn..." required />
                    </div>
                    <div class="form-group">
                        <label for="loginPass">Mật khẩu</label>
                        <input type="password" id="loginPass" class="form-input" placeholder="Nhập mật khẩu..." required />
                    </div>
                    <button type="submit" class="btn-submit" id="btnSubmitLogin">
                        <i class="fa-solid fa-gamepad"></i> ĐĂNG NHẬP NGAY
                    </button>
                </form>

                <!-- Register Form -->
                <form id="formRegister" onsubmit="handleRegisterSubmit(event)" style="display: none;">
                    <div class="form-group">
                        <label for="regUser">Tài khoản (Tự chọn)</label>
                        <input type="text" id="regUser" class="form-input" placeholder="Tên tài khoản (từ 3 ký tự)..." required />
                    </div>
                    <div class="form-group">
                        <label for="regPass">Mật khẩu</label>
                        <input type="password" id="regPass" class="form-input" placeholder="Mật khẩu (từ 4 ký tự)..." required />
                    </div>
                    <button type="submit" class="btn-submit" id="btnSubmitRegister" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="fa-solid fa-user-check"></i> ĐĂNG KÝ VÀ VÀO CHƠI
                    </button>
                    <p class="auth-notice">
                        *Đăng ký siêu tốc chỉ cần tài khoản và mật khẩu, không yêu cầu email/sđt.
                    </p>
                </form>
            </div>

            <!-- When LOGGED IN -->
            <div class="logged-card" id="loggedForm">
                <div class="user-avatar-large">
                    <i class="fa-solid fa-crown"></i>
                </div>
                <div>
                    <h3 style="font-size: 20px; font-weight: 700; color: #f8fafc;" id="loggedUsername">User</h3>
                    <p style="color: var(--text-muted); font-size: 13px; margin-top: 4px;">Đã sẵn sàng chiến đấu trên Server 1 - Gà Chọi!</p>
                </div>
                
                <a href="play.aspx" class="btn-play-now" id="btnPlayNowDirect">
                    <i class="fa-solid fa-crosshairs"></i> VÀO GAME NGAY BÂY GIỜ
                </a>

                <div style="display: flex; gap: 12px; width: 100%;">
                    <a href="gm.aspx" class="nav-item btn-nav-gm" style="flex: 1; justify-content: center;" id="btnGoGM">
                        <i class="fa-solid fa-wand-magic-sparkles"></i> Mở Tool GM
                    </a>
                    <button onclick="handleLogout()" class="nav-item" style="flex: 1; justify-content: center; background: transparent; border: 1px solid var(--border-glass);" id="btnLogoutHome">
                        <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- Download Section -->
    <div class="section-downloads" id="downloads">
        <div class="section-title">
            <h2>Tải Client & Trải Nghiệm Game</h2>
            <p>Chọn phiên bản phù hợp với thiết bị của bạn để chơi Gunny 9.2 tốt nhất</p>
        </div>

        <div class="downloads-grid">
            <!-- Windows Client -->
            <div class="download-card" id="cardWinClient">
                <div class="download-icon icon-windows">
                    <i class="fa-brands fa-windows"></i>
                </div>
                <h3>Client Windows (PC)</h3>
                <p>
                    Phiên bản Client chuyên dụng Gunny 9.2 tích hợp bộ đệm cục bộ 0ms, chống lag giật và không cần cài đặt Flash. Đã cấu hình trọn gói tới máy chủ 221.121.4.241, tải về giải nén chơi ngay!
                </p>
                <a href="GunnyClient_V92_Full.zip" class="btn-card-download btn-win" id="btnDownloadClientFull" style="background: linear-gradient(135deg, #f97316, #ef4444); box-shadow: 0 4px 15px rgba(249, 115, 22, 0.4);">
                    <i class="fa-solid fa-rocket"></i> Tải GunnyClient 9.2 Full (VIP Khuyên Dùng)
                </a>
                <a href="Gunny92_Launcher_Windows.zip" class="btn-card-download" id="btnDownloadWinZip" style="margin-top: 8px; background: rgba(2, 132, 199, 0.15); border: 1px solid rgba(2, 132, 199, 0.4); color: #38bdf8;">
                    <i class="fa-solid fa-download"></i> Tải Launcher Gọn Nhẹ (.ZIP)
                </a>
            </div>

            <!-- macOS Client -->
            <div class="download-card" id="cardMacClient">
                <div class="download-icon icon-mac">
                    <i class="fa-brands fa-apple"></i>
                </div>
                <h3>Client macOS</h3>
                <p>
                    Bộ Client Flash & Launcher tối ưu hóa cho macOS (Apple Silicon M1/M2/M3 & Intel). Mượt mà, đầy đủ âm thanh và đồ họa gốc.
                </p>
                <a href="Gunny92_Client_macOS.zip" class="btn-card-download btn-mac" id="btnDownloadMacZip">
                    <i class="fa-solid fa-download"></i> Tải Client macOS (.ZIP)
                </a>
            </div>

            <!-- Web Player -->
            <div class="download-card" id="cardWebPlayer">
                <div class="download-icon icon-web">
                    <i class="fa-solid fa-globe"></i>
                </div>
                <h3>Chơi Trực Tiếp Trên Web</h3>
                <p>
                    Không cần tải phần mềm, chơi trực tiếp trên trình duyệt (hỗ trợ Cốc Cốc, Cent Browser hoặc bật Flash). Đường dẫn bảo mật không lộ mật khẩu.
                </p>
                <a href="play.aspx" class="btn-card-download btn-web" id="btnPlayOnWeb">
                    <i class="fa-solid fa-play"></i> Bắt Đầu Chơi Web
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div>&copy; 2026 Gunny 9.2 Private Server. Bản quyền máy chủ IP Công Khai 221.121.4.241.</div>
        <div>Hỗ trợ người chơi: Admin GM | Trực tuyến 24/7</div>
    </footer>

    <!-- Toast Notification -->
    <div id="homeToast">
        <i class="fa-solid fa-circle-check" style="color: #10b981;"></i>
        <span id="homeToastMsg">Thành công!</span>
    </div>

    <script>
        function ajaxGet(url, callback) {
            var xhr = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject('Microsoft.XMLHTTP');
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        callback(data);
                    } catch (e) {
                        callback({ success: false, message: 'Phản hồi không hợp lệ' });
                    }
                }
            };
            xhr.send();
        }

        function showHomeToast(msg, isSuccess) {
            if (typeof isSuccess === 'undefined') isSuccess = true;
            var t = document.getElementById('homeToast');
            var m = document.getElementById('homeToastMsg');
            m.innerText = msg;
            t.style.borderLeftColor = isSuccess ? '#10b981' : '#ef4444';
            t.style.display = 'flex';
            setTimeout(function () { t.style.display = 'none'; }, 3500);
        }

        function switchAuthTab(type) {
            var btnLogin = document.getElementById('tabBtnLogin');
            var btnReg = document.getElementById('tabBtnRegister');
            var fLogin = document.getElementById('formLogin');
            var fReg = document.getElementById('formRegister');

            if (type === 'login') {
                btnLogin.classList.add('active');
                btnReg.classList.remove('active');
                fLogin.style.display = 'block';
                fReg.style.display = 'none';
            } else {
                btnReg.classList.add('active');
                btnLogin.classList.remove('active');
                fReg.style.display = 'block';
                fLogin.style.display = 'none';
            }
        }

        function handleLoginSubmit(e) {
            if (e && e.preventDefault) e.preventDefault();
            var u = document.getElementById('loginUser').value.replace(/^\s+|\s+$/g, '');
            var p = document.getElementById('loginPass').value.replace(/^\s+|\s+$/g, '');

            ajaxGet('api.ashx?action=login&username=' + encodeURIComponent(u) + '&password=' + encodeURIComponent(p), function (d) {
                showHomeToast(d.message, d.success);
                if (d.success) {
                    setLoggedIn(d.username);
                }
            });
            return false;
        }

        function handleRegisterSubmit(e) {
            if (e && e.preventDefault) e.preventDefault();
            var u = document.getElementById('regUser').value.replace(/^\s+|\s+$/g, '');
            var p = document.getElementById('regPass').value.replace(/^\s+|\s+$/g, '');

            ajaxGet('api.ashx?action=register&username=' + encodeURIComponent(u) + '&password=' + encodeURIComponent(p), function (d) {
                showHomeToast(d.message, d.success);
                if (d.success) {
                    setLoggedIn(d.username);
                }
            });
            return false;
        }

        function handleLogout() {
            ajaxGet('api.ashx?action=logout', function (d) {
                document.getElementById('loggedForm').style.display = 'none';
                document.getElementById('unloggedForm').style.display = 'block';
                showHomeToast('Đã đăng xuất!');
            });
        }

        function setLoggedIn(username) {
            document.getElementById('unloggedForm').style.display = 'none';
            var logged = document.getElementById('loggedForm');
            logged.style.display = 'flex';
            document.getElementById('loggedUsername').innerText = username;
        }

        function checkUserSession() {
            ajaxGet('api.ashx?action=session', function (d) {
                if (d.loggedIn) {
                    setLoggedIn(d.username);
                }
            });
        }

        if (window.addEventListener) {
            window.addEventListener('DOMContentLoaded', checkUserSession, false);
        } else if (window.attachEvent) {
            window.attachEvent('onload', checkUserSession);
        }
    </script>
</body>
</html>
