{pkgs, ...}: {
  config.vim = {
    # Enable markdown support for Avante
    languages = {
      markdown = {
        enable = true;
        extensions.render-markdown-nvim = {
          enable = true;
          setupOpts = {
            settings = {
              file_types = ["markdown" "Avante"];
              ft = ["markdown" "Avante"];
            };
          };
        };
      };
    };

    # Enable the built-in avante-nvim module
    assistant.avante-nvim = {
      enable = true;
      setupOpts = {
        # Default provider for chat and suggestions
        provider = "gemini";
        auto_suggestions_provider = "gemini";
        
        # System prompt configuration
        system_prompt = ''
          You are an AI Programming Assistant integrated into Neovim.
          Your goal is to help the user write, understand, refactor, and debug code efficiently.
          - Prioritize correctness, clarity, and established best practices.
          - Provide concise explanations when needed.
          - Format code snippets using markdown code blocks.
          - If a request is ambiguous, ask for clarification.
        '';
        
        # Provider configurations
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1";
            model = "o4-mini";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 16384;  # 16K output tokens for o4-mini
            };
          };
          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-opus-4-20250514";  # Claude Opus 4 - latest
            extra_request_body = {
              temperature = 0;
              max_tokens = 32000;  # 32K output tokens
            };
          };
          gemini = {
            model = "gemini-2.5-flash";  # Latest Gemini 2.5 Flash
            extra_request_body = {
              temperature = 0;
              max_tokens = 8192;  # Gemini typically supports 8K output
            };
          };
          openrouter = {
            __inherited_from = "openai";
            endpoint = "https://openrouter.ai/api/v1";
            model = "anthropic/claude-sonnet-4:beta";  # Claude Sonnet 4 via OpenRouter
            extra_request_body = {
              temperature = 0;
              max_tokens = 64000;  # Claude Sonnet 4 supports 64K output
            };
          };
        };
        
        # Diff settings
        diff = {
          autojump = true;
          list_opener = "copen";
        };
        
        # Highlights
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        
        # Behavior settings
        behaviour = {
          auto_suggestions = false;
          auto_set_highlight_group = true;
          auto_set_keymaps = true;
          auto_apply_diff_after_generation = false;
          support_paste_from_clipboard = false;
        };
        
        # Hints
        hints = {
          enabled = true;
        };
        
        # Mappings
        mappings = {
          diff = {
            both = "cb";
            next = "]x";
            none = "c0";
            ours = "co";
            prev = "[x";
            theirs = "ct";
          };
        };
        
        # Windows
        windows = {
          sidebar_header = {
            align = "center";
            rounded = true;
          };
          width = 40;
          wrap = true;
        };
      };
    };

    # Additional plugin for image clipboard support
    extraPlugins = with pkgs.vimPlugins; {
      img-clip-nvim = {
        package = img-clip-nvim;
        setup = "require('img-clip').setup({ })";
      };
    };
  };
}
