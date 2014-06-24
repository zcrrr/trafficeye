 (function(window) {
     function UserInfoManager() {
         this.userinfo = null;
         this.ua = null;
         this.pid = null;
         this.type = null;
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
         setType: function(type) {
             this.type = type;
         }
     };

     function PageManager() {
         //ID元素对象集合
         this.elems = {
             "backpagebtn": null,
             "ride": null,
             "away": null,
             "startloc": null,
             "endloc": null,
             "weekloc": null,
             "timeloc": null
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
                 ridebtnElem = me.elems["ride"],
                 awaybtnElem = me.elems["away"],
                 backpagebtnElem = me.elems["backpagebtn"];
             //返回按钮
             backpagebtnElem.onbind("touchstart", me.btnDown, backpagebtnElem);
             backpagebtnElem.onbind("touchend", me.backpagebtnUp, me);
             //我要搭车按钮
             ridebtnElem.onbind("touchstart", me.btnDown, ridebtnElem);
             ridebtnElem.onbind("touchend", me.ridebtnUp, me);
             //我要送人按钮
             awaybtnElem.onbind("touchstart", me.btnDown, awaybtnElem);
             awaybtnElem.onbind("touchend", me.awaybtnUp, me);
             //填充值到页面
             var pbweek = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_week"));
             var pbtime = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_time"));
             var pbstartloc = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_startloc"));
             var pbendloc = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_endloc"));
             var pbtype = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_type"));
             // console.log(pbstartloc.startLocation);
             if(pbweek){
                // document.getElementById("weekloc").value=pbweek.weekvalue;
                me.elems["weekloc"].html(pbweek.weekvalue);
             }
             if(pbtime){
                // document.getElementById("timeloc").value=pbtime.time;
                me.elems["timeloc"].html(pbtime.time);
             } 
             if(pbstartloc){
                // document.getElementById("startloc").value=pbstartloc.startLocation;
                me.elems["startloc"].html(pbstartloc.startLocation);
            }
             if(pbendloc){
                // document.getElementById("endloc").value=pbendloc.endLocation;
                me.elems["endloc"].html(pbendloc.endLocation);
            }
            if(pbtype){
                // document.getElementById("endloc").value=pbendloc.endLocation;
                if(pbtype == "1"){
                    me.elems["ride"].addClass("curr");
                    me.elems["away"].removeClass("curr");
                }else if(pbtype = "2"){
                    me.elems["ride"].removeClass("curr");
                    me.elems["away"].addClass("curr");
                }else{
                    me.elems["ride"].removeClass("curr");
                    me.elems["away"].removeClass("curr");
                }
            }
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
         ridebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
                
             me.elems["ride"].addClass("curr");
             me.elems["away"].removeClass("curr");
             me.userInfoManager.setType("1");
             Trafficeye.offlineStore.set("publishInfo_type","1");
        },
        awaybtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
                
             me.elems["away"].addClass("curr");
             me.elems["ride"].removeClass("curr");
             me.userInfoManager.setType("2");
             Trafficeye.offlineStore.set("publishInfo_type","2");
        },
        
        /**
          * 判断个人信息是否完整
          */
         reqUserInfo: function() {
             var me =this;
             var url = Trafficeye.BASE_RIDE_URL + "/carpoolInfo/v1/validateUserInfo";
             var myInfo = Trafficeye.getMyInfo();

             var data = {
                 "ua": myInfo.ua,
                 "pid": myInfo.pid,
                 "uid": myInfo.uid
             };
             
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
                             if (state == 2) {
                                 // Trafficeye.trafficeyeAlert(data.state.desc);
                                 
                                  Trafficeye.toPage("pcar_userinfo.html");
                                 
                             }else {
                                 // Trafficeye.trafficeyeAlert(data.state.desc + "(" + data.state.code + ")");
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
          * 发布信息列表请求函数
          */
         publish: function(evt) {
             var me =this;
             var url = Trafficeye.BASE_RIDE_URL + "/carpoolInfo/v1/publishInfo";
             var myInfo = Trafficeye.getMyInfo();
         
             var pbweek = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_week"));
             var pbtime = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_time"));
             var pbstartloc = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_startloc"));
             var pbendloc = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_endloc"));
             var pbtype = Trafficeye.str2Json(Trafficeye.offlineStore.get("publishInfo_type"));
             
             if(!pbweek){
                Trafficeye.trafficeyeAlert("您未选择周期");
                return;
             }
             if(!pbtime){
                Trafficeye.trafficeyeAlert("您未填写时间");
                return;
             }
             if(!pbstartloc){
                Trafficeye.trafficeyeAlert("您未选择起点");
                return;
             }
             if(!pbendloc){
                Trafficeye.trafficeyeAlert("您未选择终点");
                return;
             }
             if(!pbtype){
                // document.getElementById("endloc").value=pbendloc.endLocation;
                Trafficeye.trafficeyeAlert("您未选择发布类别");
                return;
            }
             var data = {
                 "ua": myInfo.ua,
                 "pid": myInfo.pid,
                 "uid": myInfo.uid,
                 "type": pbtype,//我要搭车页面，请求应为我要送人的内容
                 "startLocation": pbstartloc.startLocation,
                 "endLocation": pbendloc.endLocation,
                 "startPoint": pbstartloc.startPoint,
                 "endPoint": pbendloc.endPoint,
                 "day": pbweek.week,
                 "time": pbtime.time
             };
             
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
                                 Trafficeye.trafficeyeAlert("发布成功!");
                                 if(Trafficeye.fromSource){
                                      var presource = Trafficeye.fromSource();
                                     Trafficeye.toPage(presource.currpage);
                                 }else{
                                    Trafficeye.toPage("pcar_index.html");
                                 }
                             }else {
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
         }
     };

     $(function() {
        
        // 获取SNS平台用户信息，回调函数
        window.callbackChooseLocation  = function(type,lon,lat,address){
            // console.log(data);
            Trafficeye.httpTip.closed();
            var pm = Trafficeye.pageManager;
            // Trafficeye.alert(type+","+lon+","+lat+","+address);
            var fromSource;
            if(type == "start")
            {
                fromSource = {
                 startPoint : lon+","+lat,
                 startLocation : address
                }
                pm.elems["startloc"].html(address);
            }else if(type == "end"){
                fromSource = {
                 endPoint : lon+","+lat,
                 endLocation : address
                }
                pm.elems["endloc"].html(address);
            }
            
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("publishInfo_"+type+"loc", fromSourceStr);
        };
        
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
             if (myInfo.userinfo) {
                // pm.reqRideInfo(0,pcar_flag.flag,pcar_flag.type);
                pm.reqUserInfo();
             } else {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
         
         //发布
         window.publish = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.publish(evt);
             }
         };
         //设置周期
         window.weekloc = function(evt) {
             Trafficeye.toPage("pcar_week.html");
         };
         //设置时间
         window.timeloc = function(evt) {
             Trafficeye.toPage("pcar_time.html");
         };
         //设置起点
         window.startloc = function(evt) {
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.chooseLocation("start");
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                window.location.href=("objc:??chooseLocation::?start");
            } else {
                alert("调用修改用户信息接口,PC不支持.");
                window.callbackChooseLocation("start","116.40168","39.9077","天安门东站C东南口");
            }
         };
         
         //设置终点
         window.endloc = function(evt) {
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.chooseLocation("end");
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                window.location.href=("objc:??chooseLocation::?end");
            } else {
                window.callbackChooseLocation("end","119","911","安华桥伦洋大厦");
                alert("调用修改用户信息接口,PC不支持.");
            }
         };
        window.initPageManager();
     });

 }(window));