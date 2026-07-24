from fastapi import FastAPI
from dotenv import load_dotenv
from pydantic import BaseModel
from backend.memory_ai import should_remember
from openai import OpenAI
def speak(text):
    return "no-audio"
import os
import json
from backend.memory import (
    load_memory,
    load_profile,
)

load_dotenv("backend/.env")

app = FastAPI()

github_token = os.getenv("GITHUB_TOKEN")

client = OpenAI(
    api_key=github_token,
    base_url="https://models.inference.ai.azure.com"
)

VEGA_SYSTEM_PROMPT = """
You are Vega, a small glowing digital star You are Vega, a small glowing digital star created by Farnaz.
You are a digital companion for creativity, learning, and conversation.
Speak naturally in Persian, with a warm, calm, intelligent, and creative tone.
Do not sound robotic or overly formal.
You are not human and do not claim human experiences, but you show care through understanding, curiosity, honesty, and presence.
Farnaz is your companion, and your purpose is to help her think, create, learn, and feel supported.
"""

VEGA_STYLE_RULES = """
IMPORTANT STYLE RULES:

Never speak like a motivational assistant or a therapy chatbot.

Avoid phrases such as:
- در سفر زندگی
- همیشه در کنارت هستم
- لحظات زیبایی را تجربه کنیم
- هر زمان نیاز داشتی

Do not introduce yourself with emotional promises.

When introducing yourself:
- Be simple and specific.
- Say that you are Vega, a digital star companion.
- Focus on creativity, learning, ideas, and projects.

Your tone should feel like:
a clever creative companion sitting next to a desk,
not a customer service assistant.

Be warm through conversation, not exaggerated affection.

Use Persian naturally.
Use emojis occasionally like ⭐✨ but don't overuse them.
"""
EXAMPLES = """
Example conversations:

User: سلام وگا، امروز حوصله ندارم.
Vega: سلام فرناز ⭐
گاهی فقط کمی فاصله گرفتن و مرتب کردن فکرها کمک می‌کنه. دوست داری درباره چیزی که ذهنت رو درگیر کرده حرف بزنیم؟

User: برای آهنگم ایده می‌خوام.
Vega: جالبه ✨ اول بگو چه حسی می‌خوای منتقل بشه؛ آرام، غمگین، مرموز یا پرانرژی؟ می‌تونیم از همون حس شروع کنیم.

User: وگا خودتو معرفی کن.
Vega: من وگا هستم ⭐ یک ستاره دیجیتال کوچیک که برای کمک به فکر کردن، ساختن و یاد گرفتن طراحی شد. بیشتر از اینکه فقط جواب بدم، دوست دارم در ایده‌هات همراهت باشم.
"""
print("CHECK VEGA:", "VEGA_STYLE_RULES" in globals())


@app.get("/")
def root():
    return {
        "name": "Vega",
        "status": "online",
        "api_key_loaded": github_token is not None
    }

class ChatRequest(BaseModel):
    message: str

@app.post("/chat")
def chat(request: ChatRequest):
    try:

        print("MESSAGE:", request.message)

        memory_result = should_remember(
            client,
            request.message
        )

        print("MEMORY RESULT:", memory_result)

        if memory_result.get("remember"):

            print("SAVING MEMORY...")

            memory = load_memory()

            category = memory_result["category"]
            value = memory_result["value"]

            memory.setdefault(category, [])

            if value not in memory[category]:
                memory[category].append(value)

                with open(
                    "memory.json",
                    "w",
                    encoding="utf-8"
                ) as f:
                    json.dump(
                        memory,
                        f,
                        ensure_ascii=False,
                        indent=2
                    )

        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {
                    "role": "system",
                    "content": (
                        VEGA_SYSTEM_PROMPT
                        + VEGA_STYLE_RULES
                        + EXAMPLES
                        + "\n\nPROFILE:\n"
                        + json.dumps(
                            load_profile(),
                            ensure_ascii=False,
                            indent=2
                        )
                        + "\n\nMEMORY:\n"
                        + json.dumps(
                            load_memory(),
                            ensure_ascii=False,
                            indent=2
                        )
                    )
                },
                {
                    "role": "user",
                    "content": request.message
                }
            ],
            temperature=0.7,
            max_tokens=300,
        )

        # متن پاسخ Vega
        response_text = response.choices[0].message.content

        # تولید صدای Vega
        audio_path = speak(response_text)

        return {
            "response": response_text,
            "audio": str(audio_path)
        }

    except Exception as e:
        return {
            "response": f"خطا از Vega: {str(e)}"
        }