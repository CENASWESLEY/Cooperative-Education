
//Debug test 

/* 
const net = require('net');

const bulbIp = '172.20.10.2';
const bulbPort = 55443;

const command = {
  id: 1,
  method: 'set_power',
  params: ['on']
};

const client = new net.Socket();
client.connect(bulbPort, bulbIp, () => {
  console.log('Connected to bulb');
  client.write(JSON.stringify(command) + '\r\n');
});

client.on('data', (data) => {
  console.log('Received: ' + data);
  client.destroy(); // kill client after server's response
});

client.on('close', () => {
  console.log('Connection closed');
});

client.on('error', (err) => {
  console.error('Error: ' + err);
});



*/

async function sendRequest(endpoint) {
  try {
    const response = await fetch(endpoint, { method: 'POST' });
    const result = await response.json();
    console.log('Response from server:', result);
  } catch (error) {
   
  }
}

function turnOn() {
  sendRequest('http://localhost:3000/bulb/on');
}

function turnOff() {
  sendRequest('http://localhost:3000/bulb/off');
}

document.addEventListener('DOMContentLoaded', (event) => {
  const switchElement = document.getElementById('switch_yeelight-value');
  switchElement.addEventListener('change', (event) => {
    if (event.target.checked) {
      turnOn();
    } else {
      turnOff();
    }
  });
});

