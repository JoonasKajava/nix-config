
$env.MANPAGER = 'nvim +Man!'

# carapace's fish bridge can't discover fish completions (it runs `fish --no-config`,
# where $fish_complete_path is empty), so fall back to asking fish directly.
let fish_completer = {|spans|
  fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
  | lines
  | each {|line| $line | split row "\t" | {value: $in.0, description: ($in.1? | default "")} }
}

let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let external_completer = {|spans|
  let expanded_alias = (scope aliases | where name == $spans.0 | get -o 0.expansion)
  let spans = if $expanded_alias != null {
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else { $spans }

  let result = (do $carapace_completer $spans)
  if ($result | is-empty) { do $fish_completer $spans } else { $result }
}

$env.config = {
  completions: {
    external: {
      enable: true
      completer: $external_completer
    }
  }
  show_banner: false
  edit_mode: 'vi'
  buffer_editor: "nvim"
  cursor_shape: {
    vi_insert: line
    vi_normal: block
  }
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}
