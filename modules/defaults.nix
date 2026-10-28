{
  lib,
  den,
  ...
}: {

  # enable hm by default
  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
