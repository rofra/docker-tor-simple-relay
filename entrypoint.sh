#!/bin/bash
set -e

# Prepare configuration file
cp -f /torrc.base $HOME/.torrc

cat <<-EOF >> ${HOME}/.torrc
${TOR_EXTRA_CONF}
EOF

exec /usr/local/bin/tor "$@"