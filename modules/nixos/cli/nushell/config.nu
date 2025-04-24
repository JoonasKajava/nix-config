$env.config = {
  edit_mode: 'vi'
  cursor_shape: {
    vi_insert: line
    vi_normal: block
  }
  completions: {
    external: {
      enable: true
      completer: $carapace_completer
    }
  }
}
