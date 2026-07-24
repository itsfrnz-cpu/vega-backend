import json
import os

MEMORY_FILE = "backend/memory.json"


def load_memory():
    if not os.path.exists(MEMORY_FILE):
        return {}

    with open(MEMORY_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def save_memory(memory):
    with open(MEMORY_FILE, "w", encoding="utf-8") as f:
        json.dump(
            memory,
            f,
            ensure_ascii=False,
            indent=4
        )


def add_memory(key, value):
    memory = load_memory()

    if key not in memory:
        memory[key] = []

    memory[key].append(value)

    save_memory(memory)

    return memory