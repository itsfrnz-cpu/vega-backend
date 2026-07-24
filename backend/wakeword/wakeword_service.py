import sounddevice as sd
import numpy as np
from scipy.signal import resample
from openwakeword.model import Model

print("⭐ Vega wakeword engine loaded")

model = Model(
    wakeword_models=["hey_jarvis"],
    inference_framework="onnx"
)

print("🎙️ Listening for: Hey Jarvis")

while True:
    # ضبط صدا با 48kHz از میکروفون
    audio = sd.rec(
        3840,
        samplerate=48000,
        channels=1,
        dtype='int16',
        device=9
    )
    sd.wait()

    # تبدیل به float و تقویت صدا
    audio = audio.flatten().astype(np.float32) * 200

    # تبدیل 48kHz به 16kHz
    audio_16k = resample(audio, 1280).astype(np.int16)

    # پیش‌بینی wake word
    prediction = model.predict(audio_16k)
    score = prediction["hey_jarvis"]

    print(f"Score: {score:.3f}")

    if score > 0.3:  # آستانه را پایین آوردیم برای حساسیت بیشتر
        print("⭐ Wake word detected!")