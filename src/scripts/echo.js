// Description:
//   Echos a response back to the user.
//
// Commands:
//   hubot echo <query> - Echos back <query>.
//
// URLS:
//   /hubot/echo
//
// Notes:
//   This is really just intended to help with diagnostics.
module.exports = function(robot) {
  robot.respond(/echo(?:\s+(.*))?$/i, function(msg) {
    msg.send(`echo: ${msg.match[1]}`);
  });
};
