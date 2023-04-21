FROM arm32v7/python:3.8-slim-buster

RUN mkdir /app

COPY ./*.txt ./*.py /app/

RUN sed -i 's#http://deb.debian.org#http://mirrors.aliyun.com/#g' /etc/apt/sources.list
RUN apt-get --allow-releaseinfo-change update && apt install libgl1-mesa-glx libglib2.0-0 build-essential zlib1g-dev libjpeg-dev g++ libssl-dev curl -y
RUN CMAKE_VERSION="$(curl -Ls "https://api.github.com/repos/Kitware/CMake/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')" \
    && cd /app && curl -Ls "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz" -o cmake.tar.gz \
    && mkdir cmake && tar -zxvf cmake.tar.gz --strip-components 1 -C /app/cmake && cd cmake && ./bootstrap && make -j4 && make install
RUN python3 -m pip install --upgrade pip -i https://pypi.douban.com/simple/
RUN pip3 install --no-cache-dir -r /app/requirements.txt --extra-index-url https://pypi.douban.com/simple/
RUN cd /app && curl -Ls "https://raw.githubusercontent.com/nknytk/built-onnxruntime-for-raspberrypi-linux/master/wheels/buster/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl" -o onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl
RUN pip3 install /app/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl -v -i https://pypi.douban.com/simple/
RUN pip3 install --no-build-isolation scikit-build -v -i https://pypi.douban.com/simple/
RUN pip3 install --no-build-isolation --no-deps opencv-python-headless==3.4.18.65 -v -i https://pypi.douban.com/simple/
RUN pip3 install --no-build-isolation --no-deps ddddocr==1.4.7 --no-deps --no-build-isolation -v -i https://pypi.douban.com/simple/
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /root/.cache/* \
    && rm -rf /app/cmake.tar.gz && rm -rf /app/cmake \
    && rm -rf /app/onnxruntime-1.6.0-cp38-cp38-linux_armv7l.whl

WORKDIR /app

CMD ["python3", "ocr_server.py", "--port", "9898", "--ocr", "--det"]
