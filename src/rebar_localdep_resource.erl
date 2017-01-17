-module(rebar_localdep_resource).
-behaviour(rebar_resource).
-export([lock/2
        ,download/3
        ,needs_update/2
        ,make_vsn/1]).

-define(DEFAULT_EXCLUDED_FILES,
        ["_build", "rebar.lock", ".rebar", ".rebar3"]).

lock(_Dir, Source) ->
    Source.

needs_update(_AppDir, _Resource) ->
    true.

download(AppDir, {localdep, Path}, _State) ->
    download(AppDir, {localdep, Path, {exclude, []}}, _State);
download(AppDir, {localdep, Path, {exclude, ExcludedFiles}}, _State) ->
    case os:getenv("LOCALDEP_DIR") of
        false ->
            {fetch_fail, "`LOCALDEP_DIR` env variable not defined."};
        LocaldepDir ->
            DepFolder = filename:join([LocaldepDir, Path]),
            case file:list_dir(DepFolder) of
                {ok, FilesOrFolders} ->
                    ValidFilesToCopy = lists:flatmap(fun(File) ->
                                                             case lists:member(File, ExcludedFiles ++ ?DEFAULT_EXCLUDED_FILES) of
                                                                 true ->
                                                                     [];
                                                                 false ->
                                                                     [filename:join([DepFolder, File])]
                                                             end
                                                     end, FilesOrFolders),
                    ok = rebar_file_utils:cp_r(ValidFilesToCopy, AppDir),
                    {ok, undefined};
                {error, Reason} ->
                    {fetch_fail, lists:flatten(io_lib:format("Error while fetching dependency ~s: ~p", [Path, Reason]))}
            end
    end.

make_vsn(AppDir) ->
    [AppInfo] = rebar_app_discover:find_apps([AppDir], all),
    OriginalVsn = rebar_app_info:original_vsn(AppInfo),
    {plain, OriginalVsn}.

