PROJECT = websocket
PROJECT_DESCRIPTION = Cowboy Websocket example
PROJECT_VERSION = 1

DEPS = cowboy
dep_cowboy_commit = master

include ../../erlang.mk

appl:
	erl -pa ebin -s web_appl start -name web_appl@joqhome.dynamic-dns.net
