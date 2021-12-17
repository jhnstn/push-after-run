const core = require("@actions/core");
const exec = require("@actions/exec");
const simpleGit = require("simple-git");

const git = simpleGit();

async function run() {
  const command = core.getInput("run_command");
  console.log("run command: ", command.split(/[\r\n]+/));

  await exec.exec(command);
}

try {
  run();
} catch (error) {
  core.setFailed(error.message);
}
