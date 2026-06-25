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

SECRETS_DST="$2"

if [[ -z "${SECRETS_DST}" ]]; then
 echo 'No dst!' >&2; exit 1
elif [[ -L "${SECRETS_DST}" ]]; then
 echo "\"${SECRETS_DST}\" is a symlink!" >&2; exit 1
elif [[ -e "${SECRETS_DST}" ]]; then
 if [[ -f "${SECRETS_DST}" ]]; then
  echo "\"${SECRETS_DST}\" exists!" >&2; exit 1
 else
  echo "\"${SECRETS_DST}\" is not a file!" >&2; exit 1
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

SECRETS_PASSWORD="$4"

SECRETS_ALGORITHM="$5"

case "${SECRETS_ALGORITHM}" in
 'sha256') SECRETS_ALGORITHM_FLAG='-sha256';;
 *) echo "Algorithm \"${SECRETS_ALGORITHM}\" is not supported!" >&2; exit 1;;
esac

openssl dgst "${SECRETS_ALGORITHM_FLAG}" -sign "${SECRETS_KEY}" -passin "pass:${SECRETS_PASSWORD}" -out "${SECRETS_DST}" "${SECRETS_SRC}"

if [[ $? -ne 0 ]]; then
 echo "Signing \"${SECRETS_SRC}\" error!" >&2; exit 1; fi

if [[ -L "${SECRETS_DST}" ]]; then
 echo "\"${SECRETS_DST}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${SECRETS_DST}" ]]; then
 echo "\"${SECRETS_DST}\" does not exist!" >&2; exit 1
elif [[ ! -f "${SECRETS_DST}" ]]; then
 echo "\"${SECRETS_DST}\" is not a file!" >&2; exit 1
elif [[ ! -s "${SECRETS_DST}" ]]; then
 echo "\"${SECRETS_DST}\" is empty!" >&2; exit 1
fi
