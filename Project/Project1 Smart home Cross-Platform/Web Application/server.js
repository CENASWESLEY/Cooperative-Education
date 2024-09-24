const express = require('express');
const net = require('net');
const cors = require('cors'); 
const app = express();
const port = 3000;

const bulbIp = '172.20.10.2';  // IP ของหลอดไฟ
const bulbPort = 55443;

// Middleware to handle CORS
app.use(cors()); 

// Middleware to parse JSON bodies
app.use(express.json());

// Function to send command to Yeelight bulb
function sendCommand(command, callback) {
  const client = new net.Socket();
  client.connect(bulbPort, bulbIp, () => {
    client.write(JSON.stringify(command) + '\r\n');
  });

  client.on('data', (data) => {
    let response;
    try {
      response = JSON.parse(data.toString());
    } catch (error) {
      return callback(new Error(`Invalid JSON response: ${data.toString()}`));
    }
    callback(null, response);
    client.destroy(); // Close the connection after receiving data
  });

  client.on('error', (err) => {
    callback(err);
  });
}

// API endpoint to turn on the bulb
app.post('/bulb/on', (req, res) => {
  const command = {
    id: 1,
    method: 'set_power',
    params: ['on', 'smooth', 500]
  };
  sendCommand(command, (err, response) => {
    if (err) {
      return res.status(500).send(err.toString());
    }
    res.send(response);
  });
});

// API endpoint to turn off the bulb
app.post('/bulb/off', (req, res) => {
  const command = {
    id: 1,
    method: 'set_power',
    params: ['off', 'smooth', 500]
  };
  sendCommand(command, (err, response) => {
    if (err) {
      return res.status(500).send(err.toString());
    }
    res.send(response);
  });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
