-module(ws_mm).

-export([start/1]).

-define(WEB_APP_ADDR,"localhost").
-define(WEB_APP_PORT,58089).
-define(CLIENT_SETUP,[binary,{packet,4}]).


start(Pid_WS_handler)->
    io:format("~p~n",[{?MODULE,?LINE,Pid_WS_handler}]),
    case gen_tcp:connect(?WEB_APP_ADDR,?WEB_APP_PORT,?CLIENT_SETUP) of
	{ok,Socket}->
	    Pid_WS_handler!{ok,active_session},
	    loop(Pid_WS_handler,Socket);
	{error,Err}->
	    Pid_WS_handler!{error,Err}
    end.

loop(Pid_WS_handler,Socket)->
    receive
	{tcp,Socket,AppMsgBin}-> %MEssage from Web application 
	    io:format("~p~n",[{?MODULE,?LINE,tcp,Socket,AppMsgBin}]),
	    Pid_WS_handler!{msg_from_app,AppMsgBin},
	    loop(Pid_WS_handler,Socket);
	{Pid_WS_handler,{event_to_app,Event}}->
	    io:format("~p~n",[{?MODULE,?LINE,event_to_app,Event}]),
	    gen_tcp:send(Socket,Event),
	    loop(Pid_WS_handler,Socket);
	{tcp_close,Socket}->
	    Pid_WS_handler!{self,{error,connection_closed}};
	Err ->
	    io:format("~p~n",[{?MODULE,?LINE,error,Err,Socket}]),
	    loop(Pid_WS_handler,Socket)
    end.
