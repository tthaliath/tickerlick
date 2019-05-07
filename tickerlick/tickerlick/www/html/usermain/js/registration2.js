$(document).ready(function() {
$("#signon").click(function() {
var fname = $("#fnamesignup").val();
var lname =  $("#lnamesignup").val(); 
var email = $("#emailsignup").val();
var password = $("#passwordsignup").val();
var cpassword = $("#cpasswordsignup").val();
//var re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;	
var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
if (fname == '' || email == '' || password == '' || cpassword == '') {
alert("Please fill all mandatory fields...!!!!!!");
} else if (email == '' || !re.test(email)){ alert('Please enter a valid email address.');
} else if ((password.length) < 6) {
alert("Password should atleast 6 character in length...!!!!!!");
} else if (!(password).match(cpassword)) {
alert("Your passwords don't match. Try again?");
} else {
$.post("php/register.php", {
name1: fname,
name2: lname,
email1: email,
password1: password
}, function(data) {
if (data == 'You have Successfully Registered.....') {
$("form")[0].reset();
}
alert(data);
});
}
});
});

