#!/usr/bin/env python3
"""Validate the repository YAML files used by Terraform."""

from pathlib import Path

import yaml


CONFIG_DIR = Path(__file__).parents[1] / "repo-configs"
ALLOWED_FIELDS = {
    "description",
    "private",
    "visibility",
    "homepage",
    "auto_init",
    "topics",
}


def fail(path: Path, message: str) -> None:
    raise SystemExit(f"{path}: {message}")


def validate(path: Path) -> None:
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
    except yaml.YAMLError as error:
        fail(path, f"invalid YAML: {error}")

    if not isinstance(data, dict):
        fail(path, "must contain a YAML object")

    unknown = set(data) - ALLOWED_FIELDS
    if unknown:
        fail(path, f"unknown field(s): {', '.join(sorted(unknown))}")

    string_fields = ("description", "homepage")
    for field in string_fields:
        if field in data and not isinstance(data[field], str):
            fail(path, f"{field} must be a string")

    for field in ("private", "auto_init"):
        if field in data and not isinstance(data[field], bool):
            fail(path, f"{field} must be true or false")

    if "visibility" in data and data["visibility"] not in {"public", "private", "internal"}:
        fail(path, "visibility must be public, private, or internal")

    if "topics" in data:
        if not isinstance(data["topics"], list) or not all(
            isinstance(topic, str) for topic in data["topics"]
        ):
            fail(path, "topics must be a list of strings")

    if "private" in data and "visibility" in data:
        expected = "private" if data["private"] else "public"
        if data["visibility"] != expected:
            fail(path, "private and visibility must describe the same visibility")


def main() -> None:
    paths = sorted(CONFIG_DIR.glob("*.yaml"))
    if not paths:
        raise SystemExit(f"No YAML files found in {CONFIG_DIR}")

    for path in paths:
        validate(path)
        print(f"validated {path}")


if __name__ == "__main__":
    main()
