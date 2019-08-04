%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_tellstick_eunit).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------

%% External exports

-export([]).
-record(device,
	{id,name,state}).
-record(sensor,
	{protocol,model,id,temp,humidity,latest_update}).

	  

%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
init_test()->
    {ok,_}=tellstick:start(),
    pong=net_adm:ping('w50000@varmdo.asuscomm.com'),
    ok=tellstick:set_devices("glurk_3","OFF"),
    TdInfo=rpc:call('w50000@varmdo.asuscomm.com',os,cmd,["tdtool --list"]),
    % Devices
    DevicesTupleList=read_device(TdInfo),
    {"3","glurk_3","OFF"}=lists:keyfind("glurk_3",2,DevicesTupleList),
    % Sensors
    SensorTupleList=read_sensors(TdInfo), 
    {"fineoffset","temperaturehumidity","167",_,_,_}=lists:keyfind("167",3,SensorTupleList),
    {"fineoffset","temperature","248",_,[],_}=lists:keyfind("248",3,SensorTupleList), % No humididt
  % {"fineoffset","temperaturehumidity","167","34.1°","20%","2019-08-04 13:41:35"}=lists:keyfind("167",3,SensorTupleList),
    ok.


t1_read_test()->
    "OFF"=tellstick:read_devices("glurk_3"),
    {"temperaturehumidity",_,_}=tellstick:read_sensors("167"),
    Z=tellstick:read_all(),
    {"1","glurk_1","OFF"}=lists:keyfind("glurk_1",2,Z), 
    {"fineoffset","temperaturehumidity","247",_,_,_}=lists:keyfind("247",3,Z), 
    ok.

t1_set_test()->
    
    ok=tellstick:set_devices("glurk_3","OFF"),
 %   Z="Turning "++"off"++" "++"device "++"3"++", "++"glurk_3"++" - "++"Success\n",
    ok.
t1_set_2_test()->
    ok=tellstick:set_devices("glurk_3","on"),
    "ON"=tellstick:read_devices("glurk_3"),
    ok.

t1_set_3_test()->
    ok=tellstick:set_devices("glurk_3","OFF"),
    "OFF"=tellstick:read_devices("glurk_3"),
    ok.

stop_test()->
    tellstick:stop(),
    do_kill(),
    ok.
do_kill()->
    init:stop().


%----------
read_device(TdInfo)->
    [D,_S]=string:split(TdInfo,"SENSORS:"),
    [_|D1]=string:tokens(D,"\n"),
    D2=[string:tokens(Str,"\t")||Str<-D1],
    DevicesTupleList=[{Id,Name,State}||[Id,Name,State]<-D2],
    DevicesTupleList.

read_sensors(TdInfo)->
    [_D,S]=string:split(TdInfo,"SENSORS:"),
    [_|S1]=string:tokens(S,"\n"),
    S2=[string:tokens(Str,"\t")||Str<-S1],
    SensorTupleList=[{string:trim(Proto),string:trim(Model),string:trim(Id),string:trim(Temp),string:trim(Humidity),string:trim(Latest_update)}||[Proto,Model,Id,Temp,Humidity,Latest_update]<-S2],
    SensorTupleList.
