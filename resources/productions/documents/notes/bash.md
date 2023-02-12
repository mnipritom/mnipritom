---
https://stackoverflow.com/a/7816490

---

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/10.md <==
https://stackoverflow.com/a/16159057

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/11.md <==
#### Passing bash arrays by named reference

[bash - Passing multiple distinct arrays to a shell function - Stack Overflow](https://stackoverflow.com/questions/10953833/passing-multiple-distinct-arrays-to-a-shell-function)

[bash - How to pass an array as function argument? - Ask Ubuntu](https://askubuntu.com/questions/674333/how-to-pass-an-array-as-function-argument)

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/12.md <==
https://unix.stackexchange.com/a/425759

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/13.md <==
- https://stackoverflow.com/a/22404959
- https://stackoverflow.com/a/68859346
- https://stackoverflow.com/a/72961859
- https://unix.stackexchange.com/a/269080
- https://unix.stackexchange.com/a/438712
- https://unix.stackexchange.com/a/438712
- https://stackoverflow.com/a/8157973

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/14.md <==
https://stackoverflow.com/a/49981731

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/15.md <==
[bash array as function argument](https://stackoverflow.com/a/8083147)

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/16.md <==
> getting rid of leading and trailing double quotes

```bash
temp="${opt%\"}"
temp="${temp#\"}"
echo "$temp"
```

```bash
$ prefix="hell"
$ suffix="ld"
$ string="hello-world"
$ foo=${string#"$prefix"}
$ foo=${foo%"$suffix"}
$ echo "${foo}"
o-wor
```

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/17.md <==
https://stackoverflow.com/a/70080566
==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/1.md <==
## Source : https://unix.stackexchange.com/questions/258727/spaces-in-variable-assignments-in-shell-scripts

## Question:

What is the difference between below variables assignments?

var=23
var =23
var= 23
var = 23

Is there any difference in space around the assignment operator?

---

## Answer:

That very much depends on the shell. If we only look at the 4 main shell families (Bourne, csh, rc, fish):

## Bourne family

That is the Bourne shell and all its variants and ksh, bash, ash/dash, zsh, yash.

    var=23: that's the correct variable assignment syntax: a word that consists of unquoted letters, digits or underscores followed by an unquoted = that appears before a command argument (here it's on its own)
    var =23, the var command with =23 as argument (except in zsh where =something is a special operator that expands to the path of the something command. Here, you'd likely to get an error as 23 is unlikely to be a valid command name).
    var= 23: an assignment var= followed by a command name 23. That's meant to execute 23 with var= passed to its environment (var environment variable with an empty value).
    var = 23, var command with = and 23 as argument. Try with echo = 23 for instance.

## Csh family

csh and tcsh. Variable assignments there are with the set var = value syntax for scalar variables, set var = (a b) for arrays, setenv var value for environment variables, @ var=1+1 for assignment and arithmetic evaluation.

So:

    var=23 is just invoking the var=23 command.
    var =23 is invoking the var command with =23 as argument.
    var= 23 is invoking the var= command with 23 as argument
    var = 23 is invoking the var command with = and 23 as arguments.

## Rc family

That's rc, es and akanga. In those shells, variables are arrays and assignments are with var = (foo bar), with var = foo being short for var = (foo) (an array with one foo element) and var = short for var = () (array with no element, use var = '' or var = ('') for an array with one empty element).

In any case, blanks (space or tab) around = are allowed and optional. So in those shells those 4 commands are equivalent and equivalent to var = (23) to assign an array with one element being 23.

## Fish

In fish, the variable assignment syntax is set var value1 value2. Like in rc, variables are arrays.

So the behaviour would be the same as with csh, except that fish won't let you run a command with a = in its name. If you have such a command, you need to invoke it via sh for instance: sh -c 'exec weird===cmd'.

So all var=23 and var= 23 will give you an error, var =23 will call the var command with =23 as argument and var = 23 will call the var command with = and 23 as arguments.

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/2.md <==
## Source: https://stackoverflow.com/questions/12488556/bash-loop-skip-commented-lines

## Question:

I'm looping over lines in a file. I just need to skip lines that start with "#". How do I do that?

 #!/bin/sh

 while read line; do
    if ["$line doesn't start with #"];then
     echo "line";
    fi
 done < /tmp/myfile

Thanks for any help!

---

## Answer:

while read line; do
  case "$line" in \#*) continue ;; esac
  ...
done < /tmp/my/input

Frankly, however, it is often clearer to turn to grep:

grep -v '^#' < /tmp/myfile | { while read line; ...; done; }

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/3.md <==
## Source : https://unix.stackexchange.com/questions/174715/how-to-ignore-the-lines-starts-with-using-grep-awk

## Question

How to ignore the lines starts with # using grep / awk?

cat /etc/oratab
#test1:/opt/oracle/app/oracle/product/11.2.0.4:N
+ASM2:/grid/oracle/app/oracle/product/11.2.0.4:N         # line added by Agent
test2:/opt/oracle/app/oracle/product/11.2.0.4:N          # line added by Agent
test3:/opt/oracle/app/oracle/product/11.2.0.4:N          # line added by Agent

oracle@node1 [/home/oracle]
cat /etc/oratab | grep -v "agent" | awk -F: '{print $2 }' | awk NF | uniq

awk NF is to omit blank lines in the output.

Only lines starts with # needs to be ignored. Expected output:

/grid/oracle/app/oracle/product/11.2.0.4
/opt/oracle/app/oracle/product/11.2.0.4

---

## Answer



awk -F: '/^[^#]/ { print $2 }' /etc/oratab | uniq

/^[^#]/ matches every line the first character of which is not a #; [^ means "none of the charaters before the next (or rather: closing) ].

As only the part between the first two colons is needed -F:' makesawksplit the line at colons, and print $2' prints the second part.

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/4.md <==
## Source : [Stackoverflow](https://stackoverflow.com/a/30033822)

---

If you prefer named parameters, it's possible (with a few tricks) to actually pass named parameters to functions (also makes it possible to pass arrays and references).

The method I developed allows you to define named parameters passed to a function like this:

```bash
function example { args : string firstName , string lastName , integer age } {
  echo "My name is ${firstName} ${lastName} and I am ${age} years old."
}
```

You can also annotate arguments as @required or @readonly, create ...rest arguments, create arrays from sequential arguments (using e.g. string[4]) and optionally list the arguments in multiple lines:

```bash
function example {
  args
    : @required string firstName
    : string lastName
    : integer age
    : string[] ...favoriteHobbies

  echo "My name is ${firstName} ${lastName} and I am ${age} years old."
  echo "My favorite hobbies include: ${favoriteHobbies[*]}"
}
```

In other words, not only you can call your parameters by their names (which makes up for a more readable core), you can actually pass arrays (and references to variables - this feature works only in Bash 4.3 though)! Plus, the mapped variables are all in the local scope, just as $1 (and others).

The code that makes this work is pretty light and works both in Bash 3 and Bash 4 (these are the only versions I've tested it with). If you're interested in more tricks like this that make developing with bash much nicer and easier, you can take a look at my Bash Infinity Framework, the code below is available as one of its functionalities.

```bash
shopt -s expand_aliases

function assignTrap {
  local evalString
  local -i paramIndex=${__paramIndex-0}
  local initialCommand="${1-}"

  if [[ "$initialCommand" != ":" ]]
  then
    echo "trap - DEBUG; eval \"${__previousTrap}\"; unset __previousTrap; unset __paramIndex;"
    return
  fi

  while [[ "${1-}" == "," || "${1-}" == "${initialCommand}" ]] || [[ "${#@}" -gt 0 && "$paramIndex" -eq 0 ]]
  do
    shift # First colon ":" or next parameter's comma ","
    paramIndex+=1
    local -a decorators=()
    while [[ "${1-}" == "@"* ]]
    do
      decorators+=( "$1" )
      shift
    done

    local declaration=
    local wrapLeft='"'
    local wrapRight='"'
    local nextType="$1"
    local length=1

    case ${nextType} in
      string | boolean) declaration="local " ;;
      integer) declaration="local -i" ;;
      reference) declaration="local -n" ;;
      arrayDeclaration) declaration="local -a"; wrapLeft= ; wrapRight= ;;
      assocDeclaration) declaration="local -A"; wrapLeft= ; wrapRight= ;;
      "string["*"]") declaration="local -a"; length="${nextType//[a-z\[\]]}" ;;
      "integer["*"]") declaration="local -ai"; length="${nextType//[a-z\[\]]}" ;;
    esac

    if [[ "${declaration}" != "" ]]
    then
      shift
      local nextName="$1"

      for decorator in "${decorators[@]}"
      do
        case ${decorator} in
          @readonly) declaration+="r" ;;
          @required) evalString+="[[ ! -z \$${paramIndex} ]] || echo \"Parameter '$nextName' ($nextType) is marked as required by '${FUNCNAME[1]}' function.\"; " >&2 ;;
          @global) declaration+="g" ;;
        esac
      done

      local paramRange="$paramIndex"

      if [[ -z "$length" ]]
      then
        # ...rest
        paramRange="{@:$paramIndex}"
        # trim leading ...
        nextName="${nextName//\./}"
        if [[ "${#@}" -gt 1 ]]
        then
          echo "Unexpected arguments after a rest array ($nextName) in '${FUNCNAME[1]}' function." >&2
        fi
      elif [[ "$length" -gt 1 ]]
      then
        paramRange="{@:$paramIndex:$length}"
        paramIndex+=$((length - 1))
      fi

      evalString+="${declaration} ${nextName}=${wrapLeft}\$${paramRange}${wrapRight}; "

      # Continue to the next parameter:
      shift
    fi
  done
  echo "${evalString} local -i __paramIndex=${paramIndex};"
}

alias args='local __previousTrap=$(trap -p DEBUG); trap "eval \"\$(assignTrap \$BASH_COMMAND)\";" DEBUG;'
```

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/5.md <==
### Suppressing `stdout`
https://askubuntu.com/a/474566

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/6.md <==
### Commands to examine

- `dirname`
- `basename`
- `realpath`
- `readlink`
- `namei`
- `file`
- `find`
-

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/7.md <==
#### Calling a function of a Bash script

https://stackoverflow.com/a/16159057
[Cannot call bash function inside makefile - Stack Overflow](https://stackoverflow.com/a/39914492)
==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/8.md <==
https://unix.stackexchange.com/a/523420

==> articles/clusters/steps/domains/technologies/topics/Bash, Awk/9.md <==
https://unix.stackexchange.com/a/61888

#### Non Interactive Partitioning

[[1](https://man7.org/linux/man-pages/man8/sfdisk.8.html)] [[2](https://superuser.com/a/1132834)] [[`DEVLOG.md`](./DEVLOG.md/#multiple-efi-partitions)]

#### Current Working Directory

[[1](https://unix.stackexchange.com/a/216915)] [[2](https://stackoverflow.com/a/55798664)] [[3](https://stackoverflow.com/a/246128)]. Considering `namei` instead of `readlink` and `realpath`.

- In Bash
  - Works even when the file is symlinked

    ```bash
    "$( cd "$( dirname "$( readlink --canonicalize "${BASH_SOURCE[0]:-$0}" )" )" && pwd )"
    ```
- In Makefile
  - Works even when the file is symlinked
    [[1](https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile#comment48133734_23324703)]

#### Bash Strict Mode

[[1](http://redsymbol.net/articles/unofficial-bash-strict-mode/)] [[2](https://disconnected.systems/blog/another-bash-strict-mode/)] [[3](https://olivergondza.github.io/2019/10/01/bash-strict-mode.html)] [[4](https://jonlabelle.com/snippets/view/shell/unofficial-bash-strict-mode)]

[5](https://nono.ma/prompt-user-input-makefile)

https://www.mattduck.com/2021-05-fzf-tab-completion.html
