 (function(window) {
     function UserInfoManager() {
         this.userinfo = null;
         this.ua = null;
         this.pid = null;
         this.sun = null;
         this.mon = null;
         this.tues = null;
         this.wed = null;
         this.thur = null;
         this.fri =null;
         this.sat = null;
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
         },
         setSun: function(sun) {
             this.sun = sun;
         },
         setMon: function(mon) {
             this.mon = mon;
         },
         setTues: function(tues) {
             this.tues = tues;
         },
         setWed: function(wed) {
             this.wed = wed;
         },
         setThur: function(thur) {
             this.thur = thur;
         },
         setFri: function(fri) {
             this.fri = fri;
         },
         setSat: function(sat) {
             this.sat = sat;
         }
     };

     function PageManager() {
         //ID元素对象集合
         this.elems = {
             "backpagebtn": null,
             "sun": null,
             "mon": null,
             "tues": null,
             "wed": null,
             "thur": null,
             "fri": null,
             "sat": null
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
                sunbtnElem = me.elems["sun"],
                monbtnElem = me.elems["mon"],
                tuesbtnElem = me.elems["tues"],
                wedbtnElem = me.elems["wed"],
                thurbtnElem = me.elems["thur"],
                fribtnElem = me.elems["fri"],
                satbtnElem = me.elems["sat"],
                backpagebtnElem = me.elems["backpagebtn"];
             //返回按钮
             backpagebtnElem.onbind("touchstart", me.btnDown, backpagebtnElem);
             backpagebtnElem.onbind("touchend", me.backpagebtnUp, me);
             //周日
             sunbtnElem.onbind("touchstart", me.btnDown, sunbtnElem);
             sunbtnElem.onbind("touchend", me.sunbtnUp, me);
             //周一
             monbtnElem.onbind("touchstart", me.btnDown, monbtnElem);
             monbtnElem.onbind("touchend", me.monbtnUp, me);
             //周二
             tuesbtnElem.onbind("touchstart", me.btnDown, tuesbtnElem);
             tuesbtnElem.onbind("touchend", me.tuesbtnUp, me);
             //周三
             wedbtnElem.onbind("touchstart", me.btnDown, wedbtnElem);
             wedbtnElem.onbind("touchend", me.wedbtnUp, me);
             //周四
             thurbtnElem.onbind("touchstart", me.btnDown, thurbtnElem);
             thurbtnElem.onbind("touchend", me.thurbtnUp, me);
             //周五
             fribtnElem.onbind("touchstart", me.btnDown, fribtnElem);
             fribtnElem.onbind("touchend", me.fribtnUp, me);
             //周六
             satbtnElem.onbind("touchstart", me.btnDown, satbtnElem);
             satbtnElem.onbind("touchend", me.satbtnUp, me);
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
         //点击周日的处理函数
         sunbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.sun == "1"){
                me.userInfoManager.setSun("0");
                me.elems["sun"].removeClass("selected");
            }else{
                me.elems["sun"].addClass("selected");
                me.userInfoManager.setSun("1");
            }
        },
        //点击周一的处理函数
         monbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.mon == "1"){
                me.userInfoManager.setMon("0");
                me.elems["mon"].removeClass("selected");
            }else{
                me.elems["mon"].addClass("selected");
                me.userInfoManager.setMon("1");
            }
        },
        //点击周二的处理函数
         tuesbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.tues == "1"){
                me.userInfoManager.setTues("0");
                me.elems["tues"].removeClass("selected");
            }else{
                me.elems["tues"].addClass("selected");
                me.userInfoManager.setTues("1");
            }
        },
        //点击周三的处理函数
         wedbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.wed == "1"){
                me.userInfoManager.setWed("0");
                me.elems["wed"].removeClass("selected");
            }else{
                me.elems["wed"].addClass("selected");
                me.userInfoManager.setWed("1");
            }
        },
        //点击周四的处理函数
         thurbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.thur == "1"){
                me.userInfoManager.setThur("0");
                me.elems["thur"].removeClass("selected");
            }else{
                me.elems["thur"].addClass("selected");
                me.userInfoManager.setThur("1");
            }
        },
        //点击周五的处理函数
         fribtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.fri == "1"){
                me.userInfoManager.setFri("0");
                me.elems["fri"].removeClass("selected");
            }else{
                me.elems["fri"].addClass("selected");
                me.userInfoManager.setFri("1");
            }
        },
        //点击周六的处理函数
         satbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if(me.userInfoManager.sat == "1"){
                me.userInfoManager.setSat("0");
                me.elems["sat"].removeClass("selected");
            }else{
                me.elems["sat"].addClass("selected");
                me.userInfoManager.setSat("1");
            }
        },
         //发布拼车信息
         submitWeek: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             
             var week=[];
             var weekvalue=[];
             if(me.userInfoManager.sun =="1")     
             {
               week.push(0);
               weekvalue.push("周日");
             }   
             if(me.userInfoManager.mon =="1")     
             {
               weekvalue.push("周一");
                week.push(1);
             }   
             if(me.userInfoManager.tues =="1")     
             {
               weekvalue.push("周二");
                week.push(2);
             }   
             if(me.userInfoManager.wed =="1")     
             {
               weekvalue.push("周三");
                week.push(3);
             }   
             if(me.userInfoManager.thur =="1")     
             {
               weekvalue.push("周四");
                week.push(4);
             }   
             if(me.userInfoManager.fri =="1")     
             {
               weekvalue.push("周五");
                week.push(5);
             }   
             if(me.userInfoManager.sat =="1")     
             {
               weekvalue.push("周六");
                week.push(6);
             }   
             var tempweek = week.join(",");
             var tempweekvalue = weekvalue.join(",");
             if(!tempweek){
                Trafficeye.trafficeyeAlert("请您选择日期");
             }
             var publishInfo_time = {
                    "week" : tempweek,
                    "weekvalue" : tempweekvalue
                };
                var dataStr = Trafficeye.json2Str(publishInfo_time);
                Trafficeye.offlineStore.set("publishInfo_week", dataStr);

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
             Trafficeye.offlineStore.remove("publishInfo_week");
             //判断缓存中是否有userinfo信息
             if (!myInfo.userinfo) {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
         
         //保存
         window.submitWeek = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.submitWeek(evt);
             }
         };
        window.initPageManager();
     });

 }(window));