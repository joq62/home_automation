%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(websocket_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.
start(_Type, _Args) ->
       io:format("tabort , cwd ~p~n",[{?MODULE,?LINE,file:get_cwd()}]),
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_dir, websocket,"index.html"}},
			{"/stugcontroller", ws_h, []},
			{"/static/[..]", cowboy_static, {priv_file, websocket, "static"}}
		]}
	]),
      io:format("tabort ,Dispatch  ~p~n",[{?MODULE,?LINE,Dispatch}]),
	{ok, _} = cowboy:start_clear(http, [{port, 58080}], #{
		env => #{dispatch => Dispatch}
	}),
	websocket_sup:start_link().

stop(_State) ->
	ok.
