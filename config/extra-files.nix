let
  myCheatsheetPath = pkgs.writeTextFile {
    name = "cheatsheet.txt";
    text = ''
      quickfix move backward through jump list | <C-o>
      quickfix move forward through jump list | <C-i>
      open terminal in new buffer | <C-a>
    '';
  };
in 
