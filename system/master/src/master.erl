%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : test application calc
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(master).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record( state,{}).

%% --------------------------------------------------------------------




-export([server_load_start/3,
	 server_stop_unload/2,
	 l/2,l/3,
	 u/2,ul/2,
	 m/1,
	 load_start/0,stop_unload/0,
	 cmd/2
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

load_start()->
    RL=application:load(?MODULE),
    RS=application:start(?MODULE),
    {RL,RS}.

stop_unload()->
    RL=application:stop(?MODULE),
    RS=application:unload(?MODULE),
    {RL,RS}.

%% Gen server functions

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).



%%-----------------------------------------------------------------------
server_load_start(Node,Application,PathEbin)->
    gen_server:call(?MODULE, {server_load_start,Node,Application,PathEbin},5000).

server_stop_unload(Node,Application)->
    gen_server:call(?MODULE, {server_stop_unload,Node,Application},5000).

l(Node,Module, Filename)->
    gen_server:call(?MODULE, {l,Node,Module, Filename},5000).

l(Node,Files)->
    gen_server:call(?MODULE, {l,Node,Files},5000).

u(Node,Module)->
    gen_server:call(?MODULE, {u,Node,Module},5000).

ul(Node,Modules)->
    gen_server:call(?MODULE, {ul,Node,Modules},5000).

m(Node)->
    gen_server:call(?MODULE, {m,Node},5000).



cmd(F,A)->
    gen_server:call(?MODULE, {cmd,F,A},5000).

%%-----------------------------------------------------------------------


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
    io:format("Started  ~p~n",[{date(),time(),?MODULE}]),
    {ok, #state{}}.   
    
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
handle_call({server_load_start,Node,Application,PathEbin}, _From, State) ->
    Reply=rpc:call(node(),master_lib,server_load_start,[Node,Application,PathEbin],5000),
    {reply, Reply, State};

handle_call({server_stop_unload,Node,Application}, _From, State) ->
    Reply=rpc:call(node(),master_lib,server_stop_unload,[Node,Application],5000),
    {reply, Reply, State};



handle_call({m,Node}, _From, State) ->
    Reply=rpc:call(node(),master_lib,m,[Node],5000),
    {reply, Reply, State};

handle_call({u,Node,Module}, _From, State) ->
    Reply=rpc:call(node(),master_lib,u,[Node,Module],5000),
    {reply, Reply, State};

handle_call({ul,Node,Modules}, _From, State) ->
    Reply=rpc:call(node(),master_lib,ul,[Node,Modules],5000),
    {reply, Reply, State};

handle_call({l,Node,Module, Filename}, _From, State) ->
    Reply=rpc:call(node(),master_lib,l,[Node,Module, Filename],5000),
    {reply, Reply, State};

handle_call({l,Node,Files}, _From, State) ->
    Reply=rpc:call(node(),master_lib,l,[Node,Files],5000),
    {reply, Reply, State};

handle_call({cmd,_F,_A}, _From, State) ->
    Reply={?MODULE,?LINE},
    {reply, Reply, State};

handle_call({stop}, _From, State) -> 
    io:format("stop ~p~n",[{?MODULE,?LINE}]),
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
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------


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

