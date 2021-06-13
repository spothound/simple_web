const express = require('express');
const amqp = require('amqplib/callback_api');
var config = require('./config');
const app = express();
const path = require('path');
const router = express.Router();
const PORT = process.env.port || 80


router.get('/',function(req,res){
  amqp.connect(`amqp://${config.mq_ip}:${config.mq_port}`, {timeout: 2000}, function (error0, connection) {
      if (error0) {
          res.sendFile(path.join(__dirname+'/disconnected.html'));
      }
      res.sendFile(path.join(__dirname+'/connected.html'));
  });
});

app.use('/', router);

app.listen(PORT);

console.log(`Running on ${PORT}`);