    // เก็บค่าทั้งหมดใน objects แยกตามประเภท
    export const dataValues = {
      weather: {},
      favourite: {},
      alert: {},
      external: {},
      home_charger: {},
    };


document.addEventListener('DOMContentLoaded', () => {



    /* ==================== MQTT ==================== */

    // กำหนด URL ของ MQTT broker
    const brokerUrl = 'wss://test.mosquitto.org:8081/mqtt';

    // สร้าง client MQTT
    const client = mqtt.connect(brokerUrl);

    // กำหนด list ของ topics ที่ต้องการ subscribe
    const topics_sub = [ 
      'Weather : Wind', 
      'Weather : Temperature', 
      'Weather : Humidity', 
      'Security : Door', 
      'Games Room : Power',
      'Sensor : Ultrasonic',
      'Sensor : Water Level', 
      'Sensor : Pump',
      'data/test/ev/Data/Charger'
    ];

    for (let i = 1; i <= 7; i++) {
      topics_sub.push(`External : Meter_Value_${i}`);
    }

    // กำหนด list ของ topics และ element IDs ที่เกี่ยวข้อง
    const topics_weather = {
      'Weather : Wind': 'wind-value',
      'Weather : Temperature': 'temp-value',
      'Weather : Humidity': 'humi-value',
    };

    const topics_favourite = {
      'Security : Door': 'switch_door-value', 
      'Games Room : Power': 'switch_power-value',
    };

    const topics_alert = {
      'Sensor : Ultrasonic': 'ultrasonic',
      'Sensor : Water Level': 'water-level',
      'Sensor : Pump': 'pump',
    };

    const topics_external = {
      'External : Meter_Value_1': 'volt',
      'External : Meter_Value_2': 'current',
      'External : Meter_Value_3': 'active_power',
      'External : Meter_Value_4': 'reactive_power',
      'External : Meter_Value_6': 'power_factor',
      'External : Meter_Value_7': 'frequency',
    };

    const topics_homecharger = {

      'data/test/ev/Data/Charger': ['volt-home_charger', 'current-home_charger', 'power-home_charger', 'energy-home_charger'],

    }

    // กำหนด list ของ topics ที่ต้องการ publish
    const topics_pub = {

      'Living Room : Light' : 'switch_light-value',
      'evtest/startstop/Charger': 'start_transaction',
      'evtest/startstop/Charger': 'stop_transaction',
      
    };

    // กำหนดช่วงเวลาการแสดงผล log (ตัวอย่างเช่น ทุกๆ 2 วินาที)
    const logInterval = 2000;

    // เหตุการณ์เมื่อเชื่อมต่อสำเร็จ
    client.on('connect', () => {
      console.log('Connected to MQTT broker');
      client.subscribe(topics_sub, (err) => {
        if (err) {
          console.error('Failed to Subscribe:', err);
        } else {
          console.log(`| Subscribed to topics |\n${topics_sub.join(', \n')}`);
        }
      });
    });
    

    // ฟังก์ชันสำหรับการส่งค่าผ่าน MQTT
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

    // ฟังก์ชันสำหรับการเปลี่ยนรูปภาพตามเงื่อนไขที่กำหนด
    function updateImage(elementId, imageSrc) {
      const imgElement = document.querySelector(`#${elementId}`).closest('.alert_card').querySelector('img');
      if (imgElement) {
        imgElement.src = imageSrc; // อัพเดตแหล่งที่มาของภาพ
      } else {
        console.error(`Image element not found for elementId: ${elementId}`);
      }
    }

    // ฟังก์ชัน handleAlertData ที่อัปเดต
    function handleAlertData(topic, value, elementId) {
      const parsedValue = parseFloat(value); // แปลงค่าข้อความเป็นตัวเลขทศนิยม
      updateProgress(elementId, parsedValue);
      const adjustedValueimg = (value / 65535) * 100;
      if (elementId === 'ultrasonic' && adjustedValueimg < 10) {
        updateImage(elementId, 'assets/Icons/whitecar.png');
      } else if (elementId === 'water-level' && adjustedValueimg > 50) {
        updateImage(elementId, 'assets/Icons/highwater.png');
      } else if (elementId === 'pump' && adjustedValueimg > 10) {
        updateImage(elementId, 'assets/Icons/whitegauge.png');
      } else {
        if (elementId === 'ultrasonic') {
          updateImage(elementId, 'assets/Icons/blackcar.png');
        } else if (elementId === 'water-level') {
          updateImage(elementId, 'assets/Icons/lowwater.png');
        } else if (elementId === 'pump') {
          updateImage(elementId, 'assets/Icons/blackgauge.png');
        }
      }

      dataValues.alert[topic] = parsedValue;
    }

    // ฟังก์ชัน updateProgress ที่อัปเดต
    function updateProgress(elementId, value) {
      const circle = document.getElementById(elementId);
      if (circle) {
        const adjustedValue = (value / 65535) * 100;
        const angle = adjustedValue * 3.6;
        circle.style.background = `conic-gradient(var(--bg-main-color-white) 0deg, var(--bg-main-color-white) ${angle}deg, var(--bg-submain-color-black) ${angle}deg 360deg)`;
        const text = circle.querySelector('.progress-circle-text');
        text.textContent = `${adjustedValue.toFixed(0)}%`;
      } else {
        console.error(`Element with id ${elementId} not found.`);
      }
    }

    // เหตุการณ์เมื่อได้รับข้อความ
    client.on('message', (topic, message) => {
      console.log(`Received message from topic ${topic}: ${message.toString()}`);
      const value = message.toString();
      
      if (topic === 'data/test/ev/Data/Charger') {
        handleHomechargerData(value);
      } else {
        const elementId = topics_weather[topic] || topics_favourite[topic] || topics_alert[topic] || topics_external[topic] || topics_homecharger[topic];

        if (elementId) {
          if (topic in topics_weather) {
            handleWeatherData(topic, value, elementId);
          } else if (topic in topics_favourite) {
            handleFavouriteData(topic, value, elementId);
          } else if (topic in topics_alert) {
            handleAlertData(topic, value, elementId);
          } else if (topic in topics_external) {
            handleExternalData(topic, value, elementId);
          } 
      
        }
      }
    });

 // ฟังก์ชัน handleWeatherData
function handleWeatherData(topic, value, elementId) {
  let unit = '';
  if (topic === 'Weather : Wind') unit = ' m/s';
  if (topic === 'Weather : Temperature') unit = '°C';
  if (topic === 'Weather : Humidity') unit = '%';
  const displayValue = `${value}${unit}`;
  
  const element = document.getElementById(elementId);
  if (element) {  // Check if element exists
      element.textContent = displayValue;
      dataValues.weather[topic] = displayValue;
  } else {
      console.error(`Element with id ${elementId} not found.`);
  }
}


    // ฟังก์ชัน handleFavouriteData
    function handleFavouriteData(topic, value, elementId) {
      const isChecked = value === 'true';
      const switchElement = document.getElementById(elementId);

      if (switchElement) {
        switchElement.checked = isChecked;
        switchElement.disabled = (topic === 'Security : Door' || topic === 'Games Room : Power'); // Disable the switches for door and power
      }
      dataValues.favourite[topic] = isChecked;
    }

    // ฟังก์ชัน handleExternalData
    function handleExternalData(topic, value, elementId) {
      const parsedValue = parseFloat(value).toFixed(2);
      document.getElementById(elementId).textContent = parsedValue;
      dataValues.external[topic] = parsedValue;
    }

    //const testMessage = 'D5$229.20$0.00$0.00$0.81$0.00$0.00$0.09$10.92$0.00$0.00$0.00$1$0$END';
    //handleHomechargerData(testMessage);

    // ฟังก์ชัน handleHomechargerData
    function handleHomechargerData(message) {
      // แปลงข้อความเป็น array โดยแยกด้วยเครื่องหมาย '$'
      const values = message.toString().split('$');
      if(values[0] == 'D5'){
          // กำหนดค่าตามตำแหน่งที่ระบุในภาพ
          const Volt_Charger = parseFloat(values[1]);
          const Current_Charger = parseFloat(values[4]);
          const Power_Charger = parseFloat(values[7]);
          const Energy_Charger= parseFloat(values[8]);
          
          // อัปเดตค่าใน dataValues.home_charger
          dataValues.home_charger['volt-home_charger'] = Volt_Charger;
          dataValues.home_charger['current-home_charger'] = Current_Charger;
          dataValues.home_charger['power-home_charger'] = Power_Charger;
          dataValues.home_charger['energy-home_charger'] = Energy_Charger*1000;

        // อัปเดตค่าใน DOM
        document.getElementById('volt-home_charger').textContent = Volt_Charger.toFixed(2);
        document.getElementById('current-home_charger').textContent = Current_Charger.toFixed(2);
        document.getElementById('energy-home_charger').textContent = Energy_Charger.toFixed(2);
        document.getElementById('session_energy-home_charger').textContent =  Energy_Charger.toFixed(2);
        document.getElementById('power-home_charger').textContent = Power_Charger.toFixed(2);
      }
      else{

        // กำหนดค่าตามตำแหน่งที่ระบุในภาพ
        const Energy_Charger= parseFloat(values[1]);

      // เซฟค่าใน localStorage
      localStorage.setItem('energy-home_charger', Energy_Charger.toString());

      // อัปเดตค่าใน dataValues.home_charger
      dataValues.home_charger['energy-home-charger'] = Energy_Charger;

      // อัปเดตค่าใน DOM
      document.getElementById('energy-home_charger').textContent = Energy_Charger.toFixed(2);
    }
    }

    // ฟังก์ชันสำหรับแสดงผล log
    function displayLog() {
      if (Object.keys(dataValues.weather).length > 0 ||
          Object.keys(dataValues.favourite).length > 0 ||
          Object.keys(dataValues.alert).length > 0 ||
          Object.keys(dataValues.external).length > 0 ||
          Object.keys(dataValues.home_charger).length > 0 ) {
        console.clear();
        console.log('| UPDATE DATA |');
        console.log('Weather:', dataValues.weather);
        console.log('Favourite:', dataValues.favourite);
        console.log('Alert:', dataValues.alert);
        console.log('External:', dataValues.external);
        console.log('Home Charger:', dataValues.home_charger);
      }
    }
    // เพิ่ม event listener เพื่อ switch_light-value
    document.getElementById('switch_light-value').addEventListener('change', (event) => {
      const newValue = event.target.checked ? 'true' : 'false';
      console.log(`Switch light value changed: ${newValue}`);
      publishMessage('Living Room : Light', newValue);
      dataValues.favourite['Living Room : Light'] = newValue;
    });

    document.getElementById('start_transaction').addEventListener('click', (event) => {
      const start = event.target.checked ? '0' : '1';
      console.log(`Start Transaction: ${start}`);
      publishMessage('evtest/startstop/Charger', '1');
      dataValues.home_charger['Start Transaction:'] = start;
    });

    document.getElementById('stop_transaction').addEventListener('click', (event) => {
      const stop = event.target.checked ? '1' : '0';
      console.log(`Stop Transaction: ${stop}`);
      publishMessage('evtest/startstop/Charger', '0');
      dataValues.home_charger['Stop Transaction:'] = stop;
    });


    // กราฟมิตเตอร์

    const chartData = [0, 0, 0, 0, 0, 0];

    // ฟังก์ชันสำหรับอัปเดตข้อมูลกราฟ
    function updateChartData(topic, value) {
      const chartData = window.meter.data.datasets[0].data;
        switch(topic) {
            case 'External : Meter_Value_1':
                chartData[0] = value;
                break;
            case 'External : Meter_Value_2':
                chartData[1] = value;
                break;
            case 'External : Meter_Value_3':
                chartData[2] = value;
                break;
            case 'External : Meter_Value_4':
                chartData[3] = value;
                break;
            case 'External : Meter_Value_6':
                chartData[4] = value;
                break;
            case 'External : Meter_Value_7':
                chartData[5] = value;
                break;
            default:
                console.log('Unknown topic:', topic);
        }

      // อัปเดตกราฟ
      window.meter.update();
    }

    client.on('message', (topic, message) => {
      const value = parseFloat(message.toString());
      console.log(`Received message on topic ${topic}: ${value}`);
      updateChartData(topic, value);
    });

    // เรียกใช้ฟังก์ชันแสดงผล log ทุกๆ logInterval
    setInterval(displayLog, logInterval);

    // เหตุการณ์เมื่อเกิดข้อผิดพลาด
    client.on('error', (err) => {
      console.error('MQTT Error:', err);
    });

});
