-module(ws_h).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).


init(Req, Opts) ->
 %   io:format("~p~n",[{?MODULE,?LINE,init,Req}]),
    {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
    io:format("~p~n",[{?MODULE,?LINE,websocket_init}]),
    PidHandler=self(),
    {PidMM,RefMM}=spawn_monitor(ws_mm,start,[PidHandler]),
    Result=receive
	       {ok,active_session}->
		   io:format("~p~n",[{?MODULE,?LINE, ok,active_session}]),
		   NewState=lists:append(State,[{pid_mm,PidMM},{ref_mm,RefMM}]),
		   {ok,NewState};
	       Error->
		   io:format("~p~n",[{?MODULE,?LINE, error,Error}]),
		   {error,Error}
    end,
    io:format("Result ~p~n",[{?MODULE,?LINE,Result}]),
    Result.

websocket_handle({text, Event}, State) ->
    io:format("~p~n",[{?MODULE,?LINE,websocket_handle,{text, Event}}]),
    {pid_mm,PidMM}=lists:keyfind(pid_mm,1,State),
    PidMM!{self(),{event_to_app,Event}},
    {ok, State};

websocket_handle(Data, State) ->
    io:format("~p~n",[{?MODULE,?LINE,websocket_handle,Data}]),
    {ok, State}.

websocket_info({msg_from_app,AppMsgBin}, State) ->
    {text,Msg}=binary_to_term(AppMsgBin),
    io:format("~p~n",[{?MODULE,?LINE,websocket_info,msg_from_app,Msg}]),
    {reply, {text, Msg}, State};

websocket_info({send, Msg}, State) ->
    {reply, {text, Msg}, State};

websocket_info(Info, State) ->
    io:format("unmathced signal ~p~n",[{?MODULE,?LINE,websocket_info,Info,State}]),
	{ok, State}.
