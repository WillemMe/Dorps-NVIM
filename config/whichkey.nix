{
  config.vim = {
    binds.whichKey = {
      enable = true;
      setupOpts = {
        plugins = {
          marks = true;
          registers = true;
          spelling = {
            enabled = true;
            suggestions = 20;
          };
          presets = {
            operators = true;
            motions = true;
            text_objects = true;
            windows = true;
            nav = true;
            z = true;
            g = true;
          };
        };
        layout = {
          height = {
            min = 4;
            max = 25;
          };
          width = {
            min = 20;
            max = 50;
          };
          spacing = 3;
          align = "center";
        };
        registrations = {
          f = {
            name = "Find";
            f = "Find files";
            g = "Live grep";
            b = "Buffers";
            h = "Help tags";
            z = "Find directory (Zoxide)";
          };
          g = {
            name = "Git";
            s = "Status";
            c = "Commits";
            b = "Branches";
          };
          h = {
            name = "Harpoon";
            a = "Add file";
            m = "Menu";
          };
        };
      };
    };
  };
}
