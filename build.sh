#!/bin/bash

# help message function
function print_help_msg {
  echo -e "Build the docker image for NCBI blast+. Usage:"
  echo -e "  -u  optional username prefix for docker image (default = \"\")."
  echo -e "  -v  optional version for NCBI blast+."
  echo -e "  -l  flag indicator for latest version of blast"
  echo -e "  -t  flag indicator for simple testing with rpsblast."
  exit 1
}

IMAGE=blast
IMAGE_PREFIX=""
VERSION=$(cat VERSION)
TEST_FLAG='false'
LATEST_FLAG='false'
while getopts "u:v:lt" opt; do
  case $opt in
    u)  IMAGE_PREFIX=$OPTARG/           ;;
    v)  VERSION=$OPTARG                 ;;
    t)  TEST_FLAG='true'                ;;
    l)  LATEST_FLAG='true'              ;;
    ?)  print_help_msg
        exit 1
  esac
done

# build docker image with given prefix
docker build \
  --build-arg version="${VERSION}" \
  -t "${IMAGE_PREFIX}${IMAGE}:${VERSION}" .

# tag this version of docker image as latest if indicated
if ${LATEST_FLAG}; then
  docker tag "${IMAGE_PREFIX}${IMAGE}:${VERSION}" "${IMAGE_PREFIX}${IMAGE}":latest
fi

# execute the test script for validation
# test docker image with rpstblastn and rpsbprc
if ${TEST_FLAG}; then

  # the following code segment requires CD to run, and only test rpstblastn and rpsbproc

  # SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  # PROJECT_DIR="$( dirname "$( dirname "${SCRIPT_DIR}" )" )"

  # TEST_NUCLEOTIDE_NAME="AXOC01000064"
  # LOCAL_QUERIES_DIR="${SCRIPT_DIR}/queries"
  # LOCAL_RESULTS_DIR="${SCRIPT_DIR}/results"
  # LOCAL_DB_DIR="${PROJECT_DIR}/data/interim/CDD"
  # DB_NAME="Cdd"
  # DOCKER_QUERIES_DIR="/blast/queries"
  # DOCKER_RESULTS_DIR="/blast/results"
  # DOCKER_DB_DIR="/blast/db"

  # echo "Running rpstblastn with example nucleotide ..."
  # mkdir -p "${LOCAL_RESULTS_DIR}"
  # rm "${LOCAL_QUERIES_DIR}"/"${TEST_NUCLEOTIDE_NAME}".asn || true
  # rm "${LOCAL_RESULTS_DIR}"/"${TEST_NUCLEOTIDE_NAME}".txt || true

  # docker run --rm \
  #     -v "${LOCAL_QUERIES_DIR}":"${DOCKER_QUERIES_DIR}":ro \
  #     -v "${LOCAL_RESULTS_DIR}":"${DOCKER_RESULTS_DIR}":rw \
  #     -v "${LOCAL_DB_DIR}":"${DOCKER_DB_DIR}":ro \
  #     "${IMAGE_PREFIX}"blast:"${VERSION}" \
  #     rpstblastn \
  #         -query "${DOCKER_QUERIES_DIR}"/"${TEST_NUCLEOTIDE_NAME}".fna \
  #         -db "${DOCKER_DB_DIR}"/"${DB_NAME}" \
  #         -evalue 0.01 \
  #         -outfmt 11 \
  #         -out "${DOCKER_RESULTS_DIR}"/"${TEST_NUCLEOTIDE_NAME}".asn

  # echo "Parsing results from rpstblastn  ..."
  # mv "${LOCAL_RESULTS_DIR}"/"${TEST_NUCLEOTIDE_NAME}".asn "${LOCAL_QUERIES_DIR}"
  # docker run --rm \
  #     -v "${LOCAL_QUERIES_DIR}":"${DOCKER_QUERIES_DIR}":ro \
  #     -v "${LOCAL_RESULTS_DIR}":"${DOCKER_RESULTS_DIR}":rw \
  #     -v "${LOCAL_DB_DIR}":"${DOCKER_DB_DIR}":ro \
  #     "${IMAGE_PREFIX}"blast:"${VERSION}" \
  #     rpsbproc \
  #         -i "${DOCKER_QUERIES_DIR}"/"${TEST_NUCLEOTIDE_NAME}".asn \
  #         -o "${DOCKER_RESULTS_DIR}"/"${TEST_NUCLEOTIDE_NAME}".txt \
  #         -e 0.01 \
  #         -m rep

  # echo "Parsed results (in concise layout):"
  # cat "${LOCAL_RESULTS_DIR}"/"${TEST_NUCLEOTIDE_NAME}".txt
  pass

fi
