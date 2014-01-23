import os, shutil

# Determine the base directory.
basedir = os.path.dirname(os.path.abspath(__file__))
sourcedir = os.path.join(basedir, 'src')
outputdir = os.path.join(basedir, 'output')

def merge(base, override):
	"""
	Merge two settins dicts.
	"""
	for k, v in override.items():
		base[k] = v

def load(path, isSub = False):
	"""
	Recursively load the settings from a puttytray file.
	"""
	epaths = []
	settings = {}
	with open(path, 'r') as f:
		for line in f:
			line = line.strip()
			if line.startswith('@ignore') and not isSub:
				return
			elif line.startswith('@extend'):
				epaths.append(os.path.join(os.path.dirname(path), line.split(' ', 1)[1]))
			else:
				if '\\' in line:
					k, v = line.split('\\', 1)
					settings[k] = v
	for epath in epaths:
		esettings = load(epath, True)
		merge(settings, esettings)
	return settings

def save(path, settings):
	"""
	Save settings to a puttytray file.
	"""
	with open(path, 'w') as f:
		for k, v in settings.items():
			f.write('{}\\{}\n'.format(k, v))

def process(path):
	"""
	Process a file.
	"""
	settings = load(path)
	if not settings:
		return
	newpath = os.path.join(outputdir, os.path.basename(path))
	save(newpath, settings)

if os.path.exists(outputdir):
	shutil.rmtree(outputdir)
if not os.path.exists(outputdir):
	os.mkdir(outputdir)
for path in os.listdir(sourcedir):
	process(os.path.join(sourcedir, path))
