all:
	@test -d deps || rebar get-deps	
	rebar compile
	cd apps; make

clean:
	rm -rf *~ apps/ebin/*.beam apps/app_tellstick/*.beam apps/system/*.beam *.beam *.tmp apps/ebin/misc_dets;
	cd apps; make
