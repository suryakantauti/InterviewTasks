<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginUserForm.aspx.cs" Inherits="EmployeeManagement.LoginUserForm" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .container { max-width: 400px; margin: 100px auto; background-color: lightgray; padding: 20px; border-radius: 20px }
        .error { color: red; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Login</h2>
            <div class="form-group">
                <asp:Label ID="lblUsername" runat="server" Text="Username:"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter Username"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label ID="lblPassword" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter Password"></asp:TextBox>
            </div>
            <div class="form-group d-flex justify-content-center">
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
            </div>
            <div class="form-group text-center">
                <asp:Label ID="lblMessage" runat="server" CssClass="error"></asp:Label>
            </div>
        </div>
    </form>
    <script>
        $(document).ready(function () {
            $("#btnLogin").click(function (e) {
                var username = $("#<%= txtUsername.ClientID %>").val().trim();
                var password = $("#<%= txtPassword.ClientID %>").val().trim();
                if (!username || !password) {
                    $("#<%= lblMessage.ClientID %>").text("Please enter both username and password.");
                    alert("Please enter both username and password.");
                    e.preventDefault();
                }
            });
            if ($("#<%= lblMessage.ClientID %>").text() === "Invalid username or password.") {
                alert("Invalid username or password.");
            }
        });
    </script>
</body>
</html>