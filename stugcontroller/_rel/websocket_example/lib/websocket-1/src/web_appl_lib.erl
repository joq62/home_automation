-module(web_appl_lib).

-export([xtract/1,
	 execute/2]).


xtract(EventStr)->
    [Function,ArgStr]=split_msg(EventStr),  
    ArgList=get_args(ArgStr),
    {Function,ArgList}.

split_msg(EventStr)->
    string:split(EventStr,":").

get_args(ArgStr)->
    A1=string:trim(ArgStr,both,"["),
    A2=string:trim(A1,both,"]"),
    string:tokens(A2,",").

execute(EventStr,Status)->
    [Function,ArgStr]=split_msg(EventStr),  
    io:format("Function,ArgStr ~p~n",[{?MODULE,?LINE,Function,ArgStr}]),  
    ArgList=get_args(ArgStr),    
    io:format("ArgList~p~n",[{?MODULE,?LINE,ArgList}]),
    {NewStatus,Reply}= execute(Function,ArgList,Status),
     io:format("{NewStatus,Reply} ~p~n",[{?MODULE,?LINE,{NewStatus,Reply}}]),    
    {NewStatus,Reply}.

% Button commands
execute("button",["varme_huset"],Status)->
    {NewStatus,Reply}=do_button("button",["varme_huset"],Status),
    {NewStatus,Reply};

execute("button",["varme_lillstugan"],Status)->
    {NewStatus,Reply}=do_button("button",["varme_lillstugan"],Status),
    {NewStatus,Reply};

execute("button",["lampor_huset"],Status)->
    {NewStatus,Reply}=do_button("button",["lampor_huset"],Status),
    {NewStatus,Reply};

execute("button",["lampor_lillstugan"],Status)->
    {NewStatus,Reply}=do_button("button",["lampor_lillstugan"],Status),
    {NewStatus,Reply};

execute("button",Args,Status)->
    io:format("Args =~p~n",[Args]),
    ArgsBitStr=iolist_to_binary(Args),
    {Status,{text, << "error", ArgsBitStr/binary, "badargs" >>}};

% Add other functions


%% Not implmented functions
execute(Function,_,Status) ->
    io:format("Function =~p~n",[Function]),
    FunctionBitStr=iolist_to_binary(Function),
    {Status,{text, << "error", FunctionBitStr/binary, "function not implemented" >>}}.

% Support functons

do_button("button",[Id],Status)->
        {NewStatus,Reply}=case lists:keyfind(Id,1,Status) of
			     {Id,"off"}->
		%		 IdBitStr=iolist_to_binary(Id),
			%	 {lists:keyreplace(Id,1,Status,{Id,"on"}),
			%	 {text, << "change_text",":", IdBitStr/binary, ":","on" >>}};
				  MsgBin=iolist_to_binary([ "change_text",":", Id,":","on"]),
				  {lists:keyreplace(Id,1,Status,{Id,"on"}),
				   {text,MsgBin}};
			     {Id,"on"}->
			%	 IdBitStr=iolist_to_binary(Id),
				  MsgBin=iolist_to_binary([ "change_text",":", Id,":","off"]),
				 {lists:keyreplace(Id,1,Status,{Id,"off"}),
				  {text, MsgBin}};
			     X->
				 io:format("X=~p~n",[X]),
				 IdBitStr=iolist_to_binary(Id),
				 {Status,
				 {text, << "error", IdBitStr/binary, "no_element" >>}}
			 end,
    {NewStatus,Reply}.
