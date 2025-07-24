let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
# For now this does not work
#source ~/.cache/carapace/init.nu

$env.config = {
    buffer_editor: "code"
    show_banner: false
    completions: {
        external: {
            enable: true
            completer: $carapace_completer
        }
    }
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
