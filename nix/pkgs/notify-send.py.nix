{
  pkgs,
  python3 ? pkgs.python3,
  wrapGAppsHook,
  ...
}:
python3.pkgs.buildPythonApplication rec {
  pname = "notify-send.py";
  version = "1.2.7";
  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
  };
  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    dbus-python
    wrapGAppsHook
  ];
}
