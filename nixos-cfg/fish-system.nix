{ pkgs, ... }: {
  programs.fish.enable = true;
  users.users.rassvet.shell = pkgs.fish;
}
