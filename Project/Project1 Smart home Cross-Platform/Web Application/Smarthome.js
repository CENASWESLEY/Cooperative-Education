
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, doc, setDoc, getDoc, collection, getDocs } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import { getStorage, ref, uploadBytes, getDownloadURL } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-storage.js";
import { dataValues } from "./MQTT.js"; 

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


// =================== Device ===================

document.addEventListener('DOMContentLoaded', () => {



    // =================== Clock ===================
    function updateClock() {
    const now = new Date();

    // Extract date and time parts
    const month = now.toLocaleString('en-US', { month: 'long' });
    const day = now.toLocaleString('en-US', { weekday: 'long' });
    const date = now.getDate();
    const year = now.getFullYear();

    let hours = now.getHours();
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();
    const period = hours >= 12 ? 'PM' : 'AM';

    // Pad single digit minutes and seconds with leading zero
    const paddedMinutes = minutes < 10 ? '0' + minutes : minutes;
    const paddedSeconds = seconds < 10 ? '0' + seconds : seconds;

    // Update HTML elements
    document.getElementById('month').innerText = month;
    document.getElementById('day').innerText = day;
    document.getElementById('date').innerText = date;
    document.getElementById('year').innerText = year;

    document.getElementById('hour').innerText = hours;
    document.getElementById('min').innerText = paddedMinutes;
    document.getElementById('sec').innerText = paddedSeconds;
    document.getElementById('period').innerText = period;

        // Remove highlight class from all days
        const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
        days.forEach(dayId => {
            document.getElementById(dayId).classList.remove('highlight_day');
        });
    
        // Add highlight class to the current day
        const currentDay = now.toLocaleString('en-US', { weekday: 'short' }).toLowerCase();
        document.getElementById(currentDay).classList.add('highlight_day');

    }

    // Initial call to set the clock
    updateClock();
    // Update the clock every second
    setInterval(updateClock, 1000);



    /* ==================== Session time  & Table ==================== */
    var interval;
    var running = false;
    var startTime;
    var endTime;
    var elapsedTime = 0; //เวลาที่ผ่านไปเมื่อจับเวลา ถูกหยุดและเริ่มต้นใหม่
    var startTimeCharger;
    var endTimeCharger;


    // Load stored data from local storage
    if (localStorage.getItem('running')) {
        running = JSON.parse(localStorage.getItem('running'));
    }
    if (localStorage.getItem('startTime')) {
        startTime = parseInt(localStorage.getItem('startTime'));
    }
    if (localStorage.getItem('elapsedTime')) {
        elapsedTime = parseInt(localStorage.getItem('elapsedTime'));
    }


    $(document).ready(function() {
        // Initializing DataTables
        var table = $('#history-home_charger').DataTable({
        "pageLength": 5
    });

    function updateTime() {
        const now = Date.now();
        const diff = now - startTime + elapsedTime;
        const hours = Math.floor(diff / (1000 * 60 * 60)); // แปลงเวลา 1000 = 1s
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((diff % (1000 * 60)) / 1000);
        
        document.getElementById('hour-session').innerText = String(hours).padStart(2, '0'); //แปลงเลขเป็น string แล้วเติม 0 ด้านหน้า
        document.getElementById('min-session').innerText = String(minutes).padStart(2, '0');
        document.getElementById('sec-session').innerText = String(seconds).padStart(2, '0');
    }

    window.startTransaction = function() {
        if (!running) {
            startTime = Date.now();
            startTimeCharger = startTime;
            interval = setInterval(updateTime, 1000);
            running = true;

            // Save to local storage
            localStorage.setItem('running', JSON.stringify(running));
            localStorage.setItem('startTime', startTime.toString());
            localStorage.setItem('startTimeCharger', startTimeCharger.toString());
        }
    }
    

    window.stopTransaction = function() {
        if (running) {
            clearInterval(interval);
            endTime = Date.now();
            endTimeCharger = endTime;
            elapsedTime += endTime - startTime;
            running = false;

            // Save to local storage
            localStorage.setItem('running', JSON.stringify(running));
            localStorage.setItem('elapsedTime', elapsedTime.toString());
            localStorage.setItem('endTimeCharger', endTimeCharger.toString());

            updateTable();
        } else {
            elapsedTime = 0;
            document.getElementById('hour-session').innerText = '00';
            document.getElementById('min-session').innerText = '00';
            document.getElementById('sec-session').innerText = '00';

            // Save to local storage
            localStorage.setItem('elapsedTime', elapsedTime.toString());

            dataValues.home_charger['volt-home_charger'] = '0';
            dataValues.home_charger['current-home_charger'] = '0';
            dataValues.home_charger['power-home_charger'] = '0';
            dataValues.home_charger['energy-home_charger'] = '0';
        }
    }

    async function updateTable() {
        const startDate = new Date(parseInt(startTime)); // แปลงค่า startTime จาก timestamp เป็น Date object
        const endDate = new Date(parseInt(endTime)); // แปลงค่า endTime จาก timestamp เป็น Date object
        const durationMs = endDate - startDate;
        const hours = Math.floor(durationMs / (1000 * 60 * 60));
        const minutes = Math.floor((durationMs % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((durationMs % (1000 * 60)) / 1000);
        const duration = `${hours}:${minutes}:${seconds}`;
        
        const energy = parseFloat(document.getElementById('energy-home_charger').textContent);
        const cost = (energy * 7.50).toFixed(2);
        const status = 'Completed';

        const day = startDate.getDate().toString().padStart(2, '0');
        const month = (startDate.getMonth() + 1).toString().padStart(2, '0');
        const year = startDate.getFullYear();
        const date = `${day}-${month}-${year}`;

        // เพิ่มแถวใหม่ลงใน DataTables
        table.row.add([
            date,
            startDate.toLocaleTimeString(),
            endDate.toLocaleTimeString(),
            duration,
            `${energy.toFixed(2)} kWh`,
            `฿${cost}`,
            status
        ]).draw(false);

        // บันทึกข้อมูลลง Firestore
        const email = auth.currentUser.email;
        const transactionData = {
            date: date,
            startTime: startDate.toLocaleTimeString(),
            endTime: endDate.toLocaleTimeString(),
            duration: `${duration} hours`,
            energy: `${energy.toFixed(2)} kWh`,
            cost: `฿${cost}`,
            status: status
        };

        const historydate = `Date : ${date} | Time : ${transactionData.startTime} - ${transactionData.endTime}`

        try {
            await setDoc(doc(db, "Email", email, "transaction", historydate), transactionData);
            console.log("Document successfully written!");
        } catch (error) {
            console.error("Error writing document: ", error);
        }
    }


    // ถ้า session ยังคงทำงานอยู่ให้เริ่มต้นการนับเวลาใหม่
    if (running) {
        interval = setInterval(updateTime, 1000);
    }

    async function loadTransactions() {
        const email = auth.currentUser.email;
        const transactionRef = collection(db, "Email", email, "transaction");

        try {
            const querySnapshot = await getDocs(transactionRef);
            querySnapshot.forEach((doc) => {
                const data = doc.data();
                table.row.add([
                    data.date,
                    data.startTime,
                    data.endTime,
                    data.duration,
                    data.energy,
                    data.cost,
                    data.status
                ]).draw(false);
            });
        } catch (error) {
            console.error("Error loading transactions: ", error);
        }
    }

    // ตรวจสอบผู้ใช้ที่เข้าสู่ระบบ
    onAuthStateChanged(auth, user => {
        if (user) {
            // User is signed in
            loadTransactions(); // เรียกใช้ฟังก์ชัน loadTransactions เมื่อผู้ใช้เข้าสู่ระบบ
        } else {
            // User is signed out
        }
    });

    });

    /* ==================== Swiper Page ==================== */

        var pages = document.querySelectorAll('.chart_multipages > div');
        var dots = document.querySelectorAll('.dot_page');

        dots.forEach((dot,index) => {

            dot.addEventListener("click",function(){

            // Hide all pages
            pages.forEach(page => page.classList.remove("active_page"));

            // Show the selected page
            pages[index].classList.add("active_page");

            // Remove highlight from all dots
            dots.forEach(d => d.classList.remove("highlight_page"));

            // Add highlight to the clicked dot
            dot.classList.add("highlight_page");

            });
        });

        Chart.register(ChartStreaming);

    // =================== Meter ===================

    const ctxMeter = document.getElementById('chart-meter').getContext('2d');
        
    const gradient = ctxMeter.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, '#F5B553');
    gradient.addColorStop(0.8, '#00000000');

    const gradient2 = ctxMeter.createLinearGradient(0, 0, 0, 400);
    gradient2.addColorStop(0, '#FFFFFF');
    gradient2.addColorStop(0.8, '#00000000');

    const chartData = [0, 0, 0, 0, 0, 0];

    const meter = new Chart(ctxMeter, {
        type: 'line',
        data: {
            labels: ['V', 'A', 'W', 'VAR', 'PF', 'HZ'],
            datasets: [{
                label: 'Meter',
                data: chartData,
                borderColor: '#F5B553',
                backgroundColor: gradient,
                borderWidth: 2,
                pointBackgroundColor: '#FFFFFF',
                pointBorderColor: '#FFFFFF',
                pointRadius: 3,
                pointHoverRadius: 7,
                fill: true,
                tension: 0
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    max: 1000,
                    ticks: {
                        color: 'white',
                        stepSize: 200 // Set y-axis increments to 100
                    },
                    grid: {
                        color: '#00000060' // Light grid lines
                    }
                },
                x: {
                    ticks: {
                        color: 'white'
                    },
                    grid: {
                        color: '#00000060' // Light grid lines
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });

    window.meter = meter;
    // =================== Chart Home Charger ===================

    const ctxCharger = document.getElementById('home_charger').getContext('2d');
    let homeCharger;

    const dataCharger = {
        labels: [], // จะเพิ่มเวลาลงในนี้
        datasets: [{
            label: 'Current (A)',
            borderColor: '#FFFFFF',
            backgroundColor: gradient2,
            data: [],
            fill: true,
            pointRadius: 0
        }, {
            label: 'Total Energy (KWH)',
            borderColor: '#F5B553',
            backgroundColor: gradient,
            data: [],
            fill: true,
            pointRadius: 0
        }]
    };

    const configCharger = {
        type: 'line',
        data: dataCharger,
        options: {
            animation: false,
            scales: {
                x: {
                    type: 'linear',
                    ticks: {
                        callback: function(value, index, values) {
                            const date = new Date(value);
                            return date.getHours() + ':' + date.getMinutes() + ':'+ date.getSeconds() + ' a.m.';
                        }
                    }
                },
                y: {
                    beginAtZero: true
                }
            },
            plugins: {
                legend: {
                    display: true
                }
            }
        }
    };

    function createChart() {
        if (homeCharger) {
            homeCharger.destroy();
        }
        homeCharger = new Chart(ctxCharger, configCharger);
    }

    function updateChart() {
        const now = Date.now();
        const elapsed = now - startTimeCharger;

        if (running) {
            homeCharger.data.labels.push(now);
            homeCharger.data.datasets[0].data.push({
                x: now,
                y: dataValues.home_charger['current-home_charger'] || 0
            });
            homeCharger.data.datasets[1].data.push({
                x: now,
                y: dataValues.home_charger['energy-home_charger'] || 0
            });
            homeCharger.update();
        }
    }

    createChart();

    // Update the chart every second if running
    setInterval(updateChart, 1000);

});

/* ==================== ScrollReveal ==================== */

const sr = ScrollReveal({

    origin:'top',
    distance:'100px',
    duration:2000,
    delay:0,
});

sr.reveal(`.title_main`,{ origin: 'top'});
sr.reveal(`.living,.Bed,.kitchen,.sensor,.security,.room`,{ origin: 'top'});
sr.reveal(`.user_submain`,{ origin: 'bottom'});

