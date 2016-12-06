#!/bin/sh
# This file contains customizations that can be applied during
# the install of ManageSoft for Managed Devices.

# Create a secure temporary directory
TMPDIR=/var/tmp/tempdir.$RANDOM.$RANDOM.$$
( umask 077 && mkdir $TMPDIR ) || {
        echo "ERROR: mgssetup.sh could not create a temporary directory." 1>&2
        exit 1
}

# ----------------------------------------------------------------------
cat << EOF > $TMPDIR/mgsft_rollout_response

# The ManageSoft domain name.  Refer to the ManageSoft
# documentation for further details.
MGSFT_DOMAIN_NAME=asp.int

# The alternate machine identification allows the specification of an
# alternate machine name if it is to be different to the current hostname
# (e.g. if registered differently in Active Directory) Not specifying
# this setting or a value of NONE disables this feature.
# MGSFT_MACHINE_ID=

# The policy path specifies the location of the policy to be applied to
# the managed device.  This is typically used when the policy is not
# attached to Active Directory domains.  For example, a path may be
# "Policies/Merged/MANAGESOFT_domain/Machine/device.npl".  Not specifying
# this setting or a value of NONE disables this feature.
MGSFT_POLICY_PATH="Policies/Merged/MANAGESOFT_domain/Machine/hosting international servers.npl"

# The initial ManageSoft download location(s) for the installation.
# For example, http://myhost.mydomain.com/ManageSoftDL/
# Refer to the ManageSoft documentation for further details.
MGSFT_BOOTSTRAP_DOWNLOAD=http://sam.usgpeoplehosting.com/ManageSoftDL

# The initial ManageSoft reporting location(s) for the installation.
# For example, http://myhost.mydomain.com/ManageSoftRL/
# Refer to the ManageSoft documentation for further details.
MGSFT_BOOTSTRAP_UPLOAD=http://sam.usgpeoplehosting.com/ManageSoftRL

# The initial proxy configuration.  Uncomment these to enable proxy configuration.
# Note that setting values of NONE disables this feature.
# MGSFT_HTTP_PROXY=http://webproxy.local:3128
# MGSFT_HTTPS_PROXY=https://webproxy.local:3129
# MGSFT_PROXY=socks:socks.socksproxy.local:19121,direct
# MGSFT_NO_PROXY=internal1.local,internal2.local

# Check the HTTPS server certificate's existence, name, validity period,
# and issuance by a trusted certificate authority (CA).  This is enabled
# by default and can be disabled with false.
# MGSFT_HTTPS_CHECKSERVERCERTIFICATE=true

# Check that the HTTPS server certificate has not been revoked. This is
# enabled by default and can be disabled with false.
# MGSFT_HTTPS_CHECKCERTIFICATEREVOCATION=true

# The run policy flag determines if policy will run after installation.
#    "1" or "Yes" will run policy after install
#    "0" or "No" will not run policy
MGSFT_RUNPOLICY=Yes
EOF

# Set owner to install or nobody or readable by all so pre 8.2.0 Solaris
# clients checkinstall script can read it.
if [ "`uname -s`" = "SunOS" ]
then
        chown install $TMPDIR/mgsft_rollout_response 2>/dev/null \
                || chown nobody $TMPDIR/mgsft_rollout_response 2>/dev/null \
                || chmod a+r $TMPDIR/mgsft_rollout_response
fi

# ----------------------------------------------------------------------
# Move from the secure directory to the known path
ret=0
( mv -f $TMPDIR/mgsft_rollout_response /var/tmp/mgsft_rollout_response ) || ret=1
rm -rf $TMPDIR

[ $ret -ne 0 ] && echo "ERROR: mgssetup.sh could not create answer files." 1>&2

exit $ret

