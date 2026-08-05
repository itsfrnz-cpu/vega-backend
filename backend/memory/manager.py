import json
import os
from pathlib import Path

MEMORY_FILE = Path(__file__).parent / "data" / "memory.json"


def load_memory():

    if not MEMORY_FILE.exists():
        return {
            "user": {},
            "likes": [],
            "projects": [],
            "facts": [],
            "notes": []
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

    if category == "likes":
        target = memory["preferences"]["likes"]

    elif category in memory["preferences"]:
        target = memory["preferences"][category]

    elif category == "dislikes":
        target = memory["preferences"]["dislikes"]

    elif category == "projects":
        target = memory["projects"]

    elif category == "facts":
        target = memory["facts"]

    elif category == "goals":
        target = memory["goals"]

    else:
        memory.setdefault(category, [])
        target = memory[category]

    if value not in target:
        target.append(value)

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