using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace EmployeeManagement
{
    public partial class LoginUserForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string sc = WebConfigurationManager.ConnectionStrings["EmpDB"].ConnectionString;
            SqlConnection con = new SqlConnection(sc);
            SqlCommand cmd = new SqlCommand("SPUserExists", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Username", username);
            cmd.Parameters.AddWithValue("@Password", password);
            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                Session["Role"] = dr["Role"].ToString();
                Session["Name"] = dr["Name"].ToString();
                Session["Phone"] = dr["Phone"].ToString();
                Response.Redirect("EmployeeManagement.aspx");
            }
            else lblMessage.Text = "Invalid username or password.";
        }
    }
}