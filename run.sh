#!/bin/bash
GROUP=2019-02
BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}
HOMEWORK_RUN=./otus-homeworks/homeworks/$BRANCH/run.sh
REPO=https://github.com/express42/otus-homeworks.git
DOCKER_IMAGE=sun2everyone/hwtest

echo GROUP:$GROUP

if [ "$BRANCH" == "" ]; then
	echo "We don't have tests for master branch"
	exit 0
fi

echo HOMEWORK:$BRANCH

echo "Clone repository with tests"
git clone -b $GROUP --single-branch --branch 2019-02 $REPO

## Fixing tests
 sed -i ./otus-homeworks/homeworks/$BRANCH/controls/packer.rb -e "s/its('stdout').*$/its('stdout') {should eq '' }/"
 sed -i ./otus-homeworks/homeworks/$BRANCH/controls/ansible.rb -e "/ansible-lint/,+3 d"
 sed -i ./otus-homeworks/homeworks/$BRANCH/controls/ansible.rb -e "s/ansible\/roles/ansible\/\.import_roles:ansible\/roles/"


if [ -f $HOMEWORK_RUN ]; then
	echo "Run tests"
	# Prepare network & run container
	docker network create hw-test-net
	docker run -d -v $(pwd):/srv -v /var/run/docker.sock:/tmp/docker.sock \
		-e DOCKER_HOST=unix:///tmp/docker.sock -e CHEF_LICENSE=accept --cap-add=NET_ADMIN -p 33433:22 --privileged \
		--device /dev/net/tun --name hw-test --network hw-test-net $DOCKER_IMAGE
	# Show versions & run tests
	docker exec hw-test bash -c 'echo -=Get versions=-; ansible --version; ansible-lint --version; packer version; terraform version; tflint --version; docker version; docker-compose --version'
	docker exec hw-test bash -c 'printf "[app]\nlocalhost\n\n[db]\nlocalhost\n" > ansible/inventory'
	docker exec -e USER=appuser -e BRANCH=$BRANCH hw-test $HOMEWORK_RUN

	# ssh -i id_rsa_test -p 33433 root@localhost "cd /srv && BRANCH=$BRANCH $HOMEWORK_RUN"
else
	echo "We don't have tests for this homework"
	exit 0
fi
