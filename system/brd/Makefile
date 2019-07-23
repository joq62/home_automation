all:
	rm -rf ebin/* src/*~;
	erlc -o ebin src/*.erl;
	cp src/*.app ebin;
	tar -cvf count.tar ebin

w1:
	erl -pa ebin -name w1@varmdo.asuscomm.com -setcookie abc -kernel inet_dist_listen_min 20001 inet_dist_listen_max 20001 -s brd load_start

w2:
	erl -pa ebin -name w2@varmdo.asuscomm.com -setcookie abc -kernel inet_dist_listen_min 20002 inet_dist_listen_max 20002 -s brd load_start



test:
	rm -rf ebin/* src/*~ test_ebin/* test_src/*~;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -pa test_ebin -s test_brd_eunit test -sname test_brd
