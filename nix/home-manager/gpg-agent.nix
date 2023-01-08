{ pinentry }:
{
  home.file = {
    # Setup gpg-agent config.
    # TODO: Once I figure out how I want to handle secrets check if that can also solve this problem.
    ".gnupg/gpg-agent.conf" = {
      text = builtins.replaceStrings
        [ "pinentry-auto" ]
        [ "${pinentry}/bin/pinentry" ]
        (builtins.readFile ../../gnupg/gpg-agent.conf);
    };
  };
}
