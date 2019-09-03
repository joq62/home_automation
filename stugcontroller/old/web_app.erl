-module(web_app).

-export([start/0,
	 browser_info/1]).
-define(PORT,58089).
-define(IP_ADDR,"localhost").


browser_info({Action,Parameters})->
    
    ?MODULE!{self(),{Action,Parameters}}.

start()->
    Pid_app_mm=spawn_link(web_app_mm,start,[?MODULE,?IP_ADDR,?PORT]),
    loop(Pid_app_mm).

loop(Pid_app_mm)->
    receive
	{tcp,Socket,Msg2app_bin}->
	    MsgTerm=binary_to_term(Msg2app),
	    erlang:apply(Application,browser_info,[MsgTerm]);
	{?MODULE,{Action,Parameters}}->
	    gen_tcp:send(Socket,term_to_binary({Action,Parameters}))
    end,
    loop(Socket,Application).
			 
	    
	
    Pid=spawn(fun()->loop() end),->
    register(test_loop,Pid).

loop()->
   receive
       {Browser,{execute,MsgStr,State}}->
	   [Function,ArgStr]=split_msg(MsgStr),  
	  % io:format("Function,ArgStr ~p~n",[{?MODULE,?LINE,Function,ArgStr}]),  
	   ArgList=get_args(ArgStr),    
	   io:format("ArgList~p~n",[{?MODULE,?LINE,ArgList}]),
	   {NewState,Reply}= execute(Function,ArgList,State),
	   Browser!{test_loop,{execute_ret, {NewState,Reply}}}
   end,
   loop().


split_msg(MsgStr)->
    string:split(MsgStr,":").

get_args(ArgStr)->
    A1=string:trim(ArgStr,both,"["),
    A2=string:trim(A1,both,"]"),
    string:tokens(A2,",").

execute("button",[Id],State)->
        {NewState,Reply}=case lists:keyfind(Id,1,State) of
			     {Id,"off"}->
				 IdBitStr=iolist_to_binary(Id),
				 {lists:keyreplace(Id,1,State,{Id,"on"}),
				  {text, << "change_text",":", IdBitStr/binary, ":","on" >>}};
			     {Id,"on"}->
				 IdBitStr=iolist_to_binary(Id),
				 {lists:keyreplace(Id,1,State,{Id,"off"}),
				  {text, << "change_text",":", IdBitStr/binary,":", "off" >>}};
			     X->
				 io:format("X=~p~n",[X]),
				 IdBitStr=iolist_to_binary(Id),
				 {State,
				  {text, << "error", IdBitStr/binary, "no_element" >>}}
			 end,
    {NewState,Reply};
execute("button",Args,State)->
    io:format("Args =~p~n",[Args]),
    ArgsBitStr=iolist_to_binary(Args),
    {State,{text, << "error", ArgsBitStr/binary, "badargs" >>}};
execute(Function,_,State) ->
    io:format("Function =~p~n",[Function]),
    FunctionBitStr=iolist_to_binary(Function),
    {State,{text, << "error", FunctionBitStr/binary, "function not implemented" >>}}.
