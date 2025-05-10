$env.config = {
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
