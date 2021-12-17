const core = require("@actions/core");
const exec = require("@actions/exec");
const simpleGit = require("simple-git");

const git = simpleGit();

try {
  await exec.exec(core.getInput("run_command"));
  const status = git.status();
  console.log(status);
} catch (error) {
  core.setFailed(error.message);
}
