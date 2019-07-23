%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(brd_lib).
 


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(NUM_TRIES,10).
-define(INTERVALL,5*1000).
-define(MASTER_NODES,['master@varmdo.asuscomm.com','master@joqhome.dynamic-dns.net']).
%% --------------------------------------------------------------------

%% External exports
-compile(export_all).

%-export([load_start_node/3,stop_unload_node/3
%	]).


%% ====================================================================
%% External functions
%% ====================================================================
connect()->
    R=do_connect(?NUM_TRIES,?INTERVALL,?MASTER_NODES,false),
    R.
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

add(A,B)->
    A+B.
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
%filter_events(Key
do_connect(0,_,_,false)->
    {error,efailed_to_connect_master};
do_connect(0,_,_,true)->
    ok;
do_connect(N,I,Masters,R)->
    case do_ping(Masters,false) of
	true->
	    NewN=0,
	    NewR=true;
	false->
	    NewN=N-1,
	    NewR=false,
	    timer:sleep(I)
    end,
    do_connect(NewN,I,Masters,NewR).

do_ping([],R)->
    R;
do_ping([MasterNode|T],R) ->
    io:format("Try to connect ~p~n",[{?MODULE,?LINE,MasterNode}]),
    case net_adm:ping(MasterNode) of
	pong->
	    NewT=[],
	    NewR=true;
	pang ->
	    NewT=T,
	    NewR=false
    end,
    do_ping(NewT,NewR).
	      
