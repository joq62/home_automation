%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : 
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_log).
%% --------------------------------------------------------------------
%% Include files 
%% --------------------------------------------------------------------
%%  -include("").
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
-export([]).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: Application
%% Description:
%% Returns: non
%% ------------------------------------------------------------------

%% --------------------------------------------------------------------
%% 1. Initial set up
%% --------------------------------------------------------------------
%% Key Data structures
%% 
% Value   Severity      Description                                Condition
%    0 	Emergency    	System is unusable 	                  A panic condition.[8]
%    1 	Alert 		Action must be taken immediately 	  A condition that should be corrected immediately, 
%                                                                 such as a corrupted system database.[8]
%    2 	Critical 	Critical conditions 	                  Hard device errors.[8]
%    3 	Error   	error                                     Error conditions 	
%    4 	Warning 	warning                          	  Warning conditions 	
%    5 	Notice 		Normal but significant conditions 	  Conditions that are not error conditions, 
%                                                                 but that may require special handling.[8]
%    6 	Informational 	info 		                          Informational messages 	
%    7 	Debug 		Debug-level messages 	                  Messages that contain information 
%                                                                 normally of use only when debugging a program.[8]
%% --------------------------------------------------------------------

start_test()->
    {ok,_}=log:start(),
    L=log:read_events(1),
    Date=date(),
    [[{date,Date},
      {time,_Time},
      {node,test_log@main},
      {event_level,info},
      {event_info,[log,_Line,'service started',log]}]]=L,
    [{date,_},
     {time,_},
     {node,test_log@main},
     {event_level,info},
     {event_info,[log,_LINE,'service started',log]}]=log:new_event(),
    false=log:new_event(),
    ok.

add_events_1_test()->
    Info1=[{node,node_1},{event_level,info},{event_info,[?MODULE,line1,'test info 1',info1]}],
    log:add_event(Info1),
    [{date,_},
     {time,_},
     {node,node_1},
     {event_level,info},
     {event_info,[test_log,line1,'test info 1',info1]}]=log:new_event(),
    false==log:new_event(),

    Emer1=[{node,node_2},{event_level,emergency},{event_info,[?MODULE,line2,'test emrg 1',emrg1]}],
    log:add_event(Emer1),  
    Al1=[{node,node_3},{event_level,alert},{event_info,[?MODULE,line3,'test al 1',al1]}],
    log:add_event(Al1),    

    Crit1=[{node,node_4},{event_level,critical},{event_info,[?MODULE,line4,'test critical 1',critical1]}],
    log:add_event(Crit1),
    Err1=[{node,node_5},{event_level,error},{event_info,[?MODULE,line5,'test error 1',err1]}],
    log:add_event(Err1),  
    W1=[{node,node_6},{event_level,warning},{event_info,[?MODULE,line6,'test warning 1',w1]}],
    log:add_event(W1),


    Not1=[{node,node_7},{event_level,notice},{event_info,[?MODULE,line7,'test notice1',notice1]}],
    log:add_event(Not1),
    Dbg1=[{node,node_8},{event_level,debug},{event_info,[?MODULE,line8,'test debug 1',debug1]}],
    log:add_event(Dbg1),  
    %glurk=log:read_events(10),
    ok.
    
filter_events_test_zz()->
    Events=log:read_events(10),
    KeyErr=error,
    L1=[Event||Event<-Events,lists:keyfind(event_level,1,Event) == {event_level,error}],
    [[{date,_},
      {time,_},
      {node,node_5},
      {event_level,error},
      {event_info,[test_log,line5,'test error 1',err1]}]]=L1,
    L2=[Event||Event<-Events,lists:keyfind(event_level,1,Event) == {event_level,info}],
    [[{date,_},
      {time,_},
      {node,node_5},
      {event_level,error},
      {event_info,[test_log,line5,'test error 1',err1]}]]=L2,
    ok.

filter_events_2_test_z()->
    Events=tcp:call([log,read_events,[3]]),
    Key=ok,
    L=[Event||Event<-Events,lists:keyfind(event_type,1,Event) == {event_type,Key}],
    []=L,
    ok.

stop_test()->    
    spawn(fun()->kill_session() end),
    ok.
kill_session()->
    timer:sleep(1000),
    erlang:halt(),
    ok.
    
