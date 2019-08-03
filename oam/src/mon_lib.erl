%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(mon_lib).
 


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports
-compile(export_all).

%-export([load_start_node/3,stop_unload_node/3
%	]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
print_event(Event)->
    {date,D}= lists:keyfind(date,1,Event),
    {time,T}= lists:keyfind(time,1,Event), 
    {node,Node}= lists:keyfind(node,1,Event),
    {event_level,Level}= lists:keyfind(event_level,1,Event),
    {event_info,Info}= lists:keyfind(event_info,1,Event),
    io:format(" ~w ~n",[{D,T,Node,Level,Info}]).

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
print_events(Num)->
    Events=log:read_events(Num),
    [rpc:call(node(),controller_lib,print_event,[Event])||Event<-Events],

print_event(Prev)->
    io:format("~p~n",[Prev]),
    [OamNode|_]=rpc:call('w50100@joqhome.dynamic-dns.net',app_discovery,query,[log]),
    case rpc:call(OamNode,log,read_events,[1]) of
	[LogInfo]->
		io:format("~p~n",[{?MODULE,?LINE,LogInfo}]),
	    if 
		Prev==LogInfo->
		    io:format("~p~n",[{?MODULE,?LINE,Prev}]),
		    NewPrev=Prev;
		true ->
		    io:format("~p~n",[LogInfo]),
		    NewPrev=LogInfo
	    end;
	{badrpc,Err}->
	    io:format("~p~n",[{badrpc,Err}]),
	    NewPrev=[]
    end,
    NewPrev.

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
%filter_events(Key
