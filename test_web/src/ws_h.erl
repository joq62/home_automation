-module(ws_h).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
    io:format("~p~n",[State]),
    NewState=lists:append(State,[{"varme_huset","off"},{"varme_lillstugan","off"},
				 {"lampor_huset","off"},{"lampor_lillstugan","off"}]),
    {ok, NewState}.

websocket_handle({text, Msg}, State) ->
    io:format("~p~n",[{?MODULE,?LINE,Msg}]),
    MsgStr=binary_to_list(Msg),
    io:format("~p~n",[{?MODULE,?LINE,MsgStr}]),
    test_loop!{self(),{execute,MsgStr}},
    receive
	{test_loop,{execute_ret, {NewState,Reply}}}->
	    {NewState,Reply}
    end,
    {reply,Reply, NewState};

websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info({send, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, State};

websocket_info({timeout, _Ref, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
	{ok, State}.
