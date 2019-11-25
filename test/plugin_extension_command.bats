#!/usr/bin/env bats

load test_helpers

setup() {
  setup_asdf_dir
  install_dummy_plugin
}

teardown() {
  clean_asdf_dir
}

@test "asdf can execute plugin bin commands" {
  plugin_path="$(get_plugin_path dummy)"

  # this plugin defines a new `asdf dummy foo` command
  cat <<'EOF' > "$plugin_path/bin/foo"
#!/usr/bin/env bash
echo this is an executable $*
EOF
  chmod +x "$plugin_path/bin/foo"

  expected="this is an executable bar"
  
  run asdf dummy foo bar
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

@test "asdf can source plugin bin scripts" {
  plugin_path="$(get_plugin_path dummy)"

  # this plugin defines a new `asdf dummy foo` command
  echo 'echo sourced script has asdf utils $(get_plugin_path dummy) $*' > "$plugin_path/bin/foo"

  expected="sourced script has asdf utils $plugin_path bar"
  
  run asdf dummy foo bar
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}
