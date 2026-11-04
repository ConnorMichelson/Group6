var userName = document.getElementById('userName');
var password = document.getElementById('password');


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


userName.addEventListener('blur', function() {
    checkLengthInput(6, userName);
}, false);


password.addEventListener('blur', function() {
    checkLengthInput(6, password);
}, false);