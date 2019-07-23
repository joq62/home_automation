%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_controller_eunit).
 

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
connect_test()->
    pong=net_adm:ping('w20002@varmdo.asuscomm.com'),
    pong=net_adm:ping('w20004@varmdo.asuscomm.com'),
    ok.
init_test()->
    ok=application:start(adder),
    ok=application:start(tick),
    ok=application:start(app_discovery),
    ok=application:start(app_deploy),
    ok.

adder_test()->
    ok=adder_test:t1(),
    ok.

tick_test()->
    ok= tick_test:t1(),
    ok.

app_discovery_test()->
    ok=app_discovery_test:t1(),
    ok=app_discovery_test:t2(),
    ok=app_discovery_test:t3(),
    ok.

app_deploy_test()->
    ok=app_deploy_test:t1(),
    ok=app_deploy_test:t2(),
    ok.

discovery_test()->
    ok=app_use_discovery_test:t1(),    
    ok.

controller_alg_test()->
    application:stop(adder),
    application:stop(tick),
    controller_algorith_test:t1(),
    controller_algorith_test:t2(),
    controller_algorith_test:t3(),
    ok.
    

stop_test()->
    application:stop(adder),
    application:stop(tick),
    application:stop(app_discovery),
    application:stop(app_deploy),
    do_kill(),
    ok.
do_kill()->
    timer:sleep(1000),
    init:stop().
