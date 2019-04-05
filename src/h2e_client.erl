-module(h2e_client).

-export([
    start_link/1,
    stop/1
]).

start_link(Ref) ->
    Pid = spawn_link(fun() -> init() end),
    true = erlang:register(Ref, Pid),
    {ok, Pid}.

call(Ref) ->
    call(Ref, "/").

call(Ref, Url) ->
    Ref ! {self(), Url},
    receive
        {response, Resonse} ->
            {ok, Resonse}
    after
        5000 ->
            {error, timeout}
    end.

stop(Ref) ->
    Ref ! close.

init() ->
    {ok, ConnPid} = gun:open("localhost", 8443, #{transport => tls}),
    _MRef = monitor(process, ConnPid),
    {ok, http2} = gun:await_up(ConnPid),
    loop(ConnPid).

loop(ConnPid) ->
    receive
        {ReqPid, Url} ->
            Resonse = gun:get(ConnPid, Url),

            StreamRef = gun:get(ConnPid, Url),
            Response =
                receive
                    {gun_response, ConnPid, StreamRef, fin, Status, Headers} ->
                        no_data;
                    {gun_response, ConnPid, StreamRef, nofin, Status, Headers} ->
                        receive_data(ConnPid, MRef, StreamRef);
                    {'DOWN', MRef, process, ConnPid, Reason} ->
                        error_logger:error_msg("Connection Down!"),
                        exit(Reason)
                after
                    1000 ->
                        timeout
                end,
            ReqPid ! {response, Response},
            loop(ConnPid);
        {'DOWN', Mref, process, ConnPid, Reason} ->
            error_logger:error_msg("Connection Down!"),
            exit(Reason);
        close ->
            gun:cancel(ConnPid, StreamRef),
            gun:close(ConnPid);
        Msg ->
            io:format("Received Msg ~p\n\n", [Msg]),
            loop(ConnPid)
end.

receive_data(ConnPid, MRef, StreamRef) ->
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            io:format("~s~n", [Data]),
            receive_data(ConnPid, MRef, StreamRef);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            io:format("~s~n", [Data]);
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 1000 ->
        exit(timeout)
    end.
