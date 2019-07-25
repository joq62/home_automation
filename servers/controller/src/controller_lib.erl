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
-define(NODES_CONFIG,"nodes.config").
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
deploy_app_discovery(0,_,R)-> 
    R;
deploy_app_discovery(_,_,{ok,R}) -> 
    {ok,R};
deploy_app_discovery(N,Interval,_R)->  
    case lists:member(app_deploy,registered()) of
	false->
	    timer:sleep(Interval),
	    NewN=N-1,
	    NewR=error;
	true->
	    {ok,ConfigNodes}=file:consult(?NODES_CONFIG),
	    [net_adm:ping(Node)||{Node}<-ConfigNodes],
	    Nodes=nodes(),
	    R=[{Node,app_discovery,rpc:call(node(),app_deploy,load_start_app,[Node,app_discovery])}||Node<-Nodes],
	    NewN=N-1,
	    NewR=ok
    end,
    deploy_app_discovery(NewN,Interval,NewR).

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
campaign()->
    io:format("*************** Start Campaign ***********' ~p~n",[{?MODULE,?LINE,date(),time()}]), 
    {ok,ConfigNodes}=file:consult(?NODES_CONFIG),
    A=[{Node,net_adm:ping(Node)}||{Node}<-ConfigNodes],
 %   io:format("Ping = ~p~n",[{?MODULE,?LINE,A}]),
    AvailableNodes=nodes(), % Exclude controller node
    io:format("AvailableNodes = ~p~n",[{?MODULE,?LINE,AvailableNodes}]),
    {ok,Info}=file:consult(?NODE_APP_CONFIG),
    NodeAppsList=app_discovery:node_apps_list(),
   io:format("NodeAppsList = ~p~n",[{?MODULE,?LINE,NodeAppsList}]),
    % Check applications to start and start them
    StartApps=apps_to_start(Info,NodeAppsList,AvailableNodes,[]), 
    io:format("StartApps = ~p~n",[{?MODULE,?LINE,StartApps}]),
    io:format("AvailableNodes = ~p~n",[{?MODULE,?LINE,AvailableNodes}]),
  %  R=do_deploy(StartApps,AvailableNodes,[]),
  %  io:format("do_deploy = ~p~n",[{?MODULE,?LINE,R}]),   
    % Check applications to stop and stop them
    StopApps=apps_to_stop(Info,NodeAppsList,[]),
   % [app_deploy:stop_unload_app(Node,App)||{App,Node}<-StopApps],
  %  io:format("StartApps = ~p~n",[{?MODULE,?LINE,StartApps}]),
   % io:format("StopApps = ~p~n",[{?MODULE,?LINE,StopApps}]),
    {StartApps,StopApps}.

apps_to_start([],_,_,StartedApps)->
    io:format("StartedApps= ~p~n",[{?MODULE,?LINE,StartedApps}]),    
    StartedApps;
apps_to_start([{App,Nodes}|T],NodeAppsList,AvailableNodes,Acc) ->
    io:format("Info, T= ~p~n",[{?MODULE,?LINE,App,Nodes,T}]),
    % Check if non of the nodes has the the required applications
    %
    case Nodes of
	  all->
	    A=[app_deploy:load_start_app(Node,App)||Node<-AvailableNodes];
	  any ->
	      io:format("~p~n",[{?MODULE,?LINE,any}]),
	      [Node|_]=AvailableNodes,
	      io:format("Node ~p~n",[{?MODULE,?LINE,Node}]),
	      A=[app_deploy:load_start_app(Node,App)],
	      io:format("A, Node,~p~n",[{?MODULE,?LINE,A,Node}]);
	  Nodes->
	      io:format("~p~n",[{?MODULE,?LINE,Nodes}]),
	      A=[app_deploy:load_start_app(Node,App)||Node<-Nodes]
      end,
    NewAcc=lists:append(A,Acc),
    io:format("NewAcc ~p~n",[{?MODULE,?LINE,NewAcc}]),
    apps_to_start(T,NodeAppsList,AvailableNodes,NewAcc).

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
    glurk=error;
do_deploy([],_AvailableNodes,Result)->
    io:format("~p~n",[{?MODULE,?LINE,Result}]);
do_deploy([{App,Nodes}|T],AvailableNodes,Acc) ->
   io:format("~p~n",[{?MODULE,?LINE,App,Nodes,AvailableNodes}]),
    R=case Nodes of
	  all->
	      io:format("~p~n",[{?MODULE,?LINE,all}]),
	      glurk=[app_deploy:load_start_app(Node,App)||Node<-AvailableNodes];
	  any ->
	      io:format("~p~n",[{?MODULE,?LINE,any}]),
	      [Node|_]=AvailableNodes,
%	      io:format("~p~n",[{?MODULE,?LINE,Node}]),
	      glurk=app_deploy:load_start_app(Node,App);
	  Nodes->
	      io:format("~p~n",[{?MODULE,?LINE,Nodes}]),
	      glurk=[app_deploy:load_start_app(Node,App)||Node<-Nodes]
      end,
    NewR=lists:append(R,Acc), 
    do_deploy(T,AvailableNodes,NewR).
