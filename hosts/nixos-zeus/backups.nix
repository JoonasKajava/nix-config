{...}:
{
  services.borgbackup.jobs.home-joonas = {
    paths =  "/home/joonas" ;
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/joonas/.ssh/id_ed25519";
    repo = "ssh://s4081520@s4081520.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
  };
}