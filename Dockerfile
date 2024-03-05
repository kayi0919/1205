# 使用 Python 3.8 作為基礎映像
FROM python:3.8

RUN apt-get install -y libssl-dev
RUN pip install robotframework-requests


# 升級 pip 並安裝相關套件
RUN pip install --upgrade pip && \
    pip install robotframework robotframework-seleniumlibrary rpaframework robotframework-requests

# 安裝 Chrome 和驅動程序所需的相關套件
RUN apt-get update && apt-get install -y wget gnupg curl unzip libssl-dev

# 下載並設定 Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable

# 將本地的 chromedriver 檔案複製到 Docker 映像中
COPY chromedriver /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

RUN apt-get update && apt-get install -y fonts-arphic-uming fonts-arphic-ukai
ENV LANG="zh_TW.UTF-8"
ENV LC_ALL="zh_TW.UTF-8"

# 設定瀏覽器的環境變數（這裡示範設定語言環境）
ENV LANG="zh-TW.UTF-8"


# 設定工作目錄
WORKDIR /robot

# 定義容器啟動後的默認命令
CMD ["robot"]
