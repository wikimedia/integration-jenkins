#!/bin/bash -xe

rm -f .coveralls.yml

# As coveralls was meant to be installed using composer we need
# to trick it into thinking that it was by adding this symlink
if [ ! -L vendor ]; then
  ln -s /srv/deployment/integration/php-coveralls/vendor vendor
fi

echo "# .coveralls.yml generated my jenkins.git\bin\mw-send-to-coveralls.sh" >> .coveralls.yml
set +x
echo "repo_token: $(cat /var/lib/jenkins-slave/coveralls.io.token)" >> .coveralls.yml
set -x
echo "src_dir: /" >> .coveralls.yml
echo "service_name: php-coveralls" >> .coveralls.yml
echo "service_event_type: manual" >> .coveralls.yml
echo "coverage_clover: log/clover.xml" >> .coveralls.yml
echo "json_path: log/coveralls-upload.json" >> .coveralls.yml

php vendor/bin/coveralls
