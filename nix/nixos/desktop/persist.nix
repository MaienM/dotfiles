{ options, ... }:
{
  fileSystems."/var/log" = {
    device = "ssd/persist/log";
    fsType = "zfs";
  };

  services.openssh.hostKeys = builtins.map (
    value:
    value
    // {
      path = builtins.replaceStrings [ "/etc/ssh/" ] [ "/persist/etc/ssh/" ] value.path;
    }
  ) options.services.openssh.hostKeys.default;
}
