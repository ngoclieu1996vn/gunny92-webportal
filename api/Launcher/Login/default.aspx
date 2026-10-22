<%@ Page Language="C#" AutoEventWireup="true" ResponseEncoding="utf-8" ContentType="text/plain; charset=utf-8" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    private const string ConnStr = "Server=127.0.0.1;User Id=sa;Password=abcd@12344;TrustServerCertificate=True;";

    protected void Page_Load(object sender, EventArgs e)
    {
        string username = (Request["username"] ?? "").Trim();
        string password = (Request["password"] ?? "").Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            Response.Write("0|Tài khoản hoặc mật khẩu không được để trống.");
            return;
        }

        try
        {
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
                            bool isBan = r["IsBan"] != DBNull.Value && Convert.ToBoolean(r["IsBan"]);
                            if (isBan)
                            {
                                Response.Write("0|Tài khoản này đã bị khóa.");
                                return;
                            }

                            string storedPwd = r["Password"] != DBNull.Value ? r["Password"].ToString() : "";
                            if (VerifyPassword(password, storedPwd))
                            {
                                string token = Guid.NewGuid().ToString("N");
                                Response.Write("1|" + token);
                                return;
                            }
                        }
                    }
                }
            }

            Response.Write("0|Tài khoản hoặc mật khẩu không chính xác.");
        }
        catch (Exception ex)
        {
            Response.Write("0|Lỗi máy chủ: " + ex.Message);
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
        if (storedPwd.Equals(HashPassword(inputPwd), StringComparison.OrdinalIgnoreCase)) return true;
        if (storedPwd.Equals(inputPwd, StringComparison.OrdinalIgnoreCase)) return true;
        return false;
    }
</script>
