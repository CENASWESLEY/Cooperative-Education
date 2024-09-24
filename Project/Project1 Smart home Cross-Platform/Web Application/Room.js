// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, collection, doc, setDoc, getDocs, updateDoc, deleteDoc } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import { getStorage, ref, uploadBytesResumable, getDownloadURL } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-storage.js";

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
    var plus = document.getElementsByClassName("room_title_plus");
    var imageUploadAdd = document.getElementById("imageUploadAdd");
    var dialogBoxBgAdd = document.getElementById("dialog_box_bg_add");
    var imageUploadEdit = document.getElementById("imageUploadEdit");
    var dialogBoxBgEdit = document.getElementById("dialog_box_bg_edit");

    var Add = document.getElementById("dialog_add");
    var inputNameAdd = document.getElementById("dialog_box_input_addname");
    var inputDeviceAdd = document.getElementById("dialog_box_input_adddevice");
    var roomMainbox = document.getElementById("room_mainbox");
    var SubmitAdd = document.getElementById("dialog_submit_Add");
    var closeAdd = document.getElementById("close-button-Add");
    var newBgAdd = '';

    var Edit = document.getElementById("dialog_edit");
    var SubmitEdit = document.getElementById("dialog_submit_Edit");
    var closeEdit = document.getElementById("close-button-Edit");
    var deleteButton = document.getElementById("dialog_delete");
    var currentEditBox = null;
    var newBgEdit = '';

    const uploadProgress = document.getElementById("dialog_addprocess_number");
    const loader = document.getElementById("loader-icon");
    const successIcon = document.getElementById("success-icon");

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
            loadRooms(email);
        } else {
            console.log("No user is signed in");
        }
    });

    // Load rooms data from Firestore
    async function loadRooms(email) {
        const querySnapshot = await getDocs(collection(db, "Email", email, "rooms"));
        querySnapshot.forEach((doc) => {
            var room = doc.data();
            var roomId = doc.id;
            var NewRoom = `
                <div class="room_box" data-id="${roomId}">
                    <a href="Model_Room.html?roomId=${roomId}">
                        <img class="room_box_bg" src="${room.bg}" alt="">
                    </a>
                    <img class="room_box_option" src="assets/Icons/option.png" alt="">
                    <div class="room_box_title">
                        <p>${room.name}</p>
                        <p>${room.device} Devices</p>
                    </div>
                </div>
            `;
            roomMainbox.innerHTML += NewRoom;
        });
        updateRoomBoxOptions();
    }

    loadRooms();

    for (var i = 0; i < plus.length; i++) {
        plus[i].onclick = function() {
            Add.style.display = "flex";
        }
    }

    closeAdd.onclick = function() {
        Add.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == Add) {
            Add.style.display = "none";
        }
    }

    imageUploadAdd.onchange = function(event) {
        const file = event.target.files[0];
        const maxSize = 1048487; // Maximum file size in bytes (1 MB)

        if (file.size > maxSize) {
            alert("File is too large! Please upload a file smaller than 1 MB.");
            return;
        }

        var reader = new FileReader();
        reader.onload = function() {
            dialogBoxBgAdd.src = reader.result;
            newBgAdd = file; // Store the file instead of the result
        }
        reader.readAsDataURL(file);
    }

    SubmitAdd.onclick = async function () {
        var RoomName = inputNameAdd.value || 'New Room';
        var RoomDevice = inputDeviceAdd.value || 0;
        var newRoomData = {
            name: RoomName,
            device: RoomDevice,
        };
    
    
        // ตรวจสอบว่าองค์ประกอบถูกค้นพบหรือไม่ก่อนเข้าถึง
        if (loader) loader.style.display = "flex";
        if (successIcon) successIcon.style.display = "none";
    
        if (newBgAdd) {
            const maxSize = 1048576; // 1 MB
    
            if (newBgAdd.size > maxSize) {
                alert("File is too large! Please upload a file smaller than 1 MB.");
                if (loader) loader.style.display = "none";
                return;
            }
    
            const storageRef = ref(storage, `Room/${email}/${newBgAdd.name}`);
            const uploadTask = uploadBytesResumable(storageRef, newBgAdd);
    
            uploadTask.on('state_changed', 
                (snapshot) => {
                    // Update progress
                    const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                    if (uploadProgress) uploadProgress.textContent = `UPLOAD : ${Math.round(progress)}%`;
                    if (progress > 99) {
                        if (uploadProgress) uploadProgress.textContent = "UPLOAD : 100%";
                        if (loader) loader.style.display = "none";
                        if (successIcon) successIcon.style.display = "flex";
                    }
                }, 
                (error) => {
                    console.error("Upload failed:", error);
                    if (uploadProgress) uploadProgress.textContent = "UPLOAD FAILED";
                    if (loader) loader.style.display = "none";
                }, 
                async () => {
                    // Get the download URL and save room data
                    const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
                    newRoomData.bg = downloadURL;
    
                    await saveRoomData(newRoomData);
                    if (uploadProgress) uploadProgress.textContent = "UPLOAD : 100%";
                    if (loader) loader.style.display = "none";
                    if (successIcon) successIcon.style.display = "flex";
    
                    // Reset fields and image after successful upload
                    setTimeout(() => {
                        resetForm();
                    }, 2000); // 2 seconds delay to show success icon
                }
            );
        } else {
            // Fetch the default image from URL and convert to Blob
            try {
                const response = await fetch('assets/images/Living.jpg');
                const file = await response.blob();
    
                const storageRef = ref(storage, `Room/${email}/Living.jpg`);
                const uploadTask = uploadBytesResumable(storageRef, file);
    
                uploadTask.on('state_changed', 
                    (snapshot) => {
                        // Update progress
                        const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                        if (uploadProgress) uploadProgress.textContent = `UPLOAD : ${Math.round(progress)}%`;
                        if (progress > 99) {
                            if (uploadProgress) uploadProgress.textContent = "UPLOAD : 100%";
                            if (loader) loader.style.display = "none";
                            if (successIcon) successIcon.style.display = "flex";
                        }
                    }, 
                    (error) => {
                        console.error("Upload failed:", error);
                        if (uploadProgress) uploadProgress.textContent = "UPLOAD FAILED";
                        if (loader) loader.style.display = "none";
                    }, 
                    async () => {
                        // Get the download URL and save room data
                        const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
                        newRoomData.bg = downloadURL;
    
                        await saveRoomData(newRoomData);
                        if (uploadProgress) uploadProgress.textContent = "UPLOAD : 100%";
                        if (loader) loader.style.display = "none";
                        if (successIcon) successIcon.style.display = "flex";
    
                        // Reset fields and image after successful upload
                        setTimeout(() => {
                            resetForm();
                        }, 2000); // 2 seconds delay to show success icon
                    }
                );
            } catch (error) {
                console.error("Error fetching or uploading default image:", error);
                if (uploadProgress) uploadProgress.textContent = "UPLOAD FAILED";
                if (loader) loader.style.display = "none"; 
            }
        }
    };
    
    function resetForm() {
    
        if (uploadProgress) uploadProgress.textContent = "UPLOAD : 0%";
        if (loader) loader.style.display = "none";
        if (successIcon) successIcon.style.display = "none";
        if (inputNameAdd) inputNameAdd.value = '';
        if (inputDeviceAdd) inputDeviceAdd.value = '';
        if (dialogBoxBgAdd) dialogBoxBgAdd.src = 'assets/images/Living.jpg';
        newBgAdd = null;
    }
    
    
    
    
    
    
    
    async function saveRoomData(newRoomData) {
        try {
            await setDoc(doc(db, "Email", email, "rooms", newRoomData.name.replace(/\s+/g, '_')), newRoomData);
            var NewRoom = `
                <div class="room_box" data-id="${newRoomData.name.replace(/\s+/g, '_')}">
                    <a href="Model_Room.html?roomId=${newRoomData.name.replace(/\s+/g, '_')}">
                        <img class="room_box_bg" src="${newRoomData.bg}" alt="">
                    </a>
                    <img class="room_box_option" src="assets/Icons/option.png" alt="">
                    <div class="room_box_title">
                        <p>${newRoomData.name}</p>
                        <p>${newRoomData.device} Devices</p>
                    </div>
                </div>
            `;
            roomMainbox.innerHTML += NewRoom;
            Add.style.display = "none";
            updateRoomBoxOptions();
        } catch (error) {
            console.error("Error adding document: ", error);
        }
    }
    
    function updateRoomBoxOptions() {
        var roomBoxOptions = document.getElementsByClassName("room_box_option");
        for (var i = 0; i < roomBoxOptions.length; i++) {
            roomBoxOptions[i].onclick = function(event) {
                Edit.style.display = "flex";
                var roomBox = event.target.parentElement;
                currentEditBox = roomBox;
    
                var roomBg = roomBox.querySelector(".room_box_bg").src;
                var roomName = roomBox.querySelector(".room_box_title p:first-child").textContent;
                var roomDevice = roomBox.querySelector(".room_box_title p:nth-child(2)").textContent;
    
                dialogBoxBgEdit.src = roomBg;
                document.getElementById("dialog_box_input_editname").value = roomName;
                document.getElementById("dialog_box_input_editdevice").value = roomDevice;
            }
        }
    }
    
    closeEdit.onclick = function() {
        Edit.style.display = "none";
    }

    imageUploadEdit.onchange = function(event) {
        const file = event.target.files[0];
        const maxSize = 1048487; // Maximum file size in bytes (1 MB)

        if (file.size > maxSize) {
            alert("File is too large! Please upload a file smaller than 1 MB.");
            return;
        }

        var reader = new FileReader();
        reader.onload = function() {
            dialogBoxBgEdit.src = reader.result;
            newBgEdit = file; // Store the file instead of the result
        }
        reader.readAsDataURL(file);
    }

    SubmitEdit.onclick = async function () {
        if (currentEditBox) {
            var RoomName = document.getElementById("dialog_box_input_editname").value || 'Room';
            var RoomDevice = document.getElementById("dialog_box_input_editdevice").value || 1;
    

            const roomId = currentEditBox.getAttribute('data-id');
            if (!roomId) {
                console.error("roomId is not defined");
                return; 
            }
        
            // Upload the image to Firebase Storage if changed
            if (newBgEdit) {
                const storageRef = ref(storage, `Room/${email}/${newBgEdit.name}`);
                const uploadTask = uploadBytesResumable(storageRef, newBgEdit);
    
                uploadTask.on('state_changed', 
                    (snapshot) => {
                        // Progress of the upload
                    }, 
                    (error) => {
                        console.error("Upload failed:", error);
                    }, 
                    async () => {
                        // Get the download URL and update room data
                        const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
                        var updatedRoomData = {
                            name: RoomName,
                            bg: downloadURL,
                            device: RoomDevice,
                        };
    
                        try {
                            await updateDoc(doc(db, "Email", email, "rooms", roomId), updatedRoomData);
                            currentEditBox.querySelector(".room_box_bg").src = downloadURL;
                            currentEditBox.querySelector(".room_box_title p:first-child").textContent = RoomName;
                            currentEditBox.querySelector(".room_box_title p:nth-child(2)").textContent = `${RoomDevice} Devices`;
                            Edit.style.display = "none";
                        } catch (error) {
                            console.error("Error updating document: ", error);
                        }
                    }
                );
            } else {
                // Update room data without changing the image
                var updatedRoomData = {
                    name: RoomName,
                    device: RoomDevice,
                };
    
                try {
                    await updateDoc(doc(db, "Email", email, "rooms", roomId), updatedRoomData);
                    currentEditBox.querySelector(".room_box_title p:first-child").textContent = RoomName;
                    currentEditBox.querySelector(".room_box_title p:nth-child(2)").textContent = `${RoomDevice} Devices`;
                    Edit.style.display = "none";
                } catch (error) {
                    console.error("Error updating document: ", error);
                }
            }
        }
    };

    deleteButton.onclick = async function() {
        if (currentEditBox) {
            var roomId = currentEditBox.getAttribute('data-id');
            roomMainbox.removeChild(currentEditBox);
            Edit.style.display = "none";

            try {
                await deleteDoc(doc(db, "Email", email, "rooms", roomId));
            } catch (error) {
                console.error("Error removing document: ", error);
            }
        }
    }
});
