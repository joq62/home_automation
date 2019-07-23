%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(controller_lib).
 



%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-define(NODE_APP_CONFIG,"node_app.config").
-define(PATH_EBIN,"ebin_files").
-define(PATH_APP_FILES,"app_files").

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
sync(Interval)->
    AvailableNodes=nodes(), % Exclude controller node
    {ok,Info}=file:consult(?NODE_APP_CONFIG),
    AllApps=app_discovery:all_apps(),
    % Check applications to start and start them
    StartApps=apps_to_start(AllApps,Info,[]), 
    do_deploy(StartApps,AvailableNodes,[]),
    % Check applications to stop and stop them
    StopApps=apps_to_start(Info,AllApps,[]),
    [app_deploy:stop_unload_app(Node,App)||{App,Node}<-StopApps],
    {StartApps,StopApps}.

apps_to_start([],_,StartApps)->
    StartApps;
apps_to_start([{Node,AppList}|T],Info,Acc) ->
    A=[{App,Node1}||{App,Node1}<-Info,
		  false==lists:keymember(App,1,AppList)],
    NewAcc=lists:append(A,Acc),
    apps_to_start(T,Info,NewAcc).

apps_to_stop([],_,StopApps)->
    StopApps;
apps_to_stop([{App,Node}|T],AllApps,Acc) ->
    A=[{App,Node}||{_Node1,AppList}<-AllApps,
		  false==lists:keymember(App,1,AppList)],
    NewAcc=lists:append(A,Acc),
    apps_to_stop(T,AllApps,NewAcc).
		 

    
tick(Interval)->
    timer:sleep(Interval),
    controller:sync(Interval).

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

do_deploy(_,[],_)->
    error;
do_deploy(_Info,_AvailableNodes,error)->
    error;
do_deploy([],_AvailableNodes,ok)->
    ok;
do_deploy([{App,Nodes}|T],AvailableNodes,_) ->
%    io:format("~p~n",[{?MODULE,?LINE,App,Nodes}]),
    R=case Nodes of
	  all->
	      [app_deploy:load_start_app(Node,App)||Node<-AvailableNodes],
	      ok;
	  any ->
	      [Node|_]=AvailableNodes,
%	      io:format("~p~n",[{?MODULE,?LINE,Node}]),
	      app_deploy:load_start_app(Node,App),
	      ok;
	  Nodes->
	      [app_deploy:load_start_app(Node,App)||Node<-Nodes],
	      ok
      end,
    do_deploy(T,AvailableNodes,R).
