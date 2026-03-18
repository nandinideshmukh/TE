const path = require('path');
const express = require('express');
const app = express();

const fs = require('fs');
const DATA_FILE = './data.json';

/* ================= FILE DATABASE ================= */

// Read data
function readData() {
    const data = fs.readFileSync(DATA_FILE);
    return JSON.parse(data);
}

// Write data
function writeData(data) {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
}

/* ================= MIDDLEWARE ================= */

var cors = require('cors');
app.use(cors());

var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

/* ================= API ROUTES ================= */

// Test API
app.get('/api/hello', function (req, res) {
    res.send("This is a normal text response");
});

// Get all users
app.get('/api/user', function (req, res) {
    const data = readData();
    res.send(data.users);
});

// Get user by ID
app.get('/api/user/:id', function (req, res) {
    const data = readData();
    const user = data.users.find(u => u.id == req.params.id);
    res.send(user);
});

// Create user
app.post('/api/user', function (req, res) {
    const data = readData();
    const { name, age } = req.body;

    if (!name || name.length < 3) {
      return this.setState({ error: 'Name must be at least 3 characters' });
    }


    if (age < 0 || age > 118) {
        return res.status(400).json({ error: "Age must be between 0 and 118" });
    }


    const newUser = {
        id: Date.now(),
        name: req.body.name,
        age: req.body.age
    };

    data.users.push(newUser);
    writeData(data);

    res.sendStatus(201);
});

// Search user
app.get('/api/search', function (req, res) {
    const data = readData();

    if (req.query.name) {
        const users = data.users.filter(u => u.name === req.query.name);
        res.send(users);
    }
    else if (req.query.age) {
        const users = data.users.filter(u => u.age == req.query.age);
        res.send(users);
    }
    else {
        res.send([]);
    }
});

/* ================= REACT BUILD ================= */

// Serve static files
app.use(express.static(path.resolve(__dirname, 'build')));

// React routing
app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'build', 'index.html'));
});

/* ================= START SERVER ================= */

app.listen(5000, function () {
    console.log("Server listening on port 5000");
});