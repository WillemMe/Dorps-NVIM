# Spellcheck configuration with local dictionary files
# This module provides multi-language spell checking for English (US) and Dutch (NL)
# using custom dictionaries from the dictionaries/ directory
{pkgs, ...}: let
  # Path to local dictionary files
  dictPath = ../dictionaries;

  # Build English spell file from local hunspell dictionary
  spellFileEN =
    pkgs.runCommand "en-utf-8-spell" {
      nativeBuildInputs = [pkgs.neovim];
    } ''
      mkdir -p $out/spell

      # Copy local hunspell files to working directory
      cp ${dictPath}/English_us.aff ./en_US.aff
      cp ${dictPath}/English_us.dic ./en_US.dic

      # Copy additional dictionary
      cp ${dictPath}/additional_us.aff ./additional_us.aff
      cp ${dictPath}/additional_us.dic ./additional_us.dic

      # Generate .spl file using Neovim in headless mode
      # Combine base and additional dictionaries
      nvim --headless \
        -c "mkspell! $out/spell/en.utf-8.spl en_US additional_us" \
        -c "quit"
    '';

  # Build Dutch spell file from local hunspell dictionary
  spellFileNL =
    pkgs.runCommand "nl-utf-8-spell" {
      nativeBuildInputs = [pkgs.neovim];
    } ''
      mkdir -p $out/spell

      # Copy local hunspell files to working directory
      cp ${dictPath}/Dutch_nl.aff ./nl_NL.aff
      cp ${dictPath}/Dutch_nl.dic ./nl_NL.dic

      # Copy additional dictionary
      cp ${dictPath}/additional_nl.aff ./additional_nl.aff
      cp ${dictPath}/additional_nl.dic ./additional_nl.dic

      # Generate base .spl file using Neovim in headless mode
      nvim --headless \
        -c "mkspell! $out/spell/nl.utf-8.spl nl_NL additional_nl" \
        -c "quit"

      # Verify the spell file was created
      ls -lh $out/spell/
    '';

  # Combine both spell files into one directory
  spellDir = pkgs.runCommand "nvim-spell-files" {} ''
    mkdir -p $out/spell
    ln -s ${spellFileEN}/spell/en.utf-8.spl $out/spell/en.utf-8.spl
    ln -s ${spellFileNL}/spell/nl.utf-8.spl $out/spell/nl.utf-8.spl
  '';
in {
  config.vim = {
    # Add spell files to runtime path
    additionalRuntimePaths = [
      spellDir # Contains both EN and NL spell files
    ];

    # Enable spellcheck with US English as default
    spellcheck = {
      enable = true;
      languages = ["en_us"];
    };

    # User commands for easy language switching
    luaConfigRC.spell-commands = ''
      -- Create user commands for quick language switching
      vim.api.nvim_create_user_command('SpellEN', function()
        vim.opt.spelllang = "en_us"
        vim.notify("Spell language: English (US)", vim.log.levels.INFO)
      end, { desc = "Set spell language to English (US)" })

      vim.api.nvim_create_user_command('SpellNL', function()
        vim.opt.spelllang = "nl"
        vim.notify("Spell language: Dutch (NL)", vim.log.levels.INFO)
      end, { desc = "Set spell language to Dutch (NL)" })

      vim.api.nvim_create_user_command('SpellBoth', function()
        vim.opt.spelllang = "en_us,nl"
        vim.notify("Spell language: English + Dutch", vim.log.levels.INFO)
      end, { desc = "Set spell language to both English and Dutch" })
    '';
  };
}
