if ! command -v git &> /dev/null; then
	return
fi

# Files
_fzf_pipeline_git_files_source() {
	local file

	git ls-files "$@" \
	| uniq \
	| while read -r file; do
		# Handle files with special characters, which git outputs as a quoted name with escape codes.
		if [[ "$file" =~ '"*' ]]; then
			file="$(print $file)"
			file="${(Q)file}"
		fi
		echo "${(q)file} $file" 
	done 
}
_fzf_pipeline_git_files_preview() {
	preview "${(Q)1}"
}
_fzf_pipeline_git_files_target() {
	echo ${(Q)1}
}

# Files with changes
_fzf_pipeline_git_files_modified_source() {
	_fzf_pipeline_git_files_source --modified --exclude-standard \
	| grep --invert-match --fixed-strings --line-regexp "$(_fzf_pipeline_git_files_deleted_source)"
}
_fzf_pipeline_git_files_modified_preview() {
	gitd --color -- "${(Q)1}" | delta
}
alias _fzf_pipeline_git_files_modified_target='_fzf_pipeline_git_files_target'

# Deleted files
alias _fzf_pipeline_git_files_deleted_source='_fzf_pipeline_git_files_source --deleted --exclude-standard'
_fzf_pipeline_git_files_deleted_preview() {
	gitd --color -- "${(Q)1}" | delta
}
alias _fzf_pipeline_git_files_deleted_target='_fzf_pipeline_git_files_target'

# Other files (this includes files not yet known to git)
alias _fzf_pipeline_git_files_others_source='_fzf_pipeline_git_files_source --others --exclude-standard'
_fzf_pipeline_git_files_others_preview() {
	gitd --color -- "${(Q)1}" | delta
}
alias _fzf_pipeline_git_files_others_target='_fzf_pipeline_git_files_target'

# Staged files
_fzf_pipeline_git_files_staged_source() {
	git diff --name-only --cached \
	| while read file; do
		echo "${(q)file} $file"
	done \
	| uniq
}
_fzf_pipeline_git_files_staged_preview() {
	gitd --staged --color -- "${(Q)1}" | delta
}
alias _fzf_pipeline_git_files_staged_target='_fzf_pipeline_git_files_target'

# Commits
_fzf_pipeline_git_commit_source() {
	git log --pretty=format:"%H ${color_fg_yellow}%h$color_reset %s" "$@"
}
_fzf_pipeline_git_commit_preview() {
	git show --no-patch "$1"
	echo
	git stash show --name-status "$1"
}

# Branches
_fzf_pipeline_git_branch_source() {
	# Get all branches, local and remote, with their full name.
	# Filter out remote branches that have the same name and HEAD as another branch (local or remote).
	local __ branch columns name commit
	columns=$(($COLUMNS / 5))
	git branch --all "$@" \
	| grep -v HEAD \
	| sed 's/^.[[:space:]]*//' \
	| while read branch; do
		# Output format: branch_full remote_name branch_name commit_hash
		echo -n ${branch#remotes/}
		if [[ "$branch" == "remotes/"* ]]; then
			echo -n ' '${${branch#remotes/}%/*}
		else
			echo -n ' !!!!!local'
		fi
		echo -n ' '${branch#remotes/*/}
		echo -n ' '$(git rev-parse "$branch")
		echo
	done \
	| sort --key=2 \
	| sort --key=4 --stable \
	| sort --key=3 --stable \
	| uniq --skip-fields=2 \
	| sort --key=2 --stable \
	| while read branch __ __ __; do
		echo -n $branch
		echo -n ' '${color_fg_yellow}${branch[0,$columns]}$color_reset
		echo -n ' '$(git log --pretty=format:%s "$branch" --max-count=1)
		echo
	done
}
alias _fzf_pipeline_git_branch_preview='_fzf_pipeline_git_commit_preview'
_fzf_pipeline_git_branch_target() {
	local short

	# Abbreviate the name, if it is non-ambiguous
	short=${1#*/}
	if [[ $(git branch --list --all | grep "$short" | wc -l) -eq 1 ]]; then
		echo $short
	else
		echo $1
	fi
}

# Tags
_fzf_pipeline_git_tag_source() {
	git tag "$@" --format="%(refname:strip=1) ${color_fg_yellow}%(refname:strip=2)$color_reset %(subject)"
}
alias _fzf_pipeline_git_tag_preview='_fzf_pipeline_git_commit_preview'

# Stash
_fzf_pipeline_git_stash_source() {
	git stash list --pretty=format:"%H ${color_fg_yellow}%gd$color_reset %s" "$@"
}
alias _fzf_pipeline_git_stash_preview='_fzf_pipeline_git_commit_preview'

# Reflog
_fzf_pipeline_git_reflog_source() {
	git reflog \
	| sed 's/HEAD@{[0-9]\+}: //' \
	| sed "s/ \([^: ]\+\)\( [^:(]\+\)\?\( ([^)]\+)\)\?:/ $color_fg_cyan\1$color_fg_green\2$color_fg_red\3$color_reset/"
}

# Presets
alias _fzf_preset_git_files='_fzf_config_add git_files'
alias _fzf_preset_git_files_modified='_fzf_config_add git_files_modified'
alias _fzf_preset_git_files_deleted='_fzf_config_add git_files_deleted'
alias _fzf_preset_git_files_staged='_fzf_config_add git_files_staged'
alias _fzf_preset_git_files_others='_fzf_config_add git_files_others'
_fzf_preset_git_files_dirty() {
	echo \
	| _fzf_config_add "git_files_modified" "${color_fg_cyan}modified$color_reset" \
	| _fzf_config_add "git_files_deleted" "${color_fg_red}deleted$color_reset" \
	| _fzf_config_add "git_files_others" "${color_fg_green}added$color_reset"
}
alias _fzf_preset_git_commit='_fzf_config_add git_commit'
alias _fzf_preset_git_branch='_fzf_config_add git_branch'
alias _fzf_preset_git_tag='_fzf_config_add git_tag'
alias _fzf_preset_git_stash='_fzf_config_add git_stash'
_fzf_preset_git_ref() {
	echo \
	| _fzf_config_add "git_branch" "${color_fg_green}branch$color_reset" \
	| _fzf_config_add "git_tag" "${color_fg_blue}tag$color_reset" \
	| _fzf_config_add "git_stash" "${color_fg_purple}stash$color_reset" \
	| _fzf_config_add "git_commit" "${color_fg_cyan}commit$color_reset"
}
alias _fzf_preset_git_reflog='_fzf_config_add git_reflog'

_fzf_register_preset "git_files" "Git files" "git:files"
_fzf_register_preset "git_files_modified" "Git files with unstaged changes" "git:files:modified"
_fzf_register_preset "git_files_deleted" "Git files that are removed" "git:files:deleted"
_fzf_register_preset "git_files_others" "Git files that are not yet tracked" "git:files:others"
_fzf_register_preset "git_files_dirty" "Git files (with changes/untracked)" "git:files:dirty"
_fzf_register_preset "git_files_staged" "Git files that are staged" "git:files:staged"
_fzf_register_preset "git_commit" "Git commits" "git:commit"
_fzf_register_preset "git_branch" "Git branches" "git:branch"
_fzf_register_preset "git_tag" "Git tags" "git:tag"
_fzf_register_preset "git_stash" "Git stashes" "git:stash"
_fzf_register_preset "git_ref" "Git refs (commits, branches and tags)" "git:ref"
_fzf_register_preset "git_reflog" "Git reflog" "git:reflog"
