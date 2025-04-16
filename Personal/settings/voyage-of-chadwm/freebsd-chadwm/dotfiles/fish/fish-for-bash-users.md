# Keeping in mind ...

https://stackoverflow.com/questions/29667714/convert-bash-function-to-fishs



Some notes on the differences:

    setting variables
        bash: var=value
        fish: set var value
    functions
        bash

        funcName() {
            ...
        }

        fish

        function funcName
            ...
        end

    function arguments
        bash: "$@", "$1", "$2", ...
        fish: $argv, $argv[1], $argv[2], ...
    function local variables
        bash: local var
        fish: set -l var
    conditionals I
        bash: [[ ... ]] and test ... and [ ... ]
        fish: test ... and [ ... ], no [[ ... ]]
    conditionals II
        bash: if cond; then cmds; fi
        fish: if cond; cmds; end
    conditionals III
        bash: cmd1 && cmd2
        fish: cmd1; and cmd2
        fish (as of fish 3.0): cmd1 && cmd2
    command substitution
        bash: output=$(pipeline)
        fish: set output (pipeline)
    process substitution
        bash: join <(sort file1) <(sort file2)
        fish: join (sort file1 | psub) (sort file2 | psub)

Documentation

    bash: https://www.gnu.org/software/bash/manual/bashref.html
    fish: http://fishshell.com/docs/current/index.html and https://fishshell.com/docs/current/fish_for_bash_users.html

