from fastapi.responses import JSONResponse
from fastapi import FastAPI
from timeline import update_chat
from dotenv import load_dotenv
from pydantic import BaseModel
from memory_ai import should_remember
from openai import OpenAI
def speak(text):
    return "no-audio"
import os
import openai
print(openai.__version__)
import json
from memory_search import get_relevant_memory
from memory import load_profile, add_memory
from pathlib import Path

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "vega_system.txt"

VEGA_SYSTEM_PROMPT = PROMPT_PATH.read_text(
    encoding="utf-8"
)
print("VEGA PROMPT LOADED:", len(VEGA_SYSTEM_PROMPT))

load_dotenv(Path(__file__).parent / ".env")
print("ENV PATH:", Path(__file__).parent / ".env")
print("ENV CONTENT:")
print(Path(__file__).parent.joinpath(".env").read_text())
avalai_key = os.getenv("AVALAI_API_KEY")
avalai_base = os.getenv("AVALAI_BASE_URL")

app = FastAPI()

print("API EXISTS:", avalai_key is not None)
print("BASE:", avalai_base)

client = OpenAI(
    api_key=avalai_key,
    base_url=avalai_base
)

print("CHECK VEGA:", "Vega" in VEGA_SYSTEM_PROMPT)


@app.get("/")
def root():
    return {
        "name": "Vega",
        "status": "online",
        "api_key_loaded": avalai_key is not None
    }

class ChatRequest(BaseModel):
    message: str

@app.post("/chat")
def chat(request: ChatRequest):

    print("🔥🔥🔥 CHAT FUNCTION ENTERED")
    print("MESSAGE =", request.message)

    relevant_memory = get_relevant_memory(
        request.message
    )

    print("RELEVANT MEMORY:")
    print(relevant_memory)

    memory_context = ""

    if relevant_memory:
        memory_context = json.dumps(
            relevant_memory,
            ensure_ascii=False,
            indent=2
        )

    memory_result = should_remember(
        client,
        request.message
    )

    print("MEMORY RESULT:", memory_result)

    if memory_result.get("remember"):
        add_memory(
            memory_result["category"],
            memory_result["value"]
        )

    print("SAVED MEMORY:", memory_result)

    try:
        update_chat()

        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {
                    "role": "system",
                    "content": f"""
{VEGA_SYSTEM_PROMPT}

Relevant user memory:

{memory_context}

Use this memory only when helpful.
Do not mention memory.
"""
                },
                {
                    "role": "user",
                    "content": request.message
                }
            ],
        )

        answer = response.choices[0].message.content

        print("ANSWER:", answer)

        return {
            "response": answer
        }

    except Exception as e:
        print("ERROR:")
        print(repr(e))

        return JSONResponse(
            content={
                "error": str(e)
            },
            media_type="application/json; charset=utf-8"
        )
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app,
        host="127.0.0.1",
        port=8000
    )