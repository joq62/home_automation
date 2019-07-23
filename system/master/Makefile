all:
	rm -rf ebin/* src/*~;
	erlc -o ebin src/*.erl;
	cp src/*.app ebin;
	tar -cvf master.tar ebin

master:
	rm -rf ebin/* src/*~;
	erlc -o ebin src/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -pa ../*/ebin -name master@varmdo.asuscomm.com -setcookie abc -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -s master load_start

test:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -pa test_ebin -s test_master_eunit test -sname test_master
