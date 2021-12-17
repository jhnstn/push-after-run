const core = require("@actions/core");
const exec = require("@actions/exec");
const simpleGit = require("simple-git");

const git = simpleGit();

const command = core.getInput("run_command");
console.log("run command: ", command);

exec.exec(command);

await exec.exec(command);
