{
  config.vim.keymaps = [
    # Visual Block Motions
    # Select text and move with vi dirction keys
    {
      mode = ["v"];
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      silent = true;
      desc = "Move selected lines down";
    }
    {
      mode = ["v"];
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      silent = true;
      desc = "Move selected lines up";
    }
    {
      mode = ["v"];
      key = "L";
      action = "> gv";
      silent = true;
      desc = "Indent selected lines right";
    }
    {
      mode = ["v"];
      key = "H";
      action = "< gv";
      silent = true;
      desc = "Indent selected lines left";
    }
    # Vis Block Motions end
    {
      mode = ["n"];
      key = "<C-n>";
      action = "<cmd>Neotree toggle<CR>";
      silent = true;
      desc = "Open Neotree";
    }
    {
      mode = ["n"];
      key = "J";
      action = "mzJ`z";
      silent = true;
      desc = "Join lines";
    }
    {
      mode = ["n"];
      key = "<C-d>";
      action = "<C-d>zz";
      silent = true;
      desc = "Scroll down half page (centered)";
    }
    {
      mode = ["n"];
      key = "<C-u>";
      action = "<C-u>zz";
      silent = true;
      desc = "Scroll up half page (centered)";
    }
    {
      mode = ["n"];
      key = "n";
      action = "nzzzv";
      silent = true;
      desc = "Next search result (centered)";
    }
    {
      mode = ["n"];
      key = "N";
      action = "Nzzzv";
      silent = true;
      desc = "Previous search result (centered)";
    }
    # Delete and paste buffer without overriding paste buffer
    {
      mode = ["x"];
      key = "<leader>p";
      action = ''[["_dP]]'';
      silent = true;
      desc = "Paste without losing yank buffer";
    }
    # next greatest remap ever : asbjornHaland
    {
      mode = ["n" "v"];
      key = "<leader>y";
      action = ''[["+y]]'';
      silent = true;
      desc = "Yank to system clipboard";
    }
    {
      mode = ["n"];
      key = "<leader>Y";
      action = ''[["+Y]]'';
      silent = true;
      desc = "Yank line to system clipboard";
    }
    {
      mode = ["n" "v"];
      key = "<leader>d";
      action = ''[["_d]]'';
      silent = true;
      desc = "Delete without yanking";
    }
    {
      mode = ["n"];
      key = "Q";
      action = "<nop>";
      silent = true;
      desc = "Disable Ex mode";
    }
    {
      mode = ["n"];
      key = "<C-f>";
      action = "<cmd>silent !tmux neww tmux-sessionizer<CR>";
      silent = true; # Note: action already contains <cmd>silent, but adding here for consistency
      desc = "Open tmux sessionizer";
    }
    # format current buffer
    {
      mode = ["n"];
      key = "<leader>f";
      action = "<cmd>Format<CR>";
      silent = true;
      desc = "Format buffer";
    }

    {
      mode = ["n"];
      key = "<C-k>";
      action = "<cmd>cnext<CR>zz";
      silent = true;
      desc = "Next quickfix item";
    }
    {
      mode = ["n"];
      key = "<C-j>";
      action = "<cmd>cprev<CR>zz";
      silent = true;
      desc = "Previous quickfix item";
    }
    {
      mode = ["n"];
      key = "<leader>k";
      action = "<cmd>lnext<CR>zz";
      silent = true;
      desc = "Next location list item";
    }
    {
      mode = ["n"];
      key = "<leader>j";
      action = "<cmd>lprev<CR>zz";
      silent = true;
      desc = "Previous location list item";
    }
    {
      mode = ["n"];
      key = "<leader>s";
      action = "[[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]];";
      silent = true;
      desc = "Substitute word under cursor";
    }
    {
      mode = ["n"];
      key = "<leader>x";
      action = "<cmd>!chmod +x %<CR>";
      desc = "Change the current buffer to execute";
      silent = true;
    }
    {
      mode = ["n"];
      key = "<leader>h";
      action = "<cmd>nohlsearch<CR>";
      silent = true;
      desc = "Clear search highlight";
    }
    # Git Fugitive
    {
      mode = ["n"];
      key = "<leader>gs";
      action = "<cmd>Git<CR>";
      silent = true;
      desc = "Open Fugitive Git status";
    }
    # gitworktrees
    {
      mode = ["n"];
      key = "<leader>pw";
      action = "lua require('telescope').extensions.git_worktree.git_worktrees() ";
      silent = true;
      desc = "Telescope Git worktrees";
    }
    # meta v for visual block in MacOS
    {
      mode = ["n"];
      key = "<leader>v";
      action = ''<cmd>execute "normal! \<C-v>"<CR>'';
      silent = true;
      desc = "Enter Visual Block Mode";
    }
    {
      mode = ["t"];
      key = "<Esc>";
      action = ''<C-\><C-n>'';
      silent = true;
      desc = "Exit terminal";
    }
  ];
}
