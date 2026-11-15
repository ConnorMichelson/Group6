var email = document.getElementById('email');
var password = document.getElementById('password');

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


email.addEventListener('blur', function() {
    checkEmail();
}, false);


password.addEventListener('blur', function() {
    checkLengthInput(6, password);
}, false);