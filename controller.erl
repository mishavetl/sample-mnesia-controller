-module(controller).
-include_lib("stdlib/include/qlc.hrl").
-include("models.hrl").
-export([init/0, finish/0, create_user/2, read_user/1, delete_users/0, create_user_table/0, delete_user/1, create_database/0]).

init() ->
	mnesia:start().

create_user_table() ->
	mnesia:create_table(user, [{attributes, record_info(fields, user)}, {local_content, true}, {disc_only_copies, [node()]}]).

create_database() ->
	mnesia:create_schema([node()]).

create_user(Name, Passw) ->
	User = #user{name=Name, passw=Passw},
	Creation = fun() -> mnesia:write(User) end,
	mnesia:transaction(Creation).

read_user(Name) ->
	Read = fun() -> mnesia:read(user, Name, read) end,
	mnesia:transaction(Read).

delete_users() ->
	Deletion = fun() -> mnesia:clear_table(user) end,
	mnesia:transaction(Deletion).

delete_user(Username) ->
	Deletion = fun() -> mnesia:delete({user, Username}) end,
	mnesia:transaction(Deletion).

finish() ->
	mnesia:stop().
