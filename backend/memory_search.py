from backend.memory import load_memory


def get_relevant_memory(message: str):
    memory = load_memory()
    message = message.lower()

    result = {}

    rules = {
        "projects": [
            "پروژه",
            "بازی",
            "اپ",
            "برنامه"
        ],
        "likes": [
            "دوست دارم",
            "علاقه",
            "غذا",
            "آهنگ"
        ],
        "facts": [
            "اسم",
            "کی",
            "کجا",
            "چند"
        ]
    }

    for category, keywords in rules.items():
        if any(word in message for word in keywords):
            if category in memory:
                result[category] = memory[category]

    return result