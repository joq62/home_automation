all:
	rm -rf ebin/* src/*~;
	erlc -o ebin src/*.erl;
	tar -cvf server.tar ebin

test:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s test_server_eunit test -sname test_server
