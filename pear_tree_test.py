from flask import Flask, render_template, request
from llama_cpp import Llama

llm = Llama(model_path="llm_model.bin")

app = Flask(__name__)

@app.route("/")
def initial():
    return render_template("request.html")

@app.route("/response", methods=["POST"])
def response_call():
    return llm(request.form["query_text"], max_tokens=1024, temperature=0.5, top_p=0.9, echo=False, stop=["#"])["choices"][0]["text"].strip()