-module(boot).

-export([start/0]).

start()->
    ok = application:start(crypto),
    ok=application:start(asn1),
    ok=application:start(public_key),
    ok=application:start(ssl),
    ok = application:start(ranch), 
    ok = application:start(cowlib), 
    ok = application:start(cowboy),
        ok = application:start(websocket),
    Pid=spawn(fun()->loop() end),
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