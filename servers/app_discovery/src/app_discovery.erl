%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : test application calc
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(app_discovery).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include("interfacesrc/brd_local.hrl").

%% --------------------------------------------------------------------
 
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state,{node_apps_list,
	       app_nodes_list
	      }).

%% --------------------------------------------------------------------
-define(SYNC_INTERVAL,2*1000*60).
%% ====================================================================
%% External functions
%% ====================================================================


-export([ query/1,
	  all_apps/0,
	  sync/1,
	  tick/1
	]).

-export([start/0,
	 stop/0
	 ]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals

%% Gen server function

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).



%%-----------Call ------------------------------------------------------------

query(App)->
    gen_server:call(?MODULE, {query,App},5000).

all_apps()->
    gen_server:call(?MODULE, {all_apps},50000).
%%----------Cast-------------------------------------------------------------
sync(Interval)->
    gen_server:cast(?MODULE, {sync,Interval}).    

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    {NodeAppList,AppNodesList}=rpc:call(node(),app_discovery_lib,sync,[?SYNC_INTERVAL],5000),
    io:format("Started ~p~n",[{date(),time(),?MODULE}]),
    {ok, #state{node_apps_list=NodeAppList,app_nodes_list=AppNodesList}}.   
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------

handle_call({query,WantedApp}, _From, State) ->
   {NodeAppList,AppNodesList}=app_discovery_lib:check_apps(),
    Reply=[Node||{App,Node}<-AppNodesList,WantedApp==App],
    {reply, Reply, State};

handle_call({all_apps}, _From, State) ->
%    Reply={?MODULE,?LINE},
    Reply=State#state.node_apps_list,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
  %  io:format("stop ~p~n",[{?MODULE,?LINE}]),
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({sync,Interval},State) ->
    {NodeAppList,AppNodesList}=rpc:call(node(),app_discovery_lib,sync,[Interval],5000),
    NewState=State#state{node_apps_list=NodeAppList,app_nodes_list=AppNodesList},
    {noreply, NewState};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Exyernal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
tick(Interval)->
    timer:sleep(Interval),
    app_discovery:sync(Interval).
    
    

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------
    

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

