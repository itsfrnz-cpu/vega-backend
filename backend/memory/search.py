from .manager import load_memory


def get_relevant_memory(message: str):

    memory = load_memory()
    message = message.lower()

    result = {}

    # Music
    music_words = [
        "خواننده",
        "آهنگ",
        "موسیقی",
        "موزیک",
        "گوش میدم",
        "دوست دارم"
    ]

    if any(word in message for word in music_words):

        favorite_music = memory.get(
            "preferences",
            {}
        ).get(
            "favorite_music",
            []
        )

        if favorite_music:
            result["favorite_music"] = favorite_music


    # Likes
    like_words = [
        "علاقه",
        "دوست دارم",
        "عاشق"
    ]

    if any(word in message for word in like_words):

        likes = memory.get(
            "preferences",
            {}
        ).get(
            "likes",
            []
        )

        if likes:
            result["likes"] = likes


    # Projects
    project_words = [
        "پروژه",
        "می‌سازم",
        "ساختم"
    ]

    if any(word in message for word in project_words):

        projects = memory.get(
            "projects",
            []
        )

        if projects:
            result["projects"] = projects


    # Profile
    profile_words = [
        "اسمم",
        "نامم",
        "کی هستم"
    ]

    if any(word in message for word in profile_words):

        profile = memory.get(
            "profile",
            {}
        )

        if profile:
            result["profile"] = profile


    return result