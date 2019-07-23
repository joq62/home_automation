all:
	ok
compile:
	rm -rf app_files/* ebin_files/*;
# eunit test
	rm -rf test_ebin/*;
	erlc -o test_ebin test_src/*.erl;
	echo Compilation succeeded
test:
#erl command
	erl -pa ebin_files -name controller@varmdo.asuscomm.com -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -pa test_ebin -s test_controller_eunit test 
exec:
	erl -pa ebin_files -name controller@varmdo.asuscomm.com -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -pa test_ebin -s system_boot start
