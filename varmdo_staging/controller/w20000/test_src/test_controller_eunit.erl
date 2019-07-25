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
    ok=application:start(app_discovery),
    ok=application:start(app_deploy),
    ok.

adder_test()->
    ok=app_deploy:load_start_app(node(),adder), 
    ok=adder_test:t1(),
    app_deploy:stop_unload_app(node(),adder),
    ok.

tick_test()->
    ok=app_deploy:load_start_app(node(),tick), 
    ok= tick_test:t1(),
    app_deploy:stop_unload_app(node(),tick),
    ok.

app_discovery_test()->
    ok=app_deploy:load_start_app(node(),tick), 
    ok=app_deploy:load_start_app(node(),adder), 
    ok=app_discovery_test:t1(),
    ok=app_discovery_test:t2(),
    ok=app_discovery_test:t3(),
    app_deploy:stop_unload_app(node(),adder),
    app_deploy:stop_unload_app(node(),tick),
    ok.

app_deploy_test_d()->
    ok=app_deploy_test:t1(),
    ok=app_deploy_test:t2(),
    ok.

discovery_test_d()->
    ok=app_use_discovery_test:t1(),    
    ok.

controller_alg_test_d()->
    controller_algorith_test:t1(),
    controller_algorith_test:t2(),
    controller_algorith_test:t3(),
    ok.
    

stop_test()->
    application:stop(app_discovery),
    application:stop(app_deploy),
    do_kill(),
    ok.
do_kill()->
    timer:sleep(1000),
    init:stop().
