{
  config.vim.keymaps = [
    {
      mode = ["n"];
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      silent = true;
      desc = "Diagnostics (Trouble)";
    }
    {
      mode = ["n"];
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      silent = true;
      desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = ["n"];
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      silent = true;
      desc = "Symbols (Trouble)";
    }
    {
      mode = ["n"];
      key = "<leader>xl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      silent = true;
      desc = "LSP Definitions / References (Trouble)";
    }
    {
      mode = ["n"];
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      silent = true;
      desc = "Location List (Trouble)";
    }
    {
      mode = ["n"];
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      silent = true;
      desc = "Quickfix List (Trouble)";
    }
  ];
}
