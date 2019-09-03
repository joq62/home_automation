%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : test application calc
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(web_appl).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include("interfacesrc/brd_local.hrl").

%% --------------------------------------------------------------------
-define(WEB_APP_PORT,58089).
-define(MIDDLE_MAN,web_appl_mm).
-define(SERVER_CONFIG,[binary,{packet,4},{reuseaddr,true},{active,true}]).

-define(INITIAL_STATUS,[{"varme_huset","off"},{"varme_lillstugan","off"},
			{"lampor_huset","off"},{"lampor_lillstugan","off"}]).
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state,{port, lsock,socket, status}).

%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================


-export([msg_from_app_user/1,
	 t/2
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



%%-----------------------------------------------------------------------
msg_from_app_user(Msg)->
    gen_server:call(?MODULE, {msg_from_app_user,Msg},infinity).

%%-----------------------------------------------------------------------
t(Id,Temp)->
    gen_server:cast(?MODULE, {t,Id,Temp}).
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
    {ok,LSock}=gen_tcp:listen(?WEB_APP_PORT, ?SERVER_CONFIG),
    io:format("~p~n",[{?MODULE,?LINE}]),
    {ok, #state{port=?WEB_APP_PORT,lsock=LSock,status=?INITIAL_STATUS},0}.   
    
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
handle_call({msg_from_app_user,Msg}, _From, State) ->
    Reply = Msg,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
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
		
handle_cast({t,Id,Temp}, #state{socket=Socket}=State) ->
    case Id of
	huset->
	    MsgBin=list_to_binary(["change_text",":", "set_huset_temp",":",integer_to_list(Temp)]),
	    Text={text,MsgBin},
	    gen_tcp:send(Socket,term_to_binary(Text));
	ute->
	    MsgBin=list_to_binary(["change_text",":", "set_ute_temp",":",integer_to_list(Temp)]),
	    Text={text,MsgBin},
	    gen_tcp:send(Socket,term_to_binary(Text));
	lill->
	    MsgBin=list_to_binary(["change_text",":", "set_lillstugan_temp",":",integer_to_list(Temp)]),
	    Text={text,MsgBin},
	    gen_tcp:send(Socket,term_to_binary(Text));
	UnMatched->
	    io:format("unmatched match  ~p~n",[{?MODULE,?LINE,UnMatched}])
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)

handle_info({tcp,Socket,RawData},State) ->
    EventStr=binary_to_list(RawData), 
 %   io:format("~p~n",[{?MODULE,?LINE,web_appl_lib:xtract(EventStr)}]),
    {NewStatus,Reply}=web_appl_lib:execute(EventStr,State#state.status),
    gen_tcp:send(Socket,term_to_binary(Reply)),
    
    {noreply, State#state{status=NewStatus}};

handle_info({tcp_closed,_Socket},#state{lsock=LSock} =State) ->
    io:format("~p~n",[{?MODULE,?LINE,tcp_closed}]),
    {ok,NewSocket}=gen_tcp:accept(LSock),
    NewState=State#state{socket=NewSocket},
    {noreply, NewState};

handle_info(timeout,#state{lsock=LSock} =State) ->
    io:format("~p~n",[{?MODULE,?LINE,timeout}]),
    {ok,NewSocket}=gen_tcp:accept(LSock),
    NewState=State#state{socket=NewSocket},
    {noreply, NewState};

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

