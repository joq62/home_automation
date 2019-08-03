all:
	rm -rf *.app *.erl *.beam;
	erl -pa boot_strap -name w20000@joqhome.dynamic-dns.net -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -s boot_strap start worker
test:
	erl -name w20000@joqhome.dynamic-dns.net -setcookie change -kernel inet_dist_listen_min 20000 inet_dist_listen_max 20000 -s mon start
