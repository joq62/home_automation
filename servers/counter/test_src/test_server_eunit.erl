%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_server_eunit).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------

%% External exports

-export([]).


%% ====================================================================
%% External function
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
init_test()->
    {ok,_}=server:start(),
    ok.

t1_test()->
    ok=server:tick(),
    1=server:num(),
    ok=server:tick(),
    2=server:num(),
    ok.

stop_test()->
    server:stop(),
    do_kill(),
    ok.
do_kill()->
    init:stop().
