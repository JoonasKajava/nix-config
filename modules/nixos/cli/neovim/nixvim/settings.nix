{...}: {
  extraConfigLuaPre =
    # lua
    ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })
    '';

  luaLoader.enable = true;

  clipboard.providers.wl-copy.enable = true;

  opts = {
    # Show line numbers
    number = true;

    # Show relative line numbers
    relativenumber = true;

    # Use the system clipboard
    clipboard = "unnamedplus";

    # Number of spaces that represent a <TAB>
    tabstop = 2;
    softtabstop = 2;

    # Show tabline always
    showtabline = 2;

    # Use spaces instead of tabs
    expandtab = true;

    # Enable smart indentation
    smartindent = true;

    # Number of spaces to use for each step of (auto)indent
    shiftwidth = 2;

    # Enable break indent
    breakindent = true;

    # Highlight the screen line of the cursor
    cursorline = true;

    # Minimum number of screen lines to keep above and below the cursor
    scrolloff = 8;

    # Enable mouse support
    mouse = "a";

    # Wrap long lines at a character in 'breakat'
    linebreak = true;

    # Disable spell checking
    spell = false;

    # Disable swap file creation
    swapfile = false;

    undofile = true;

    # Time in milliseconds to wait for a mapped sequence to complete
    timeoutlen = 300;

    # Enable 24-bit RGB color in the TUI
    termguicolors = true;

    # Don't show mode in the command line
    showmode = false;

    # Open new split below the current window
    splitbelow = true;

    # Keep the screen when splitting
    splitkeep = "screen";

    # Open new split to the right of the current window
    splitright = true;

    # Hide command line unless needed
    cmdheight = 0;

    hlsearch = true;
    incsearch = true;

    # Enable ignorecase + smartcase for better searching
    ignorecase = true;
    smartcase = true; # Don't ignore case with capitals
    grepprg = "rg --vimgrep";
    grepformat = "%f:%l:%c:%m";

    # Remove EOB
    fillchars = {
      eob = " ";
    };

    # Enable the sign column to prevent the screen from jumping
    signcolumn = "yes";

    # Set encoding type
    encoding = "utf-8";
    fileencoding = "utf-8";
  };
}
