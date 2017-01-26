-module(h2e_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("h2e.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    h2e_sup:start_link().

stop(_State) ->
    ok.
