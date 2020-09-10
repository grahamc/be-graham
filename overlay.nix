self: super: {
  grahamc = {
    about = {
      name = "Graham Christensen";
      email = "graham@grahamc.com";
    };

    portable-shell = self.mkShell {
      name = "be-graham";

      buildInputs = [
        self.bat
        self.grahamc.vim
        self.nixpkgs-fmt
        self.shellcheck
        self.tmux
      ];

      EDITOR = "${self.grahamc.vim}/bin/nvim";
      EMAIL = self.grahamc.about.email;
      GIT_AUTHOR_EMAIL = self.grahamc.about.email;
      GIT_AUTHOR_NAME = self.grahamc.about.name;
      GIT_COMMITTER_EMAIL = self.grahamc.about.email;
      GIT_COMMITTER_NAME = self.grahamc.about.name;
      XDG_CONFIG_HOME = self.grahamc.xdg_configs;

      shellHook = ''
        nixpkgs-fmt ${toString ./.}
        source ${self.bash-completion}/etc/profile.d/bash_completion.sh
        alias cat=bat
      '';
    };

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
            vim-trailing-whitespace
            vim-wordy
          ];
        };
      };
    };

    xdg_configs = ./xdg_configs;
  };
}
