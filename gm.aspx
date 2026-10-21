<%@ Page Language="C#" AutoEventWireup="true"  ResponseEncoding="utf-8" ContentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gunny 9.2 - Trang Quản Trị GM</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #0a0e17;
            --bg-panel: rgba(18, 24, 38, 0.9);
            --bg-card: rgba(30, 41, 59, 0.6);
            --primary: #f97316;
            --primary-glow: rgba(249, 115, 22, 0.35);
            --accent: #38bdf8;
            --success: #10b981;
            --danger: #ef4444;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
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
            background-image: 
                radial-gradient(circle at 10% 10%, rgba(249, 115, 22, 0.1) 0%, transparent 40%),
                radial-gradient(circle at 90% 90%, rgba(56, 189, 248, 0.1) 0%, transparent 40%);
        }

        /* Topbar */
        .topbar {
            height: 60px;
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
        }

        .brand {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 20px;
            color: #fb923c;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .gm-tag {
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
            padding: 3px 10px;
            border-radius: 9999px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .nav-links {
            display: flex;
            gap: 12px;
        }

        .nav-link {
            padding: 6px 14px;
            border-radius: 8px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
            border: 1px solid transparent;
        }

        .nav-link:hover {
            color: var(--text-main);
            background: rgba(255, 255, 255, 0.05);
            border-color: var(--border);
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            width: 100%;
            margin: 24px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 24px;
        }

        /* Left Column: Player Search & Info */
        .panel {
            background: var(--bg-panel);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
        }

        .panel-title {
            font-family: 'Outfit', sans-serif;
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #f8fafc;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
        }

        .search-box {
            display: flex;
            gap: 8px;
        }

        .input-text {
            flex: 1;
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid var(--border);
            color: var(--text-main);
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
        }

        .input-text:focus {
            border-color: var(--primary);
        }

        .btn-search {
            background: var(--primary);
            color: white;
            border: none;
            padding: 0 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-search:hover {
            background: #ea580c;
        }

        /* Player Search Results */
        .player-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            max-height: 200px;
            overflow-y: auto;
        }

        .player-item {
            padding: 10px 12px;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s;
        }

        .player-item:hover, .player-item.active {
            border-color: var(--primary);
            background: rgba(249, 115, 22, 0.1);
        }

        .player-item-name {
            font-weight: 600;
            font-size: 13px;
            color: #f8fafc;
        }

        .player-item-meta {
            font-size: 11px;
            color: var(--text-muted);
        }

        /* Selected Player Card */
        .player-card {
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.8), rgba(15, 23, 42, 0.8));
            border: 1px solid rgba(249, 115, 22, 0.3);
            border-radius: 12px;
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .player-header {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .player-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(249, 115, 22, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #fb923c;
            border: 2px solid #fb923c;
        }

        .player-info-main h3 {
            font-size: 16px;
            font-weight: 700;
            color: #f8fafc;
        }

        .player-info-main span {
            font-size: 12px;
            color: var(--text-muted);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            margin-top: 6px;
        }

        .stat-item {
            background: rgba(0, 0, 0, 0.25);
            padding: 8px 10px;
            border-radius: 6px;
            font-size: 12px;
        }

        .stat-label {
            color: var(--text-muted);
            font-size: 11px;
            display: block;
        }

        .stat-value {
            font-weight: 700;
            color: #38bdf8;
            font-size: 13px;
        }

        /* Right Column: Actions */
        .action-tabs {
            display: flex;
            gap: 8px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
        }

        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .tab-btn.active {
            color: white;
            background: var(--primary);
            box-shadow: 0 0 12px var(--primary-glow);
        }

        .tab-content {
            display: none;
            flex-direction: column;
            gap: 20px;
            margin-top: 10px;
        }

        .tab-content.active {
            display: flex;
        }

        /* Action Cards */
        .action-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .action-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .action-card-title {
            font-size: 15px;
            font-weight: 700;
            color: #f8fafc;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-quick-65 {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-quick-65:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .currency-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .currency-col {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .currency-col label {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .btn-submit-action {
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            align-self: flex-start;
        }

        .btn-submit-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px var(--primary-glow);
        }

        /* Item Grid */
        .item-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .item-preset {
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 12px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .item-preset:hover, .item-preset.selected {
            border-color: #fb923c;
            background: rgba(249, 115, 22, 0.1);
        }

        .item-preset-icon {
            width: 36px;
            height: 36px;
            background: rgba(249, 115, 22, 0.2);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fb923c;
            font-size: 16px;
        }

        .item-preset-name {
            font-size: 13px;
            font-weight: 600;
            color: #f8fafc;
        }

        .item-preset-id {
            font-size: 11px;
            color: var(--text-muted);
        }

        /* Item Search live autocomplete */
        .item-search-box {
            position: relative;
            margin-bottom: 10px;
        }
        .item-search-results {
            position: absolute;
            top: calc(100% + 4px);
            left: 0;
            right: 0;
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 8px;
            max-height: 250px;
            overflow-y: auto;
            z-index: 999;
            box-shadow: 0 10px 30px rgba(0,0,0,0.7);
        }
        .item-search-row {
            padding: 10px 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            cursor: pointer;
            transition: background 0.15s;
        }
        .item-search-row:hover {
            background: rgba(249, 115, 22, 0.2);
        }
        .item-search-name {
            font-size: 13px;
            font-weight: 600;
            color: #f8fafc;
        }
        .item-search-badge {
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 4px;
            background: rgba(249, 115, 22, 0.2);
            color: #fb923c;
            font-weight: bold;
        }

        /* Toast notifications */
        #toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #1e293b;
            color: white;
            padding: 14px 20px;
            border-radius: 8px;
            border-left: 4px solid var(--success);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            z-index: 1000;
        }
    </style>
</head>
<body>

    <header class="topbar">
        <a href="Default.aspx" class="brand" id="gmBrand">
            <i class="fa-solid fa-gamepad"></i> GUNNY 9.2 <span class="gm-tag">GM TOOL</span>
        </a>
        <div class="nav-links">
            <a href="Default.aspx" class="nav-link" id="linkHome"><i class="fa-solid fa-house"></i> Trang Chủ</a>
            <a href="play.aspx" class="nav-link" id="linkPlay"><i class="fa-solid fa-play"></i> Vào Game</a>
        </div>
    </header>

    <div class="container">
        <!-- Left: Search & Player Profile -->
        <div class="panel">
            <div class="panel-title">
                <i class="fa-solid fa-user-gear"></i> Tìm Kiếm Nhân Vật
            </div>

            <div class="search-box">
                <input type="text" id="inputSearch" class="input-text" placeholder="Nhập Tên Nhân Vật (Nickname) hoặc Tài Khoản... (để trống để xem tất cả)" value="" onkeyup="if(event.keyCode===13) searchPlayer();" />
                <button class="btn-search" id="btnSearchPlayer" onclick="searchPlayer()">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm
                </button>
            </div>

            <div class="player-list" id="playerList">
                <!-- Search results rendered here -->
            </div>

            <!-- Profile Info -->
            <div class="player-card" id="playerCard" style="display: none;">
                <div class="player-header">
                    <div class="player-avatar" id="playerAvatarIcon">
                        <i class="fa-solid fa-user-ninja"></i>
                    </div>
                    <div class="player-info-main">
                        <h3 id="cardNickName">---</h3>
                        <span id="cardUserName">Tài khoản: ---</span>
                    </div>
                </div>

                <div class="stats-grid">
                    <div class="stat-item">
                        <span class="stat-label">Cấp Độ (Grade)</span>
                        <span class="stat-value" id="cardGrade">Lv.0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Lực Chiến</span>
                        <span class="stat-value" id="cardFightPower">0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Xu (Money)</span>
                        <span class="stat-value" id="cardMoney">0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Vàng (Gold)</span>
                        <span class="stat-value" id="cardGold">0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Lễ Kim (Gift)</span>
                        <span class="stat-value" id="cardGiftToken">0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Kinh Nghiệm (GP)</span>
                        <span class="stat-value" id="cardGp">0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right: Actions -->
        <div class="panel">
            <div class="action-tabs">
                <button class="tab-btn active" onclick="switchTab('tabLevel')" id="btnTabLevel">
                    <i class="fa-solid fa-angles-up"></i> Cấp Độ & Tiền Tệ
                </button>
                <button class="tab-btn" onclick="switchTab('tabItems')" id="btnTabItems">
                    <i class="fa-solid fa-gift"></i> Chuyển Đồ & Vũ Khí
                </button>
            </div>

            <!-- Tab 1: Cấp độ & Tiền tệ -->
            <div class="tab-content active" id="tabLevel">
                
                <!-- Quick Level 65 Button -->
                <div class="action-card" style="border-color: rgba(16, 185, 129, 0.4); background: rgba(16, 185, 129, 0.05);">
                    <div class="action-card-header">
                        <div>
                            <div class="action-card-title" style="color: #34d399;">
                                <i class="fa-solid fa-crown"></i> Nâng Cấp Nhanh: LEVEL 65
                            </div>
                            <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">
                                Đặt cấp độ nhân vật lên 65 (Grade = 65, GP = 333,333,333) để kiểm tra vào game ngay lập tức.
                            </p>
                        </div>
                        <button class="btn-quick-65" id="btnSetLv65" onclick="setQuickLevel(65)">
                            <i class="fa-solid fa-bolt"></i> SET LEVEL 65 NGAY
                        </button>
                    </div>
                </div>

                <!-- Custom Level -->
                <div class="action-card">
                    <div class="action-card-title">
                        <i class="fa-solid fa-gauge-high"></i> Tùy Chỉnh Cấp Độ
                    </div>
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <input type="number" id="customLevel" class="input-text" style="max-width: 150px;" min="1" max="70" value="65" />
                        <button class="btn-submit-action" id="btnSetCustomLevel" onclick="setCustomLevel()">
                            Cập Nhật Cấp Độ
                        </button>
                    </div>
                </div>

                <!-- Add Currency -->
                <div class="action-card">
                    <div class="action-card-title">
                        <i class="fa-solid fa-coins"></i> Cộng Tiền Tệ & Xu
                    </div>
                    <div class="currency-row">
                        <div class="currency-col">
                            <label>Cộng Xu (Money)</label>
                            <input type="number" id="addMoney" class="input-text" value="10000000" />
                        </div>
                        <div class="currency-col">
                            <label>Cộng Vàng (Gold)</label>
                            <input type="number" id="addGold" class="input-text" value="10000000" />
                        </div>
                        <div class="currency-col">
                            <label>Cộng Lễ Kim (GiftToken)</label>
                            <input type="number" id="addGiftToken" class="input-text" value="10000000" />
                        </div>
                    </div>
                    <button class="btn-submit-action" id="btnAddCurrency" onclick="addCurrency()">
                        <i class="fa-solid fa-plus-circle"></i> Cộng Tài Nguyên Ngay
                    </button>
                </div>

            </div>

            <!-- Tab 2: Chuyển đồ & Vũ khí -->
            <div class="tab-content" id="tabItems">
                <div class="action-card">
                    <div class="action-card-title">
                        <i class="fa-solid fa-wand-magic"></i> Chọn Vật Phẩm Mẫu
                    </div>
                    
                    <div class="item-grid" id="itemPresets">
                        <div class="item-preset selected" onclick="selectPreset(7014, 'WOW - Lu Gạch')">
                            <div class="item-preset-icon"><i class="fa-solid fa-cube"></i></div>
                            <div>
                                <div class="item-preset-name">WOW - Lu Gạch</div>
                                <div class="item-preset-id">ID: 7014</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(7010, 'WOW - Pháo')">
                            <div class="item-preset-icon"><i class="fa-solid fa-bomb"></i></div>
                            <div>
                                <div class="item-preset-name">WOW - Pháo</div>
                                <div class="item-preset-id">ID: 7010</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(7009, 'WOW - Sấm Sét')">
                            <div class="item-preset-icon"><i class="fa-solid fa-bolt-lightning"></i></div>
                            <div>
                                <div class="item-preset-name">WOW - Sấm Sét</div>
                                <div class="item-preset-id">ID: 7009</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(7023, 'SUPER - Boomerang')">
                            <div class="item-preset-icon"><i class="fa-solid fa-meteor"></i></div>
                            <div>
                                <div class="item-preset-name">SUPER - Boomerang</div>
                                <div class="item-preset-id">ID: 7023</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(7024, 'SUPER - Búa Lôi Đài')">
                            <div class="item-preset-icon"><i class="fa-solid fa-hammer"></i></div>
                            <div>
                                <div class="item-preset-name">SUPER - Búa Lôi Đài</div>
                                <div class="item-preset-id">ID: 7024</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(7022, 'SUPER - Thương Cổ')">
                            <div class="item-preset-icon"><i class="fa-solid fa-khanda"></i></div>
                            <div>
                                <div class="item-preset-name">SUPER - Thương Cổ</div>
                                <div class="item-preset-id">ID: 7022</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(11025, 'Đá Cường Hóa Lv5')">
                            <div class="item-preset-icon"><i class="fa-solid fa-gem"></i></div>
                            <div>
                                <div class="item-preset-name">Đá Cường Hóa Lv5</div>
                                <div class="item-preset-id">ID: 11025</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(311501, 'Châu Báu Sát Thương Lv5')">
                            <div class="item-preset-icon"><i class="fa-solid fa-ring"></i></div>
                            <div>
                                <div class="item-preset-name">Châu Báu Lv5</div>
                                <div class="item-preset-id">ID: 311501</div>
                            </div>
                        </div>

                        <div class="item-preset" onclick="selectPreset(11906, 'Thẻ VVIP 30 Ngày')">
                            <div class="item-preset-icon"><i class="fa-solid fa-id-card"></i></div>
                            <div>
                                <div class="item-preset-name">Thẻ VVIP</div>
                                <div class="item-preset-id">ID: 11906</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tìm kiếm theo tên -->
                <div class="action-card">
                    <div class="action-card-title">
                        <i class="fa-solid fa-magnifying-glass"></i> Tìm Kiếm Vật Phẩm / Vũ Khí Theo Tên
                    </div>
                    <div class="item-search-box">
                        <input type="text" id="itemSearchQuery" class="input-text" placeholder="Gõ tên vật phẩm, vũ khí (vd: VIP, Super, Lu gạch, Boomerang, Sấm sét, Đá, Châu báu, v.v.)..." oninput="onItemSearchInput()" autocomplete="off" />
                        <div id="itemSearchResults" class="item-search-results" style="display:none;"></div>
                    </div>
                    <div id="selectedItemDisplay" style="display:none; padding:8px 12px; border-radius:6px; background:rgba(34,197,94,0.15); border:1px solid rgba(34,197,94,0.3); color:#4ade80; font-size:13px; font-weight:600;"></div>
                </div>

                <div class="action-card">
                    <div class="action-card-title">
                        <i class="fa-solid fa-sliders"></i> Tùy Chỉnh Thông Số Vật Phẩm
                    </div>

                    <div class="currency-row">
                        <div class="currency-col">
                            <label>Template ID:</label>
                            <input type="number" id="itemTemplateId" class="input-text" value="7014" />
                        </div>
                        <div class="currency-col">
                            <label>Số lượng:</label>
                            <input type="number" id="itemCount" class="input-text" value="1" />
                        </div>
                        <div class="currency-col">
                            <label>Cấp Cường Hóa (+0 đến +15):</label>
                            <input type="number" id="itemStrengthen" class="input-text" value="12" min="0" max="15" />
                        </div>
                    </div>

                    <div class="currency-row">
                        <div class="currency-col">
                            <label>Hợp Thành (Công/Thủ/Nhanh/May):</label>
                            <input type="number" id="itemCompose" class="input-text" value="50" min="0" max="50" />
                        </div>
                        <div class="currency-col">
                            <label>Hạn Dùng (0 = Vĩnh Viễn, hoặc số ngày):</label>
                            <input type="number" id="itemValidDate" class="input-text" value="0" />
                        </div>
                    </div>

                    <button class="btn-submit-action" id="btnSendItemToMail" onclick="sendItem()">
                        <i class="fa-solid fa-paper-plane"></i> Chuyển Đồ Vào Hộp Thư Nhân Vật
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- Notification Toast -->
    <div id="toast">
        <i class="fa-solid fa-circle-check" style="color: #10b981;"></i>
        <span id="toastMsg">Thành công!</span>
    </div>

    <script>
        var selectedPlayer = null;

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

        function showToast(msg, isSuccess) {
            if (typeof isSuccess === 'undefined') isSuccess = true;
            var t = document.getElementById('toast');
            var m = document.getElementById('toastMsg');
            m.innerText = msg;
            t.style.borderLeftColor = isSuccess ? '#10b981' : '#ef4444';
            t.style.display = 'flex';
            setTimeout(function () { t.style.display = 'none'; }, 4500);
        }

        function switchTab(tabId) {
            var tabs = document.getElementsByClassName('tab-btn');
            for (var i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
            var contents = document.getElementsByClassName('tab-content');
            for (var j = 0; j < contents.length; j++) contents[j].classList.remove('active');

            document.getElementById(tabId).classList.add('active');
            if (tabId === 'tabLevel') document.getElementById('btnTabLevel').classList.add('active');
            if (tabId === 'tabItems') document.getElementById('btnTabItems').classList.add('active');
        }

        function selectPreset(id, name) {
            var presets = document.getElementsByClassName('item-preset');
            for (var i = 0; i < presets.length; i++) presets[i].classList.remove('selected');
            if (window.event && window.event.currentTarget) {
                window.event.currentTarget.classList.add('selected');
            }
            document.getElementById('itemTemplateId').value = id;
            showToast('Đã chọn ' + name);
        }

        function searchPlayer() {
            var q = document.getElementById('inputSearch').value.replace(/^\s+|\s+$/g, '');
            if (!q) q = '*'; // Search all recent players if empty

            ajaxGet('api.ashx?action=gm_search&q=' + encodeURIComponent(q), function (d) {
                var list = document.getElementById('playerList');
                list.innerHTML = '';
                if (d.success && d.players && d.players.length > 0) {
                    for (var i = 0; i < d.players.length; i++) {
                        (function (p) {
                            var div = document.createElement('div');
                            div.className = 'player-item';
                            div.innerHTML = '<div>' +
                                '<div class="player-item-name" style="color:#38bdf8; font-weight:700;"><i class="fa-solid fa-user-tag"></i> ' + (p.nickName || p.userName) + '</div>' +
                                '<div class="player-item-meta">Tài khoản: <strong>' + p.userName + '</strong> | ID: ' + p.userId + '</div>' +
                                '</div>' +
                                '<span style="font-weight: 700; color: #fb923c; font-size: 13px;">Lv.' + p.grade + '</span>';
                            div.onclick = function () { selectPlayer(p, div); };
                            list.appendChild(div);
                        })(d.players[i]);
                    }
                    // Automatically select first result
                    selectPlayer(d.players[0], list.children[0]);
                } else {
                    list.innerHTML = '<p style="font-size:12px; color:#94a3b8; padding:8px;">Không tìm thấy nhân vật nào. Hãy thử tìm theo Nickname hoặc Tên tài khoản khác.</p>';
                }
            });
        }

        function selectPlayer(p, el) {
            selectedPlayer = p;
            var items = document.getElementsByClassName('player-item');
            for (var i = 0; i < items.length; i++) items[i].classList.remove('active');
            if (el) el.classList.add('active');

            document.getElementById('playerCard').style.display = 'flex';
            document.getElementById('cardNickName').innerText = p.nickName || p.userName;
            document.getElementById('cardUserName').innerText = 'Tài khoản: ' + p.userName + ' (ID: ' + p.userId + ')';
            document.getElementById('cardGrade').innerText = 'Lv.' + p.grade;
            document.getElementById('cardFightPower').innerText = p.fightPower ? p.fightPower.toLocaleString() : '0';
            document.getElementById('cardMoney').innerText = p.money ? p.money.toLocaleString() : '0';
            document.getElementById('cardGold').innerText = p.gold ? p.gold.toLocaleString() : '0';
            document.getElementById('cardGiftToken').innerText = p.giftToken ? p.giftToken.toLocaleString() : '0';
            document.getElementById('cardGp').innerText = p.gp ? p.gp.toLocaleString() : '0';
        }

        function setQuickLevel(lvl) {
            if (!selectedPlayer) {
                showToast('Vui lòng chọn nhân vật trước!', false);
                return;
            }
            var url = 'api.ashx?action=gm_set_level&userId=' + selectedPlayer.userId + '&level=' + lvl;
            ajaxGet(url, function (d) {
                showToast(d.message, d.success);
                if (d.success) {
                    selectedPlayer.grade = lvl;
                    document.getElementById('cardGrade').innerText = 'Lv.' + lvl;
                    searchPlayer();
                }
            });
        }

        function setCustomLevel() {
            var lvl = parseInt(document.getElementById('customLevel').value);
            setQuickLevel(lvl);
        }

        function addCurrency() {
            if (!selectedPlayer) {
                showToast('Vui lòng chọn nhân vật trước!', false);
                return;
            }
            var m = document.getElementById('addMoney').value;
            var g = document.getElementById('addGold').value;
            var gt = document.getElementById('addGiftToken').value;

            var url = 'api.ashx?action=gm_add_currency&userId=' + selectedPlayer.userId + '&money=' + encodeURIComponent(m) + '&gold=' + encodeURIComponent(g) + '&giftToken=' + encodeURIComponent(gt);
            ajaxGet(url, function (d) {
                showToast(d.message, d.success);
                if (d.success) {
                    searchPlayer();
                }
            });
        }

        function sendItem() {
            if (!selectedPlayer) {
                showToast('Vui lòng chọn nhân vật trước!', false);
                return;
            }
            var tid = document.getElementById('itemTemplateId').value;
            var count = document.getElementById('itemCount').value;
            var str = document.getElementById('itemStrengthen').value;
            var comp = document.getElementById('itemCompose').value;
            var val = document.getElementById('itemValidDate').value;

            var url = 'api.ashx?action=gm_send_item&userId=' + selectedPlayer.userId + '&templateId=' + encodeURIComponent(tid) + '&count=' + encodeURIComponent(count) + '&strengthen=' + encodeURIComponent(str) + '&compose=' + encodeURIComponent(comp) + '&validDate=' + encodeURIComponent(val);
            ajaxGet(url, function (d) {
                showToast(d.message, d.success);
            });
        }

        var itemSearchTimer = null;
        function onItemSearchInput() {
            clearTimeout(itemSearchTimer);
            var q = document.getElementById('itemSearchQuery').value.trim();
            if (q.length < 1) {
                document.getElementById('itemSearchResults').style.display = 'none';
                return;
            }
            itemSearchTimer = setTimeout(function() {
                var url = 'api.ashx?action=gm_search_items&q=' + encodeURIComponent(q);
                ajaxGet(url, function(d) {
                    if (d.success && d.data) {
                        renderItemSearchResults(d.data);
                    }
                });
            }, 250);
        }

        function renderItemSearchResults(items) {
            var container = document.getElementById('itemSearchResults');
            if (!items || items.length === 0) {
                container.innerHTML = '<div style="padding:12px;text-align:center;color:#94a3b8;font-size:12px;">Không tìm thấy vật phẩm nào khớp từ khóa</div>';
                container.style.display = 'block';
                return;
            }
            var html = '';
            for (var i = 0; i < items.length; i++) {
                var it = items[i];
                var nameEsc = it.name.replace(/'/g, "\\'");
                html += '<div class="item-search-row" onclick="selectSearchedItem(' + it.templateId + ', \'' + nameEsc + '\')">' +
                    '<div><span class="item-search-name">' + it.name + '</span></div>' +
                    '<span class="item-search-badge">ID: ' + it.templateId + '</span>' +
                '</div>';
            }
            container.innerHTML = html;
            container.style.display = 'block';
        }

        function selectSearchedItem(tid, name) {
            document.getElementById('itemTemplateId').value = tid;
            document.getElementById('itemSearchResults').style.display = 'none';
            document.getElementById('itemSearchQuery').value = name;
            var disp = document.getElementById('selectedItemDisplay');
            disp.innerHTML = '<i class="fa-solid fa-check-circle"></i> Đã chọn: <strong>' + name + '</strong> (TemplateID: ' + tid + ')';
            disp.style.display = 'block';
        }

        if (window.addEventListener) {
            window.addEventListener('DOMContentLoaded', searchPlayer, false);
        } else if (window.attachEvent) {
            window.attachEvent('onload', searchPlayer);
        }
    </script>
</body>
</html>
