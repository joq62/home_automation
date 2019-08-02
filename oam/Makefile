## set the paths for a default setup
all:
	rm -rf */*~ *.beam ebin/* *~ *.dump */*.beam;
	erlc -o ebin src/*.erl;
	cp src/*.app ebin;
	erl -pa ebin -s log_lib boot -sname log
compile:
	erlc -o ebin src/*.erl;
	erlc -o ebin test_src/*.erl;
	echo compilation succeeded
mon:
	erl -pa ebin -s mon start -name@joqhome.dynamic-dns.net -setcookie change	
