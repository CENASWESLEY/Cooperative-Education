import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, collection, getDocs, doc, setDoc, updateDoc, getDoc, onSnapshot } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";
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

const topics_sub = [ 
    'Weather : Wind', 
    'Weather : Temperature', 
    'Weather : Humidity', 
    'Security : Door', 
    'Games Room : Power',
    'Sensor : Ultrasonic',
    'Sensor : Water Level', 
    'Sensor : Pump',
]; 

client.on('connect', () => {
    client.subscribe(topics_sub, (err) => {
        if (err) {
            console.error('Subscription error:', err);
        }
    });
});

function setupRealTimeUpdates(email) {
    const roomsRef = collection(db, "Email", email, "rooms");

    // ใช้ onSnapshot เพื่อติดตามการเปลี่ยนแปลงของ State ในแต่ละห้อง
    onSnapshot(roomsRef, (snapshot) => {
        snapshot.docChanges().forEach((change) => {
            if (change.type === "added" || change.type === "modified") {
                const roomName = change.doc.id;
                const roomData = change.doc.data();
                const controlState = roomData.State || {};

                console.log(`Real-time update for room: ${roomName}`, controlState);

                for (const [deviceName, deviceState] of Object.entries(controlState)) {
                    const switchClass = `.switch_${deviceName.toLowerCase()}`; 
                    const switchElements = document.querySelectorAll(switchClass); 
                    if (switchElements.length > 0) {
                        switchElements.forEach(switchElement => {
                            switchElement.checked = deviceState;
                        });
                    } else {
                        console.log(`Switch element for ${deviceName} in room ${roomName} not found.`);
                    }
                }
            }
        });
    });
}

function publishMessage(topic, message) {
    const messageString = String(message); 
    console.log(`Publishing message to ${topic}: ${messageString}`);
    client.publish(topic, messageString, (err) => {
        if (err) {
            console.error(`Failed to publish to ${topic}:`, err);
        } else {
            console.log(`Message published to ${topic}: ${messageString}`);
        }
    });
}

// Updated function to update switch state in all rooms
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

document.addEventListener('DOMContentLoaded', () => {
    var email;

    onAuthStateChanged(auth, async (user) => {
        if (user) {
            email = user.email;
            await updateMainScreenDevices(email);
            await loadSwitchStates(email);
            setupRealTimeUpdates(email);

            client.on('message', async (topic, message) => {
                const valueString = message.toString().toLowerCase(); // Get the message as a string
                const value = valueString === 'true'; // Convert the message to a boolean
                if (topic === 'Security : Door' || topic === 'Games Room : Power') {
                    console.log(`Received message from topic ${topic}: ${valueString}`);
                    const deviceName = topic.split(' : ')[1].toUpperCase();
                    await updateSwitchState(email, deviceName, value);
                }
            });

        } else {
            console.log("No user is signed in");
        }
    });

    async function loadSwitchStates(email) {
        const roomsRef = collection(db, "Email", email, "rooms");
        const roomsSnapshot = await getDocs(roomsRef);

        roomsSnapshot.forEach(async (roomDoc) => {
            const roomName = roomDoc.id;
            const roomData = roomDoc.data();
            const controlState = roomData.State || {};

            for (const [deviceName, deviceState] of Object.entries(controlState)) {
                const switchClass = `.switch_${deviceName.toLowerCase()}`; 
                const switchElements = document.querySelectorAll(switchClass); 
                if (switchElements.length > 0) {
                    switchElements.forEach(switchElement => {
                        switchElement.checked = deviceState;
                    });
                    addSwitchListener(email, deviceName, switchClass);
                } else {
                    console.log(`Switch element for ${deviceName} in room ${roomName} not found.`);
                }
            }
            updateProgressCircle(roomName, roomData.Alert);

        });
    }

    function updateProgressCircle(roomName, alertState) {
        if (!alertState) return;

        const deviceIds = ['ultrasonic', 'water-level', 'pump'];

        deviceIds.forEach((deviceId) => {
            const progressCircleElement = document.querySelector(`#${deviceId}_${roomName.toLowerCase().replace(/\s/g, '_')}`);
            const valueElement = progressCircleElement?.querySelector('.progress-circle-text');

            if (progressCircleElement && valueElement) {
                const deviceState = alertState[deviceId.toUpperCase()];
                if (deviceState !== undefined) {
                    valueElement.textContent = `${deviceState}%`; 
                } else {
                    console.log(`Device state for ${deviceId} in room ${roomName} not found.`);
                }
            } else {
                console.log(`Progress circle element for ${deviceId} in room ${roomName} not found.`);
            }
        });
    }

    function addSwitchListener(email, deviceName, switchClass) {
        const switchElements = document.querySelectorAll(switchClass); 
        if (switchElements.length > 0) {
            switchElements.forEach(switchElement => {
                switchElement.addEventListener('change', async (event) => {
                    const newValue = event.target.checked;
                    console.log(`Switch ${deviceName} value changed: ${newValue}`);

                    await updateSwitchState(email, deviceName, newValue);

                    switchElements.forEach(element => {
                        element.checked = newValue;
                    });

                    if (deviceName.toLowerCase() === 'light') {
                        publishMessage(`Living Room : Light`, newValue);
                    }
                });
            });
        } else {
            console.error(`Switch element for ${deviceName} not found.`);
        }
    }

    async function loadAllDevices(email) {
        const allDevices = { Control: [], Alert: [] };
        const roomsRef = collection(db, "Email", email, "rooms");
        const roomsSnapshot = await getDocs(roomsRef);
        roomsSnapshot.forEach(roomDoc => {
            const roomData = roomDoc.data();
            if (roomData.Control) {
                allDevices.Control.push(...roomData.Control.map(device => ({ roomName: roomDoc.id, deviceName: device })));
            }
            if (roomData.Alert) {
                allDevices.Alert.push(...roomData.Alert.map(device => ({ roomName: roomDoc.id, deviceName: device })));
            }
        });
        return allDevices;
    }

    async function updateMainScreenDevices(email) {
        const allDevices = await loadAllDevices(email);
        const controlContainer = document.getElementById('favourite_maincard');
        const alertContainer = document.getElementById('alert_maincard');

        controlContainer.innerHTML = '';
        alertContainer.innerHTML = '';

        allDevices.Control.forEach(({ roomName, deviceName }) => {
            const deviceCard = createFavouriteCardFromName(deviceName, roomName, 'Control');
            controlContainer.appendChild(deviceCard);
        });

        allDevices.Alert.forEach(({ roomName, deviceName }) => {
            const deviceCard = createAlertCardFromName(deviceName, roomName, 'Alert');
            alertContainer.appendChild(deviceCard);
        });

        updateDeviceCount(document.getElementById('favourite_device'), allDevices.Control.length);
        updateDeviceCount(document.getElementById('alert_device'), allDevices.Alert.length);
    }

    function updateDeviceCount(element, count) {
        if (element) {
            element.textContent = `${count} DEVICES`;
        } else {
            console.error("Element not found");
        }
    }

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
                await updateSwitchState(email, 'DOOR', newValue);
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

            // Add event listener for LIGHT switch
            newCard.querySelector('.switch_light').addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                console.log(`Switch LIGHT value changed: ${newValue}`);
                publishMessage('Living Room : Light', newValue);
                await updateSwitchState(email, 'LIGHT', newValue);
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
                        <label for "" class="switch-label"></label>
                    </div>
                </div>
            `;

            newCard.querySelector('.switch_power').addEventListener('change', async (event) => {
                const newValue = event.target.checked;
                console.log(`Switch POWER value changed: ${newValue}`);
                await updateSwitchState(email, 'POWER', newValue);

              
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
                await updateSwitchState(email, 'YEELIGHT', newValue);
            });
        }

        return newCard;
    }

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

        return newCard;
    }
});
