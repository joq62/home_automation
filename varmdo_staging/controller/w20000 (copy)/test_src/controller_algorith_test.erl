%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(controller_algorith_test).
 

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
    {ok,Info}=file:consult("node_app.config"),
    AvailableNodes=nodes(), % Exclude controller node
    R=do_deploy(Info,AvailableNodes,ok),
    ok.

t2()->
    [Node1|_]=app_discovery:query(adder),
    [Node2|_]=app_discovery:query(tick),
    42=rpc:call(Node1,adder,add,[20,22],5000),
    rpc:call(Node2,server,tick,[]),
    1=rpc:call(Node2,server,num,[]),
    ok.

t3()->
    Nodes1=app_discovery:query(adder),    
    [app_deploy:stop_unload_app(Node1,adder)||Node1<-Nodes1],
    Nodes2=app_discovery:query(tick),    
  %  io:format("~p~n",[{?MODULE,?LINE,Nodes2}]),
    [app_deploy:stop_unload_app(Node2,tick)||Node2<-Nodes2],  
    ok.  

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
