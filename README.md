# Weibo
practice of swift 5.5


* 原教学视频地址 [新浪微博项目_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1xJ411T7Vf?spm_id_from=333.999.0.0)
* 视频是2015年的某培训机构的教学视频, 当时应该是在用swift3, 现在swift已经到5.5了
* 虽然Weibo这个项目因为和培训机构挂钩常常为人所不齿, 但耐心跟着视频学还是能有所收获
* 视频中的相关素材需要自己搞

# 一、简介
该项目主要是通过微博开发者平台开放的接口, 进行请求，做一些界面的展示和交互
* [微博API](https://open.weibo.com/wiki/API)
* [yihang107/Weibo: practice of swift 5.5 (github.com)](https://github.com/yihang107/Weibo)
## 1.1 技术点
### 1.1.1 swift入门
* 快速上手swift，课程里教的一些写法可能已经过时或者弃用, 比如
    * 方法不再传`"方法名"`, 而是使用`#selector(self.方法名)`, 并且方法需要标记为`@objc`
    * KVC,如果需要使用KVC, 需要添加`@objc`标柱成员, 或者在类前使用`@objcMembers`
    * NS开头的类重写为不要NS开头的类
* 除了查阅其他资料确定新的写法, 也可以按照旧的写法写上, XCode会进行响应提示
### 1.1.2 MVVM项目结构
在MVC的基础上, 引入ViewModel, 负责View和Model之间的数据交互, 原先由控制器负责的模型数据加工的部分会转移给ViewModel处理, 从而让控制器的代码不会过于臃肿
### 1.1.3 数据持久化
* Bundle
* 沙盒
    * 归档解档 
    * 数据库sqlite3 
    * NSUserDefault

### 1.1.4 通信
* Delegate 多个方法
* NSNotification 越过多个层级
* KVO 
* 闭包

### 1.1.5 网络请求 微博接口的调用 [API - 微博API (weibo.com)](https://open.weibo.com/wiki/API)
* 授权
    * 授权页面调起
    * 获取access_token
* 用户信息
* 用户首页微博
* 用户发布微博 
    * 这个接口现在有限制,不再是发布微博而是第三方链接分享,用户发布的微博当中必须含有一个地址, 这个地址的服务器目录下要包含第三方开发者的相关文件, 第三方开发者同时要在平台绑定这个域名
    
### 1.1.6 第三方库
* **SnapKit** 自动布局
* **AFNetWorking** 网络的封装, 自己根据自己的请求需要二次封装
* **SDWebImage** 带缓存的网络图片加载框架
* **SVProgressHUD** 加载数据的UI
* **FMDB** sqlite3的封装
### 1.1.7 开发工具
* **source tree** git的可视化工具的使用
* **navicat** 数据库的可视化工具使用
* **cocopods** 第三方框架管理工具

# 二、界面及功能
## 2.1 主界面
主界面是一个UIToolBarController, 下面包含四个navigationController(首页微博, 个人消息, 发现, 个人信息), 点击控制器进行导航控制器的rootController的切换。

中间的发布微博为一个占位的控制器, 上边覆盖了一个按钮, 按钮绑定了事件, 通过UserAccountViewModel的单例判断用户是否登录, 从而决定是跳到发布微博界面还是登录界面。

### 2.1.1 用户登录判断
* VM单例初始化的时候从沙盒路径中解档获取到model
* 判断UserAccount的access_token是否为空, 以及是否过期
* 授权登录时用户能够获取到access_token以及expires_in这个有效期, 拿到后立刻计算过期日期保存到UserAccount模型
* 将过期日期和当前日期比较即可得知access_token是否有效确定用户登录状态

## 2.1 游客界面 
主界面的所有子界面的未登录状态 提示用户进行登录, 这个控制器是主界面所有子控制器的父类, 导航栏左右两边各一个按钮

控制器的视图为自定义的视图, 内步同样包含两个按钮, 定义了一套协议, 约定点击注册、登录后各执行哪个方法, delegate设置为控制器, 这两个方法和导航栏的两个按钮绑定的方法一致
![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d6c2f3c4a61249ac8ad6fa9bce4b6d73~tplv-k3u1fbpfcp-watermark.image?)

## 2.3 授权界面
### 2.3.1 授权登录步骤
* 输入用户名和密码进行授权, 拿到授权码
* 通过授权码再次请求, 拿到accessToken
* 通过accessToken再次请求用户信息
    
### 2.3.2 授权界面展示
使用WKWebView加载授权界面, navigationDelegate设置为控制器自己, 同时实现代理的`func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)` 方法
* 判断重定向地址是否为我们指定的重定向地址, 以及是否含有授权码
* 如果有授权码我们再让UserAccout视图模型调用网络工具请求access_token, 如果成功返回, 保存用户信息到模型中(KVC)
* 请求用户数据, 返回用户的头像和昵称, 补充到用户信息模型中
* VM将用户信息模型保存到本地, 归档


### 2.3.3 自动填充
将授权界面URL在safari打开, 调整为手机查看, 查看界面元素, 获取到ElementId, 将赋值的js放入webview的`evaluateJavaScript`方法中执行即可
![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a673fba8fcbf49e3b552c8a609e25a6c~tplv-k3u1fbpfcp-watermark.image?)

## 2.4 欢迎界面
主要是用户头像从下至上出现, 使用SDWebImage中的`UIImageView+WebCache`的扩展方法方法加载网络图片

* viewDidAppear中
    * 更新imageView的高度约束
    * UIView的animate方法 动画内容填 self.view.layoutIfNeeded(), 原本会在下一个runloop开始时更新的约束变为在动画时间内完成
    * 动画完成后给appDelegate发送消息切换根视图控制器

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/900e1f47e40246ea822bef02f06ff108~tplv-k3u1fbpfcp-watermark.image?)
## 2.5 新特性介绍界面

### 2.5.1 界面细节
多张图片的collectionView, 最后一张图片展示的时候显示开始按钮, 点击进入主界面, 通过代理的`scrollViewDidEndDecelerating`, 根据当前的contentOffset和bounds的width进行计算页数, 如果是最后一页就展现按钮。 点击按钮后发送通知给appdelegate将设置主窗口根视图控制器为主界面

### 2.5.2 何时加载
程序运行起来在appDelegate的`func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool` 中判断加载哪个根视图控制器, 如果用户登录了且当前版本为新版本则将新特性控制器设为程序启动的根视图控制器

### 2.5.2 判断是否为新版本
* `Bundle.main.infoDictionary!["CFBundleShortVersionString"]`获取当前版本
* `UserDefaults.standard.double(forKey: sandboxVersionKey)` 获取之前版本
* 比较后得到结果
* `UserDefaults.standard.set(version, forKey: sandboxVersionKey)`保存当前版本号
## 2.6 微博首页

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b9a1ab2be74243b896efb6721a42888d~tplv-k3u1fbpfcp-watermark.image?)
### 2.6.1 展示数据
* 包含原创微博和转发微博, 采用继承的方式, 二者在原有基础上做拓展
    * 原创微博组成
        * 顶部视图 用户相关信息（头像, 昵称, 时间）
        * 正文内容 label
        * 图片 （如果有）
        * 底部视图 转发 评论 点赞
    * 转发微博
        * 原文内容 在正文和图片中间
        * 背景按钮 包裹住原文内容和图片

* 行高的自动计算和缓存
    * 计算 结合自动布局
        * 头部、底部视图为固定高度, 头部的top顶住contentView, 底部的top顶住图片内容
        * 正文内容设置left和top, `preferredMaxLayoutWidth`, 这样高度能够自己展开
        * 图片内容（collectionView）
            * 自动布局中先给宽高设定一个数值, top顶住正文内容
            * 设置好模型后(didSet方法)调用`sizeToFit()` 然后`reloadData()`
            * 重写`sizeThatFits` 返回cell的正确大小
                * 没有图片 zero
                * 1张图片 根据url从SDWebImage缓存当中查找图片 根据图片尺寸调整 存在宽度的下限和上限, flowlayout的size也需要调整
                * 4张图片 田字型 调整宽度和高度
                * 其他数量, 按照9宫格根据行数计算宽高
                
    * 缓存行高
        * cell本身设置一个方法, 传入视图模型, 返回行高, `func crowHeight(vm: StatusViewModel) -> CGFloat`, 传入模型后保存模型, 触发didSet方法, 更新约束, 调用layoutIfNeeded, 立刻更新约束, 返回底部视图的frame的max.y
        * `func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat` 这个数据源方法中返回视图模型中的缓存行高
        * 视图模型中的行高为懒加载属性, 内部准备一个对应类型的cell, 传入视图模型, 返回行高
        * 对于一个展示过的cell来说, 行高一定已经计算完毕
    

### 2.6.2 数据刷新
* 下拉刷新
    * 设置控制器的refreshControl 添加监听方法 监听`UIControl.Event.valueChanged`
* 上拉刷新
    * 设置tableView的tableFooterView为UIActivityIndicatorView
    * `func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell` 这个方法中通过判断当前行数是否为倒数几行决定是否为上拉刷新
    * 手动调用`startAnimating()` 方法
* 刷新数据
    * 根据tableFooterView的动画状态判断是上拉刷新还是下拉刷新
    * 让视图模型请求数据 上拉刷新设置max_id 下拉刷新设置since_id
    * 数据访问层操作数据
        * 查询数据库数据 当前用户的id下的缓存微博数据
            * 如果有则不需要网络请求, 将数据库中的json data解析为一条条微博的模型
            * 如果没有则进行网络请求
        * 网络请求数据 缓存到数据库
    * 字典通过KVC的方式转为对象模型, 拼接到原数组当中

### 2.6.3 图片查看器

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5d05a6f105e04dee9f94e99904687354~tplv-k3u1fbpfcp-watermark.image?)
* 放大缩小, 左右切换
* 保存到本地
    * `public func UIImageWriteToSavedPhotosAlbum(_ image: UIImage, _ completionTarget: Any?, _ completionSelector: Selector?, _ contextInfo: UnsafeMutableRawPointer?)`
    * info.plist需要添加 `Privacy - Photo Library Usage Description` 字段, 描述任意
* 基于位置的转场动画
    * 由于单张图片被点击到视图控制器层级过多, 采用通知的方式
    * 首页控制器注册通知, 收到消息后进行自定义的转场, 设置转场动画的代理对象
        * `vc.modalPresentationStyle = .custom`
        * `vc.transitioningDelegate = self?.photoBrowserAnimation`
    * cell对象被点击的时候collectionView发送通知, 将自己也传过去
    * 代理对象实现了转场动画的相应方法, 包括展现和消失
    * 动画代理对象需要知道起始位置和结束位置, 以及相应的图片视图, 给自己增加了两个代理对象, 定义了相应协议
        * 展现代理 为 图片视图collection 提供以下方法
            * 被点击cell的imageview
            * 缩略图cell的rect(相对于主窗口)
            * 图片查看器大图的rect(相对于主窗口), 根据缩略图图片比例计算
        * 消失代理 为 照片浏览器 提供以下方法
            * 消失的时候的indexPath
            * 消失的时候的视图
            
    * 具体动画的思路
        * 展现
            * 系统提供的动画视图上 添加目标视图, 同时缩略图frame调整为相对于窗口的初始值, 也添加到动画视图上
            * UIView的animate, frame调整为大图相对于rect的frame
            * 动画结束后移除这些视图
        * 消失
            * 同上
            * 注意indexPath可能已经变化, 所以是获取当前indexPath的起始位置和目标位置
            
## 2.7 撰写微博

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2e62d99e30104fa88eb0d4bd2d0bcc91~tplv-k3u1fbpfcp-watermark.image?)
### 2.7.1 自定义工具条搭配键盘
* 控制器通过NSNotification监听键盘frame变化, 根据键盘的frame调整bar的自动布局
### 2.7.2 图片选择器
PicturePickerController, 内部是一个collectionView, 每个cell包含一张图片和删除按钮, 默认提供一个cel, cell定义了一套协议将自己的点击传递给控制器, 包括点击和删除
* 点击按钮打开一个UIImagePickerController 选择图片
* `func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) `这个方法内做返回图片的处理
* 返回的图片需要做缩放处理, 不然会占用过多内存
# 三 模型和视图模型
通过以下比对, 可以看出视图模型在原有模型的基础上, 对数据进行了进一步加工和处理, 控制器的代码会相对来说更少, 视图之后不再直接接触到模型, 而是使用视图模型的加工数据
## 3.1 用户账户
### 3.1.1 用户账户模型
除了以下之外就只有KVC相关方法和归档解档方法
| 属性 | 意义 | 
| --- | --- |
| access_token | 用户登录标识 |
| expires_in | 有效时长 |
| expiresDate| 过期时间, 根据有效时长计算|
| uid| 用户id |
| screen_name | 用户昵称 |
| avatar_large| 用户头像地址字符串|

### 3.1.2 用户账户视图模型
单例, 初始化的时候从沙盒路径中读取后解档
| 属性 | 意义 | 
| --- | --- |
| account| 用户账户模型 |
| accessToken | 有效的token, 过期返回nil |
| userLogin| 用户登录标识, token有效返回true|
| avatarUrl| 用户头像地址URL|
|accountPath| 用户账户归档地址|
| isExpired| 是否过期|


## 3.2 微博
### 3.2.1 微博模型
| 属性 | 意义 | 
| --- | --- |
|id| 唯一标识|
|text| 正文|
|created_at| 创建时间|
|reposts_count|转发数|
|comments_count|评论数|
|attitudes_count|点赞数|
|retweeted_status| 转发的微博|
|user| 微博发布者|
|pic_urls| 转发微博的图片url字符串, 是个字典|

### 3.2.2 微博视图模型
通过一个微博模型进行初始化
| 属性 | 意义 | 
| --- | --- |
| status| 微博模型|
| cellId| cell复用ID, 原创微博和转发微博|
| rowHeight| 懒加载, 获取一个cell传入自身进行计算|
| userProfileUrl|用户头像URL |
| userDefaultIconView| 头像默认ImageView |
| statusPicDefaultIconView| 微博配图默认ImageView|
| thumbnailUrls | 配图URL数组|
| retweetedText| 转发微博的文本, 拼接原微博用户名和微博内容|

## 3.3 微博视图模型数组模型
| 属性 | 意义 | 
| --- | --- |
| statusList |微博视图模型数组|

提供以下方法
```swift
/// 加载微博列表 新加载的数据凭借到模型数组后面
func loadStatus(isPullup: Bool, finished: @escaping(_ isSuccessed: Bool)->())

/// 缓存单张图片
private func cacheSingleImage(dataList: [StatusViewModel], finished: @escaping(_ isSuccessed: Bool)->())
```

# 四、其他
## 4.1 AFNetWorking二次封装
封装一个类, 专门用于网络请求, 传入必要的参数即可
```swift

/// 发布一条微博
func sendStatus(status: String, image: UIImage?, finished: @escaping YYHRequestCllBack)

/// 请求首页微博
func loadStatus(since_id: Int, max_id: Int,finished: @escaping YYHRequestCllBack)

/// 授权地址
var oAuthURL: URL
/// 加载用户信息
func loadUserInfo(uid: String, finished: @escaping YYHRequestCllBack)
/// 请求access_token
func loadAccessToken(code: String, finished: @escaping YYHRequestCllBack)

/// 带有token参数的请求
func tokenRequest(method: NetworkRequestMethod, URLString: String, parameters: [String: Any]? , finished:  @escaping YYHRequestCllBack)
/// 给参数字典添加access_token
private func appendToken(params: inout [String : Any]?) -> Bool

/// 不同类型的请求方式 GET|POST|其他
private func request(method: NetworkRequestMethod, URLString: String, parameters: [String: Any]? , finished:  @escaping YYHRequestCllBack)
```

## 4.2 FMDB二次封装
专门用于数据库操作的单例
```swift
let queue: FMDatabaseQueue
/// 执行sql, 查询, 结果集作为字典返回
func execRecordSet(sql: String) -> [[String: Any]]
```


# 五、ToDoList
* 提供更好的缓存方案, 如果用户关注了新的用户, 或者是间隔了很长一段时间突然上拉刷新, 会丢失一些数据, 之后读缓存会没有这些数据
* 跳到单条微博
* 某条微博下的评论
* 评论一条微博
