{ pkgs, user }:

{
  environment.systemPackages = with pkgs; [ jetbrains-toolbox ];

}
