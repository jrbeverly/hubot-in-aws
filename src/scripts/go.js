// Description:
//   Search the go url shortener
//
// Commands:
//   hubot go <query> - Search the go URL shortener for <query>.
//
// URLS:
//   /hubot/go
//
// Notes:
//   Ideally this would use slack attachments to pretty-print the result
module.exports = function(robot) {
    urls = [
        {
            name: "Documents", 
            slug: "docs",
            url: "https://example.com/docs"
        },
        {
            name: "Source Control", 
            slug: "git",
            url: "https://github.com/"
        },
        {
            name: "Search", 
            slug: "s",
            url: "https://google.com"
        },
    ]

    robot.respond(/go(?:\s+(.*))?$/i, function(msg) {
        result = urls.filter(entry => entry.slug === msg.match[1]);
        if (result.length == 0) {
            msg.send(`I couldn't find anything for ${msg.match[1]}`);
        } else {
            entry = result[0];
            msg.send(`${entry.name} (${entry.slug}) = ${entry.url}`);
        }
    });
  };
  