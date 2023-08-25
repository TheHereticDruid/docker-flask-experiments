FROM python:3.11.4-slim-bullseye AS builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y build-essential
RUN python3 -m venv /.execVenv
ENV PATH=/.execVenv/bin:$PATH
COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt

FROM python:3.11.4-slim-bullseye
COPY --from=builder /.execVenv/ /.execVenv/
ENV PATH=/.execVenv/bin:$PATH
ADD pear_tree_test.py /
COPY templates/ /templates/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y wget
RUN wget https://huggingface.co/CRD716/ggml-vicuna-1.1-quantized/resolve/main/ggml-vicuna-7b-1.1-q4_0.bin -O /llm_model.bin
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
CMD ["flask", "--app", "pear_tree_test", "run"]