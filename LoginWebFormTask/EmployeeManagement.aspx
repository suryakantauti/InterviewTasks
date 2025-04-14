<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeManagement.aspx.cs" Inherits="EmployeeManagement.EmployeeManagement" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Management</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .container { margin: 20px auto; max-width: 1200px; }
        .error { color: red; }
        .employee-table { width: 100%; margin-top: 20px; }
        .employee-table th, .employee-table td { padding: 10px; text-align: left; }
        .form-group { margin-bottom: 15px; }
        img { max-width: 100px; }
        .form-check-inline { margin-right: 20px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfFormVisible" runat="server" Value="false" />
        <div class="container">
            <h2>Employee Management</h2>
            <div style="width: 100%; text-align: right;">
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger float-right" OnClick="btnLogout_Click" />
            </div>
            <br />
            <hr />
            <div class="form-group">
                <asp:Button ID="btnInsertNew" runat="server" Text="Insert New Employee" CssClass="btn btn-success" OnClick="btnInsertNew_Click" />
            </div>
            <div id="employeeForm" runat="server">
                <div class="form-group">
                    <asp:HiddenField ID="hfEmpId" runat="server" />
                    <div class="row">
                        <div class="col-md-6">
                            <asp:Label ID="lblName" runat="server" Text="Name:" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter Name"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <asp:Label ID="lblDOB" runat="server" Text="Date of Birth:" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <asp:Label ID="lblSex" runat="server" Text="Sex:" CssClass="form-label"></asp:Label>
                            <asp:RadioButtonList ID="rblSex" runat="server" RepeatDirection="Horizontal" CssClass="col-md-8">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-6">
                            <asp:Label ID="lblPhone" runat="server" Text="Phone:" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Enter Phone"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <asp:Label ID="lblAddress" runat="server" Text="Address:" CssClass="form-label"></asp:Label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter Address"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <asp:Label ID="lblImage" runat="server" Text="Image:" CssClass="form-label"></asp:Label>
                            <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                            <asp:Image ID="imgPreview" runat="server" Visible="false" CssClass="mt-2" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
                    <asp:Label ID="lblMessage" runat="server" CssClass="error"></asp:Label>
                </div>
            </div>
            <asp:GridView ID="gvEmployees" runat="server" CssClass="employee-table table table-bordered" AutoGenerateColumns="false" OnRowCommand="gvEmployees_RowCommand">
                <Columns>
                    <asp:BoundField DataField="EmpID" HeaderText="ID" />
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="DOB" HeaderText="Date of Birth" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="Sex" HeaderText="Sex" />
                    <asp:BoundField DataField="Phone" HeaderText="Phone" />
                    <asp:BoundField DataField="Address" HeaderText="Address" />
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="imgEmployee" runat="server" ImageUrl='<%# Eval("ImagePath") %>' Width="50px" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditEmployee" CommandArgument='<%# Eval("EmpID") %>' CssClass="btn btn-warning btn-sm" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteEmployee" CommandArgument='<%# Eval("EmpID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Are you sure you want to delete this employee?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
    <script>
    $(document).ready(function () {
        console.log("Document ready");
        var isFormVisible = $("#<%= hfFormVisible.ClientID %>").val() === "true";
        console.log("Initial form visibility: " + (isFormVisible ? "Visible" : "Hidden"));
        if (isFormVisible) {
            $("#employeeForm").show();
        } else {
            $("#employeeForm").hide();
        }
        $("#<%= fuImage.ClientID %>").on("change", function () {
            console.log("File input changed");
            var file = this.files[0];
            var $preview = $("#<%= imgPreview.ClientID %>");
            if (file) {
                var fileSizeKB = file.size / 1024;
                console.log("File selected: " + file.name + " (" + fileSizeKB.toFixed(2) + " KB)");
                if (fileSizeKB > 256) {
                    console.log("File size exceeds 256 KB");
                    alert("File size should not exceed 256 KB.");
                    $(this).val("");
                    $preview.attr("src", "").css("display", "none");
                    return;
                }
                if (!file.type.match("image.*")) {
                    console.log("Invalid file type: " + file.type);
                    alert("Please select a valid image file (e.g., JPG, PNG).");
                    $(this).val("");
                    $preview.attr("src", "").css("display", "none");
                    return;
                }
                var reader = new FileReader();
                reader.onload = function (e) {
                    console.log("FileReader loaded: " + e.target.result.substring(0, 50));
                    $preview.attr("src", e.target.result).css({
                        "display": "block",
                        "max-width": "100px",
                        "margin-top": "10px"
                    });
                };
                reader.onerror = function (e) {
                    console.error("FileReader error: " + e);
                    alert("Error reading the image file.");
                    $preview.attr("src", "").css("display", "none");
                };
                reader.readAsDataURL(file);
            } else {
                console.log("No file selected");
                $preview.attr("src", "").css("display", "none");
            }
        });
        $("#<%= txtDOB.ClientID %>").on("change", function () {
            console.log("DOB input changed");
            var dob = $(this).val();
            if (dob) {
                var birthDate = new Date(dob);
                if (isNaN(birthDate.getTime())) {
                    console.log("Invalid DOB format: " + dob);
                    alert("Please enter a valid date of birth.");
                    $(this).val("");
                    return;
                }
                var today = new Date();
                var age = today.getFullYear() - birthDate.getFullYear();
                var monthDiff = today.getMonth() - birthDate.getMonth();
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                console.log("Calculated age: " + age);
                if (age < 18) {
                    console.log("Age validation failed: Age is " + age);
                    alert("Employee must be 18 years or older.");
                    $(this).val("");
                }
            } else {
                console.log("DOB cleared");
            }
        });
        $("#<%= btnSave.ClientID %>").on("click", function (e) {
            console.log("Save button clicked");
            var name = $("#<%= txtName.ClientID %>").val().trim();
            var dob = $("#<%= txtDOB.ClientID %>").val();
            var sex = $("input[name='<%= rblSex.UniqueID %>']:checked").val();
            var phone = $("#<%= txtPhone.ClientID %>").val().trim();
            var address = $("#<%= txtAddress.ClientID %>").val().trim();
            if (!name || !dob || !sex || !phone || !address) {
                console.log("Validation failed: Missing required fields");
                $("#<%= lblMessage.ClientID %>").text("Please fill all required fields.");
                $("#<%= hfFormVisible.ClientID %>").val("true");
                $("#employeeForm").show();
                return false;
            }
            var birthDate = new Date(dob);
            if (isNaN(birthDate.getTime())) {
                console.log("Validation failed: Invalid DOB format");
                $("#<%= lblMessage.ClientID %>").text("Please enter a valid date of birth.");
                $("#<%= hfFormVisible.ClientID %>").val("true");
                $("#employeeForm").show();
                return false;
            }

            var today = new Date();
            var age = today.getFullYear() - birthDate.getFullYear();
            var monthDiff = today.getMonth() - birthDate.getMonth();
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            if (age < 18) {
                console.log("Validation failed: Age is " + age);
                $("#<%= lblMessage.ClientID %>").text("Employee must be 18 years or older.");
                $("#<%= hfFormVisible.ClientID %>").val("true");
                $("#employeeForm").show();
                return false;
            }
            console.log("Validation passed: Submitting form");
            return true;
        });
    });
</script>
</body>
</html>