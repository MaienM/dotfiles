{ pkgs
, pythonPackages ? pkgs.python3.pkgs
, ...
}:
pythonPackages.buildPythonApplication rec {
  pname = "notify-send.py";
  version = "1.2.7";
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
  };
  propagatedBuildInputs = with pythonPackages; [ pygobject3 dbus-python ];
}
