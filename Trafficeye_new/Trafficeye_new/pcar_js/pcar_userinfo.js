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
             "username": null,
             "mobile": null,
             "city": null,
             "sex": null,
             "birthday": null,
             "carnumber": null,
             "weixin": null,
             "qqnum": null,
             "title" : null
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
                 loadmorebtnElem = me.elems["loadmorebtn"],
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
             Trafficeye.toPage("pcar_index.html");
         },
         /**
         * 用户信息请求函数
         */
        reqUserInfo : function() {
            var url = Trafficeye.BASE_USER_URL + "userInfo";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "uidFriend" : myInfo.uid
            };
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
                            var state = data.state.code;
                            if (state == 0) {
                                me.reqUserInfoSuccess(data.userInfo);
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
        /**
         * 获取到用户信息后，页面展现函数
         * @param  {JSON Object} data
         * @param  {Boolean} flag 是否是自己的信息界面
         */
        reqUserInfoSuccess : function(dataSource) {
            var me = this,
            usernameElem = me.elems["username"],
            mobileElem = me.elems["mobile"],
            cityElem = me.elems["city"],
            sexElem = me.elems["sex"],
            birthdayElem = me.elems["birthday"],
            carnumberElem = me.elems["carnumber"],
            weixinElem = me.elems["weixin"],
            qqnumElem = me.elems["qqnum"];
            //渲染页面
            if(dataSource.realName){//用户名称
                usernameElem.html(dataSource.realName);
            }
            //关注与粉丝
            if(dataSource.mobile)
            {
                mobileElem.html(dataSource.mobile);
            }
            if(dataSource.city){
                cityElem.html(dataSource.city);
            }
            //性别
            var gender = dataSource.gender;
            // nc_midElem.show();
            switch(gender) {
                    case "M" :
                        sexElem.html("男");
                        break;
                    case "F" :
                        sexElem.html("女");
                        break;
                    case "S" :
                        break;
                }
            if(dataSource.birthdate){
                birthdayElem.html(dataSource.birthdate);
            }
            if(dataSource.carNum){
                carnumberElem.html(dataSource.carNum);
            }
            if(dataSource.wxNum){
                weixinElem.html(dataSource.wxNum);
            }
            if(dataSource.qq){
                qqnumElem.html(dataSource.qq);
            }
        },
         //查看他发布的动态
         username: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_relname.html");
                 }), Trafficeye.MaskTimeOut);
 
         },
         //查看他发布的动态
         mobile: function(evt) {
   
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_mobile.html");
                 }), Trafficeye.MaskTimeOut);
     
         },
         //查看他发布的动态
         city: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_city.html");
                 }), Trafficeye.MaskTimeOut);
      
         },
         //查看他发布的动态
         sex: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_sex.html");
                 }), Trafficeye.MaskTimeOut);
     
         },
         //查看他发布的动态
         birthday: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_birthday.html");
                 }), Trafficeye.MaskTimeOut);
          
         },
         //查看他发布的动态
         carnumber: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_carnum.html");
                 }), Trafficeye.MaskTimeOut);

         },
         //查看他发布的动态
         weixin: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_weixin.html");
                 }), Trafficeye.MaskTimeOut);

         },
         //查看他发布的动态
         qqnum: function(evt) {

                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_qqnum.html");
                 }), Trafficeye.MaskTimeOut);

         }
     };

     $(function() {
        
        window.initPageManager = function() {
//把来源信息存储到本地

             var fromSource = {"sourcepage":"pcar_index.html","currpage" : "pcar_userinfo.html","prepage" : "pcar_publishinfo.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
             
    
             
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
             if (myInfo.userinfo) {
                pm.reqUserInfo();
             } else {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
         
         //真实姓名
         window.username = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.username(evt);
             }
         };
         //手机号码
         window.mobile = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.mobile(evt);
             }
         };
         //所在城市
         window.city = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.city(evt);
             }
         };
         //性别
         window.sex = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.sex(evt);
             }
         };
         //生日
         window.birthday = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.birthday(evt);
             }
         };
         //车牌
         window.carnumber = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.carnumber(evt);
             }
         };
         //微信
         window.weixin = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.weixin(evt);
             }
         };
         //qq
         window.qqnum = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.qqnum(evt);
             }
         };
        window.initPageManager();
     });

 }(window));