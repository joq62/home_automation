%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(boot_strap).
 


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-define(GIT_APP_FILES,"https://github.com/joq62/app_files.git").
-define(GIT_SRC_FILES,"https://github.com/joq62/src_files.git").
-define(SRC_FILES,"src_files").
-define(APP_FILES,"app_files").
%% External exports
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
%% -----------------------------------------------------------------
start([NodeType])->
    case NodeType of
	worker->
	    io:format("~p~n",[{?MODULE,?LINE,NodeType}]),
	    os:cmd("sudo rm -rf app_files src_files"),
	    {ok,FileNames}=file:list_dir("."),
	    [file:delete(FileName)||FileName<-FileNames,".erl"==filename:extension(FileName)],
	    [file:delete(FileName)||FileName<-FileNames,".beam"==filename:extension(FileName)],
	    [file:delete(FileName)||FileName<-FileNames,".app"==filename:extension(FileName)];
	controller->
	    os:cmd("sudo rm -rf app_files src_files"),
	    {ok,FileNames}=file:list_dir("."),
	    [file:delete(FileName)||FileName<-FileNames,".erl"==filename:extension(FileName)],
	    [file:delete(FileName)||FileName<-FileNames,".beam"==filename:extension(FileName)],
	    [file:delete(FileName)||FileName<-FileNames,".app"==filename:extension(FileName)],
	    os:cmd("git clone "++?GIT_SRC_FILES),
	    os:cmd("git clone "++?GIT_APP_FILES),
	    
	    {ok,SrcFiles}=file:list_dir(?SRC_FILES),
	    R=[c:c(filename:join(?SRC_FILES,FileName))||FileName<-SrcFiles,".erl"==filename:extension(FileName)],
	    {ok,AppFiles}=file:list_dir(?APP_FILES),
	    AppFiles2Copy=[file:copy(filename:join(?APP_FILES,FileName),FileName)||FileName<-AppFiles,".app"==filename:extension(FileName)],
	    ok=application:start(controller),
	    io:format("~p~n",[{?MODULE,?LINE,NodeType,R}])
    end.


%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
%filter_events(Key
