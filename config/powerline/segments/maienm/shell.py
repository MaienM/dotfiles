import os

from powerline.lib.shell import run_cmd
from powerline.theme import requires_segment_info

def get_ppid(pl, pid):
	return run_cmd(pl,['ps', '-o', 'ppid=', '-p', str(pid)])

def is_shell(pl, pid):
	cmd = run_cmd(pl, ['ps', '-o', 'cmd=', '-p', pid])
	return cmd.endswith('sh')

@requires_segment_info
def shell_level(pl, segment_info, min_level=0, only_count_shells=True, require_parent_shell=True):
	"""
        Returns the current shell level.

	By default this is $SHLVL.

	:param int min_level:
		The minimum required level.
        :param bool only_count_shells
                Whether to only count parent processes that are shells.
		This means that it will recursively count the parent processes
		until it encounters one that doesn't end in 'sh', or til it has
		checked $SHLVL parents. 
		This count will then be used as the shell level.
		This means the output may not be equal to $SHLVL
        :param bool require_parent_shell:
                Whether the parent process has to be a shell.
		This means the parent process has to end in 'sh'.
        """
	lvl = int(segment_info['environ'].get('SHLVL', 0))
	if only_count_shells:
		newlvl = 0
		pid = os.getppid()
		for i in range(lvl + 1):
			pid = get_ppid(pl, pid)
			if not is_shell(pl, pid):
				break
			newlvl += 1
		lvl = newlvl
	if require_parent_shell and not is_shell(pl, get_ppid(pl, os.getppid())):
		return None
	if lvl and lvl >= min_level:
		return str(lvl)
