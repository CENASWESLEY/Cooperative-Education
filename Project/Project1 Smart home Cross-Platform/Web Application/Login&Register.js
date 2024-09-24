// Import Firebase
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-auth.js";

// Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyDlEl-DpdzHbHrrz6CF5VzXPpDnm9FxFCQ",
    authDomain: "smart-home-389e5.firebaseapp.com",
    databaseURL: "https://smart-home-389e5-default-rtdb.firebaseio.com",
    projectId: "smart-home-389e5",
    storageBucket: "smart-home-389e5.appspot.com",
    messagingSenderId: "614600068675",
    appId: "1:614600068675:web:ab428bcdf99382f4c6cef6",
    measurementId: "G-HRDBXFNBTS"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Email validation function
function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// Function to register user
function register() {
    const register_email = document.getElementById("register-email").value;
    const register_password = document.getElementById("register-password").value;
    const register_confirmpassword = document.getElementById("register-confirmpassword").value;

    const register_correct_checkpass = document.getElementById("correct_iconcheck-registerpass");
    const register_correct_checkconfirmpass = document.getElementById("correct_iconcheck-registerconfirmpass");
    const register_incorrect_checkpass = document.getElementById("incorrect_iconcheck-registerpass");
    const register_incorrect_checkconfirmpass = document.getElementById("incorrect_iconcheck-registerconfirmpass");

    if (register_email == '' || register_password == '' || register_confirmpassword == '') {
        alertMessage('Please fill Data for Register', 'error');
        return;
    }

    if (!isValidEmail(register_email)) {
        alertMessage('Invalid email format. Please use a valid email address.', 'error');
        return;
    }

    if (register_password !== register_confirmpassword) {
        alertMessage('Passwords do not match', 'error');
        return;
        register_incorrect_checkpass.style.display = 'flex';
        register_incorrect_checkconfirmpass.style.display = 'flex';
        register_correct_checkpass.style.display = 'none';
        register_correct_checkconfirmpass.style.display = 'none';
    } else {
        register_correct_checkpass.style.display = 'flex';
        register_correct_checkconfirmpass.style.display = 'flex';
        register_incorrect_checkpass.style.display = 'none';
        register_incorrect_checkconfirmpass.style.display = 'none';
    }

    createUserWithEmailAndPassword(auth, register_email, register_password)
        .then((userCredential) => {
            const user = userCredential.user;
            console.log("User registered:", user);
            alertMessage('Register Successfully', 'success');
            setTimeout(() => {
                window.location.href = "Login.html";
            }, 3000);
        })
        .catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
            console.error("Error registering user:", errorCode, errorMessage);
            alertMessage(errorMessage, 'error');
        });
}

document.addEventListener("DOMContentLoaded", () => {
    // Event listener for email validation while typing (for register)
    const registerEmailInput = document.getElementById("register-email");
    if (registerEmailInput) {
        registerEmailInput.addEventListener("input", (event) => {
            const register_email = event.target.value;
            const register_correct_checkemail = document.getElementById("correct_iconcheck-registeremail");
            const register_incorrect_checkemail = document.getElementById("incorrect_iconcheck-registeremail");

            if (isValidEmail(register_email)) {
                register_correct_checkemail.style.display = 'flex';
                register_incorrect_checkemail.style.display = 'none';
            } else {
                register_correct_checkemail.style.display = 'none';
                register_incorrect_checkemail.style.display = 'flex';
            }
        });
    }

    // Event listener for password confirmation validation while typing (for register)
    const registerPasswordInput = document.getElementById("register-password");
    const registerConfirmPasswordInput = document.getElementById("register-confirmpassword");
    if (registerPasswordInput && registerConfirmPasswordInput) {
        registerPasswordInput.addEventListener("input", validatePasswords);
        registerConfirmPasswordInput.addEventListener("input", validatePasswords);
    }

    // Event listener for email validation while typing (for login)
    const loginEmailInput = document.getElementById("login-email");
    if (loginEmailInput) {
        loginEmailInput.addEventListener("input", (event) => {
            const login_email = event.target.value;
            const login_correctIcon = document.getElementById("correct_iconcheck-loginemail");
            const login_incorrectIcon = document.getElementById("incorrect_iconcheck-loginemail");

            if (isValidEmail(login_email)) {
                login_correctIcon.style.display = 'flex';
                login_incorrectIcon.style.display = 'none';
            } else {
                login_correctIcon.style.display = 'none';
                login_incorrectIcon.style.display = 'flex';
            }
        });
    }

    // Event listener for login with Google
    const googleLoginButton = document.querySelector(".login_addbutton.google");
    if (googleLoginButton) {
        googleLoginButton.addEventListener("click", loginWithGoogle);
    }
     // Event listener for login with Facebook
     const facebookLoginButton = document.querySelector(".login_addbutton.facebook");
     if (facebookLoginButton) {
         facebookLoginButton.addEventListener("click", loginWithFacebook);
     }
});

// Function to validate passwords
function validatePasswords() {
    const register_password = document.getElementById("register-password").value;
    const register_confirmpassword = document.getElementById("register-confirmpassword").value;

    const register_correct_checkpass = document.getElementById("correct_iconcheck-registerpass");
    const register_correct_checkconfirmpass = document.getElementById("correct_iconcheck-registerconfirmpass");
    const register_incorrect_checkpass = document.getElementById("incorrect_iconcheck-registerpass");
    const register_incorrect_checkconfirmpass = document.getElementById("incorrect_iconcheck-registerconfirmpass");

    if (register_password === '' || register_confirmpassword === '') {
        register_correct_checkpass.style.display = 'none';
        register_incorrect_checkpass.style.display = 'none';
        register_correct_checkconfirmpass.style.display = 'none';
        register_incorrect_checkconfirmpass.style.display = 'none';
    } else {
        if (register_password !== register_confirmpassword) {
            register_incorrect_checkpass.style.display = 'flex';
            register_incorrect_checkconfirmpass.style.display = 'flex';
            register_correct_checkpass.style.display = 'none';
            register_correct_checkconfirmpass.style.display = 'none';
        } else {
            register_correct_checkpass.style.display = 'flex';
            register_correct_checkconfirmpass.style.display = 'flex';
            register_incorrect_checkpass.style.display = 'none';
            register_incorrect_checkconfirmpass.style.display = 'none';
        }
    }
}

// Function to log in user
function login() {
    const login_email = document.getElementById("login-email").value;
    const login_password = document.getElementById("login-password").value;
    const login_correct_loginemail = document.getElementById("correct_iconcheck-loginemail");
    const login_incorrect_loginemail = document.getElementById("incorrect_iconcheck-loginemail");
    const login_correct_loginepass = document.getElementById("correct_iconcheck-loginpass");
    const login_incorrect_loginepass = document.getElementById("incorrect_iconcheck-loginpass");

    if (login_email == '' || login_password == '') {
        alertMessage('Please fill Data for Login', 'error');
        login_correct_loginemail.style.display = 'none';
        login_incorrect_loginemail.style.display = 'none';
        return;
    }

    if (!isValidEmail(login_email)) {
        alertMessage('Invalid email format. Please use a valid email address.', 'error');
        login_correct_loginemail.style.display = 'none';
        login_incorrect_loginemail.style.display = 'flex';
        return;
    } else {
        login_correct_loginemail.style.display = 'flex';
        login_incorrect_loginemail.style.display = 'none';
    }

    signInWithEmailAndPassword(auth, login_email, login_password)
        .then((userCredential) => {
            const user = userCredential.user;
            console.log("User logged in:", user);
            window.location.href = "Smarthome.html";
        })
        .catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
            console.error("Error logging in user:", errorCode, errorMessage);
            alertMessage("Can't Login With your Email or Password Incorrect, Please Try Again", 'error');
        });
}

// Function to log in with Google
function loginWithGoogle() {
    const provider = new GoogleAuthProvider();
    signInWithPopup(auth, provider)
        .then((result) => {
            const user = result.user;
            console.log("User logged in with Google:", user);
            window.location.href = "Smarthome.html";
        })
        .catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
            console.error("Error logging in with Google:", errorCode, errorMessage);
            alertMessage(errorMessage, 'error');
        });
}

// Function to log out user
function logout() {
    signOut(auth).then(() => {
        console.log("User logged out");
    }).catch((error) => {
        console.error("Error logging out:", error);
    });
}

// Function to display alert messages
function alertMessage(message, type) {
    const alertBox = document.createElement("div");
    alertBox.className = `Alertmessage Alertmessage_${type}`;
    alertBox.innerHTML = `
        <p>${message}</p>
        <i class="fa-solid fa-xmark Alertmessage-icon" onclick="this.parentElement.style.display='none';"></i>
    `;
    document.body.appendChild(alertBox);

    setTimeout(() => {
        alertBox.style.display = 'none';
        document.body.removeChild(alertBox);
    }, 3000);
}

// Bind functions to window object
window.register = register;
window.login = login;
window.logout = logout;
window.loginWithGoogle = loginWithGoogle;
