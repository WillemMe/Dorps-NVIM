{
  config.vim = {
    tabline = {
      nvimBufferline = {
        enable = true;
        mappings.closeCurrent = "<leader>bd";
        setupOpts.options = {
          numbers = "none";
        };
      };
    };
  };
}
