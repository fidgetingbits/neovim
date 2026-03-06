inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
let
  configSource = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./init.lua
      ./lua
      ./after
      ./plugin
    ];
  };
in
{
  imports = [ wlib.wrapperModules.neovim ];

  options = {
    settings = {
      devMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      # Have neovim use immutable config from /nix/store
      wrappedConfig = lib.mkOption {
        type = lib.types.either wlib.types.stringable lib.types.luaInline;
        default = "${configSource}";
      };

      # Have neovim use raw config folder for faster prototyping
      unwrappedConfig = lib.mkOption {
        type = lib.types.either wlib.types.stringable lib.types.luaInline;
        default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/dev/nix/neovim'";
      };

      neovide = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      # Inform lua which top level specs are enabled
      cats = lib.mkOption {
        readOnly = true;
        type = lib.types.attrsOf lib.types.bool;
        default = lib.mapAttrs (_: v: v.enable) config.specs;
      };
    };

    nvim-lib = {
      neovimPlugins = lib.mkOption {
        readOnly = true;
        type = lib.types.attrsOf wlib.types.stringable;
        # Makes plugins autobuilt from our inputs available with
        # `config.nvim-lib.neovimPlugins.<name_without_prefix>`
        default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
      };

      # This is from the official template and allows you to build plugins
      # that aren't in nixpkgs yet.
      pluginsFromPrefix = lib.mkOption {
        type = lib.types.raw;
        readOnly = true;
        default =
          prefix: inputs:
          lib.pipe inputs [
            builtins.attrNames
            (builtins.filter (s: lib.hasPrefix prefix s))
            (map (
              input:
              let
                name = lib.removePrefix prefix input;
              in
              {
                inherit name;
                value = config.nvim-lib.mkPlugin name inputs.${input};
              }
            ))
            builtins.listToAttrs
          ];
      };
    };
  };

  config = {
    # Build a neovide wrapper
    hosts.neovide.nvim-host.enable = config.settings.neovide;

    settings.config_directory =
      if config.settings.devMode then config.settings.unwrappedConfig else config.settings.wrappedConfig;

    settings.aliases = [
      "vi"
      "vim"
    ];

    # NOTE: Specs are enabled by default
    specs = {
      core = {
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            lze
            lzextras
            mini-icons
            nvim-web-devicons
            plenary-nvim
            vim-repeat
            ;
        };

        extraPackages = lib.attrValues {
          inherit (pkgs)
            fd
            ripgrep
            tree-sitter
            universal-ctags
            ;
        };
      };

      lsp = {
        enable = config.settings.devMode;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            lazydev-nvim # FIXME: switch this to specs.lua eventually
            nvim-lspconfig
            ;
        };

        extraPackages = lib.attrValues {
          inherit (pkgs)
            bash-language-server
            just-lsp
            lua-language-server
            marksman # markdown
            nix-doc
            nixd
            ruff # python
            taplo # toml
            ;
        };
      };

      search = {
        after = [ "core" ];
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            telescope-nvim
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            flash-nvim
            ;
        };
      };

      ui = {
        after = [ "core" ];
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            catppuccin-nvim
            fidget-nvim
            hardtime-nvim
            lualine-nvim
            neo-tree-nvim
            noice-nvim
            nvim-notify
            smart-splits-nvim
            snacks-nvim
            todo-comments-nvim
            trouble-nvim
            which-key-nvim
            zen-mode-nvim
            ;
        };
      };

      git = {
        after = [ "core" ];
        enable = config.settings.devMode;
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            gitsigns-nvim
            neogit
            ;
        };
      };

      format = {
        after = [ "core" ];
        enable = config.settings.devMode;
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            conform-nvim
            ;
        };
        extraPackages = lib.attrValues {
          inherit (pkgs)
            kdlfmt
            shfmt
            shellharden
            nixfmt
            rustfmt
            ruff
            yamlfmt
            prettier
            stylua
            ;
        };
      };

      kdl = {
        after = [ "format" ];
        enable = config.settings.devMode;
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            kdl-vim
            ;
        };
      };

      markdown = {
        after = [ "core" ];
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            vim-markdown-toc
            markdown-preview-nvim
            obsidian-nvim
            ;
        };
      };

      ai = {
        after = [ "ui" ];
        enable = config.settings.devMode;
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            codecompanion-nvim
            ;
        };
      };

      completion = {
        after = [ "core" ];
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            # FIXME: see if we want any other blink-cmp sources
            blink-cmp
            blink-cmp-conventional-commits
            colorful-menu-nvim # provide additional info for completion suggestions
            friendly-snippets
            luasnip
            ;
        };
      };

      editing =
        let
          treesitterDevPlugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins:
            lib.attrValues {
              inherit (plugins)
                asm
                c
                cmake
                cpp
                git_config
                gitcommit
                gitignore
                go
                java
                javascript
                jinja
                jq
                kconfig
                kdl
                lua
                nasm
                regex
                rust
                ;
            }
          );
        in
        {
          after = [ "core" ];
          lazy = true;
          data =
            lib.attrValues {
              inherit (pkgs.vimPlugins)
                comment-nvim
                cutlass-nvim
                indent-blankline-nvim
                mini-ai
                mini-surround
                ;
              inherit (config.nvim-lib.neovimPlugins)
                nvim-toggler
                nvim-better-n
                ;
            }
            ++ [
              (pkgs.vimPlugins.nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  bash
                  html
                  json
                  json5
                  just
                  markdown
                  nix
                  python
                  toml
                  yaml
                  zsh
                ]
              ))
            ]
            ++ lib.optional config.settings.devMode treesitterDevPlugins;
        };
    };

    # https://birdeehub.github.io/nix-wrapper-modules/neovim.html#tips-and-tricks
    specMods =
      {
        parentSpec ? null,
        parentOpts ? null,
        parentName ? null,
        config,
        ...
      }:
      {
        # add an extraPackages field to the specs themselves
        options.extraPackages = lib.mkOption {
          type = lib.types.listOf wlib.types.stringable;
          default = [ ];
          description = "An extraPackages spec field to put packages to suffix to the PATH";
        };
      };
    extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];
  };
}
