%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_app_discover_eunit).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------

%% External exports

-export([]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
init_test()->
    pong=net_adm:ping('w20002@varmdo.asuscomm.com'),
    pong=net_adm:ping('w20004@varmdo.asuscomm.com'),
    {ok,_}=app_discovery:start(),
    ok.


t2_test()->
    [{'test_app_discover@varmdo.asuscomm.com',
         [{stdlib,"ERTS  CXC 138 10","3.9.2"},
          {kernel,"ERTS  CXC 138 10","6.4"}]},
     {'w20002@varmdo.asuscomm.com',
         [{stdlib,"ERTS  CXC 138 10","3.9.2"},
          {kernel,"ERTS  CXC 138 10","6.4"}]},
     {'w20004@varmdo.asuscomm.com',
         [{stdlib,"ERTS  CXC 138 10","3.9.2"},
          {kernel,"ERTS  CXC 138 10","6.4"}]}]=app_discovery:all_apps(),
    ok.

t1_test()->
    []=app_discovery:query(glurk),
    ok.

t3_test()->
    L=app_discovery:query(kernel),
    true=lists:member('w20002@varmdo.asuscomm.com',L),
    ok.

stop_test()->
    app_discovery:stop(),
    do_kill(),
    ok.
do_kill()->
    init:stop().
