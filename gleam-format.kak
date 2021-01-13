# Gleam
# If you have gleam installed somewhere specific change "gleam" below
# to be the absolute path of your gleam executable.
hook global BufCreate .*[.]gleam %{
  set buffer formatcmd "gleam format --stdin"
}
hook global BufWritePre .+\.gleam %{ format }

