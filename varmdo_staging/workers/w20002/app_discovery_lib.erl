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
%% NodeAppList= [{'w20004@varmdo.asuscomm.com',
%                  [{adder,"adder","1.0.0"},
%                   {tick,"tick","1.0.0"},
%                   {app_discovery,"app_discovery","1.0.0"},
%                   {stdlib,"ERTS  CXC 138 10","3.9.2"},
%                   {kernel,"ERTS  CXC 138 10","6.4"}]}
%                  ]}],

%% Returns: non
%% --------------------------------------------------------------------
sync(Interval)->
    {NodeAppList,AppNodesList}=check_apps(),
    {NodeAppList,AppNodesList}.
check_apps()->
    ListOfNodes=[node()|nodes()],
    Z=[{Node,rpc:call(Node,application,which_applications,[],5000)}||Node<-ListOfNodes],
    NodeAppList=node_apps_list(Z,[]),
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
node_apps_list([],NodeAppList)->
    NodeAppList;
node_apps_list([{Node,AppList}|T],Acc) ->
    Z=[App||{App,_,_}<-AppList],
    NewAcc=[{Node,Z}|Acc],
    node_apps_list(T,NewAcc).


app_nodes_list([],AppNodesList)->
    AppNodesList;
app_nodes_list([{Node,AppsList}|T],Acc)->
    A=[{App,Node}||App<-AppsList],
    NewAcc=lists:append(A,Acc),
    app_nodes_list(T,NewAcc).    
