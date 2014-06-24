 (function(window) {
    function UserInfoManager() {
        this.info = null;
        this.uid = null;
        this.pid = null;
    };
    UserInfoManager.prototype = {
        setInfo : function(data) {
            this.info = data;
        },
        setUid : function(uid) {
            this.uid = uid;
        },
        setPid : function(pid) {
            this.pid = pid;
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "backpagebtn" : null,
            "mail" : null,
            "pwd" : null,
            "register_btn" : null
        };
        //当点击请求提示框的关闭按钮，意味着中断请求，在关闭提示框后，如果请求得到响应，也不进行下一步业务处理。
        this.isStopReq = false;
        //页面对象是否初始化完成
        this.inited = false;
    };
    PageManager.prototype = {
        /**
         * 初始化页面对象
         */
        init : function() {
            var me = this;
            me.userInfoManager = new UserInfoManager();
            me.initElems();
            me.initEvents();
            me.inited = true;
        },
        /**
         * 初始化页面元素对象
         */
        initElems : function() {
            var me = this,
                elems = me.elems;
                me.elems = Trafficeye.queryElemsByIds(elems);
        },
        
        /**
         * 初始化页面元素事件
         */
        initEvents : function() {
            var me = this,
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
        },
        /**
         * 按钮按下事件处理器
         * @param  {Event} evt
         */
        btnDown : function(evt) {
            this.addClass("curr");
        },
        backpagebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var fromSource = Trafficeye.fromSource();
            Trafficeye.toPage(fromSource.sourcepage);
        },
        /**
         * 登录处理函数
         */
        reqTrafficeyeLoginbtnUp : function(evt) {
            var me = this;
            
            var myInfo = Trafficeye.getMyInfo();
            // if (!myInfo) {
            //     return;
            // }
          
            var pid = myInfo.pid;
            var ua = myInfo.ua;

            var textMail = me.elems["mail"].attr("value");
            var textPwd = me.elems["pwd"].attr("value");
            var regMail=/^\w+([-\.]\w+)*@\w+([\.-]\w+)*\.\w{2,4}$/;
             //判断邮箱格式，昵称长度，密码长度是否符合《路况交通眼账号系统字段规则》
             if(!regMail.test(textMail)){
                Trafficeye.trafficeyeAlert("邮箱格式有误,请您重新输入");
                return;
             }
             if(textPwd.length>16 || textPwd.length < 6)
             {
                Trafficeye.trafficeyeAlert("密码请您输入6-16个字符");
                return;
             }
         
            var loginBtnUp_url = Trafficeye.BASE_USER_URL + "login";
            var loginBtnUp_data = {
                "ua" : ua,
                "pid" : pid,
                "passwd" : textPwd,
                "email" : textMail
            };
            me.reqLoginbtn(loginBtnUp_url, loginBtnUp_data);
        },
        /**
         * 注册用户请求函数
         */
        reqLoginbtn : function(url, data) {
            var loginBtnUp_data = data;
            var me = this;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                Trafficeye.httpTip.opened(function() {
                                     me.isStopReq = true;
                                }, me);
                                me.isStopReq = false;
                var reqUrl = url + reqParams;
                // alert("-------------------------- :"+reqUrl+"--------------------------");
                // console.log("-------------------------- :"+reqUrl+"--------------------------");
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        Trafficeye.httpTip.closed();
                        if (data && !me.isStopReq) {
                            var state = data.state.code;
                            if (state == 0) {
                                
                                var myInfo = Trafficeye.getMyInfo();
                                //把用户信息写入到本地
                                //pid,ua,userinfo存入到浏览器本地缓存
                                var userinfodata = {
                                    "pid" : myInfo.pid,
                                    "ua" : myInfo.ua,
                                    "uid" : data.state.uid,
                                    "friend_uid" : data.userInfo.uid,
                                    "isEdit" : myInfo.isEdit,
                                    "userinfo" : data.userInfo
                                };
                                var dataStr = Trafficeye.json2Str(userinfodata);
                                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                                //写入徽章，里程信息到浏览器缓存
                                var dataReward = Trafficeye.json2Str(data.reward);
                                var dataUserInfo = Trafficeye.json2Str(data.userInfo);
                                Trafficeye.offlineStore.set("traffic_reward",dataReward);
                                if (Trafficeye.mobilePlatform.android) {
                                    window.JSAndroidBridge.loginNotify(loginBtnUp_data.email,loginBtnUp_data.passwd,dataUserInfo,dataReward);
                                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                                    var content = encodeURI(encodeURI(dataUserInfo));
                                    var contentreward = encodeURI(encodeURI(dataReward));
                                    window.location.href = ("objc:??loginNotify::?"+loginBtnUp_data.email+":?"+loginBtnUp_data.passwd+":?"+content+":?"+contentreward);
                                } else {
                                    alert("调用修改用户信息接口,PC不支持.");
                                }
                                Trafficeye.toPage("pre_info.html");
                            } else{
                                //注册失败
                                Trafficeye.trafficeyeAlert(data.state.desc+"("+data.state.code+")");
                            }
                        } else {
                            //me.reqPraiseFail();
                        }
                    }
                })
            } else {
               // me.reqPraiseFail();
            }
        },
        //忘记密码的onclick事件响应函数
        forgetpwd : function(evt) {
            var me = this;
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_forgotpwd.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //登录的onclick事件响应函数
        trafficeyelogin : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                me.reqTrafficeyeLoginbtnUp(evt);//交通眼用户登录请求处理函数
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : presource.sourcepage,"currpage" : "pre_trafficeyelogin.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         
         //获取我的用户信息, by dongyl
        var myInfo = Trafficeye.getMyInfo();
        // if (!myInfo) {
        //     return;
        // }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        
        window.trafficeyelogin = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.trafficeyelogin(evt);
            }
        };
        
        window.forgetpwd = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.forgetpwd(evt);
            }
        };
    }); 
    
 }(window));