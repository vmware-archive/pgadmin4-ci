#!/bin/bash -l

set -eox pipefail

CWDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function make_cluster() {
  source /usr/local/gpdb/greenplum_path.sh
  # Currently, the max_concurrency tests in src/test/isolation2
  # require max_connections of at least 129.
  export DEFAULT_QD_MAX_CONNECT=150
  pushd /gpdb_src/gpAux/gpdemo
      su gpadmin -c make create-demo-cluster
  popd
}

function gen_env(){
  cat > /opt/run_test.sh <<-EOF
        trap look4diffs ERR

        function look4diffs() {

            diff_files=\`find .. -name regression.diffs\`

            for diff_file in \${diff_files}; do
            if [ -f "\${diff_file}" ]; then
                cat <<-FEOF

                        ======================================================================
                        DIFF FILE: \${diff_file}
                        ----------------------------------------------------------------------

                        \$(cat "\${diff_file}")

                    FEOF
            fi
            done
            exit 1
        }
        source /usr/local/greenplum-db-devel/greenplum_path.sh
        source /opt/gcc_env.sh
        cd "\${1}/gpdb_src"
        source gpAux/gpdemo/gpdemo-env.sh


        # Run your gpcc tests here

EOF

    chmod a+x /opt/run_test.sh
}



function _main() {
    if [ -z "${MAKE_TEST_COMMAND}" ]; then
        echo "FATAL: MAKE_TEST_COMMAND is not set"
        exit 1
    fi

    if [ -z "$TEST_OS" ]; then
        echo "FATAL: TEST_OS is not set"
        exit 1
    fi

    if [ "$TEST_OS" != "centos" -a "$TEST_OS" != "sles" ]; then
        echo "FATAL: TEST_OS is set to an invalid value: $TEST_OS"
    echo "Configure TEST_OS to be centos or sles"
        exit 1
    fi


    time make_cluster
    time gen_env

}

_main "$@"
