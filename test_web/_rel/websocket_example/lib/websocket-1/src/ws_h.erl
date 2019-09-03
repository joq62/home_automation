-module(ws_h).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

split_msg(MsgStr)->
    string:split(MsgStr,":").

get_args(ArgStr)->
    A1=string:trim(ArgStr,both,"["),
    A2=string:trim(A1,both,"]"),
    string:tokens(A2,",").

execute("button",[Id],State)->
        {NewState,Reply}=case lists:keyfind(Id,1,State) of
			     {Id,"off"}->
				 IdBitStr=iolist_to_binary(Id),
				 {lists:keyreplace(Id,1,State,{Id,"on"}),
				  {text, << "change_text",":", IdBitStr/binary, ":","on" >>}};
			     {Id,"on"}->
				 IdBitStr=iolist_to_binary(Id),
				 {lists:keyreplace(Id,1,State,{Id,"off"}),
				  {text, << "change_text",":", IdBitStr/binary,":", "off" >>}};
			     X->
				 io:format("X=~p~n",[X]),
				 IdBitStr=iolist_to_binary(Id),
				 {State,
				  {text, << "error", IdBitStr/binary, "no_element" >>}}
			 end,
    {NewState,Reply};
execute("button",Args,State)->
    io:format("Args =~p~n",[Args]),
    ArgsBitStr=iolist_to_binary(Args),
    {State,{text, << "error", ArgsBitStr/binary, "badargs" >>}};
execute(Function,_,State) ->
    io:format("Function =~p~n",[Function]),
    FunctionBitStr=iolist_to_binary(Function),
    {State,{text, << "error", FunctionBitStr/binary, "function not implemented" >>}}.

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
%	erlang:start_timer(1000, self(), <<"Hello!">>),
    io:format("~p~n",[State]),
    NewState=lists:append(State,[{"varme_huset","off"},{"varme_lillstugan","off"},
	   {"lampor_huset","off"},{"lampor_lillstugan","off"}]),
 %   NewState=lists:append(State,[{<<"varme_huset">>,"off"},{<<"varme_lillstugan">>,"off"},
%	   {<<"lampor_huset">>,"off"},{<<"lampor_lillstugan">>,"off"}]),
    {ok, NewState}.

websocket_handle({text, Msg}, State) ->
    io:format("~p~n",[{?MODULE,?LINE,Msg}]),
    MsgStr=binary_to_list(Msg),
    io:format("~p~n",[{?MODULE,?LINE,MsgStr}]),
    [Function,ArgStr]=split_msg(MsgStr),  
    io:format("Function,ArgStr ~p~n",[{?MODULE,?LINE,Function,ArgStr}]),  
    ArgList=get_args(ArgStr),    
    io:format("ArgList~p~n",[{?MODULE,?LINE,ArgList}]),
    {NewState,Reply}= execute(Function,ArgList,State),
    {reply,Reply, NewState};


websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
	{ok, State}.
