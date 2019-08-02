all:
	rm -rf *.app *.erl *.beam;
	erl -pa ebin -name w20004@varmdo.asuscomm.com -setcookie change -kernel inet_dist_listen_min 20004 inet_dist_listen_max 20004
