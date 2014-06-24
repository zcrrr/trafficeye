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
            "mail" : null
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
         * 注册请求函数
         */
        reqForgotpwdbtnUp : function(evt) {
            var me = this;
            
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
          
            var pid = myInfo.pid;
            var ua = myInfo.ua;

            var textMail = me.elems["mail"].attr("value");
            var regMail=/^\w+([-\.]\w+)*@\w+([\.-]\w+)*\.\w{2,4}$/;
             //判断邮箱格式，昵称长度，密码长度是否符合《路况交通眼账号系统字段规则》
             if(!regMail.test(textMail)){
                Trafficeye.trafficeyeAlert("邮箱格式有误,请您重新输入");
                return;
             }
         
            var forgotpwdBtnUp_url = Trafficeye.BASE_USER_URL + "forgetPwd";
            var forgotpwdBtnUp_data = {
                "ua" : ua,
                "pid" : pid,
                "email" : textMail
            };
            me.reqForgotbtn(forgotpwdBtnUp_url, forgotpwdBtnUp_data);
            
        },
        /**
         * 注册用户请求函数
         */
        reqForgotbtn : function(url, data) {
            var me = this;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                Trafficeye.httpTip.opened(function() {
                                     me.isStopReq = true;
                                }, me);
                                me.isStopReq = false;
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        Trafficeye.httpTip.closed();
                        if (data && !me.isStopReq) {
                            var state = data.code;
                            if (state == 0) {
                                Trafficeye.trafficeyeAlert(data.desc);
                            } else{
                                //注册失败
                                Trafficeye.trafficeyeAlert(data.desc+"("+data.code+")");
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
        //忘记密码的确认按钮的onclick事件响应函数
        forgotpwd : function(evt) {
            var me = this;
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                me.reqForgotpwdbtnUp(evt);//注册请求处理函数
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
       
        
         //获取我的用户信息, by dongyl
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            return;
        }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        
        window.forgotpwd = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.forgotpwd(evt);
            }
        };
    }); 
    
 }(window));