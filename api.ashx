<%@ WebHandler Language="C#" Class="WebPortal.ApiHandler" %>
using System;
using System.Web;
using System.Web.SessionState;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Net;
using System.Collections.Generic;

namespace WebPortal
{
    public class ApiHandler : IHttpHandler, IRequiresSessionState
    {
        private const string ConnStr = "Server=127.0.0.1;User Id=sa;Password=abcd@12344;TrustServerCertificate=True;";
        private const string LoginKey = "taolacuopday_WAN-0668-2555555-7ROAD-dandantang-love777nguyenluulathangloznaothe-gunny92";

        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json; charset=utf-8";
            context.Response.ContentEncoding = System.Text.Encoding.UTF8;
            context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
            context.Response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
            context.Response.Headers.Add("Access-Control-Allow-Headers", "Content-Type");

            if (context.Request.HttpMethod == "OPTIONS")
            {
                context.Response.End();
                return;
            }

            string action = context.Request["action"] ?? "";

            // Check if request is launcher login POST to /api/login131
            if (context.Request.Path.EndsWith("login131", StringComparison.OrdinalIgnoreCase))
            {
                action = "login131";
            }

            try
            {
                switch (action.ToLower())
                {
                    case "register":
                        HandleRegister(context);
                        break;
                    case "login":
                        HandleLogin(context);
                        break;
                    case "login131":
                        HandleLauncherLogin(context);
                        break;
                    case "session":
                        HandleCheckSession(context);
                        break;
                    case "logout":
                        HandleLogout(context);
                        break;
                    case "servers":
                        HandleGetServers(context);
                        break;
                    case "gm_search":
                        HandleGmSearch(context);
                        break;
                    case "gm_set_level":
                        HandleGmSetLevel(context);
                        break;
                    case "gm_add_currency":
                        HandleGmAddCurrency(context);
                        break;
                    case "gm_send_item":
                        HandleGmSendItem(context);
                        break;
                    case "gm_search_items":
                        HandleGmSearchItems(context);
                        break;
                    case "gm_unlock_fashion":
                        HandleGmUnlockFashion(context);
                        break;
                    default:
                        context.Response.Write("{\"success\":false,\"message\":\"Invalid action\"}");
                        break;
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("{\"success\":false,\"message\":" + EncodeJson(ex.Message) + "}");
            }
        }

        private void HandleRegister(HttpContext context)
        {
            string username = (context.Request["username"] ?? "").Trim().ToLower();
            string password = (context.Request["password"] ?? "").Trim();

            if (string.IsNullOrEmpty(username) || username.Length < 3 || username.Length > 30)
            {
                context.Response.Write("{\"success\":false,\"message\":\"Tên tài khoản từ 3 - 30 ký tự!\"}");
                return;
            }

            if (string.IsNullOrEmpty(password) || password.Length < 4)
            {
                context.Response.Write("{\"success\":false,\"message\":\"Mật khẩu phải từ 4 ký tự trở lên!\"}");
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                // Check if account already exists
                using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(1) FROM Db_Member.dbo.Mem_Account WHERE Email = @user", conn))
                {
                    checkCmd.Parameters.AddWithValue("@user", username);
                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        context.Response.Write("{\"success\":false,\"message\":\"Tài khoản này đã tồn tại!\"}");
                        return;
                    }
                }

                // Insert into Mem_Account
                string pwdHash = HashPassword(password);
                int timeNow = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

                using (SqlCommand insCmd = new SqlCommand(@"
                    INSERT INTO Db_Member.dbo.Mem_Account (Email, Password, Fullname, TimeCreate, Money, IsBan, AllowSocialLogin)
                    VALUES (@user, @pwd, @user, @time, 100000, 0, 1)", conn))
                {
                    insCmd.Parameters.AddWithValue("@user", username);
                    insCmd.Parameters.AddWithValue("@pwd", pwdHash);
                    insCmd.Parameters.AddWithValue("@time", timeNow);
                    insCmd.ExecuteNonQuery();
                }

                context.Session["Username"] = username;
                context.Response.Write("{\"success\":true,\"message\":\"Đăng ký thành công!\",\"username\":" + EncodeJson(username) + "}");
            }
        }

        private void HandleLogin(HttpContext context)
        {
            string username = (context.Request["username"] ?? "").Trim().ToLower();
            string password = (context.Request["password"] ?? "").Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                context.Response.Write("{\"success\":false,\"message\":\"Vui lòng nhập tài khoản và mật khẩu!\"}");
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT UserID, Password, IsBan FROM Db_Member.dbo.Mem_Account WHERE Email = @user", conn))
                {
                    cmd.Parameters.AddWithValue("@user", username);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            bool isBan = Convert.ToBoolean(r["IsBan"]);
                            if (isBan)
                            {
                                context.Response.Write("{\"success\":false,\"message\":\"Tài khoản của bạn đã bị khóa!\"}");
                                return;
                            }

                            string storedPwd = r["Password"] != DBNull.Value ? r["Password"].ToString() : "";
                            bool matched = VerifyPassword(password, storedPwd);

                            if (matched)
                            {
                                context.Session["Username"] = username;
                                context.Response.Write("{\"success\":true,\"message\":\"Đăng nhập thành công!\",\"username\":" + EncodeJson(username) + "}");
                                return;
                            }
                        }
                    }
                }
            }

            context.Response.Write("{\"success\":false,\"message\":\"Tài khoản hoặc mật khẩu không chính xác!\"}");
        }

        private void HandleLauncherLogin(HttpContext context)
        {
            string username = context.Request["username"] ?? "";
            string password = context.Request["password"] ?? "";

            if (string.IsNullOrEmpty(username) && context.Request.HttpMethod == "POST")
            {
                using (StreamReader reader = new StreamReader(context.Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        if (body.StartsWith("{"))
                        {
                            var dict = ParseSimpleJson(body);
                            dict.TryGetValue("username", out username);
                            dict.TryGetValue("password", out password);
                        }
                        else
                        {
                            var nvc = HttpUtility.ParseQueryString(body);
                            username = nvc["username"] ?? "";
                            password = nvc["password"] ?? "";
                        }
                    }
                }
            }

            username = username.Trim().ToLower();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT UserID, Password, IsBan FROM Db_Member.dbo.Mem_Account WHERE Email = @user", conn))
                {
                    cmd.Parameters.AddWithValue("@user", username);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            bool isBan = Convert.ToBoolean(r["IsBan"]);
                            if (isBan)
                            {
                                context.Response.Write("{\"success\":false,\"message\":\"Tài khoản bị khóa!\"}");
                                return;
                            }

                            string storedPwd = r["Password"] != DBNull.Value ? r["Password"].ToString() : "";
                            if (VerifyPassword(password, storedPwd))
                            {
                                string token = Guid.NewGuid().ToString("N");
                                HttpRuntime.Cache.Insert("LauncherToken_" + token, username, null, DateTime.Now.AddHours(24), System.Web.Caching.Cache.NoSlidingExpiration);
                                context.Session["LauncherToken_" + token] = username;
                                context.Session["Username"] = username;

                                // Also call CreateLogin.aspx to prime game server
                                CallCreateLogin(username, token.Substring(0, 8));

                                context.Response.Write("{\"success\":true,\"data\":{\"token\":\"" + token + "\",\"userInfo\":{\"id\":1,\"username\":\"" + username + "\"}}}");
                                return;
                            }
                        }
                    }
                }
            }

            context.Response.Write("{\"success\":false,\"message\":\"Tài khoản hoặc mật khẩu không chính xác!\"}");
        }

        private void HandleCheckSession(HttpContext context)
        {
            string username = context.Session["Username"] as string;
            if (!string.IsNullOrEmpty(username))
            {
                context.Response.Write("{\"loggedIn\":true,\"username\":" + EncodeJson(username) + "}");
            }
            else
            {
                context.Response.Write("{\"loggedIn\":false}");
            }
        }

        private void HandleLogout(HttpContext context)
        {
            context.Session.Clear();
            context.Session.Abandon();
            context.Response.Write("{\"success\":true,\"message\":\"Đã đăng xuất!\"}");
        }

        private void HandleGetServers(HttpContext context)
        {
            context.Response.Write("[{\"id\":4,\"name\":\"Server 1 - Gà Chọi\",\"ip\":\"221.121.4.241\",\"port\":9200,\"status\":\"Online\",\"state\":2}]");
        }

        private void HandleGmSearch(HttpContext context)
        {
            string q = (context.Request["q"] ?? "").Trim();

            List<string> jsonPlayers = new List<string>();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string sql;
                if (string.IsNullOrEmpty(q) || q == "*" || q.Equals("all", StringComparison.OrdinalIgnoreCase))
                {
                    sql = @"SELECT TOP 25 UserID, UserName, NickName, Grade, GP, Money, Gold, GiftToken, FightPower, Sex, Repute 
                            FROM Db_Tank41.dbo.Sys_Users_Detail 
                            ORDER BY UserID DESC";
                }
                else
                {
                    sql = @"SELECT TOP 25 UserID, UserName, NickName, Grade, GP, Money, Gold, GiftToken, FightPower, Sex, Repute 
                            FROM Db_Tank41.dbo.Sys_Users_Detail 
                            WHERE NickName LIKE @q OR UserName LIKE @q OR CONVERT(varchar, UserID) = @exactQ
                            ORDER BY Grade DESC";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (!string.IsNullOrEmpty(q) && q != "*" && !q.Equals("all", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.Add("@q", SqlDbType.NVarChar, 100).Value = "%" + q + "%";
                        cmd.Parameters.AddWithValue("@exactQ", q);
                    }
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            jsonPlayers.Add(string.Format(
                                "{{\"userId\":{0},\"userName\":{1},\"nickName\":{2},\"grade\":{3},\"gp\":{4},\"money\":{5},\"gold\":{6},\"giftToken\":{7},\"fightPower\":{8},\"sex\":{9}}}",
                                r["UserID"],
                                EncodeJson(r["UserName"].ToString()),
                                EncodeJson(r["NickName"].ToString()),
                                r["Grade"],
                                r["GP"],
                                r["Money"],
                                r["Gold"],
                                r["GiftToken"],
                                r["FightPower"],
                                Convert.ToBoolean(r["Sex"]) ? "true" : "false"
                            ));
                        }
                    }
                }
            }
            context.Response.Write("{\"success\":true,\"players\":[" + string.Join(",", jsonPlayers.ToArray()) + "]}");
        }

        private void HandleGmSetLevel(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int level = Convert.ToInt32(context.Request["level"] ?? "65");
            if (level < 1) level = 1;
            if (level > 65) level = 65;

            // 1. Kick online session first so Road.Service writes old RAM state and frees session
            CallGMBridge("kick", userId);
            System.Threading.Thread.Sleep(1200);

            // 2. Query exact GP for target level from Db_Tank.dbo.LevelInfo
            long gp = 300000000;
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmdGp = new SqlCommand("SELECT GP FROM Db_Tank.dbo.LevelInfo WHERE Grade = @lvl", conn))
                {
                    cmdGp.Parameters.AddWithValue("@lvl", level);
                    object res = cmdGp.ExecuteScalar();
                    if (res != null && res != DBNull.Value) gp = Convert.ToInt64(res);
                }

                using (SqlCommand cmd = new SqlCommand("UPDATE Db_Tank41.dbo.Sys_Users_Detail SET Grade = @lvl, GP = @gp WHERE UserID = @uid", conn))
                {
                    cmd.Parameters.AddWithValue("@lvl", level);
                    cmd.Parameters.AddWithValue("@gp", gp);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    int aff = cmd.ExecuteNonQuery();
                    if (aff > 0)
                    {
                        context.Response.Write("{\"success\":true,\"message\":\"Đã chỉnh nhân vật lên Level " + level + " (GP: " + gp.ToString("N0") + ") thành công! Vào lại game nhân vật sẽ hiển thị chuẩn Level " + level + "!\"}");
                        return;
                    }
                }
            }
            context.Response.Write("{\"success\":false,\"message\":\"Không tìm thấy nhân vật!\"}");
        }

        private void HandleGmSearchItems(HttpContext context)
        {
            string q = (context.Request["q"] ?? "").Trim();
            if (string.IsNullOrEmpty(q))
            {
                context.Response.Write("{\"success\":true,\"data\":[]}");
                return;
            }

            var list = new List<string>();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 30 TemplateID, Name, CategoryID, Quality 
                    FROM Db_Tank.dbo.Shop_Goods 
                    WHERE Name LIKE @query OR CAST(TemplateID AS NVARCHAR) = @qExact
                    ORDER BY CASE WHEN Name LIKE @queryStart THEN 1 ELSE 2 END, TemplateID", conn))
                {
                    cmd.Parameters.AddWithValue("@query", "%" + q + "%");
                    cmd.Parameters.AddWithValue("@queryStart", q + "%");
                    cmd.Parameters.AddWithValue("@qExact", q);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            int tid = Convert.ToInt32(r["TemplateID"]);
                            string name = r["Name"] != DBNull.Value ? r["Name"].ToString() : "";
                            int cat = Convert.ToInt32(r["CategoryID"]);
                            int quality = Convert.ToInt32(r["Quality"]);

                            string itemJson = "{" +
                                "\"templateId\":" + tid + "," +
                                "\"name\":" + EncodeJson(name) + "," +
                                "\"categoryId\":" + cat + "," +
                                "\"quality\":" + quality +
                            "}";
                            list.Add(itemJson);
                        }
                    }
                }
            }

            context.Response.Write("{\"success\":true,\"data\":[" + string.Join(",", list.ToArray()) + "]}");
        }

        private void HandleGmAddCurrency(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int money = Convert.ToInt32(context.Request["money"] ?? "0");
            int gold = Convert.ToInt32(context.Request["gold"] ?? "0");
            int giftToken = Convert.ToInt32(context.Request["giftToken"] ?? "0");

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE Db_Tank41.dbo.Sys_Users_Detail 
                    SET Money = Money + @m, Gold = Gold + @g, GiftToken = GiftToken + @gt 
                    WHERE UserID = @uid", conn))
                {
                    cmd.Parameters.AddWithValue("@m", money);
                    cmd.Parameters.AddWithValue("@g", gold);
                    cmd.Parameters.AddWithValue("@gt", giftToken);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    int aff = cmd.ExecuteNonQuery();
                    if (aff > 0)
                    {
                        CallGMBridge("charge", userId);
                        context.Response.Write("{\"success\":true,\"message\":\"Đã cộng " + money.ToString("N0") + " Xu, " + gold.ToString("N0") + " Vàng, " + giftToken.ToString("N0") + " Lễ Kim!\"}");
                        return;
                    }
                }
            }
            context.Response.Write("{\"success\":false,\"message\":\"Không tìm thấy nhân vật!\"}");
        }

        private void HandleGmSendItem(HttpContext context)
        {
            int userId = Convert.ToInt32(context.Request["userId"]);
            int templateId = Convert.ToInt32(context.Request["templateId"]);
            int count = Convert.ToInt32(context.Request["count"] ?? "1");
            int strengthen = Convert.ToInt32(context.Request["strengthen"] ?? "12");
            int compose = Convert.ToInt32(context.Request["compose"] ?? "50");
            int validDate = Convert.ToInt32(context.Request["validDate"] ?? "0"); // 0 = vĩnh viễn

            if (count <= 0)
            {
                context.Response.Write("{\"success\":false,\"message\":\"Số lượng vật phẩm phải lớn hơn 0.\"}");
                return;
            }

            string nickName = "";
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand qCmd = new SqlCommand("SELECT NickName FROM Db_Tank41.dbo.Sys_Users_Detail WHERE UserID = @uid", conn))
                {
                    qCmd.Parameters.AddWithValue("@uid", userId);
                    object nickObj = qCmd.ExecuteScalar();
                    if (nickObj != null) nickName = nickObj.ToString();
                }

                if (string.IsNullOrEmpty(nickName))
                {
                    context.Response.Write("{\"success\":false,\"message\":\"Không tìm thấy người nhận!\"}");
                    return;
                }

                // The send procedure reads the player database's catalog, not the GM search table.
                using (SqlCommand templateCmd = new SqlCommand("SELECT MaxCount FROM Db_Tank41.dbo.Shop_Goods WHERE TemplateID = @tid", conn))
                {
                    templateCmd.Parameters.AddWithValue("@tid", templateId);
                    object maxCount = templateCmd.ExecuteScalar();
                    if (maxCount == null || maxCount == DBNull.Value || Convert.ToInt32(maxCount) <= 0)
                    {
                        context.Response.Write("{\"success\":false,\"message\":\"Vật phẩm chưa có trong danh mục gửi thư hoặc không thể gửi. Hãy đồng bộ danh mục trước.\"}");
                        return;
                    }
                }

                using (SqlCommand cmd = new SqlCommand("Db_Tank41.dbo.SP_Admin_SendUserItem", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ItemID", 0);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@TemplateID", templateId);
                    cmd.Parameters.AddWithValue("@Place", 0);
                    cmd.Parameters.AddWithValue("@Count", count);
                    cmd.Parameters.AddWithValue("@IsJudge", true);
                    cmd.Parameters.AddWithValue("@Color", "");
                    cmd.Parameters.AddWithValue("@IsExist", true);
                    cmd.Parameters.AddWithValue("@StrengthenLevel", strengthen);
                    cmd.Parameters.AddWithValue("@AttackCompose", compose);
                    cmd.Parameters.AddWithValue("@DefendCompose", compose);
                    cmd.Parameters.AddWithValue("@LuckCompose", compose);
                    cmd.Parameters.AddWithValue("@AgilityCompose", compose);
                    cmd.Parameters.AddWithValue("@IsBinds", true);
                    cmd.Parameters.AddWithValue("@BeginDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@ValidDate", validDate);
                    cmd.Parameters.AddWithValue("@BagType", 0);
                    cmd.Parameters.AddWithValue("@ID", 0);
                    cmd.Parameters.AddWithValue("@SenderID", 1);
                    cmd.Parameters.AddWithValue("@Sender", "Admin GM");
                    cmd.Parameters.AddWithValue("@ReceiverID", userId);
                    cmd.Parameters.AddWithValue("@Receiver", nickName);
                    cmd.Parameters.AddWithValue("@Title", "Quà tặng từ GM Gunny 9.2");
                    cmd.Parameters.AddWithValue("@Content", "Chúc bạn trải nghiệm game Gunny 9.2 thật vui vẻ!");
                    cmd.Parameters.AddWithValue("@SendTime", DateTime.Now);
                    cmd.Parameters.AddWithValue("@IsRead", false);
                    cmd.Parameters.AddWithValue("@IsDelR", false);
                    cmd.Parameters.AddWithValue("@IfDelS", false);
                    cmd.Parameters.AddWithValue("@IsDelete", false);
                    cmd.Parameters.AddWithValue("@Annex1", "");
                    cmd.Parameters.AddWithValue("@Annex2", "");
                    cmd.Parameters.AddWithValue("@Gold", 0);
                    cmd.Parameters.AddWithValue("@Money", 0);

                    cmd.ExecuteNonQuery();
                }

                // Notify game server in real time via MailNotice WCF
                CallGMBridge("mail", userId);
            }

            context.Response.Write("{\"success\":true,\"message\":\"Đã gửi thư chứa vật phẩm thành công tới " + nickName + "! Hộp thư trong game sẽ sáng lên ngay lập tức (không cần F5).\"}");
        }

        private void HandleGmUnlockFashion(HttpContext context)
        {
            int userId = 0;
            int.TryParse(context.Request["userId"], out userId);

            if (userId <= 0)
            {
                context.Response.Write("{\"success\":false,\"message\":\"UserId không hợp lệ!\"}");
                return;
            }

            // 1. Kick session first so Road.Service doesn't overwrite DB upon exit
            CallGMBridge("kick", userId);
            System.Threading.Thread.Sleep(1200);

            string suitList = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Delete existing avatar collections for this user
                        using (SqlCommand cmdDel = new SqlCommand("DELETE FROM Db_Tank41.dbo.User_Avatar_Colection WHERE UserID = @uid", conn, trans))
                        {
                            cmdDel.Parameters.AddWithValue("@uid", userId);
                            cmdDel.ExecuteNonQuery();
                        }

                        // 2. Insert all 71 avatar collections with full active items & expiry 2099
                        string sqlInsertAvatar = @"
                            INSERT INTO Db_Tank41.dbo.User_Avatar_Colection (UserID, endTime, dataId, ActiveCount, Sex, ActiveDress)
                            SELECT 
                                @uid AS UserID,
                                CAST('2099-12-31 23:59:59' AS DATETIME) AS endTime,
                                c.ID AS dataId,
                                COUNT(g.TemplateID) AS ActiveCount,
                                c.Sex,
                                ISNULL(STRING_AGG(CAST(g.TemplateID AS varchar(20)), ','), '') AS ActiveDress
                            FROM Db_Tank.dbo.Cloth_Property_Template c
                            LEFT JOIN Db_Tank.dbo.Cloth_Group_Template g ON c.ID = g.ID AND c.Sex = g.Sex
                            GROUP BY c.ID, c.Sex;";
                        using (SqlCommand cmdAvatar = new SqlCommand(sqlInsertAvatar, conn, trans))
                        {
                            cmdAvatar.Parameters.AddWithValue("@uid", userId);
                            cmdAvatar.ExecuteNonQuery();
                        }

                        // 3. Insert or Update Suit_Manager
                        string sqlSuit = @"
                            IF EXISTS (SELECT 1 FROM Db_Tank41.dbo.Suit_Manager WHERE UserID = @uid)
                                UPDATE Db_Tank41.dbo.Suit_Manager SET Kill_List = @suitList WHERE UserID = @uid;
                            ELSE
                                INSERT INTO Db_Tank41.dbo.Suit_Manager (UserID, Kill_List) VALUES (@uid, @suitList);";
                        using (SqlCommand cmdSuit = new SqlCommand(sqlSuit, conn, trans))
                        {
                            cmdSuit.Parameters.AddWithValue("@uid", userId);
                            cmdSuit.Parameters.AddWithValue("@suitList", suitList);
                            cmdSuit.ExecuteNonQuery();
                        }

                        // 4. Update fineSuitExp to max (345,860) in Sys_Users_Detail
                        using (SqlCommand cmdExp = new SqlCommand("UPDATE Db_Tank41.dbo.Sys_Users_Detail SET fineSuitExp = 345860 WHERE UserID = @uid", conn, trans))
                        {
                            cmdExp.Parameters.AddWithValue("@uid", userId);
                            cmdExp.ExecuteNonQuery();
                        }

                        trans.Commit();
                        context.Response.Write("{\"success\":true,\"message\":\"Kích hoạt full 71 Bộ Sưu Tập Thời Trang (vĩnh viễn 2099), mở khóa toàn bộ 46 Trang Phục (Suits) và Max Tinh Luyện thành công!\"}");
                        return;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        context.Response.Write("{\"success\":false,\"message\":" + EncodeJson("Lỗi kích hoạt thời trang: " + ex.Message) + "}");
                        return;
                    }
                }
            }
        }

        private static void CallGMBridge(string action, int uid)
        {
            try
            {
                string url = "http://127.0.0.1/request/GMBridge.ashx?action=" + action + "&uid=" + uid;
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
                req.Timeout = 3000;
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                {
                    // Success
                }
            }
            catch {}
        }

        private static bool CallCreateLogin(string username, string key)
        {
            try
            {
                int timeNow = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                string raw = username + key + timeNow.ToString() + LoginKey;
                string hash = Md5Hex(raw);
                string content = username + "|" + key + "|" + timeNow + "|" + hash;
                string url = "http://127.0.0.1/request/CreateLogin.aspx?content=" + Uri.EscapeDataString(content);

                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
                req.Timeout = 5000;
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                using (StreamReader r = new StreamReader(resp.GetResponseStream()))
                {
                    string res = r.ReadToEnd().Trim();
                    return res == "0";
                }
            }
            catch
            {
                return false;
            }
        }

        private static string HashPassword(string pwd)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(pwd + "_salt_gunny92"));
                return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }
        }

        private static bool VerifyPassword(string inputPwd, string storedPwd)
        {
            if (string.IsNullOrEmpty(storedPwd)) return false;
            if (storedPwd == inputPwd) return true;
            if (storedPwd.Equals(Md5Hex(inputPwd), StringComparison.OrdinalIgnoreCase)) return true;
            if (storedPwd.Equals(HashPassword(inputPwd), StringComparison.OrdinalIgnoreCase)) return true;
            // Also accept if stored is bcrypt and matches via php standard or direct match
            return false;
        }

        private static string Md5Hex(string input)
        {
            using (MD5 md5 = MD5.Create())
            {
                byte[] b = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
                StringBuilder sb = new StringBuilder();
                foreach (byte x in b) sb.Append(x.ToString("x2"));
                return sb.ToString();
            }
        }

        private static string EncodeJson(string s)
        {
            if (s == null) return "\"\"";
            return "\"" + s.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "").Replace("\n", "\\n") + "\"";
        }

        private static Dictionary<string, string> ParseSimpleJson(string json)
        {
            var dict = new Dictionary<string, string>();
            json = json.Trim().Trim('{', '}');
            string[] pairs = json.Split(',');
            foreach (var p in pairs)
            {
                var kv = p.Split(new char[] { ':' }, 2);
                if (kv.Length == 2)
                {
                    string key = kv[0].Trim().Trim('"');
                    string val = kv[1].Trim().Trim('"');
                    dict[key] = val;
                }
            }
            return dict;
        }
    }
}
