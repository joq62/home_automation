%% This is the application resource file (.app file) for the 'base'
%% application.
{application, a,
[{description, "a  " },
{vsn, "1.0.0" },
{modules, 
	  [a_app,a_sup,a,a_lib]},
{registered,[a]},
{applications, [kernel,stdlib]},
{mod, {a_app,[]}},
{start_phases, []}
]}.
