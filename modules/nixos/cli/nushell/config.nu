$env.config = {
  show_banner: false
  edit_mode: 'vi'
  buffer_editor: "nvim"
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
