#!/usr/bin/env bash
#npm config set registry http://registry.npmjs.org/  
export gtm_dist=/usr/lib/x86_64-linux-gnu/fis-gtm/V6.3-003A_x86_64
echo "source ~/nodem/resources/environ" >> ~/.profile
echo "gtm_dist=/usr/lib/x86_64-linux-gnu/fis-gtm/V6.3-003A_x86_64" >> ~/.profile
#npm install nodem --verbose
unzip nodem.zip
cd nodem
npm install
