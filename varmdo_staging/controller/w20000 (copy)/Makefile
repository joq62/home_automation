all:
	ok
compile:
	rm -rf app_files/* ebin_files/*;
#  applications app_deploy
	erlc -o ebin_files  ../../../applications/app_deploy/src/*.erl;
	cp ../../../applications/app_deploy/src/*.app app_files;
	cp ../../../applications/app_deploy/src/*.app ebin_files;
#servers app_deploy
	erlc -o ebin_files  ../../../servers/app_deploy/src/*.erl;
#  applications app_discovery
	erlc -o ebin_files  ../../../applications/app_discovery/src/*.erl;
	cp ../../../applications/app_discovery/src/*.app app_files;
	cp ../../../applications/app_discovery/src/*.app ebin_files;
#servers app_discovery
	erlc -o ebin_files  ../../../servers/app_discovery/src/*.erl;
#  applications adder
	erlc -o ebin_files  ../../../applications/adder/src/*.erl;
	cp ../../../applications/adder/src/*.app app_files;
	cp ../../../applications/adder/src/*.app ebin_files;
#servers adder
	erlc -o ebin_files  ../../../servers/adder/src/*.erl;
#  applications tick
	erlc -o ebin_files  ../../../applications/tick/src/*.erl;
	cp ../../../applications/tick/src/*.app app_files;
	cp ../../../applications/tick/src/*.app ebin_files;
#servers
	erlc -o ebin_files  ../../../servers/server/src/*.erl;
# eunit test
	rm -rf test_ebin/*;
	erlc -o test_ebin test_src/*.erl;
	echo Compilation succeeded
test:
#erl command
	erl -pa ebin_files -name controller@varmdo.asuscomm.com -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -pa test_ebin -s test_controller_eunit test 
exec:
	erl -pa ebin_files -name controller@varmdo.asuscomm.com -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -pa test_ebin
