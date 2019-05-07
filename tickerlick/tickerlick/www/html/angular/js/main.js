var myHeading = document.querySelector('h1');
var myVariable = ['Thomas','Bob','Steve'];
//myHeading.innerHTML = 'Hello world!';
myHeading.innerHTML = myVariable[2];
function submitform(obj ) {
    var l = obj
           var s = l.q.value.split(" ");
           l.q.value = s[0];
            if (l.q.value === 'AAPL')
            
           {
                 myHeading.innerHTML = s[2];
                   }
           document.f.action = "/cgi-bin/gettickerdataone.cgi";
           document.f.submit();
           return true;

}

/*
document.querySelector('html').onclick = function() {
    alert('Ouch! Stop poking me!');
}
*/

var myImage = document.querySelectorAll('img');

myImage.onclick = function() {
    var mySrc = myImage.getAttribute('src');
    alert(mySrc);
    if(mySrc === 'images/up_g.gif') {
      myImage.setAttribute ('src','images/down_r.gif');
    } else {
      myImage.setAttribute ('src','images/up_g.gif');
    }
}
