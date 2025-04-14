using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.Configuration;

namespace EmployeeManagement
{
    public partial class EmployeeManagement : System.Web.UI.Page
    {
        string sc = WebConfigurationManager.ConnectionStrings["EmpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Name"] == null) Response.Redirect("LoginUserForm.aspx");
            if (!IsPostBack)
            {
                BindGrid();
                ClearForm();
                hfFormVisible.Value = "false";
                employeeForm.Style["display"] = "none";
            }
            else employeeForm.Style["display"] = hfFormVisible.Value == "true" ? "block" : "none";
        }

        private void BindGrid()
        {
            SqlConnection con = new SqlConnection(sc);
            SqlCommand cmd = new SqlCommand("SPGetAllEmployee", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();
        }

        protected void btnInsertNew_Click(object sender, EventArgs e)
        {
            ClearForm();
            hfFormVisible.Value = "true";
            employeeForm.Style["display"] = "block";
            lblMessage.Text = "";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string name = txtName.Text.Trim();
                DateTime dob = DateTime.Parse(txtDOB.Text);
                string sex = rblSex.SelectedValue;
                string phone = txtPhone.Text.Trim();
                string address = txtAddress.Text.Trim();
                string imagePath = imgPreview.ImageUrl;
                if (fuImage.HasFile)
                {
                    string fileName = Path.GetFileName(fuImage.FileName);
                    string savePath = Server.MapPath("~/Assets/") + fileName;
                    fuImage.SaveAs(savePath);
                    imagePath = "~/Assets/" + fileName;
                }
                SqlConnection con = new SqlConnection(sc);
                SqlCommand cmd;
                if (string.IsNullOrEmpty(hfEmpId.Value))
                {
                    cmd = new SqlCommand("SPInsertEmployee", con);
                }
                else
                {
                    cmd = new SqlCommand("SPEditEmployee", con);
                    cmd.Parameters.AddWithValue("@EmpId", Convert.ToInt32(hfEmpId.Value));
                }
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@DOB", dob);
                cmd.Parameters.AddWithValue("@Sex", sex);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@ImagePath", imagePath);
                con.Open();
                cmd.ExecuteNonQuery();
                lblMessage.Text = "Employee saved successfully.";
                BindGrid();
                ClearForm();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfEmpId.Value = "";
            txtName.Text = "";
            txtDOB.Text = "";
            rblSex.ClearSelection();
            txtPhone.Text = "";
            txtAddress.Text = "";
            fuImage.Attributes.Clear();
            imgPreview.Visible = false;
            lblMessage.Text = "";
        }

        protected void gvEmployees_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int empId = int.Parse(e.CommandArgument.ToString());
            if (e.CommandName == "EditEmployee")
            {
                SqlConnection con = new SqlConnection(sc);
                SqlCommand cmd = new SqlCommand("SPGetEmployeeById", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        hfEmpId.Value = empId.ToString();
                        txtName.Text = reader["Name"].ToString();
                        txtDOB.Text = Convert.ToDateTime(reader["DOB"]).ToString("yyyy-MM-dd");
                        rblSex.SelectedValue = reader["Sex"].ToString();
                        txtPhone.Text = reader["Phone"].ToString();
                        txtAddress.Text = reader["Address"].ToString();
                        imgPreview.ImageUrl = reader["ImagePath"].ToString();
                        imgPreview.Visible = true;
                        hfFormVisible.Value = "true";
                        employeeForm.Style["display"] = "block";
                        lblMessage.Text = "";
                    }
                }
            }
            else if (e.CommandName == "DeleteEmployee")
            {
                SqlConnection con = new SqlConnection(sc);
                SqlCommand cmd = new SqlCommand("SPDeleteEmployee", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                con.Open();
                cmd.ExecuteNonQuery();
                lblMessage.Text = "Employee deleted successfully.";
                BindGrid();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("LoginUserForm.aspx");
        }
    }
}