all:
	ERL_LIBS=_rel/websocket_example/lib;
	rm -f ebin/*;
	rm -rf ebin_cowboy/*;
	cp ../cowboy/ebin/* ebin_cowboy;
	cp ../cowboy/deps/ranch/ebin/* ebin_cowboy;
	cp ../cowboy/deps/cowlib/ebin/* ebin_cowboy;
	erlc -o ebin src/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -pa ebin_cowboy -name a@joqhome.dynamic-dns.net -s boot start
