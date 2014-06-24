 (function(window) {
     function UserInfoManager() {
         this.userinfo = null;
         this.ua = null;
         this.pid = null;
     };
     UserInfoManager.prototype = {
         setInfo: function(data) {
             this.userinfo = data;
         },
         setPid: function(pid) {
             this.pid = pid;
         },
         setUa: function(ua) {
             this.ua = ua;
         }
     };

     function PageManager() {
         //ID元素对象集合
         this.elems = {
             "backpagebtn": null,
             "hourId": null,
             "minuteId": null
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
         init: function() {
             var me = this;
             me.userInfoManager = new UserInfoManager();
             me.initElems();
             me.initEvents();
             me.inited = true;
         },
         /**
          * 初始化页面元素对象
          */
         initElems: function() {
             var me = this,
                 elems = me.elems;
             me.elems = Trafficeye.queryElemsByIds(elems);
         },

         /**
          * 初始化页面元素事件
          */
         initEvents: function() {
             var me = this,
                 backpagebtnElem = me.elems["backpagebtn"];
             //返回按钮
             backpagebtnElem.onbind("touchstart", me.btnDown, backpagebtnElem);
             backpagebtnElem.onbind("touchend", me.backpagebtnUp, me);
         },
         /**
          * 按钮按下事件处理器
          * @param  {Event} evt
          */
         btnDown: function(evt) {
             this.addClass("curr");
         },
         backpagebtnUp: function(evt) {
             var me = this,
                 elem = evt.currentTarget;
             $(elem).removeClass("curr");
             Trafficeye.toPage("pcar_publishinfo.html");
         },
         //发布拼车信息
         submitTime: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             
             
             var hourId = document.getElementById("hourId");
             var minuteId = document.getElementById("minuteId");
             var textHourId=hourId.options[hourId.selectedIndex].innerHTML;
             var textMinuteId = minuteId.options[minuteId.selectedIndex].innerHTML;
            if(!textHourId || !textMinuteId)
             {
                Trafficeye.trafficeyeAlert("请您输入时间");
                return;
             }
             
              var publishInfo_time = {
                    "time" : textHourId+":"+textMinuteId
                };
                // alert(textHourId+":"+textMinuteId);
                var dataStr = Trafficeye.json2Str(publishInfo_time);
                Trafficeye.offlineStore.set("publishInfo_time", dataStr);

             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_publishinfo.html");
             }), Trafficeye.MaskTimeOut);
         }
     };

     $(function() {
        
        window.initPageManager = function() {
             
             //获取我的用户信息
             var myInfo = Trafficeye.getMyInfo();
             if (!myInfo) {
                 return;
             }

             var pm = new PageManager();

             Trafficeye.pageManager = pm;
             //初始化用户界面
             pm.init();
             pm.myInfo = myInfo;
             //判断缓存中是否有userinfo信息
             if (!myInfo.userinfo) {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
         
         //保存
         window.submitTime = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.submitTime(evt);
             }
         };
        window.initPageManager();
     });

 }(window));