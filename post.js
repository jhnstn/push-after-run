import * as core from "@actions/core";
const core = require("@actions/core");
const simpleGit = require("simple-git");

const git = simpleGit();

try {
  const status = git.status();
  console.log(status);
} catch (error) {
  core.setFailed(error.message);
}
