 (function(window) {
    function UserInfoManager() {
        this.userinfo = null;
        this.ua = null;
        this.pid = null;
    };
    UserInfoManager.prototype = {
        setInfo : function(data) {
            this.userinfo = data;
        },
        setPid : function(pid) {
            this.pid = pid;
        },
        setUa : function(ua) {
            this.ua = ua;
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
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
        //清除用户昵称
        topage : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //清除用户昵称
        topagePhone : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_mobile.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //清除用户昵称
        topageVerify : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_mobile_verify2.html");
                // window.location.href = "pre_baseinfo_mobile_verify2.html";
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
        //获取我的用户信息
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            return;
        }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
                //判断缓存中是否有userinfo信息
        if(myInfo.userinfo){

        }else{
            //让用户重新登录
            Trafficeye.toPage("pre_login.html");
        }
        
        window.topage = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.topage(evt);
            }
        };
        
        window.topageVerify = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.topageVerify(evt);
            }
        };
        
        window.topagePhone = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.topagePhone(evt);
            }
        };
    }); 
    
 }(window));