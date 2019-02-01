#!/usr/bin/env sh

# Python
if command -v pyenv > /dev/null 2>&1 \
  && (pyenv version | grep -v system) > /dev/null 2>&1 \
  && python -c "import sys; sys.exit(sys.version_info < (3, 2))";
then
  pip install "python-language-server[rope,pyflakes,mccabe,pycodestyle,pydocstyle]"
else
  echo "Python 3.2 or newer must be installed through pyenv"
  exit 1
fi
