from datetime import datetime
import json
from pathlib import Path


TIMELINE_FILE = Path("timeline.json")


def load_timeline():
    if not TIMELINE_FILE.exists():
        return {
            "first_chat": None,
            "last_chat": None,
            "chat_count": 0
        }

    return json.loads(
        TIMELINE_FILE.read_text(
            encoding="utf-8"
        )
    )


def update_chat():

    timeline = load_timeline()

    now = datetime.now().isoformat()

    if timeline["first_chat"] is None:
        timeline["first_chat"] = now

    timeline["last_chat"] = now

    timeline["chat_count"] += 1


    TIMELINE_FILE.write_text(
        json.dumps(
            timeline,
            ensure_ascii=False,
            indent=4
        ),
        encoding="utf-8"
    )

    print("TIMELINE:", timeline)