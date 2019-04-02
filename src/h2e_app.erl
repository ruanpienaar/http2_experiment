-module(h2e_app).

-behaviour(application).

%% Application callbacks
-export([
    start/0, start/2,
    stop/1
]).

-include("h2e.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    [ application:start(A) || A <- [crypto, asn1, public_key, ssl, ranch, cowlib, cowboy, h2e] ].

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", h2e_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_tls(https, [
        {port, 8443},
        {cacertfile, "priv/ssl/cowboy-ca.crt"},
        {certfile, "priv/ssl/server.crt"},
        {keyfile, "priv/ssl/server.key"}
    ], #{env => #{dispatch => Dispatch}}),
    ok = application:start(gun),
    h2e_sup:start_link().

stop(_State) ->
    ok.
