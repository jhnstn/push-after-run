const core = require("@actions/core");
const exec = require("@actions/exec");
const simpleGit = require("simple-git");

const git = simpleGit();

async function run() {
  const commands = core.getInput("run");

  commands.split(/[\r\n]+/).forEach(async (cmd) => {
    await exec.exec(cmd);
  });
}

try {
  run();
} catch (error) {
  core.setFailed(error.message);
}
