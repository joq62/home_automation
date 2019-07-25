%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(app_discovery_test).
 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------

%% External exports
-compile(export_all).
%-export([]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

t1()->
    L1= app_discovery:query(kernel_refc),
 %   glurk=L1,
    L=erlang:registered(),
    true=lists:member(adder,L), 
    true=lists:member('controller@varmdo.asuscomm.com',L1),
    L2=app_discovery:query(adder),
    true=lists:member('controller@varmdo.asuscomm.com',L2),
    ok.

t2()->
    []=app_discovery:query(glurk),
    ok.

t3()->
    L=app_discovery:query(kernel_refc),
    true=lists:member('w20002@varmdo.asuscomm.com',L),
    ok.
