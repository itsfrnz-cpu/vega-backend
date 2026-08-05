from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel

from dotenv import load_dotenv
from openai import OpenAI

from memory.timeline import update_chat
from memory.ai import should_remember
from memory.search import get_relevant_memory
from memory.manager import add_memory

from pathlib import Path

import os
import json
import openai


print("OPENAI VERSION:", openai.__version__)


# =========================
# Config
# =========================

BASE_DIR = Path(__file__).parent
ROOT_DIR = BASE_DIR.parent


PROMPT_PATH = ROOT_DIR / "prompts" / "vega_system.txt"


VEGA_SYSTEM_PROMPT = PROMPT_PATH.read_text(
    encoding="utf-8"
)


print(
    "VEGA PROMPT LOADED:",
    len(VEGA_SYSTEM_PROMPT)
)


load_dotenv(
    BASE_DIR / ".env"
)


avalai_key = os.getenv(
    "AVALAI_API_KEY"
)

avalai_base = os.getenv(
    "AVALAI_BASE_URL"
)


print(
    "API EXISTS:",
    avalai_key is not None
)

print(
    "BASE:",
    avalai_base
)



client = OpenAI(
    api_key=avalai_key,
    base_url=avalai_base
)



# =========================
# App
# =========================

app = FastAPI(
    title="Vega Backend",
    version="0.2"
)



# =========================
# Models
# =========================

class ChatRequest(BaseModel):
    message: str



# =========================
# Routes
# =========================

@app.get("/")
def root():

    return {
        "name": "Vega",
        "status": "online"
    }



@app.post("/chat")
def chat(
    request: ChatRequest
):

    try:

        print("\n🔥 CHAT REQUEST")
        print(
            "MESSAGE:",
            request.message
        )


        # -------------------------
        # Memory retrieval
        # -------------------------

        relevant_memory = get_relevant_memory(
            request.message
        )


        print(
            "RELEVANT MEMORY:",
            relevant_memory
        )


        memory_context = ""

        if relevant_memory:

            memory_context = json.dumps(
                relevant_memory,
                ensure_ascii=False,
                indent=2
            )



        # -------------------------
        # Memory learning
        # -------------------------

        memory_result = should_remember(
            client,
            request.message
        )


        print(
            "MEMORY RESULT:",
            memory_result
        )


        if memory_result.get("remember"):


            operations = memory_result.get(
                "operations",
                []
            )


            for operation in operations:


                if operation["type"] == "add_preference":


                    add_memory(
                        operation["section"],
                        operation["value"]
                    )



        print(
            "MEMORY SAVED"
        )



        # -------------------------
        # Timeline
        # -------------------------

        update_chat()



        # -------------------------
        # AI Response
        # -------------------------

        response = client.chat.completions.create(

            model="gpt-4o-mini",

            messages=[

                {
                    "role": "system",

                    "content": f"""
{VEGA_SYSTEM_PROMPT}


Relevant user memory:

{memory_context}


Use memory only when helpful.
Do not mention memory.
"""
                },


                {
                    "role": "user",

                    "content": request.message
                }

            ]

        )



        answer = response.choices[0].message.content



        print(
            "ANSWER:",
            answer
        )



        return {

            "response": answer

        }



    except Exception as e:


        print(
            "ERROR:",
            repr(e)
        )


        return JSONResponse(

            status_code=500,

            content={

                "error": str(e)

            }

        )



# =========================
# Local Run
# =========================

if __name__ == "__main__":

    import uvicorn


    uvicorn.run(

        app,

        host="127.0.0.1",

        port=8000

    )