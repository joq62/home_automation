%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(master_lib).
 


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports
-compile(export_all).

%-export([load_start_node/3,stop_unload_node/3
%	]).


%% ====================================================================
%% External functions
%% ====================================================================

server_load_start(Node,Application,PathEbin)->
    io:format("~p~n",[{?MODULE,?LINE,Node,Application,PathEbin}]),
    case rpc:call(Node,application,get_application,[Application],5000) of
	undefined ->
              % Read app file and extract modules
	    AppFilename=atom_to_list(Application)++".app",
	    AppFullFilename=filename:join(PathEbin,AppFilename),
	    {ok,Terms}=file:consult(AppFullFilename),
	    [{application,Application,Info}]=Terms,
	    {modules,Modules}=lists:keyfind(modules,1,Info),
	    Modules_Filenames=[{Module,filename:join(PathEbin,atom_to_list(Module)++".beam")}||Module<-Modules],
	    {ok,Binary}=file:read_file(AppFullFilename),
	    ok=rpc:call(Node,file,write_file,[AppFilename,Binary],5000),
	    io:format("~p~n",[{?MODULE,?LINE}]),
	    master_lib:l(Node,Modules_Filenames),
	    io:format("~p~n",[{?MODULE,?LINE}]),
	    Reply=rpc:call(Node,application,start,[Application]);
	{ok,Application}->
	    io:format("~p~n",[{?MODULE,?LINE}]),
	    Reply={error,['already_loaded_started',Application]}
    end,
    Reply.

server_stop_unload(Node,Application)->
    case rpc:call(Node,application,get_application,[Application],5000) of
	{ok,Application}->
              % Read app file and extract modules
	    AppFilename=atom_to_list(Application)++".app",
	    {ok,Terms}=rpc:call(Node,file,consult,[AppFilename]),
	    [{application,Application,Info}]=Terms,
	    {modules,Modules}=lists:keyfind(modules,1,Info),
	    rpc:call(Node,application,stop,[Application]),
	    rpc:call(Node,application,unload,[Application]),
	    rpc:call(Node,file,delete,[AppFilename]),
	    master_lib:ul(Node,Modules),
	    Reply=ok;
	undefined ->
	    Reply={error,['eexist',Application]}
    end,
    Reply.

m(Node)->
    R=monitor_node(Node,true),
    R.


l(Node,Module, Filename)->
    {ok,Binary}=file:read_file(Filename),
    R=rpc:call(Node,code,load_binary,[Module, Filename, Binary],5000),
    R.

l(_Node,[])->
    ok;
l(Node,[{Module, Filename}|T])->
    _R=master_lib:l(Node,Module, Filename),
    l(Node,T).
    

u(Node,Module)->
    RP=rpc:call(Node,code,purge,[Module],5000),
    RD=rpc:call(Node,code,delete,[Module],5000),
    {RP,RD}.


ul(_Node,[])->
    ok;
ul(Node,[Module|T])->
    _RP=rpc:call(Node,code,purge,[Module],5000),
    _RD=rpc:call(Node,code,delete,[Module],5000),
    ul(Node,T).
				
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
%
