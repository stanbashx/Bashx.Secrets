#!/usr/local/bin/bash

SCRIPT='src/main/bash/signing/verify.sh'

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
"${SCRIPT}" '' '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC=''
SECRETS_SIGNATURE=''
SECRETS_KEY=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_SIGNATURE}" "${SECRETS_KEY}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No src!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_SIGNATURE=''
SECRETS_KEY=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_SIGNATURE}" "${SECRETS_KEY}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No signature!\n'
rm "${SECRETS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_SIGNATURE="$(mktemp)"
printf '%s' 'bar' > "${SECRETS_SIGNATURE}"
SECRETS_KEY=''
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_SIGNATURE}" "${SECRETS_KEY}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No key!\n'
rm "${SECRETS_SRC}"

:> "${STDOUT}"
:> "${STDERR}"
SECRETS_SRC="$(mktemp)"
printf '%s' 'foo' > "${SECRETS_SRC}"
SECRETS_SIGNATURE="$(mktemp)"
printf '%s' 'bar' > "${SECRETS_SIGNATURE}"
SECRETS_KEY='src/test/res/rsa4096.pub'
SECRETS_ALGORITHM=''
"${SCRIPT}" "${SECRETS_SRC}" "${SECRETS_SIGNATURE}" "${SECRETS_KEY}" "${SECRETS_ALGORITHM}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "Algorithm \"${SECRETS_ALGORITHM}\" is not supported!"$'\n'
rm "${SECRETS_SRC}"

echo 'Not implemented!'; exit 1 # todo

#

rm "${STDOUT}"
rm "${STDERR}"
