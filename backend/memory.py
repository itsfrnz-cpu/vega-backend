import json
import os

MEMORY_FILE = "memory.json"


def load_memory():
    if not os.path.exists(MEMORY_FILE):
        return {
            "user": {},
            "likes": [],
            "projects": [],
            "facts": []
        }

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


def add_memory(category, value):
    memory = load_memory()

    if category not in memory:
        memory[category] = []

    if value not in memory[category]:
        memory[category].append(value)

    save_memory(memory)

def load_profile():
    try:
        with open("profile.json", "r", encoding="utf-8") as f:
            return json.load(f)
    except:
        return {}

def remember_if_needed(text):
    text = text.strip()
    memory = load_memory()

    rules = {
        "likes": [
            "دوست دارم",
            "علاقه دارم",
            "عاشق"
        ],
        "projects": [
            "دارم میسازم",
            "پروژه",
            "دارم روی"
        ],
        "facts": [
            "اسمم",
            "من اهل",
            "شغلم",
            "دانشجو"
        ]
    }

    for category, keywords in rules.items():
        for keyword in keywords:
            if keyword in text:
                memory.setdefault(category, [])
                if text not in memory[category]:
                    memory[category].append(text)

                with open("memory.json", "w", encoding="utf-8") as f:
                    json.dump(
                        memory,
                        f,
                        ensure_ascii=False,
                        indent=2
                    )
                return