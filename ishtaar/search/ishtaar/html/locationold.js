// JavaScript Document

function drop(obj) {
var l;
l = document.f1.s2

// Here Define the Option's for the Second Drop down menu

var india=new Array("Ahmedabad","Bangalore","Belgaum","Bhopal","Bhubaneswar","Chandigarh","Chennai","Cochin","Coimbatore","Erode","Gandhinagar","Goa","Gurgaon","Hisar","Hubli","Hyderabad","Indore","Jaipur","Jalandhar","Kolkata","Lucknow","Madurai","Meerut","Mumbai","Nagpur","Nasik","New delhi","Noida","Pondicherry","Pune","Raipur","Rajkot","Secunderabad","Thane","Thanjavur","Tirunelveli","Tirupur","Trichy","Trivandrum","Vadodara","Vellore","Visakapatnam");
var indiaId=new Array(1,33,34,2,22,3,4,5,6,35,7,8,10,31,36,12,13,14,15,16,17,37,38,32,18,19,20,21,39,23,24,25,26,40,41,42,43,44,28,29,45,30);




// here Test it the Yamaha From the First Drop Down menu is Selected

if(document.f1.s1.options[document.f1.s1.options.selectedIndex].text== 'India'){
l.length=0
for(i=0; i<india.length; i++) {
document.f1.s2.options[i] = new Option(india[i])
document.f1.s2.options[i].value = indiaId[i]

}
return;
}
else {
l.length=0;
}

}
