import os

from powerline.lib.shell import run_cmd
from powerline.theme import requires_segment_info

def get_data(pl, pid):
	return run_cmd(pl,['ps', '-o', 'ppid=', '-o', 'cmd=', '-p', str(pid)]).split(None, 1)

def is_shell(pl, pid):
	pid, cmd = get_data(pl, pid)
	return cmd.endswith('sh')

@requires_segment_info
def shell_level(pl, segment_info, min_level=0, only_count_shells=True, require_parent_shell=True):
	"""
    Returns the current shell level.

	By default this is $SHLVL.

	:param int min_level
		The minimum required level.

    :param bool only_count_shells
        Whether to only count parent processes that are shells.

		This means that it will recursively count the parent processes
		until it encounters one that doesn't end in 'sh', or til it has
		checked $SHLVL parents.
		This count will then be used as the shell level.
		This means the output may not be equal to $SHLVL

    :param bool require_parent_shell
        Whether the parent process has to be a shell.
		This means the parent process has to end in 'sh'.
    """
	lvl = int(segment_info['environ'].get('SHLVL', 0))
	pid = int(segment_info.get('client_id', os.getppid()))
	ppid, _ = get_data(pl, pid)
	if only_count_shells:
		newlvl = 0
		for i in range(lvl + 1):
			ppid, cmd = get_data(pl, ppid)
			if not cmd.endswith('sh'):
				break
			newlvl += 1
		lvl = newlvl
	if require_parent_shell and is_shell(pl, ppid):
		return None
	if lvl and lvl >= min_level:
		return str(lvl)
