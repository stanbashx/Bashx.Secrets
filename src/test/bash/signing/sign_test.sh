#!/usr/local/bin/bash

SCRIPT='src/main/bash/signing/sign.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC=''
SECRETS_DST=''
SECRETS_KEY=''
SECRETS_PASSWORD_SRC=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No src!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_DST=''
SECRETS_KEY=''
SECRETS_PASSWORD_SRC=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No dst!\n'
rm "${SECRETS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_DST="$(mktemp)"
rm "${SECRETS_DST}"
SECRETS_KEY=''
SECRETS_PASSWORD_SRC=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No key!\n'
rm "${SECRETS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_DST="$(mktemp)"
rm "${SECRETS_DST}"
SECRETS_KEY='src/test/res/rsa4096.key'
SECRETS_PASSWORD_SRC=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong password!\n'
rm "${SECRETS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_DST="$(mktemp)"
rm "${SECRETS_DST}"
SECRETS_KEY='src/test/res/rsa4096.key'
SECRETS_PASSWORD_SRC='SECRETS_PASSWORD'
SECRETS_ALGORITHM='foo'
SECRETS_PASSWORD='qwe123' \
 "${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "Algorithm \"${SECRETS_ALGORITHM}\" is not supported!"$'\n'
rm "${SECRETS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_DST="$(mktemp)"
rm "${SECRETS_DST}"
SECRETS_KEY='src/test/res/rsa4096.key'
SECRETS_PASSWORD_SRC='SECRETS_PASSWORD'
SECRETS_ALGORITHM='sha256'
SECRETS_PASSWORD='qwe123' \
 "${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_DST}" "${SECRETS_KEY}" "${SECRETS_PASSWORD_SRC}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
openssl dgst -sha256 -verify 'src/test/res/rsa4096.pub' -signature "${SECRETS_DST}" "${SECRETS_SRC}" > /dev/null
if [[ $? -ne 0 ]]; then
 echo "Verify \"${SECRETS_SRC}\" error!" >&2; exit 1; fi
rm "${SECRETS_SRC}"
rm "${SECRETS_DST}"

#

rm "${STDOUT}"
rm "${STDERR}"
