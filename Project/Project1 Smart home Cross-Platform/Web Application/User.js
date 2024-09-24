// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, doc, setDoc, getDoc } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import { getStorage, ref, uploadBytes, getDownloadURL } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-storage.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyDlEl-DpdzHbHrrz6CF5VzXPpDnm9FxFCQ",
    authDomain: "smart-home-389e5.firebaseapp.com",
    projectId: "smart-home-389e5",
    storageBucket: "smart-home-389e5.appspot.com",
    messagingSenderId: "614600068675",
    appId: "1:614600068675:web:ab428bcdf99382f4c6cef6",
    measurementId: "G-HRDBXFNBTS"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth();
const storage = getStorage(app);

document.addEventListener('DOMContentLoaded', () => {
    var icon_setting = document.getElementById("icon_setting");
    var dialog_setting = document.getElementById("dialog_setting");
    var close_button_setting = document.getElementById("close-button-setting");

    var username_main = document.getElementById('main_profile-title-name');
    var profile_main = document.getElementById('main_profile-picture');
    var username_user = document.getElementById('user_profile-title-name');
    var email_user = document.getElementById('user_details_email');
    var profile_user = document.getElementById('user_profile-picture');
    var upload_image = document.getElementById("imageUploadSetting");
    var username_copy = document.getElementById('dialog_content-input');
    var profile_copy = document.getElementById("user_avatar-imgcopy");
    var newProfile = '';

    var SubmitSetting = document.getElementById("dialog_submit_setting");

    var uid;
    var email;

    onAuthStateChanged(auth, (user) => {
        if (user) {
            uid = user.uid;
            email = user.email;
            console.log("| Current User |");
            console.log("User Email:", email);
            console.log("User UID:", uid);
            // Load user data when the user is signed in
            loadUserData(email, uid);

            if(email_user){
                email_user.innerText = email;
            }
        } else {
            console.log("No user is signed in");
        }
    });

    if (icon_setting) {
        icon_setting.addEventListener('click', () => {
            dialog_setting.style.display = 'block';
        });
    }

    if (close_button_setting) {
        close_button_setting.addEventListener('click', () => {
            dialog_setting.style.display = 'none';
        });
    }

    upload_image.onchange = async function(event) {
        const file = event.target.files[0];
        const maxSize = 1048576; // Maximum file size in bytes (1 MB)
    
        if (file.size > maxSize) {
            alert("File is too large! Please upload a file smaller than 1 MB.");
            return;
        }
    
        const storageRef = ref(storage, `Profile/${file.name}`);
        await uploadBytes(storageRef, file);
        newProfile = await getDownloadURL(storageRef);
        profile_copy.src = newProfile;
    }
    

    SubmitSetting.onclick = async function () {
        var username = username_copy.value || 'Username';
        var profile_img = newProfile || 'assets/images/Avatar.png';
    
        var profile_data = {
            name: username,
            img: profile_img,
        };
    
        try {
            await setDoc(doc(db, "Email", email, "users", uid), profile_data);
    
            if (username_main) {
                username_main.innerText = "Hey, " + username;
            }
    
            if (profile_main) {
                profile_main.src = profile_img;
            }
    
            if (username_user) {
                username_user.innerText = username;
            }
    
            if (profile_user) {
                profile_user.src = profile_img;
            }
    
            // Save data to localStorage
            localStorage.setItem('userProfile', JSON.stringify({ name: username, img: profile_img }));
    
            dialog_setting.style.display = "none";
    
            alertMessage('Profile has been changed', 'change');
    
        } catch (error) {
            console.error("Error adding document: ", error);
            alertMessage('Error saving profile', 'error');
        }
    }
    

    // Function to load user data from Firestore on page load
    async function loadUserData(email, uid) {
        try {
            const userDoc = await getDoc(doc(db, "Email", email, "users", uid));
            if (userDoc.exists()) {
                const { name, img } = userDoc.data();
                if (username_main) username_main.innerText = "Hey, " + name;
                if (profile_main) profile_main.src = img;
                if (username_user) username_user.innerText = name;
                if (profile_user) profile_user.src = img;
                if (username_copy) username_copy.value = name;
                if (profile_copy) profile_copy.src = img;

            } else {
                console.log("No such document!");
            }
        } catch (error) {
            console.error("Error getting document: ", error);
        }
    }

    // Function to display alert messages
    function alertMessage(message, type) {
        const alertBox = document.getElementById("Alertmessage");
        const alertMessageMain = document.getElementById("Alertmessage_main");

        if (alertBox && alertMessageMain) {
            alertBox.className = `Alertmessage Alertmessage_${type}`;
            alertBox.getElementsByTagName("p")[0].innerText = message;
            alertBox.style.display = 'flex';

            setTimeout(() => {
                alertBox.style.display = 'none';
            }, 3000);
        }
    }

    // Close the alert message when the close icon is clicked
    document.getElementById("Alertmessage_close-icon").onclick = function () {
        document.getElementById("Alertmessage").style.display = 'none';
    }
});
