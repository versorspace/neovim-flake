{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.markdown;
in {
  options.vim.markdown = {
    enable = mkEnableOption "markdown tools and plugins";

    glow.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable markdown preview in neovim with glow";
    };
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (
        if cfg.glow.enable
        then glow-nvim
        else null
      )
    ];

    vim.globals = mkIf (cfg.glow.enable) {
      "glow_binary_path" = "${pkgs.glow}/bin";
    };

    vim.configRC = mkIf (cfg.glow.enable) ''
      autocmd FileType markdown noremap <leader>p :Glow<CR>
    '';
  };
}
