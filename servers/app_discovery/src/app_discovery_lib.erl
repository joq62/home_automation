%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(app_discovery_lib).
 


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

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
sync(Interval)->
    {NodeAppList,AppNodesList}=check_apps(),
    {NodeAppList,AppNodesList}.
check_apps()->
    ListOfNodes=[node()|nodes()],
    NodeAppList=[{Node,rpc:call(Node,erlang,registered,[],5000)}||Node<-ListOfNodes],
    AppNodesList=app_nodes_list(NodeAppList,[]),
    {NodeAppList,AppNodesList}.


tick(Interval)->
    timer:sleep(Interval),
    app_discovery:sync(Interval).
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
app_nodes_list([],AppNodesList)->
    AppNodesList;
app_nodes_list([{Node,AppsList}|T],Acc)->
    A=[{App,Node}||App<-AppsList],
    NewAcc=lists:append(A,Acc),
    app_nodes_list(T,NewAcc).    
