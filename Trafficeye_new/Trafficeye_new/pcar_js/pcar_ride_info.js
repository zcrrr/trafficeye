 (function(window) {
     function UserInfoManager() {
         this.userinfo = null;
         this.ua = null;
         this.pid = null;
         this.mobile = null;
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
         setMobile : function(mobile){
             this.mobile = mobile;
         }
     };


     function PageManager() {
         //ID元素对象集合
         this.elems = {
             "backpagebtn": null,
             "ridelist": null,
             "ridemap": null,
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
             Trafficeye.toPage("pcar_ride.html");
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
                 // var map = "<img src="+data.info.imageUrl+" alt=\"\" width=\"40\" height=\"40\"/>";
                
                 if(data.info.imageUrl){
                    // console.log(ridemapElem);
                    ridemapElem.css("display","");
                    ridemapElem.html( "<img src="+data.info.imageUrl+" alt=\"\" width=\"320\" height=\"205\"/>");
                }
                 var fromSource = {
                     "pcar_publishuid": data.info.uid
                 }
                 var fromSourceStr = Trafficeye.json2Str(fromSource);
                 Trafficeye.offlineStore.set("pcar_publish_uid", fromSourceStr);
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
             if(data.mobile){
                me.userInfoManager.setMobile(data.mobile);
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
         
         //查看他的个人信息
         lookfirends: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_ride_info1.html");
             }), Trafficeye.MaskTimeOut);
         },
         //查看他发布的动态
         fansfriends: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 var pcar_publishuid = Trafficeye.offlineStore.get("pcar_publish_uid");
                var pcar_publish_uid = Trafficeye.str2Json(pcar_publishuid);
                 //********跳转到社区个人时间线***********
                 var myInfo = Trafficeye.getMyInfo();
                 var data = {
                     "prepage": "trafficeye_personal",
                     "pid": myInfo.pid,
                     "uid": myInfo.uid,
                     "traffic_timeline": pcar_publish_uid.pcar_publishuid,
                     "myInfo": myInfo.userinfo
                 };
                 var dataStr = Trafficeye.json2Str(data);
                 if (Trafficeye.mobilePlatform.android) {
                     window.JSAndroidBridge.gotoCommunity("timeline", dataStr);
                 } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                     var rewardContent = encodeURI(encodeURI(dataStr));
                     Trafficeye.toPage("objc:??gotoCommunity::?timeline:?" + rewardContent);
                 } else {
                     alert("调用修改用户信息接口,PC不支持.");
                 }
             //********跳转到社区个人时间线***********
             }), Trafficeye.MaskTimeOut);
         },
         //电话他
         callperson: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 var mobile = me.userInfoManager.mobile;
                 // var myInfo = Trafficeye.getMyInfo();
                 // alert(mobile);
                 if (Trafficeye.mobilePlatform.android) {
                        window.JSAndroidBridge.makeACall(mobile);
                    } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                        window.location.href=("objc:??makeACall::?"+mobile);
                    } else {
                        alert("调用修改用户信息接口,PC不支持.");
                    }
                 
             }), Trafficeye.MaskTimeOut);
         }
     };

     $(function() {
        
        window.initPageManager = function() {
             //把来源信息存储到本地
             var presource = Trafficeye.fromSource();
             var fromSource = {
                 "sourcepage": presource.sourcepage,
                 "currpage": "pcar_ride_info.html",
                 "prepage": presource.currpage
             }
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
             
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
               pm.elems["title"].html("司机行程");
             }else if(pcar_flag.flag == "away"){
               pm.elems["title"].html("乘客行程");
             }
             //判断缓存中是否有userinfo信息
             if (myInfo.userinfo) {
                pm.reqRideInfo(pcar_publishid.ride_id);
             } else {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
         
         //查看他的个人信息
         window.lookfirends = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.lookfirends(evt);
             }
         };
         //查看他发布的动态
         window.fansfriends = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.fansfriends(evt);
             }
         };
         //约她，拨打电话
         window.callperson = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.callperson(evt);
             }
         };
        window.initPageManager();
     });

 }(window));