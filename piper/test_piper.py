import subprocess

text = "سلام فرناز. خوشحالم که اینجا هستم."

cmd = [
    "piper.exe",
    "-m",
    r"C:\Users\V\Documents\vega\models\piper\fa_IR-mana-medium.onnx",
    "--length_scale",
    "1.25",
   "--noise_scale",
"0.4",
"--noise_w",
"0.5",
    "-f",
    "vega_slow_python.wav"
]

subprocess.run(
    cmd,
    input=text.encode("utf-8")
)

print("done")