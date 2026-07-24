import subprocess

text = "سلام فرناز"

p = subprocess.Popen(
    [
        "piper.exe",
        "-m",
        r"C:\Users\V\Documents\vega\models\piper\fa_IR-mana-medium.onnx",
        "-f",
        "python_test.wav"
    ],
    stdin=subprocess.PIPE
)

p.communicate(text.encode("utf-8"))