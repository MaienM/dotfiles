if ! command -v git &> /dev/null; then
	return
fi

# Some shortcuts.
alias gits='rm -f \\ && git status'
alias gitc='git commit -m'
alias gitca='git commit --amend --no-edit'
alias gitcae='git commit --amend'
alias gitac='git amend-commit "$(fzf_run_preset "git:commit")"'

# Log.
alias gitlv='git log --pretty="tformat:%C(auto)%h %C(cyan)%<(14,mtrunc)%aN%C(auto)%d %C(auto)%s"'
alias gitll='git log --pretty="format:%C(yellow)Commit %H%n%C(cyan)By %an <%ae> on %ad%n%+s%n%+b"  --name-status'

alias gitlvu='gitlv "@{push}.."'
alias gitllu='gitll "@{push}.."'

# Get the jira item from a branch name
alias _git_branch_to_jira="sed 's/\\(-[0-9]\\+\\).*$/\\1/g'"

# Switch between branches
gitb() {
	local branch

	branch="$(fzf_run_preset "git:branch")"
	[ -n "$branch" ] && git checkout "$branch"
}

# A variant of git diff that also shows diffs for new and deleted files
gitd() {
	local opts

	opts=()
	if [[ "$@" == *' -- '* ]]; then
		while ! [ "$1" = '--' ]; do
			opts=("${opts[@]}" "$1")
			shift 1
		done
	fi

	for file in "$@"; do
		if [[ -n "$(git ls-files "$file")" ]]; then
			git diff "${opts[@]}" -- "$file"
		elif [[ -L "$file" ]]; then
			# A new symlink. This is not handled correctly by the --no-index git diff, so create a diff manually.
			(
				echo "${color_bold}diff --git a/$file b/$file$color_reset"
				echo "${color_bold}new file mode 120000$color_reset"
				echo "${color_bold}index 0000000..1234567$color_reset"
				echo "${color_bold}--- /dev/null$color_reset"
				echo "${color_bold}+++ b/$file$color_reset"
				echo "${color_fg_cyan}@@ -0,0 +1 @@$color_reset"
				echo "${color_fg_green}$(readlink "$file")$color_reset"
				echo "\ No newline at end of file$color_reset"
			) | diff-so-fancy
		else
			git diff "${opts[@]}" --no-index -- /dev/null "$file"
		fi
	done
}

# Diff + add.
gitda() {
	if [[ $# -eq 0 ]]; then
		files=($(fzf_run_preset \
			"git:files:dirty" \
			--multi \
			--header="Pick files to stage" \
			--bind='alt-p:abort+execute(git add -p {2} >&2 < /dev/tty)' \
			--preview-window='down:75%'
		))
		[ ${#files} -gt 0 ] || return 0
		git add "${files[@]}"
	else
		gitd $@
		while true; do
			prompt reply "Ynp" "Add to index?"
			case "$reply" in
				y) git add "$@";;
				n) ;;
				p) git add -p "$@";;
				*) continue;;
			esac
			break
		done
	fi
	gits
}

# Checkout
gitco() {
	files=()
	if [[ $# -eq 0 ]]; then
		files=($(fzf_run_preset \
			"git:files:dirty" \
			--multi \
			--header="Pick files to checkout" \
			--bind='alt-p:abort+execute(git checkout -p {2} >&2 < /dev/tty)' \
			--preview-window='down:75%'
		))
		[ ${#files} -gt 0 ] || return 0
		echo "Picked files:"
		printf "\t$color_fg_cyan%s$color_reset\n" "${files[@]}"
	else
		files=("$@")
		gitd $@
	fi
	prompt_confirm "Reset changes? ${color_fg_red}This is not reversible!$color_reset" "n" || return 0

	# Reset the changes
	for file in "${files[@]}"; do
		if [[ -n "$(git ls-files "$file")" ]]; then
			git checkout -- "$file"
		else
			rm "$file"
		fi
	done

	gits
}

# Reset
gitr() {
	files=()
	if [[ $# -eq 0 ]]; then
		files=($(fzf_run_preset \
			"git:files:staged" \
			--multi \
			--header="Pick files to unstage" \
			--preview-window='down:75%'
		))
		[ ${#files} -gt 0 ] || return 0
		echo "Picked files:"
		printf "\t$color_fg_cyan%s$color_reset\n" "${files[@]}"
	else
		files=("$@")
	fi

	git reset HEAD -- "${files[@]}"
	gits
}

# Commit
gitcj() {
	local preset
	if [[ -z "$1" ]]; then
		echo >&2 "Please add a commit message!"
		return 1
	fi
	preset=$(git rev-parse --abbrev-ref HEAD)
	preset=${preset#remotes/*/}
	preset=$(echo $preset | _git_branch_to_jira)
	if [[ "$preset" != [A-Z]*-[0-9]* ]]; then
		echo >&2 "Branch name does not appear to be a feature branch"
		return 1
	fi
	git commit -m "$preset: $@"
}

# Push
alias gitp="git push"
gitpb() {
	local remote
	remote="${1:-origin}"
	[[ -n $1 ]] && shift
	gitp --set-upstream "$@" "$remote" $(git rev-parse --abbrev-ref HEAD)
}

# Work with multiple directories
_gitdirlist() {
	for dir in *(/); do
		[ ! -e "$dir/.git" ] && continue
		echo "$dir"
	done
}
_gitdirdo() {
	declare -a failures
	for dir in $(_gitdirlist); do
		(
			cd "$dir"
			exec eval "$@"
		) || failures=("${failures[@]}" "$dir")
	done
	if [ "${#failures[@]}" -gt 0 ]; then
		echo >&2 "${color_red}The following directories failed:$color_reset"
		printf >&2 '\t%s\n' "${failures[@]}"
	fi
}
gitdirdo() {
	_gitdirdo 'echo "${color_fg_blue}==> $dir <==$color_reset"; ('"$@"'); r=$?; echo; exit $r'
}
gitdirs() {
	typeset -Agx names branches statuses

	_dirtoslug() {
		echo "${${1:t}//[^a-zA-Z0-9_]/_}"
	}

	_gitstatusresult() {
		slug="$(_dirtoslug "$VCS_STATUS_WORKDIR")"
		case "$VCS_STATUS_RESULT" in
			tout)
				# Getting result async, wait for the next call.
				return
			;;

			norepo-*)
				# Unlikely to happen, as we check for the presence of a .git directory.
				branches[$slug]='-'
				statuses[$slug]='Not a repository'
			;;

			ok-*)
				gitstatus="$(P9K_CONTENT= print -P "$POWERLEVEL9K_VCS_CONTENT_EXPANSION")$color_reset"
				gitbranch="${gitstatus/ *}"
				gitstatus="${${gitstatus#$gitbranch}## }"
				gitbranch="${$(echo "$gitbranch" | strip_escape)%\%}"

				if [ "${#gitbranch}" -gt 20 ]; then
					gitbranch="${gitbranch:0:17}..."
				fi

				branches[$slug]="$gitbranch"
				statuses[$slug]="$gitstatus"
			;;

			*)
				branches[$slug]='-'
				statuses[$slug]="GitStatus returned unexpected result '$VCS_STATUS_RESULT'." 
			;;
		esac
		gitstatus_stop_p9k_ "GITDIRS_$slug"
	}

	maxnamewidth=0
	for dir in $(_gitdirlist); do
		name="${dir:t}"
		[ "${#name}" -gt "$maxnamewidth" ] && maxnamewidth="${#name}"

		slug="$(_dirtoslug "$dir")"
		names[$slug]="$name"

		gitstatus_start_p9k_ "GITDIRS_$slug"
		gitstatus_query_p9k_ -d "$dir" -t 0.5 -c _gitstatusresult "GITDIRS_$slug" 
		_gitstatusresult
	done
	format="%-${maxnamewidth}s  %-20s  %s"

	printf "%s$format%s\n" "$color_fg_blue" 'DIR' 'BRANCH' 'STATUS' "$color_reset"
	for key in "${(k)names[@]}"; do
		for i in {0..20}; do
			[ -n "${branches[$key]}${statuses[$key]}" ] && break
			sleep 0.05
		done
		if [ -z "${branches[$key]}${statuses[$key]}" ]; then
			branches[$key]='-'
			statuses[$key]="Timeout while waiting for GitStatus async results."
		fi
		printf "$format\n" "${names[$key]}" "${branches[$key]}" "${statuses[$key]}"
	done
}
gitdirbranch() {
	_gitdirbranch() {
		for branch in "$@"; do
			if [ $(git rev-parse --abbrev-ref HEAD) = "$branch" ]; then
				break
			elif git show-ref --verify --quiet "refs/heads/$branch"; then
				git checkout "$branch" &> /dev/null
				echo "Switched $dir to branch '$branch'"
				break
			elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
				git checkout "$branch" &> /dev/null
				echo "Switched $dir to new branch '$branch'"
				break
			fi
		done
	}
	_gitdirdo "_gitdirbranch ${(q)@}"
}
