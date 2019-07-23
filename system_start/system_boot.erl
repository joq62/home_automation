%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(system_boot).
 



%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-define(GIT_APP_FILES,"https://github.com/joq62/app_files.git").
-define(GIT_EBIN_FILES,"https://github.com/joq62/ebin_files.git").

%% External exports,
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
start()->
    os:cmd("rm -r "++"app_files"),
    os:cmd("rm -r "++"ebin_files"),   
    os:cmd("git clone "++?GIT_APP_FILES),
    os:cmd("git clone "++?GIT_EBIN_FILES),
    application:load(controller),
    application:start(controller).
    
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
