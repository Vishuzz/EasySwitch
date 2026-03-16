from flask import Flask, request, send_file
import os
import subprocess

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
OUTPUT_FOLDER = "outputs"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)


@app.route("/convert", methods=["POST"])
def convert_file():
    if "file" not in request.files:
        return {"error": "No file uploaded"}, 400

    file = request.files["file"]

    input_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(input_path)

    filename_without_ext = os.path.splitext(file.filename)[0]

    subprocess.run([
        "soffice",
        "--headless",
        "--convert-to",
        "pdf",
        input_path,
        "--outdir",
        OUTPUT_FOLDER
    ])

    output_path = os.path.join(OUTPUT_FOLDER, filename_without_ext + ".pdf")

    if not os.path.exists(output_path):
        return {"error": "Conversion failed"}, 500

    return send_file(output_path, as_attachment=True)


if __name__ == "__main__":
    app.run(debug=True)