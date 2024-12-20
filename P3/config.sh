#!/bin/bash

script_path="./scripts"

expected_filenames=("router-1" "router-2" "router-3" "router-4" "host-1" "host-2" "host-3")

running_containers=$(docker ps -q)

if [[ -z "$running_containers" ]]; then
  echo "🚫 No running containers"
  exit 1
fi

apply_config() {
  local container_id="$1"
  local config_filename="$2"

  config_file="$script_path/$config_filename"
  if [[ ! -f "$config_file" ]]; then
    echo "❗ Configuration script $config_file does not exist for $config_filename"
    return
  fi

  echo "📋 Copying $config_file to container $container_id (hostname: $config_filename)..."
  docker cp "$config_file" "$container_id:/"

  echo "⚙️ Executing configuration script inside container $container_id (hostname: $config_filename)..."
  docker exec "$container_id" bash "/$config_filename"

  if [[ $? -eq 0 ]]; then
    echo "✅ Configuration successfully applied on $container_id (hostname: $config_filename)."
  else
    echo "❌ Error applying configuration on $container_id (hostname: $config_filename)."
  fi
}

for container_id in $running_containers; do
  hostname=$(docker exec "$container_id" hostname)

  config_filename=$(echo "$hostname" | sed 's/_hboissel//')

  if [[ " ${expected_filenames[@]} " =~ " ${config_filename} " ]]; then
    apply_config "$container_id" "$config_filename".sh
  else
    echo "⏭️ Skipping container $container_id with hostname $hostname (config: $config_filename)"
  fi
done
