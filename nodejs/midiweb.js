/* Not a mini server but a medium server */
const http = require('http');
const argsy = require('./argsy');

if (argsy.get(0)==='?') {
  console.log('midiweb - A medium web server.');
  console.log('Usage: node midiweb.js [port]');
  process.exit(1);
}

const hostname = '127.0.0.1';
const myport = argsy.get(0);
const port =  (isNum(myport) ? Number(myport) : 3000);
const server = http.createServer(jsonBodyResponse);
process.on('SIGINT', handleExit);
process.on('SIGQUIT', handleExit);
process.on('SIGTERM', handleExit);
server.listen(port, hostname, startListening);
process.on('SIGTERM', () => {
  server.close(() => {
    console.log('midiweb is now shutting down...');
  });
});

/* ---------------- Functions ----------------- */
function simpleJsonResponse(req, res) {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'application/json');
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "content-type");
  console.log(`Received Request: method=${req.method}, url=${req.url} at ${new Date().toLocaleTimeString()}`, Object.keys(req).join());
  res.end(JSON.stringify({body: 'You have reached this server OK'}));
}

function jsonBodyResponse(req, res) {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'application/json');
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "content-type");
  console.log(`Received Request: method=${req.method}, url=${req.url} at ${new Date().toLocaleTimeString()}`);
  const buffers = [];
  req.on('data', (part) => {
    console.log('Recd part');
    buffers.push(part);
  });
  req.on('end', () => {
    try {
      const payload = Buffer.concat(buffers).toString();
      console.log('Payload processed:', JSON.parse(payload));
    } catch (err) {
      console.log('We regret to inform you that a system snafu has, unfortunately, taken place...', err.message);
    }
    res.end(JSON.stringify({body: 'You have reached this server, congrats.'}));
  });
}

function simpleTextResponse(req, res) {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.setHeader("Access-Control-Allow-Origin", "*");
  console.log(`Received Request: method=${req.method}, url=${req.url} at ${new Date().toLocaleTimeString()}`, Object.keys(req).join());
  res.end(`method=${req.method}, url=${req.url}`, req);
}

function handleExit(signal) {
  console.log(`Received ${signal}. Closing server as you wish.`)
  server.close(function () { process.exit(0); });
}

function startListening() {
  console.log(`Server running at http://${hostname}:${port}/ with process pid ${process.pid}`);
}

function conclude() {
  console.log('I do believe we have successfully responded to a request at', new Date().toLocaleString());
}

function isNum(value) { return !(value===undefined || value===null || isNaN(value)); }
/* -------------- End Functions --------------- */
