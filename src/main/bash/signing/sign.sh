#!/usr/local/bin/bash

if [[ $# -ne 5 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

SECRETS_SRC="$1"

if [[ -z "${SECRETS_SRC}" ]]; then
 echo 'No src!' >&2; exit 1
elif [[ -L "${SECRETS_SRC}" ]]; then
 echo "\"${SECRETS_SRC}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${SECRETS_SRC}" ]]; then
 echo "\"${SECRETS_SRC}\" does not exist!" >&2; exit 1
elif [[ ! -f "${SECRETS_SRC}" ]]; then
 echo "\"${SECRETS_SRC}\" is not a file!" >&2; exit 1
elif [[ ! -s "${SECRETS_SRC}" ]]; then
 echo "\"${SECRETS_SRC}\" is empty!" >&2; exit 1
fi

SECRETS_SIGNATURE="$2"

if [[ -z "${SECRETS_SIGNATURE}" ]]; then
 echo 'No signature!' >&2; exit 1
elif [[ -L "${SECRETS_SIGNATURE}" ]]; then
 echo "\"${SECRETS_SIGNATURE}\" is a symlink!" >&2; exit 1
elif [[ -e "${SECRETS_SIGNATURE}" ]]; then
 if [[ -f "${SECRETS_SIGNATURE}" ]]; then
  echo "\"${SECRETS_SIGNATURE}\" exists!" >&2; exit 1
 else
  echo "\"${SECRETS_SIGNATURE}\" is not a file!" >&2; exit 1
 fi
fi

SECRETS_KEY="$3"

if [[ -z "${SECRETS_KEY}" ]]; then
 echo 'No key!' >&2; exit 1
elif [[ -L "${SECRETS_KEY}" ]]; then
 echo "\"${SECRETS_KEY}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${SECRETS_KEY}" ]]; then
 echo "\"${SECRETS_KEY}\" does not exist!" >&2; exit 1
elif [[ ! -f "${SECRETS_KEY}" ]]; then
 echo "\"${SECRETS_KEY}\" is not a file!" >&2; exit 1
elif [[ ! -s "${SECRETS_KEY}" ]]; then
 echo "\"${SECRETS_KEY}\" is empty!" >&2; exit 1
fi

SECRETS_ALGORITHM="$4"

case "${SECRETS_ALGORITHM}" in
 'sha256') SECRETS_ALGORITHM_FLAG='-sha256';;
 *) echo "Algorithm \"${SECRETS_ALGORITHM}\" is not supported!" >&2; exit 1;;
esac

SECRETS_PASSWORD_SRC="$5"

if [[ ! "${SECRETS_PASSWORD_SRC}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || ! -v "${SECRETS_PASSWORD_SRC}" ]]; then
 echo 'Wrong password!' >&2; exit 1; fi

openssl dgst "${SECRETS_ALGORITHM_FLAG}" -sign "${SECRETS_KEY}" -passin "env:${SECRETS_PASSWORD_SRC}" -out "${SECRETS_SIGNATURE}" "${SECRETS_SRC}"

if [[ $? -ne 0 ]]; then
 echo "Sign \"${SECRETS_SRC}\" error!" >&2; exit 1; fi

if [[ -L "${SECRETS_SIGNATURE}" ]]; then
 echo "\"${SECRETS_SIGNATURE}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${SECRETS_SIGNATURE}" ]]; then
 echo "\"${SECRETS_SIGNATURE}\" does not exist!" >&2; exit 1
elif [[ ! -f "${SECRETS_SIGNATURE}" ]]; then
 echo "\"${SECRETS_SIGNATURE}\" is not a file!" >&2; exit 1
elif [[ ! -s "${SECRETS_SIGNATURE}" ]]; then
 echo "\"${SECRETS_SIGNATURE}\" is empty!" >&2; exit 1
fi
