{ config, pkgs, ... }:

{
  age.secrets.restic-env = {
    file = ../secrets/restic-env.age;
    owner = "root";
    group = "root";
  };

  age.secrets.restic-password = {
    file = ../secrets/restic-password.age;
    owner = "root";
    group = "root";
  };

  services.restic.backups = {
    photos-and-music = {
      paths = [
        "/mnt/storage/Pictures"
        "/mnt/storage/Music"
      ];
      initialize = true;
      repository = "b2:photos-and-music";
      passwordFile = config.age.secrets.restic-password.path;
      environmentFile = config.age.secrets.restic-env.path;
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 100"
      ];
    };
  };
}

