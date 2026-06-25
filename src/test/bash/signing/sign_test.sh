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

echo 'Not implemented!'; exit 1 # todo

#

rm "${STDOUT}"
rm "${STDERR}"
