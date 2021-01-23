#/usr/bin/env bash

# TODO - change OS version via arguments passed
UBUNTU_VERSION=${1:-trusty}

BASE_IMAGE="fis-gtm-env:${UBUNTU_VERSION}"
TempDockerBase=".Dockerfile.base"
install_gtm=install-gtm-deb.sh

cat <<EOF > ${TempDockerBase} 
FROM ubuntu:${UBUNTU_VERSION}

MAINTAINER Timur Safin

ADD	${install_gtm} /root
RUN 	chmod +x /root/${install_gtm}
RUN	["/root/${install_gtm}"]

# we want load ~/.profile for the interactive bash session invocation
# with all GT.M aliases and paths defined
ENTRYPOINT ["/bin/bash", "-l"]
EOF

docker build -t ${BASE_IMAGE} --rm -f ${TempDockerBase} .
#rm -f ${TempDockerBase}

DEBUG_IMAGE="fis-gtm-devel:${UBUNTU_VERSION}"
TempDockerDev=".Dockerfile.dev"
install_devtools=install_devtools.sh
install_node=install_node.sh
install_nodem=install_nodem.sh
nodem_zip=nodem.zip

cat <<EOF > ${TempDockerDev}
FROM ${BASE_IMAGE}

MAINTAINER Timur Safin

COPY	${install_devtools} /root
RUN 	chmod +x /root/${install_devtools}
COPY    dev-root/.gdbinit /root
COPY    dev-root/run-gdb.sh /root
COPY    dev-root/run-cmake.sh /root
RUN	    chmod +x /root/run-gdb.sh /root/run-cmake.sh
RUN	    ["/root/${install_devtools}"]
COPY	${install_node} /root
RUN	    chmod +x /root/${install_node}
RUN	    ["/root/${install_node}"]



RUN     useradd -ms /bin/bash nodem
WORKDIR		/home/nodem

COPY	${nodem_zip} /home/nodem
COPY    ${install_nodem} /home/nodem
RUN	    chmod +x /home/nodem/${install_nodem}

USER	nodem
RUN	    ["/home/nodem/${install_nodem}"]

VOLUME ["/tmp/fis-gtm"]

ENTRYPOINT ["/bin/bash", "-l"]
EOF

docker build -t ${DEBUG_IMAGE} --rm -f ${TempDockerDev} .
