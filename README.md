# **使用ddddocr的最简api搭建项目，适用arm32位机器docker构建，如armv7，arm7l**
source: [ocr_api_server](https://github.com/sml2h3/ocr_api_server)
# 运行方式
## docker运行方式
```shell
git clone https://github.com/jeck5001/ocr_api_server.git
# docker怎么安装？百度吧

cd ocr_api_server

# 修改entrypoint.sh中的参数，具体参数往上翻，默认9898端口，同时开启ocr模块以及目标检测模块

# 编译镜像
docker buildx build --platform=linux/arm/v7 -t ocr_api_server-armv7l:v1.0 .

# 运行镜像
docker run -p 9898:9898 -d ocr_api_server-armv7l:v1.0

```

# 接口

**具体请看test_api.py文件**

```python
# 1、测试是否启动成功，可以通过直接GET访问http://{host}:{port}/ping来测试，如果返回pong则启动成功

# 2、OCR/目标检测请求接口格式：

# http://{host}:{port}/{opt}/{img_type}/{ret_type}
# opt：操作类型 ocr=OCR det=目标检测 slide=滑块（match和compare两种算法，默认为compare)
# img_type: 数据类型 file=文件上传方式 b64=base64(imgbyte)方式 默认为file方式
# ret_type: 返回类型 json=返回json（识别出错会在msg里返回错误信息） text=返回文本格式（识别出错时回直接返回空文本）

# 例子：

# OCR请求
# resp = requests.post("http://{host}:{port}/ocr/file", files={'image': image_bytes})
# resp = requests.post("http://{host}:{port}/ocr/b64/text", data=base64.b64encode(file).decode())

# 目标检测请求
# resp = requests.post("http://{host}:{port}/det/file", files={'image': image_bytes})
# resp = requests.post("http://{host}:{port}/det/b64/json", data=base64.b64encode(file).decode())

# 滑块识别请求
# resp = requests.post("http://{host}:{port}/slide/match/file", files={'target_img': target_bytes, 'bg_img': bg_bytes})
# jsonstr = json.dumps({'target_img': target_b64str, 'bg_img': bg_b64str})
# resp = requests.post("http://{host}:{port}/slide/compare/b64", files=base64.b64encode(jsonstr.encode()).decode())
```
