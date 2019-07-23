%% This is the application resource file (.app file) for the 'base'
%% application.
{application, brd,
[{description, "brd  " },
{vsn, "1.0.0" },
{modules, 
	  [brd_app,brd_sup,brd,brd_lib]},
{registered,[brd]},
{applications, [kernel,stdlib]},
{mod, {brd_app,[]}},
{start_phases, []}
]}.
