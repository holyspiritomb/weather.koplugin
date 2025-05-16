#!/bin/zsh
SEMVER=$1
git tag v${SEMVER}
zip -r ../weather-v${SEMVER}.zip weather.koplugin
tar cvf ../weather-v${SEMVER}.tar.gz weather.koplugin
