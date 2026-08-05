from memory.manager import load_memory


def get_relevant_memory(message: str):

    memory = load_memory()
    message = message.lower()

    result = {}

    rules = {
        "projects": [
            "پروژه",
            "بازی",
            "اپ",
            "برنامه",
            "می‌سازم"
        ],

        "likes": [
            "دوست دارم",
            "علاقه",
            "غذا",
            "آهنگ",
            "موسیقی"
        ],

        "facts": [
            "اسم",
            "اهل",
            "شغل",
            "دانشگاه"
        ]
    }


    for category, keywords in rules.items():

        if any(word in message for word in keywords):

            if category in memory:
                result[category] = memory[category]


    return result