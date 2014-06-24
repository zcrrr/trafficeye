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
             "ridelist": null,
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
             Trafficeye.toPage("pcar_ride_info.html");
         },
        /**
          * 搭车信息列表请求函数
          */
         reqRideInfo: function(publishid) {
             var url = Trafficeye.BASE_RIDE_URL + "/carpoolInfo/v1/infoDetail";
             var myInfo = Trafficeye.getMyInfo();
             var pointStr = myInfo.dataclient;
             
             var data = {
                 "ua": myInfo.ua,
                 "pid": myInfo.pid,
                 "uid" : myInfo.uid,
                 "infoId": publishid
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
                     url: reqUrl,
                     success: function(data) {
                         Trafficeye.httpTip.closed();
                         if (data && !me.isStopReq) {
                             var state = data.state.code;
                             if (state == 0) {
                                 me.reqRideListSuccess(data);
                             }  else {
                                 Trafficeye.trafficeyeAlert(data.state.desc + "(" + data.state.code + ")");
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
          * 搭车用户显示函数
          * @param  {String} url 服务URL
          * flag 是ride 是搭车 ,away 是送人
          * @param  {JSON Object} data 请求协议参数对象
          */
         reqRideListSuccess: function(data) {
             // var data = Trafficeye.str2Json(data);
             var me = this,
                 ridelistElem = me.elems["ridelist"],
                 ridemapElem = me.elems["ridemap"];
             Trafficeye.httpTip.closed();

             if (data) {
             //用户信息更新
                 var ridehtml = me.creatRideListHtml(data.info);
                 ridelistElem.html(ridehtml);
            }
         },
         
         creatRideListHtml: function(data) {
             var me = this;
             var htmls = [];
             var myInfo = Trafficeye.getMyInfo();
             var dataAvatar = data.avatarUrl;
             if(!dataAvatar)
             {
                 dataAvatar="per_img/mm.png";
             }
             if(data.type == "1"){
               htmls.push("<div class=\"dache-box\" >");
           }else{
               htmls.push("<div class=\"dache-box p\" >");
           }
             // htmls.push("<div class=\"dache-box\" >");
             htmls.push("<div class=\"d\">\<div class=\"dl\"><img src="+dataAvatar+" alt=\"\" width=\"40\" height=\"40\"/></div><div class=\"dr\">");
             htmls.push("<h3>");
             htmls.push(data.username);
             htmls.push("<span></span></h3>");
             htmls.push("<ul class=\"week\">");
             if(data.day.sun == "1"){
                htmls.push("<li class=\"select curr\">日</li>");
            }else
            {
                htmls.push("<li>日</li>");
            }
             if(data.day.mon == "1"){
                htmls.push("<li class=\"select curr\">一</li>");
            }else
            {
                htmls.push("<li>一</li>");
            }
            if(data.day.tues == "1"){
                htmls.push("<li class=\"select curr\">二</li>");
            }else
            {
                htmls.push("<li>二</li>");
            }
            if(data.day.wed == "1"){
                htmls.push("<li class=\"select curr\">三</li>");
            }else
            {
                htmls.push("<li>三</li>");
            }
            if(data.day.thur == "1"){
                htmls.push("<li class=\"select curr\">四</li>");
            }else
            {
                htmls.push("<li>四</li>");
            }
            if(data.day.fri == "1"){
                htmls.push("<li class=\"select curr\">五</li>");
            }else
            {
                htmls.push("<li>五</li>");
            }
            if(data.day.sat == "1"){
                htmls.push("<li class=\"select curr\">六</li>");
            }else
            {
                htmls.push("<li>六</li>");
            }
            htmls.push("<span>"+data.time+"左右</span>");
            htmls.push("</ul></div></div><div class=\"ss\">");
            htmls.push("<h2>起点:<span>"+data.startLocation+"</span></h2>");
            htmls.push("<h2 class=\"myh2\">终点:<span>"+data.endLocation+"</span></h2>");
            htmls.push("<div class=\"add\">"+data.city+"</div></div></div>");
            return htmls.join("");
         },
         /**
         * 用户信息请求函数
         */
        reqUserInfo : function(uidfriend) {
            var url = Trafficeye.BASE_USER_URL + "userInfo";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "uidFriend" : uidfriend
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
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_relname.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         mobile: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_mobile.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         city: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_city.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         sex: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_sex.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         birthday: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_birthday.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         carnumber: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_carnum.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         weixin: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_weixin.html");
                 }), Trafficeye.MaskTimeOut);
            }
         },
         //查看他发布的动态
         qqnum: function(evt) {
             var me = this;
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             var myInfo = Trafficeye.getMyInfo();
             if(myInfo.uid == pcar_publish_uid.pcar_publishuid){
                 var elem = $(evt).addClass("curr");
                 setTimeout((function() {
                     $(elem).removeClass("curr");
                     Trafficeye.toPage("pcar_qqnum.html");
                 }), Trafficeye.MaskTimeOut);
            }
         }
     };

     $(function() {
        
        window.initPageManager = function() {
//把来源信息存储到本地

             var fromSource = {"sourcepage":"pcar_index.html","currpage" : "pcar_ride_info1.html","prepage" : "pcar_ride_info.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
             
             var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
             var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
             
             var publish_id = Trafficeye.offlineStore.get("traffic_pcar_publish_id");
             var pcar_publishid = Trafficeye.str2Json(publish_id);
             
             var traffic_pcar_flag = Trafficeye.offlineStore.get("traffic_pcar_flag");
             var pcar_flag = Trafficeye.str2Json(traffic_pcar_flag);
             
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
             if(pcar_flag.flag == "ride"){
               pm.elems["title"].html("司机个人信息");
             }else if(pcar_flag.flag == "away"){
               pm.elems["title"].html("乘客个人信息");
             }
             //判断缓存中是否有userinfo信息
             if (myInfo.userinfo) {
                pm.reqRideInfo(pcar_publishid.ride_id);
                pm.reqUserInfo(pcar_publish_uid.pcar_publishuid);
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