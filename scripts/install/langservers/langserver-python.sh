#!/usr/bin/env sh

# Python
if command -v asdf > /dev/null 2>&1 \
  && ! (asdf current python | grep -q system) > /dev/null 2>&1 \
  && python -c "import sys; sys.exit(sys.version_info < (2, 7) or (sys.version_info >= (3,) and sys.version_info < (3, 2)))";
then
  pip install "python-language-server[rope,pyflakes,mccabe,pycodestyle,pydocstyle]"
else
  echo "Python 2.7+ or 3.2+ must be installed through asdf"
  exit 1
fi
