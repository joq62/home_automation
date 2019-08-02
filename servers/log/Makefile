## set the paths for a default setup
all:
	rm -rf */*~ *.beam ebin/* *~ *.dump */*.beam;
	erlc -o ebin src/*.erl;
	erl -pa ebin -s log_lib boot -sname log
test:
	erlc -o ebin src/*.erl;
	erlc -o ebin test_src/*.erl;
	erl -pa ebin -s test_log test -sname test_log
