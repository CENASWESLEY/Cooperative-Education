import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, collection, getDocs, doc, updateDoc, arrayUnion, arrayRemove, increment, getDoc } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import { getStorage } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-storage.js";


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

// ฟังก์ชันสำหรับการส่งค่าผ่าน MQTT
const brokerUrl = 'wss://test.mosquitto.org:8081/mqtt';
const client = mqtt.connect(brokerUrl);

function publishMessage(topic, message) {
    console.log(`Publishing message to ${topic}: ${message}`);
    client.publish(topic, message, (err) => {
        if (err) {
            console.error(`Failed to publish to ${topic}:`, err);
        } else {
            console.log(`Message published to ${topic}: ${message}`);
        }
    });
}

// Subscribe to MQTT topics
client.on('connect', () => {
    console.log('MQTT client connected');
    client.subscribe('switch_door-value');
    client.subscribe('switch_power-value');
});

client.on('message', async (topic, message) => {
    const messageString = message.toString();

    let email;
    onAuthStateChanged(auth, async (user) => {
        if (user) {
            email = user.email;

            if (topic === 'switch_door-value') {
                await updateSwitchState(email, roomName, 'DOOR', messageString === 'true');
            } else if (topic === 'switch_power-value') {
                await updateSwitchState(email, roomName, 'POWER', messageString === 'true');
            }
        }
    });
});




document.addEventListener('DOMContentLoaded', () => {


    // ===================== Common Functions ================================

    // Function to sync the cards
    function syncCards(mainCard, dialogCard, updateIconsFn) {
        // Clear existing cards in dialog
        dialogCard.innerHTML = '';

        // Get all the cards from main section
        var cards = mainCard.querySelectorAll('.favourite_card, .alert_card');

        // Clone and append each card to the dialog
        cards.forEach(card => {
            var clonedCard = card.cloneNode(true);
            updateIconsFn(clonedCard, true); // Ensure the delete button works only in management view
            dialogCard.appendChild(clonedCard);
        });
    }

    // Function to update device count
    function updateDeviceCount(element, count) {
        if (element) {
            element.textContent = `${count} DEVICES`;
        } else {
            console.error("Element not found");
        }
    }


    // Function to load devices from Firestore
    async function loadDevices(email, roomName, type, mainCard, updateIconsFn) {
        const roomDocRef = doc(db, "Email", email, "rooms", roomName);
        const roomDoc = await getDoc(roomDocRef);
        if (roomDoc.exists()) {
            const roomData = roomDoc.data();
            const devices = roomData[type] || [];

            // Clear mainCard before appending new devices
            mainCard.innerHTML = '';

            devices.forEach(deviceName => {
                const deviceCard = createCardFromName(deviceName, roomName, type);
                mainCard.appendChild(deviceCard);
            });
            updateDeviceCount(document.getElementById(`${type.toLowerCase()}_device`), devices.length);
            syncCards(mainCard, document.getElementById(`dialog_${type.toLowerCase()}_maincard`), updateIconsFn);
        } else {
            console.log("No such document!");
        }
    }

    async function addDeviceToFirestore(roomName, deviceName, type) {
        const roomDocRef = doc(db, "Email", email, "rooms", roomName);
        const roomDoc = await getDoc(roomDocRef);
        
        if (roomDoc.exists()) {
            const roomData = roomDoc.data();
            const devices = roomData[type] || [];
    
            // ตรวจสอบว่ามีอุปกรณ์ที่ชื่อซ้ำกันหรือไม่
            if (devices.includes(deviceName)) {
                console.warn(`Device "${deviceName}" already exists in ${type}.`);
                return;
            }
    
            // เพิ่มอุปกรณ์ใหม่และคำนวณจำนวนอุปกรณ์ทั้งหมด
            await updateDoc(roomDocRef, {
                [type]: arrayUnion(deviceName),
                device: (roomData.Control ? roomData.Control.length : 0) + (roomData.Alert ? roomData.Alert.length : 0) + 1
            });
            
            // สร้างการ์ดใหม่และเพิ่มไปยัง mainCard และ dialogCard
            const newCard = createCardFromName(deviceName, roomName, type);
            const mainCard = document.getElementById(`${type.toLowerCase()}_maincard`);
            const dialogCard = document.getElementById(`dialog_${type.toLowerCase()}_maincard`);
            
            mainCard.appendChild(newCard);
            const clonedCard = newCard.cloneNode(true);
            dialogCard.appendChild(clonedCard);
            updateIconsFn(clonedCard, true); // Ensure the delete button works only in management view

            //เก็บอุปกรณ์ทั้งหมดทุกห้อง
            const All_device =[];
            All_device.appendChild(newCard);
            
            // อัปเดต UI หลังจากเพิ่มอุปกรณ์
            const updatedRoomDoc = await getDoc(roomDocRef);
            const updatedRoomData = updatedRoomDoc.data();
            updateDeviceCount(document.getElementById(`${type.toLowerCase()}_device`), updatedRoomData[type].length);
        } else {
            console.log("No such document!");
        }
    }

    
    


    // Function to remove device from Firestore
    async function removeDeviceFromFirestore(roomName, deviceName, type) {
        const roomDocRef = doc(db, "Email", email, "rooms", roomName);
        await updateDoc(roomDocRef, {
            [type]: arrayRemove(deviceName),
            device: increment(-1)
        });
    }



    async function loadSwitchStates(email) {
        const roomsRef = collection(db, "Email", email, "rooms");
        const roomsSnapshot = await getDocs(roomsRef);
        roomsSnapshot.forEach(async (roomDoc) => {
            const roomName = roomDoc.id;
            const roomData = roomDoc.data();
            const controlState = roomData.State || {};

            for (const [deviceName, deviceState] of Object.entries(controlState)) {
                const switchClass = `.switch_${deviceName.toLowerCase()}`;
                const switchElement = document.querySelector(switchClass);
                if (switchElement) {
                    switchElement.checked = deviceState;
                    addSwitchListener(email, roomName, deviceName, switchClass);
                }
            }
        });
    }

    async function updateSwitchState(email, deviceName, state) {
        const roomsRef = collection(db, "Email", email, "rooms");
        const roomsSnapshot = await getDocs(roomsRef);
    
        roomsSnapshot.forEach(async (roomDoc) => {
            const roomName = roomDoc.id;
            const deviceRef = doc(db, "Email", email, "rooms", roomName);
            const deviceDoc = await getDoc(deviceRef);
    
            if (deviceDoc.exists()) {
                const deviceData = deviceDoc.data();
                let stateData = deviceData.State || {};
    
                stateData[deviceName] = state;
    
                await updateDoc(deviceRef, {
                    State: stateData
                });
    
                console.log(`Updated ${deviceName} state to ${state} in room ${roomName}`);
            } else {
                console.error(`Device document not found for room ${roomName}`);
            }
        });
    }
    

    function addSwitchListener(email, roomName, deviceName, switchClass) {
        const switchElement = document.querySelector(switchClass);
        if (switchElement) {
            switchElement.addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                console.log(`Switch ${deviceName} in ${roomName} value changed: ${newValue}`);
                await updateSwitchState(email, roomName, deviceName, newValue);
                if (deviceName.toLowerCase() === 'light') {
                    publishMessage(`${roomName} : Light`, newValue);
                }
            });
        } else {
            console.error(`Switch element for ${deviceName} in ${roomName} not found`);
        }
    }

    // ===================== Favourite Device ===================================
    var control_device = document.getElementById('control_device');
    var dialog_control_device = document.getElementById('dialog_favourite');
    var close_dialog_control_device = document.getElementById('close-button-favourite');
    var favouriteMainCard = document.getElementById('favourite_maincard');
    var dialogFavouriteMainCard = document.getElementById('dialog_control_maincard');
    var add_favourite_device = document.querySelectorAll('.favourite_card-door_adddevice, .favourite_card-light_adddevice, .favourite_card-power_adddevice, .favourite_card-yeelight_adddevice');
    
    control_device.addEventListener('click', () => {
        dialog_control_device.style.display = 'flex';
    });
    close_dialog_control_device.addEventListener('click', () => {
        dialog_control_device.style.display = 'none';
    });

    var email;
    var roomName;

    onAuthStateChanged(auth, async (user) => {
        if (user) {
            email = user.email;

            // Fetch roomName from the URL or from the HTML element
            const urlParams = new URLSearchParams(window.location.search);
            roomName = urlParams.get('roomId');
            if (!roomName) {
                roomName = document.getElementById('roomName').textContent.trim();
            }

            if (roomName) {
                // Load user data when the user is signed in
                loadDevices(email, roomName, 'Control', favouriteMainCard, updateFavouriteCardIcons);
                loadDevices(email, roomName, 'Alert', alertMainCard, updateAlertCardIcons); // เพิ่มการโหลด Alert devices

            } else {
                console.error("roomName is not defined");
            }

            await loadSwitchStates(email);
            
        } else {
            console.log("No user is signed in");
        }
    });

    // Add event listeners to add device buttons
    add_favourite_device.forEach(button => {
        button.addEventListener('click', async () => {
            var newCard = createCard(button, 'Control');
            favouriteMainCard.appendChild(newCard);
            await addDeviceToFirestore(roomName, button.querySelector('.favourite_card-name').textContent, 'Control');
            syncCards(favouriteMainCard, dialogFavouriteMainCard, updateFavouriteCardIcons);
        });
    });


    // Function to create a new card based on device name
    function createCardFromName(deviceName, roomName, type) {
        if (type === 'Control') {
            return createFavouriteCardFromName(deviceName, roomName, type);
        } else if (type === 'Alert') {
            return createAlertCardFromName(deviceName, roomName, type);
        }
    }


    // Function to create a new card based on device name
    function createFavouriteCardFromName(deviceName, roomName, type) {
        var newCard = document.createElement('div');
        newCard.classList.add('favourite_card');

        if (deviceName === 'DOOR') {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">DOOR</p>
                </div>
                <div class="favorite_card-center">
                    <img src="assets/Icons/door.png" alt="">
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text">LOCK</p>
                    <div class="favourite_switch">
                        <input type="checkbox" id="switch_door-value" class="switch switch_door">
                        <label for="" class="switch-label"></label>
                    </div>
                </div>
            `;

            newCard.querySelector('.switch_door').addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                console.log(`Switch DOOR value changed: ${newValue}`);
                await updateSwitchState(email, roomName, deviceName, newValue);
            });

        } else if (deviceName === 'LIGHT') {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">LIGHT</p>
                </div>
                <div class="favorite_card-center">
                    <img src="assets/Icons/lamp.png" alt="">
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text">TURN</p>
                    <div class="favourite_switch">
                        <input type="checkbox" id="switch_light-value" class="switch switch_light">
                        <label for="switch_light-value" class="switch-label"></label>
                    </div>
                </div>
            `;
            newCard.querySelector('.switch_light').addEventListener('change', async (event) => {
                const newValue = event.target.checked ? 'true' : 'false';
                console.log(`Switch LIGHT value changed: ${newValue}`);
                publishMessage('Living Room : Light', newValue);
                await updateSwitchState(email, roomName, deviceName, newValue);

            });
        } else if (deviceName === 'POWER') {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">POWER</p>
                </div>
                <div class="favorite_card-center">
                    <img src="assets/Icons/power.png" alt="">
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text">TURN</p>
                    <div class="favourite_switch">
                        <input type="checkbox" id="switch_power-value" class="switch switch_power">
                        <label for="" class="switch-label"></label>
                    </div>
                </div>
            `;

            newCard.querySelector('.switch_power').addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                console.log(`Switch POWER value changed: ${newValue}`);
                await updateSwitchState(email, roomName, deviceName, newValue);
            });


        } else if (deviceName === 'YEELIGHT') {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">YEELIGHT</p>
                </div>
                <div class="favorite_card-center favorite_card-center-yeelight">
                    <img src="assets/images/User/Devices/Yeelight.png" alt="">
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text">TURN</p>
                    <div class="favourite_switch">
                        <input type="checkbox" id="switch_yeelight-value" class="switch switch_yeelight">
                        <label for="switch_yeelight-value" class="switch-label"></label>
                    </div>
                </div>
            `;

            async function sendRequest(endpoint) {
                try {
                    const response = await fetch(endpoint, { method: 'POST' });
                    const result = await response.json();
                    console.log('Response from server:', result);
                } catch (error) {
                    console.error('Error:', error);
                }
            }

            function turnOn() {
                sendRequest('http://localhost:3000/bulb/on');
            }

            function turnOff() {
                sendRequest('http://localhost:3000/bulb/off');
            }

            newCard.querySelector('.switch_yeelight').addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                if (newValue) {
                    turnOn();
                    console.log('Yeelight is turned on');
                } else {
                    turnOff();
                    console.log('Yeelight is turned off');
                }
                await updateSwitchState(email, roomName, deviceName, newValue);
            
            });
            
            
        }

        return newCard;
    }

    // Function to create a new card based on button
    function createCard(button, type) {
        var newCard = document.createElement('div');
        newCard.classList.add('favourite_card');

        var name = button.querySelector('.favourite_card-name').textContent;

        if (button.classList.contains('favourite_card-yeelight_adddevice')) {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">${name}</p>
                </div>
                <div class="favorite_card-center favorite_card-center-yeelight">
                    <img src="assets/images/User/Devices/Yeelight.png" alt="">
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text">TURN</p>
                    <div class="favourite_switch">
                        <input type="checkbox" id="switch_yeelight-value" class="switch switch_yeelight">
                        <label for="switch_yeelight-value" class="switch-label"></label>
                    </div>
                </div>
            `;


        } else {
            newCard.innerHTML = `
                <div class="favorite_card-top">
                    <p class="favourite_card-Room">${roomName}</p>
                    <p class="favourite_card-name">${name}</p>
                </div>
                <div class="favorite_card-center">
                    ${button.querySelector('.favorite_card-center').innerHTML}
                </div>
                <div class="favourite_status">
                    <p class="favourite_status-text"></p>
                    <div class="favourite_switch"></div>
                </div>
            `;
        }

        updateFavouriteCardIcons(newCard, false);
        return newCard;
    }

    // Function to update icons for edit and delete
    function updateFavouriteCardIcons(card, isDialog) {
        var statusText = card.querySelector('.favourite_status-text');
        var switchDiv = card.querySelector('.favourite_switch');

        if (isDialog) {
            statusText.innerHTML = '<i class="fa-solid fa-pen-to-square" style="color: #F5B553; font-size: 24px;"></i>';
            switchDiv.innerHTML = '<img class="dialog_buttondelete" src="assets/Icons/delete.png" alt="" style="width:30px; height:30px">';
            var deleteButton = switchDiv.querySelector('.dialog_buttondelete');
            deleteButton.addEventListener('click', async () => {
                var name = card.querySelector('.favourite_card-name').textContent;
                await removeDeviceFromFirestore(roomName, name, 'Control');
                card.remove();
                syncCards(favouriteMainCard, dialogFavouriteMainCard, updateFavouriteCardIcons);
            });
        } else {
            var name = card.querySelector('.favourite_card-name').textContent;

            if (name === 'DOOR') {
                statusText.textContent = 'LOCK';
                switchDiv.innerHTML = '<input type="checkbox" id="switch_door-value" class="switch switch_door "><label for="switch_door-value" class="switch-label"></label>';
            } else if (name === 'LIGHT') {
                statusText.textContent = 'TURN';
                switchDiv.innerHTML = '<input type="checkbox" id="switch_light-value" class="switch switch_light "><label for="switch_light-value" class="switch-label"></label>';
            } else if (name === 'POWER') {
                statusText.textContent = 'TURN';
                switchDiv.innerHTML = '<input type="checkbox" id="switch_power-value" class="switch switch_power"><label for="switch_power-value" class="switch-label"></label>';
            } else if (name === 'YEELIGHT') {
                statusText.textContent = 'TURN';
                switchDiv.innerHTML = '<input type="checkbox" id="switch_yeelight-value" class="switch switch_yeelight "><label for="switch_yeelight-value" class="switch-label"></label>';
            }
        }
    }

    // Initial sync on page load
    syncCards(favouriteMainCard, dialogFavouriteMainCard, updateFavouriteCardIcons);

    // ===================== Alert Device ===================================
    var alert_device = document.getElementById('alert_device');
    var dialog_alert_device = document.getElementById('dialog_alert');
    var close_dialog_alert_device = document.getElementById('close-button-alert');
    var alertMainCard = document.getElementById('alert_maincard');
    var dialogAlertMainCard = document.getElementById('dialog_alert_maincard');
    var add_alert_device = document.querySelectorAll('.alert_card_ultrasonic_adddevice, .alert_card_waterlevel_adddevice, .alert_card_pump_adddevice');

    alert_device.addEventListener('click', () => {
        dialog_alert_device.style.display = 'flex';
    });
    close_dialog_alert_device.addEventListener('click', () => {
        dialog_alert_device.style.display = 'none';
    });

    // Add event listeners to add device buttons
    add_alert_device.forEach(button => {
        button.addEventListener('click', async () => {
            var newCard = createAlertCard(button, 'Alert');
            alertMainCard.appendChild(newCard);
            await addDeviceToFirestore(roomName, button.querySelector('.alert_card-name').textContent, 'Alert');
            syncCards(alertMainCard, dialogAlertMainCard, updateAlertCardIcons);
        });
    });

    // Function to create a new card based on device name
    function createAlertCardFromName(deviceName, roomName, type) {
        var newCard = document.createElement('div');
        newCard.classList.add('alert_card');

        if (deviceName === 'ULTRASONIC') {
            newCard.innerHTML = `
                    <div class="alert_card-top">
                        <p class="alert_card-Room">${roomName}</p>
                        <p class="alert_card-name">ULTRASONIC</p>
                    </div>
                    <div class="alert_card-center">
                        <div class="alert_progress-circle " id="ultrasonic">
                            <div class="progress-circle-inner">
                            <div class="progress-circle-half left"></div>
                            <div class="progress-circle-half right">
                                <div class="progress-circle-half inner"></div>
                            </div>
                            <div class="progress-circle-center">
                                <span class="progress-circle-text" id="ultrasonic-value">0%</span>
                            </div>
                            </div>
                        </div>
                    </div>
                    <div class="alert_card-bottom">
                        <p class="alert_status-text">STATUS</p>
                        <img src="assets/Icons/blackcar.png" alt="" class="alert_status-img">
                    </div>
            `;
        } else if (deviceName === 'WATER LEVEL') {
            newCard.innerHTML = `
                    <div class="alert_card-top">
                        <p class="alert_card-Room">${roomName}</p>
                        <p class="alert_card-name">WATER LEVEL</p>
                    </div>
                    <div class="alert_card-center">
                        <div class="alert_progress-circle" id="water-level">
                            <div class="progress-circle-inner">
                              <div class="progress-circle-half left"></div>
                              <div class="progress-circle-half right">
                                <div class="progress-circle-half inner"></div>
                              </div>
                              <div class="progress-circle-center">
                                <span class="progress-circle-text" id="water-level-value">0%</span>
                              </div>
                            </div>
                          </div>
                    </div>
                    <div class="alert_card-bottom">
                        <p class="alert_status-text">Level</p>
                        <img src="assets/Icons/lowwater.png" alt="" class="alert_status-img">
                    </div>
            `;
        } else if (deviceName === 'PUMP') {
            newCard.innerHTML = `
                    <div class="alert_card-top">
                        <p class="alert_card-Room">${roomName}</p>
                        <p class="alert_card-name">PUMP</p>
                    </div>
                    <div class="alert_card-center">
                        <div class="alert_progress-circle" id="pump">
                            <div class="progress-circle-inner">
                              <div class="progress-circle-half left"></div>
                              <div class="progress-circle-half right">
                                <div class="progress-circle-half inner"></div>
                              </div>
                              <div class="progress-circle-center">
                                <span class="progress-circle-text" id="pump-value">0%</span>
                              </div>
                            </div>
                          </div>
                    </div>
                    <div class="alert_card-bottom">
                        <p class="alert_status-text">STATUS</p>
                        <img src="assets/Icons/blackgauge.png" alt="" class="alert_status-img">
                    </div>
            `;
        }

        updateAlertCardIcons(newCard, false);
        return newCard;
    }

    // Function to create a new card based on button
    function createAlertCard(button, type) {
        var newCard = document.createElement('div');
        newCard.classList.add('alert_card');

        var name = button.querySelector('.alert_card-name').textContent;

        if (button.classList.contains('alert_card_ultrasonic_adddevice')) {
            newCard.innerHTML = `
                <div class="alert_card-top">
                    <p class="alert_card-Room">${roomName}</p>
                    <p class="alert_card-name">${name}</p>
                </div>
                <div class="alert_card-center">
                    <div class="alert_progress-circle " id="ultrasonic">
                        <div class="progress-circle-inner">
                        <div class="progress-circle-half left"></div>
                        <div class="progress-circle-half right">
                            <div class="progress-circle-half inner"></div>
                        </div>
                        <div class="progress-circle-center">
                            <span class="progress-circle-text" id="ultrasonic-value">0%</span>
                        </div>
                        </div>
                    </div>
                </div>
                <div class="alert_card-bottom">
                    <p class="alert_status-text">STATUS</p>
                    <img src="assets/Icons/blackcar.png" alt="" class="alert_status-img">
                </div>
            `;
        } else if (button.classList.contains('alert_card_waterlevel_adddevice')) {
            newCard.innerHTML = `
                <div class="alert_card-top">
                    <p class="alert_card-Room">${roomName}</p>
                    <p class="alert_card-name">${name}</p>
                </div>
                <div class="alert_card-center">
                    <div class="alert_progress-circle" id="water-level">
                        <div class="progress-circle-inner">
                          <div class="progress-circle-half left"></div>
                          <div class="progress-circle-half right">
                            <div class="progress-circle-half inner"></div>
                          </div>
                          <div class="progress-circle-center">
                            <span class="progress-circle-text" id="water-level-value">0%</span>
                          </div>
                        </div>
                      </div>
                </div>
                <div class="alert_card-bottom">
                    <p class="alert_status-text">Level</p>
                    <img src="assets/Icons/lowwater.png" alt="" class="alert_status-img">
                </div>
            `;
        } else if (button.classList.contains('alert_card_pump_adddevice')) {
            newCard.innerHTML = `
                <div class="alert_card-top">
                    <p class="alert_card-Room">${roomName}</p>
                    <p class="alert_card-name">${name}</p>
                </div>
                <div class="alert_card-center">
                    <div class="alert_progress-circle" id="pump">
                        <div class="progress-circle-inner">
                          <div class="progress-circle-half left"></div>
                          <div class="progress-circle-half right">
                            <div class="progress-circle-half inner"></div>
                          </div>
                          <div class="progress-circle-center">
                            <span class="progress-circle-text" id="pump-value">0%</span>
                          </div>
                        </div>
                      </div>
                </div>
                <div class="alert_card-bottom">
                    <p class="alert_status-text">STATUS</p>
                    <img src="assets/Icons/blackgauge.png" alt="" class="alert_status-img">
                </div>
            `;
        }

        updateAlertCardIcons(newCard, false);
        return newCard;
    }

    // Function to update icons for edit and delete
    function updateAlertCardIcons(card, isDialog) {
        var statusText = card.querySelector('.alert_status-text');
        var statusImg = card.querySelector('.alert_status-img');
    
        if (statusText && statusImg) { // ตรวจสอบว่า statusText และ statusImg ไม่เป็น null
            if (isDialog) {
                statusText.innerHTML = '<i class="fa-solid fa-pen-to-square" style="color: #F5B553; font-size: 24px;"></i>';
                statusImg.outerHTML = '<img class="dialog_buttondelete" src="assets/Icons/delete.png" alt="" style="width:30px; height:30px">'; // ใช้ outerHTML แทน innerHTML เพื่อแทนที่ element เดิม
                var deleteButton = card.querySelector('.dialog_buttondelete');
                deleteButton.addEventListener('click', async () => {
                    var name = card.querySelector('.alert_card-name').textContent;
                    await removeDeviceFromFirestore(roomName, name, 'Alert');
                    card.remove();
                    syncCards(alertMainCard, dialogAlertMainCard, updateAlertCardIcons);
                });
            } else {
                var name = card.querySelector('.alert_card-name').textContent;
    
                if (name === 'ULTRASONIC') {
                    statusText.textContent = 'STATUS';
                    statusImg.src = 'assets/Icons/blackcar.png';
                } else if (name === 'WATER LEVEL') {
                    statusText.textContent = 'STATUS';
                    statusImg.src = 'assets/Icons/lowwater.png';
                } else if (name === 'PUMP') {
                    statusText.textContent = 'STATUS';
                    statusImg.src = 'assets/Icons/blackgauge.png';
                }
            }
        } else {
            console.error("Element not found in card for updateAlertCardIcons");
        }
    }
    
    // Initial sync on page load
    syncCards(alertMainCard, dialogAlertMainCard, updateAlertCardIcons);
});
