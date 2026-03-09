{{#if (eq DOD_DISTRIBUTION_NAME 'fedora')}}
export BROWSER="~/.local/bin/distrobox-host-exec"
export SSL_CERT_FILE=/etc/pki/ca-trust/source/anchors/curl-ca-bundle.crt
{{/if}}
