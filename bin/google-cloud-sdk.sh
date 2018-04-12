#!/bin/bash
# Bash script installing google cloud sdk.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

main() {
  if [ ! -d "${HOME}/tools/google-cloud-sdk" ]; then
    curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir="${HOME}/tools"
    "${HOME}/tools/google-cloud-sdk/bin/gcloud" components install --quiet kubectl
    "${HOME}/tools/google-cloud-sdk/bin/gcloud" components update --quiet
  else
    gcloud components update
  fi
}

main "$@"
