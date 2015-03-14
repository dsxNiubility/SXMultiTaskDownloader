# SXMultiTaskDownloader
多任务异步下载器

![image](https://github.com/dsxNiubility/多线程异步下载器/raw/master/screenshots/DownLoader.gif)

* 使用了自写的下载工具单例类
* 可以实现`多个`文件同时`异步`下载，主界面拖拽`完全无卡顿`
* 每次点击下载时都会先判断本地文件是否存在，是否下载一半，并且自动从`断点续传`
* 终止程序后再次运行依旧可以实现断点续传，因为反正都是要判断本地文件的
