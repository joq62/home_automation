all:
	rm -rf ebin/* src/*~;
	erlc -o ebin src/*.erl;
	tar -cvf adder.tar ebin

exec:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -name test_app_discover@varmdo.asuscomm.com -setcookie change

test:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s test_app_discover_eunit test -name test_app_discover@varmdo.asuscomm.com -setcookie change
