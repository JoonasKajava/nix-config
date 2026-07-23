[
  {
    context = "Workspace";
    bindings = {
      "space l" = "zed::Extensions";
      "space q q" = "zed::Quit";
      "space L" = "git_panel::ToggleFocus";
      "space f t" = "terminal_panel::ToggleFocus";
      "space f T" = "terminal_panel::ToggleFocus";
      "ctrl-_" = "terminal_panel::ToggleFocus";
      "space w w" = "workspace::ToggleAllDocks";
      "space w m" = "workspace::ToggleZoom";
      "space tab l" = "pane::ActivateLastItem";
      "space tab o" = ["pane::CloseOtherItems" {close_pinned = false;}];
      "space tab f" = ["pane::ActivateItem" 0];
      "space tab tab" = "workspace::NewFile";
      "space tab ]" = "pane::ActivateNextItem";
      "space tab [" = "pane::ActivatePreviousItem";
      "space tab d" = ["pane::CloseActiveItem" {close_pinned = false;}];
      "space space" = "file_finder::Toggle";
      "space ," = "tab_switcher::Toggle";
      "space /" = "pane::DeploySearch";
      "space :" = "command_palette::Toggle";
      "space f b" = "tab_switcher::Toggle";
      "space f c" = "file_finder::Toggle";
      "space f f" = "file_finder::Toggle";
      "space f F" = "file_finder::Toggle";
      "space f g" = "file_finder::Toggle";
      "space f r" = "projects::OpenRecent";
      "space f R" = "projects::OpenRecent";
      "space g c" = "git_panel::ToggleFocus";
      "space g s" = "git_panel::ToggleFocus";
      "space s a" = null;
      "space s b" = "tab_switcher::Toggle";
      "space s c" = "command_palette::Toggle";
      "space s C" = "command_palette::Toggle";
      "space s d" = "diagnostics::Deploy";
      "space s D" = "diagnostics::Deploy";
      "space s g" = "pane::DeploySearch";
      "space s G" = "pane::DeploySearch";
      "space s h" = "command_palette::Toggle";
      "space s H" = null;
      "space s j" = "workspace::ReopenLastPicker";
      "space s k" = "zed::OpenKeymap";
      "space s l" = "diagnostics::Deploy";
      "space s M" = "editor::Hover";
      "space s o" = "zed::OpenSettingsFile";
      "space s q" = "diagnostics::Deploy";
      "space s R" = "workspace::ReopenLastPicker";
      "space s s" = "outline::Toggle";
      "space s S" = "project_symbols::Toggle";
      "space s w" = "pane::DeploySearch";
      "space s W" = "pane::DeploySearch";
      "space u C" = "theme_selector::Toggle";
      "space u b" = "theme::ToggleMode";
      "space d a" = "task::Spawn";
      "space d b" = "editor::ToggleBreakpoint";
      "space d B" = "editor::EditLogBreakpoint";
      "space d c" = "debugger::Continue";
      "space d C" = "debugger::StepOver";
      "space d g" = null;
      "space d i" = "debugger::StepInto";
      "space d l" = "debugger::Rerun";
      "space d o" = "debugger::StepOut";
      "space d O" = "debugger::StepOver";
      "space d p" = "debugger::Pause";
      "space d r" = "debugger::ToggleSessionPicker";
      "space d s" = "debugger::ToggleSessionPicker";
      "space d t" = "debugger::Stop";
      "space d w" = null;
      "space d u" = "debug_panel::ToggleFocus";
      "space t l" = "task::Rerun";
      "space t o" = null;
      "space t O" = null;
      "space t r" = "task::Spawn";
      "space t s" = null;
      "space t S" = null;
      "space t t" = "task::Spawn";
      "space t T" = "task::Spawn";
      "space t w" = null;
      "space t d" = "debugger::Start";
      "space ;" = "outline_panel::ToggleFocus";
      "space a c" = "agent::ToggleFocus";
      "space a i" = "assistant::InlineAssist";
      "space a a" = "assistant::InlineAssist";
      "space e" = "project_panel::ToggleFocus";
    };
  }
  {
    context = "Pane";
    bindings = {
      "shift-h" = "pane::ActivatePreviousItem";
      "shift-l" = "pane::ActivateNextItem";
      "[ b" = "pane::ActivatePreviousItem";
      "] b" = "pane::ActivateNextItem";
      "space b d" = ["pane::CloseActiveItem" {close_pinned = false;}];
      "space b D" = ["pane::CloseActiveItem" {close_pinned = true;}];
      "space b o" = ["pane::CloseOtherItems" {close_pinned = false;}];
      "space b l" = ["pane::CloseItemsToTheLeft" {close_pinned = false;}];
      "space b p" = "pane::TogglePinTab";
      "space b P" = ["pane::CloseCleanItems" {close_pinned = false;}];
      "space b r" = ["pane::CloseItemsToTheRight" {close_pinned = false;}];
    };
  }
  {
    context = "Editor";
    bindings = {
      "alt-j" = "editor::MoveLineDown";
      "alt-k" = "editor::MoveLineUp";
      "space l f" = "editor::Format";
      "space x d" = "diagnostics::Deploy";
      "space u l" = "editor::ToggleLineNumbers";
      "space u h" = "editor::ToggleInlayHints";
      "space g b" = "git::Blame";
      "space g B" = "git_panel::ToggleFocus";
      "space g f" = "git_panel::ToggleFocus";
      "space g l" = "git_panel::ToggleFocus";
      "space g L" = "git_panel::ToggleFocus";
      "space u i" = "editor::FindAllReferences";
      "space u I" = "outline_panel::ToggleFocus";
      "space w d" = ["pane::CloseActiveItem" {close_pinned = false;}];
      "space c c" = null;
      "g d" = "editor::GoToDefinition";
      "g a" = "editor::ToggleCodeActions";
      "g r" = "editor::FindAllReferences";
      "g R" = "editor::FindAllReferences";
      "g I" = "editor::GoToImplementation";
      "g y" = "editor::GoToTypeDefinition";
      "g D" = "editor::GoToDefinition";
      "g K" = "editor::ShowSignatureHelp";
      "shift-k" = "editor::Hover";
      "ctrl-k" = "editor::Hover";
      "space c r" = "editor::ToggleCodeActions";
      "space o i" = "editor::OrganizeImports";
      "space c C" = null;
      "space c R" = "pane::RevealInProjectPanel";
      "space l n" = "editor::Rename";
      "space l a" = "editor::ToggleCodeActions";
      "] ]" = ["editor::GoToDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "[ [" = ["editor::GoToPreviousDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "alt-n" = ["editor::GoToDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "alt-p" = ["editor::GoToPreviousDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "space s m" = null;
      "space s t" = ["workspace::SendKeystrokes" "o T O D O escape"];
      "space s T" = null;
      "space x t" = null;
      "space x T" = null;
      "[ t" = ["workspace::SendKeystrokes" "? T O D O enter"];
      "] t" = ["workspace::SendKeystrokes" "/ T O D O enter"];
      "space d e" = "debugger::EvaluateSelectedText";
      "Y" = ["workspace::SendKeystrokes" "y $"];
      "Q" = ["workspace::SendKeystrokes" "@ @"];
    };
  }
  {
    context = "Editor && vim_mode == normal";
    bindings = {
      "s" = "vim::PushSneak";
      "ctrl-h" = "workspace::ActivatePaneLeft";
      "ctrl-j" = "workspace::ActivatePaneDown";
      "ctrl-k" = "workspace::ActivatePaneUp";
      "ctrl-l" = "workspace::ActivatePaneRight";
      "ctrl-up" = ["workspace::IncreaseActiveDockSize" {px = 0;}];
      "ctrl-down" = ["workspace::DecreaseActiveDockSize" {px = 0;}];
      "ctrl-left" = ["workspace::DecreaseActiveDockSize" {px = 0;}];
      "ctrl-right" = ["workspace::IncreaseActiveDockSize" {px = 0;}];
      "space b b" = ["workspace::SendKeystrokes" "ctrl-^"];
      "space `" = ["workspace::SendKeystrokes" "ctrl-^"];
      "escape" = "editor::Cancel";
      "space u r" = "editor::Cancel";
      "space K" = "editor::Hover";
      "g c o" = ["workspace::SendKeystrokes" "j g c c k"];
      "g c O" = ["workspace::SendKeystrokes" "k g c c j"];
      "space f n" = "workspace::NewFile";
      "space x l" = "diagnostics::Deploy";
      "space x q" = "diagnostics::Deploy";
      "[ q" = ["editor::GoToPreviousDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "] q" = ["editor::GoToDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "] d" = ["editor::GoToDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "[ d" = ["editor::GoToPreviousDiagnostic" {severity = {min = "hint"; max = "error";};}];
      "] e" = ["editor::GoToDiagnostic" {severity = {min = "error"; max = "error";};}];
      "[ e" = ["editor::GoToPreviousDiagnostic" {severity = {min = "error"; max = "error";};}];
      "] w" = ["editor::GoToDiagnostic" {severity = {min = "warning"; max = "warning";};}];
      "[ w" = ["editor::GoToPreviousDiagnostic" {severity = {min = "warning"; max = "warning";};}];
      "space u B" = null;
      "space u s" = null;
      "space u w" = "editor::ToggleSoftWrap";
      "space u L" = null;
      "space u d" = "diagnostics::Deploy";
      "space u c" = null;
      "space u T" = null;
      "space -" = "pane::SplitDown";
      "space |" = "pane::SplitRight";
    };
  }
  {
    context = "Editor && vim_mode == visual";
    bindings = {
      "space l f" = "editor::Format";
      "space c r" = "editor::ToggleCodeActions";
      "space c c" = null;
      "space s w" = "pane::DeploySearch";
      "space s W" = "pane::DeploySearch";
      "space d e" = "debugger::EvaluateSelectedText";
      "space a c" = "agent::ToggleFocus";
      "space a i" = "assistant::InlineAssist";
      "space a a" = "assistant::InlineAssist";
    };
  }
  {
    context = "Editor && vim_mode == insert";
    bindings = {
      "alt-j" = "editor::MoveLineDown";
      "alt-k" = "editor::MoveLineUp";
      "ctrl-k" = "editor::ShowSignatureHelp";
      "ctrl-u" = ["workspace::SendKeystrokes" "ctrl-g u ctrl-u"];
      "ctrl-w" = ["workspace::SendKeystrokes" "ctrl-g u ctrl-w"];
    };
  }

  {
    context= "VimControl && !menu";
    unbind= {
      "shift-h"= "vim::WindowTop";
    };
  }
  {
    context= "VimControl && !menu";
    unbind= {
      "shift-l"= "vim::WindowBottom";
    };
  }
]
