// JavaScript Document
// Get form elements

var firstName = document.getElementById('firstName');
var lastName = document.getElementById('lastName');
var email = document.getElementById('email');
var userName = document.getElementById('userName');
var password = document.getElementById('password');


// Disable element
/* 
function disableEl(element) {
    element.disabled = true;
}*/


// Enable element
function enableEl(element) {
    element.disabled = false;
}


// Validate First Name and Last Name
function checkNameInput(minLength, name) {

    var elMsg;
    var elGroup;
    var nameRegex = /^[A-Za-z'-]+$/;

    if (name.id === 'firstName') {

        elMsg = document.getElementById('fnFeedback');
        elGroup = document.getElementById('fnGroup');

    }
    else {

        elMsg = document.getElementById('lnFeedback');
        elGroup = document.getElementById('lnGroup');

    }

    if (name.value.trim().length < minLength) {

        elGroup.classList.remove('has-success');
        elGroup.classList.add('has-error');

        elMsg.innerHTML = 'Name must be ' + minLength + ' characters or more';

        enableEl(name);
        return false;

    }
    else if (!nameRegex.test(name.value.trim())) {

        elGroup.classList.remove('has-success');
        elGroup.classList.add('has-error');

        elMsg.innerHTML ='Only letters, hyphens, and apostrophes allowed';

        enableEl(name);
        return false;

    }
    else {

        elGroup.classList.remove('has-error');
        elGroup.classList.add('has-success');

        elMsg.innerHTML = 'Valid name!';

        //disableEl(name);
        return true;

    }
}


// Validate Email
function checkEmail() {

    var elMsg = document.getElementById('emailFeedback');
    var elGroup = document.getElementById('emailGroup');

    //var validRegex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var validRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!validRegex.test(email.value.trim())) {

        elGroup.classList.remove('has-success');
        elGroup.classList.add('has-error');

        elMsg.innerHTML = 'Please enter a valid email address';

        enableEl(email);
        return false;

    }
    else {

        elGroup.classList.remove('has-error');
        elGroup.classList.add('has-success');

        elMsg.innerHTML = 'Valid email!';

        //disableEl(email);
        return true;

    }
}


// Validate Username and Password
function checkLengthInput(minLength, type) {

    var elMsg;
    var elGroup;

    if (type.id === 'userName') {

        elMsg = document.getElementById('usrFeedback');
        elGroup = document.getElementById('usrGroup');

    }
    else {

        elMsg = document.getElementById('passFeedback');
        elGroup = document.getElementById('passGroup');

    }

    if (type.value.trim().length < minLength) {

        elGroup.classList.remove('has-success');

        elGroup.classList.add('has-error');

        elMsg.innerHTML = 'Must be ' + minLength + ' characters or more';

        enableEl(type);
        return false;

    }
    else {

        elGroup.classList.remove('has-error');
        elGroup.classList.add('has-success');

        elMsg.innerHTML = 'Valid input!';

      //  disableEl(type);
        return true;

    }
}



firstName.addEventListener('blur', function() {
    checkNameInput(2, firstName);
}, false);

lastName.addEventListener('blur', function() {
    checkNameInput(2, lastName);
}, false);

email.addEventListener('blur', function() {
    checkEmail();
}, false);

password.addEventListener('blur', function() {
    checkLengthInput(6, password);
}, false);


document.getElementById("contactForm").addEventListener("submit", function(event) {
    event.preventDefault();

    var validFirstName = checkNameInput(2, firstName);
    var validLastName = checkNameInput(2, lastName);
    var validEmail = checkEmail();
    var validPassword = checkLengthInput(6, password);

    if (
        validFirstName &&
        validLastName &&
        validEmail &&
        validPassword
    ) {
        window.location.href = "signIn.html";
    }
});