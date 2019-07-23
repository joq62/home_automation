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
    [{'controller@varmdo.asuscomm.com',
      [{tick,"tick","1.0.0"},
       {adder,"adder","1.0.0"},
       {stdlib,"ERTS  CXC 138 10","3.9.2"},
       {kernel,"ERTS  CXC 138 10","6.4"}]},
     {'w20002@varmdo.asuscomm.com',
      [{stdlib,"ERTS  CXC 138 10","3.9.2"},
       {kernel,"ERTS  CXC 138 10","6.4"}]},
     {'w20004@varmdo.asuscomm.com',
      [{stdlib,"ERTS  CXC 138 10","3.9.2"},
       {kernel,"ERTS  CXC 138 10","6.4"}]}]=app_discovery:all_apps(),
    ok.

t2()->
    []=app_discovery:query(glurk),
    ok.

t3()->
    L=app_discovery:query(kernel),
    true=lists:member('w20002@varmdo.asuscomm.com',L),
    ok.
