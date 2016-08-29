#! /usr/bin/env bash
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${SOURCE_DIR}"

function err() { echo "$@" 1>&2; }

function assert_equal_comp {
    IN="$1";
    EXPOUT="$2";
    GOTOUT="$(echo "$IN" | ./regexp_dotno)";
    
    if [ "${EXPOUT}" != "${GOTOUT}" ]; then
        echo "[ERROR] Input '${IN}', expected '${EXPOUT}', got '${GOTOUT}'";
    # else
        # echo "[OK] Input '${IN}', expected '${EXPOUT}', got '${GOTOUT}'";
    fi
}

function assert_equal {
    assert_equal_comp "$1" "$1";
}

function assert_empty {
    IN="$1";
    GOTOUT="$(echo "$IN" | ./regexp_dotno)";
    
    if [ "x" != "x${GOTOUT}" ]; then
        echo "[ERROR] Input '${IN}', expected '', got '${GOTOUT}'";
    # else
        # echo "[OK] Input '${IN}', expected '${EXPOUT}', got '${GOTOUT}'";
    fi
}

# These should be cut down to 63
assert_equal_comp "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa64aa.no" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa64aa.no"
assert_equal_comp "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa80aaaa.no" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa80aaaa.no"

assert_equal "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa62aa.no"
assert_equal "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa63aa.no"
assert_equal "m.oslo.no"
assert_equal "aa.oslo.no"
assert_equal "lo.no"
assert_equal "sool.no"
assert_equal "o-a.no"
assert_equal "foobarfoooo.oslo.no"
assert_equal "www.gs.of.no"
assert_equal "www.sande.more-og-romsdal.no"
assert_equal "no.no"

assert_empty "l.no"
assert_empty "-o.no"
assert_empty "o-.no"


echo "[INFO] All tests complete"