const express = require('express');
const app = express();
const ldap=require("ldapjs")
const bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(express.static('public'));
const winston = require('winston');
const fs = require('fs');
const https = require('https');

const privateKey = fs.readFileSync('privateKey.key');
const certificate = fs.readFileSync('certificate.crt');

const credentials = {key: privateKey, cert: certificate};

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({
            filename: '/var/log/service/service.log',
        }),
    ],
});

const logRequest = (req, res, next) => {
    const { method, url, body } = req;
    logger.info(`Received ${method} request for ${url} with body: ${JSON.stringify(body)}`);
    next();
};
app.use(logRequest);

app.post('/login', (req, res) => {
    // Get the username and password from the request body
    const { username, password } = req.body;
    logger.info(`User wants to use ${username} as uid and ${password} as password to do authentication`);
    // Create an LDAP client and bind with the username and password
    const client = ldap.createClient({
      url: 'ldap://172.30.0.3:389'
    });
    
    client.bind(`uid=${username},ou=users,dc=example,dc=com`, password, (error) => {
      if (error) {
        console.error(error);
        logger.error(`Login failed for user ${username}`);
        res.send({
            error:true,
            message:'Invalid credentials'
        })
        //res.status(401).send('Invalid credentials');
      } else {
        logger.info(`User ${username} authenticated successfully`);
        console.log(`User ${username} authenticated successfully`);
        res.send({
            error:false,
            message: 'Login sucessful'
        })
        //res.send('Login successful');
      }
  
      client.unbind();
    });
});
// Routing
app.get('/', function(req, res){
    res.sendFile(__dirname + "/index.html");
});

app.get('/logo.jpg', function(req, res){
    res.sendFile(__dirname + "/logo.jpg");
});

const httpsServer = https.createServer(credentials, app);
httpsServer.listen(443, () => {
    logger.info('Server running on port 443');
    console.log('Server is listening on port 443');
});
