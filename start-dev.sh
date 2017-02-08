#!/bin/sh
cd `dirname $0`
exec erl -sname h2e -config $PWD/sys.config -pa $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -setcookie h2e -s h2e_app start