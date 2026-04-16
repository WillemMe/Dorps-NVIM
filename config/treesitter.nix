{pkgs, ...}: let
  # Query for XXX in comments (general languages)
  commentXxxQuery = ''
    ; extends

    ((comment) @comment.todo
      (#match? @comment.todo "XXX"))
  '';

  # Query for \TODO{} as a LaTeX command node, and XXX anywhere in text.
  # Uses (word) nodes so XXX inside % line_comment nodes is NOT matched.
  latexTodoQuery = ''
    ; extends

     (generic_command
      (command_name) @_name
      (#eq? @_name "\\TODO")) @comment.todo

    ((word) @comment.todo
      (#eq? @comment.todo "XXX"))
  '';

  commentHighlightQueries = pkgs.vimUtils.buildVimPlugin {
    name = "comment-highlight-queries";
    src = pkgs.runCommand "comment-highlight-queries-src" {} ''
      mkdir -p $out

      for lang in nix bash lua python c; do
        mkdir -p $out/after/queries/$lang
        cat > $out/after/queries/$lang/highlights.scm << 'QUERY'
      ${commentXxxQuery}
      QUERY
      done

      mkdir -p $out/after/queries/latex
      cat > $out/after/queries/latex/highlights.scm << 'QUERY'
      ${latexTodoQuery}
      QUERY
    '';
  };
in {
  config.vim = {
    treesitter = {
      enable = true;
      context.enable = true;
    };

    extraPlugins = {
      comment-highlight-queries = {
        package = commentHighlightQueries;
      };
    };

    luaConfigPost = ''
      local function setup_bang_hl()
        vim.api.nvim_set_hl(0, "BangHighlight", { fg = "#ff9500", bold = true })
      end
      setup_bang_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_bang_hl })
      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
        callback = function()
          pcall(vim.fn.matchadd, "BangHighlight", "!!.\\{-}!!")
        end,
      })
    '';
  };
}
