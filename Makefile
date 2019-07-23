all:
	rm -rf ebin/* */src/*~;
	erlc -o varmdo_staging/controller/w20000/ebin */*/src/*.erl;
	cp */*/src/*.app varmdo_staging/controller/w20000/ebin
math:
	rm -rf ebin/* test_ebin/* test_src/*~;
	erlc -o ebin servers/*/src/*.erl;
	erlc -o ebin applications/*/src/*.erl;
	cp applications/*/src/*.app ebin;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s test_b_eunit test -sname test_b
