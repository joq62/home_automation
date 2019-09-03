all:
	@test -d deps || rebar get-deps	
	rebar compile
	erlc -o ebin src/*.erl;
	erl -pa ebin -pa deps/*/ebin -s boot start -name websocket@joqhome.dynamic-dns.net

clean:
	rm -rf *~ apps/ebin/*.beam apps/app_tellstick/*.beam apps/system/*.beam *.beam *.tmp apps/ebin/misc_dets;
	cd apps; make
