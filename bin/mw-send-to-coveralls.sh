#!/bin/bash -xe

# Cleanup
rm -f .coveralls.yml
rm -rf vendor

# Pretend we have installed php-coveralls using composer
cp -r /srv/deployment/integration/php-coveralls/vendor vendor

# Create the .coveralls.yml file
echo "# .coveralls.yml generated my jenkins.git\bin\mw-send-to-coveralls.sh" >> .coveralls.yml
set +x
echo "repo_token: $(cat /var/lib/jenkins-slave/coveralls.io.token)" >> .coveralls.yml
set -x
echo "src_dir: /" >> .coveralls.yml
echo "service_name: php-coveralls" >> .coveralls.yml
echo "coverage_clover: log/clover.xml" >> .coveralls.yml
echo "json_path: log/coveralls-upload.json" >> .coveralls.yml

# Actually run coveralls!
php vendor/bin/coveralls --verbose
