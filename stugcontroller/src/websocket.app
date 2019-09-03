{application, websocket, [
	{description, "Cowboy Websocket example"},
	{vsn, "1"},
	{modules, [boot,websocket_app,websocket_sup,ws_h,ws_mm]},
	{registered, [websocket_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {websocket_app, []}}, 
	{env, []} 
]}.
