%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_b_eunit).
 
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
    ok=application:start(math),
    ok.

t1_test()->
    ok=server:tick(),
    1=server:num(),
    ok=server:tick(),
    2=server:num(),
    ok.
t2_test()->
    42=adder:add(20,22),
    ok.
t3_test()->
    adder:crash(),
    ok.
t4_test()->
    42=adder:add(20,22),
    ok.

stop_test()->
    ok=application:stop(math),
    do_kill(),
    ok.
do_kill()->
    init:stop().
