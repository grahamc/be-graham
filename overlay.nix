self: super: {
  grahamc = self.lib.makeExtensible (_: {
    lib = self.lib.makeExtensible (_: {
      loadJsonOr = file: default:
        if builtins.pathExists file
        then builtins.fromJSON (builtins.readFile file)
        else default;
    });

    about = self.lib.makeExtensible (_: {
      name = "Graham Christensen";
      email = "graham@grahamc.com";
    });

    portable-shell = self.mkShell {
      name = "be-graham";

      buildInputs = [
        self.bat
        self.grahamc.tmux
        self.grahamc.vim
        self.mosh
        self.nixpkgs-fmt
        self.shellcheck
      ];

      EDITOR = "${self.grahamc.vim}/bin/nvim";
      EMAIL = self.grahamc.about.email;
      GIT_AUTHOR_EMAIL = self.grahamc.about.email;
      GIT_AUTHOR_NAME = self.grahamc.about.name;
      GIT_COMMITTER_EMAIL = self.grahamc.about.email;
      GIT_COMMITTER_NAME = self.grahamc.about.name;
      XDG_CONFIG_HOME = self.grahamc.xdg_configs;

      shellHook = ''
        source ${self.bash-completion}/etc/profile.d/bash_completion.sh
        source ${./shell-hook}
      '';
    };

    tmux = self.writeScriptBin "grahams-${self.tmux.name}" ''
      ${self.bash}/bin/sh

      exec ${self.tmux}/bin/tmux -l ${self.grahamc.tmuxconfig} "$@"
    '';

    tmuxconfig = self.writeText "tmux.conf" ''
      # tmux eats ESC for 1s by default, causing vim to be slow
      set -sg escape-time 10
    '';

    vim = self.neovim.override {
      vimAlias = true;
      withPython3 = true;
      configure = {
        customRC = ''
          set hidden
          set expandtab
          set tabstop=2
          set background=dark
          colorscheme PaperColor
          set number
          set ignorecase
          set synmaxcol=400

          " Strip trailing whitespace
          autocmd BufWritePre * %s/\s\+$//e

          " Make tab characters obvious
          set listchars=tab:>-

          " Always show indentation guides
          let g:indent_guides_enable_on_vim_startup = 1

          " open NERDTree
          map <C-n> :NERDTreeToggle<CR>
        '';
        packages.grahams-vim = with self.vimPlugins; {
          start = [
            airline
            ale
            editorconfig-vim
            fugitive
            fzf-vim
            gitgutter
            neoformat
            nerdtree
            papercolor-theme
            python-mode
            vim-addon-nix
            vim-indent-guides
            vim-pencil
            vim-terraform
            vim-trailing-whitespace
            vim-wordy
          ];
        };
      };
    };

    xdg_configs = ./xdg_configs;
  });
}
