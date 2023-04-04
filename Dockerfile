FROM arm32v7/python:3.8-slim-buster

RUN mkdir /app

COPY ./*.txt ./*.py ./*.sh /app/

RUN sed -i 's#http://deb.debian.org#http://mirrors.aliyun.com/#g' /etc/apt/sources.list
RUN apt-get --allow-releaseinfo-change update && apt install wget build-essential zlib1g-dev libjpeg-dev libssl-dev -y
RUN cd /app && wget -O cmake-3.24.3.tar.gz --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3.tar.gz\
    && tar -zxvf cmake-3.24.3.tar.gz && cd cmake-3.24.3 && ./bootstrap && make -j4 && make install
RUN python3 -m pip install --upgrade pip -i https://pypi.douban.com/simple/
RUN pip3 install --no-cache-dir -r requirements.txt --extra-index-url https://pypi.douban.com/simple/
RUN cd /app && wget -O onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl --no-check-certificate https://github.com/nknytk/built-onnxruntime-for-raspberrypi-linux/blob/master/wheels/buster/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl
RUN pip3 install /app/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl -v -i https://pypi.douban.com/simple/
RUN pip3 install ddddocr==1.4.7 --no-deps --no-build-isolation -v -i https://pypi.douban.com/simple/
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /root/.cache/* \
    && rm -rf /app/cmake-3.24.3.tar.gz && rm -rf /app/cmake-3.24.3 \
    && rm -rf /app/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl

WORKDIR /app

CMD ["python3", "ocr_server.py", "--port", "9898", "--ocr", "--det"]
