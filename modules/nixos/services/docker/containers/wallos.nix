{config}: {
  image = "bellamy/wallos:latest";
  ports = ["8282:80/tcp"];
  # TODO: Move these volumes to better place
  volumes = [
    "/var/www/wallos/db:/var/www/html/db:rw"
    "/var/www/wallos/logos:/var/www/html/images/uploads/logos:rw"
  ];
  environment = {
    TZ = "Europe/Berlin";
  };
  autoStart = true;
}
