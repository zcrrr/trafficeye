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

     function UserPcarRideManager() {
         //加载成功的用户的所有时间线数据
         this.allPcarRideData = [];
         //用户最近一次加载的时间线数据
         this.newPcarRideData = [];
     };

     UserPcarRideManager.prototype = {

         setNewPcarRideData: function(data) {
             this.newPcarRideData = data;
         },
         mergeNewPcarRideData: function() {
             this.allPcarRideData.concat(this.newPcarRideData);
         },

         creatRideListHtml: function(data,flag) {
             var me = this;
             var htmls = [];
             var myInfo = Trafficeye.getMyInfo();
             var dataAvatar = data.avatarUrl;
             if(!dataAvatar)
             {
                 dataAvatar="per_img/mm.png";
             }
             if(flag == "ride"){
               htmls.push("<div class=\"dache-box p\" >");
           }else{
               htmls.push("<div class=\"dache-box\" >");
           }
             // htmls.push("<div class=\"dache-box\" >");
             htmls.push("<div class=\"d\" onclick=\"pcar_ride_info(this,'"+data.id+"');\"><div class=\"dl\"><img src="+dataAvatar+" alt=\"\" width=\"40\" height=\"40\"/></div><div class=\"dr\">");
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
            htmls.push("</ul></div></div><div class=\"ss\" onclick=\"pcar_ride_info(this,'"+data.id+"');\">");
            htmls.push("<h2>起点:<span>"+data.startLocation+"</span></h2>");
            htmls.push("<h2 class=\"myh2\">终点:<span>"+data.endLocation+"</span></h2>");
            htmls.push("<div class=\"add\">"+data.city+"</div></div></div>");
            return htmls.join("");
         },

         getRideListHtml: function(carList,flag) {
             var data = carList;
             var htmls = [];
             for (var i = 0, len = data.length; i < len; i++) {
                 htmls.push(this.creatRideListHtml(data[i],flag));
             }
             return htmls.join("");
         }
     };

     function PageManager() {
         //ID元素对象集合
         this.elems = {
             "backpagebtn": null,
             "ridelist": null,
             "loadmorebtn": null,
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
             me.pageNumManager = new Trafficeye.PageNumManager();
             me.UserPcarRideManager = new UserPcarRideManager();
             me.pageNumManager.reset();
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
             //隐藏加载更多按钮
             // loadmorebtnElem.style.display="none";//("display","none");
             loadmorebtnElem.css("display", "none");
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
             var fromSource = Trafficeye.fromSource();
             Trafficeye.toPage(fromSource.sourcepage);
         },
         /**
          * 搭车信息列表请求函数
          */
         reqRideInfo: function(page,flag,type) {
             var url = Trafficeye.BASE_RIDE_URL + "/carpoolInfo/v1/findInfo";
             var myInfo = Trafficeye.getMyInfo();
             var pointStr = myInfo.dataclient;
             
             var data = {
                 "ua": myInfo.ua,
                 "pid": myInfo.pid,
                 "uid" : myInfo.uid,
                 "point": pointStr.lon+","+pointStr.lat,
                 "type": type,//我要搭车页面，请求应为我要送人的内容
                 "page": page,
                 "count": 10
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
                                 me.reqRideListSuccess(flag,data);
                             } else if (data.state.code == -99) { //没有加载更多
                                 me.reqRideNo();
                             } else {
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
         //没有更多数据
         reqRideNo: function() {
             var me = this;
             Trafficeye.httpTip.closed();
             me.elems["loadmorebtn"].css("display", "none");
         },
         /**
          * 搭车用户显示函数
          * @param  {String} url 服务URL
          * flag 是ride 是搭车 ,away 是送人
          * @param  {JSON Object} data 请求协议参数对象
          */
         reqRideListSuccess: function(flag,data) {
             // var data = Trafficeye.str2Json(data);
             var me = this,
                 pageNumMger = me.pageNumManager, //判断是否加载更多
                 ridelistElem = me.elems["ridelist"];
             Trafficeye.httpTip.closed();

             if (data) {
                 //当前结果集请求的结束位置
                 var currentEnd = pageNumMger.getEnd();
                 //更新下次请求分页起始位置
                 pageNumMger.start = currentEnd + 1;
                 //用户信息更新
                 var ridehtml = me.UserPcarRideManager.getRideListHtml(data.infoList,flag);
                 if (data.nextPage == -1) { //nextPage 为 -1的时候，没有下一页
                     pageNumMger.setIsShowBtn(false);
                 } else {
                     pageNumMger.setIsShowBtn(true);
                 }
                 if ((pageNumMger.start / pageNumMger.BASE_NUM) == 1) {
                     ridelistElem.html(ridehtml);
                 } else {
                     ridelistElem.append(ridehtml);
                 }
                 //判断是否显示加载更多按钮
                 if (pageNumMger.getIsShowBtn()) {
                     me.elems["loadmorebtn"].css("display", "");
                     me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" class=\"bblue\" onclick=\"loadmorebtnUp(this);\">加载更多</div>");
                 } else {
                     me.elems["loadmorebtn"].css("display", "none");
                 }
             }
         },
         //加载更多
         loadmorebtnUp: function(evt) {
             var me = this,
                 elem = evt.currentTarget;
             var myInfo = Trafficeye.getMyInfo();
             if (!myInfo) {
                 return;
             }
             $(elem).removeClass("bblue");
             var uid = myInfo.uid;
             if (uid) {
                 me.loadmoreHander(uid);
             }
         },
         /**
          * 加载更多数据处理函数
          */
         loadmoreHander: function(uid) {
             var me = this;
             var traffic_pcar_flag = Trafficeye.offlineStore.get("traffic_pcar_flag");
             var pcar_flag = Trafficeye.str2Json(traffic_pcar_flag);
             if (uid) {
                 var userData = {};
                 userData.uid = uid;
                 userData.page = me.pageNumManager.getStart() / me.pageNumManager.BASE_NUM;
                me.reqRideInfo(userData.page,pcar_flag.flag,pcar_flag.type);
             }
         },
         //进入拼车详情的onclick事件响应函数
         pcar_ride_info: function(evt,publishid) {

            var fromSource = {
                 "ride_id": publishid
             }
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_pcar_publish_id", fromSourceStr);
             Trafficeye.toPage("pcar_ride_info.html");
         },
         //发布拼车信息
         publish: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 //清楚缓存信息
                 Trafficeye.offlineStore.remove("publishInfo_week");
                 Trafficeye.offlineStore.remove("publishInfo_time");
                 Trafficeye.offlineStore.remove("publishInfo_startloc");
                 Trafficeye.offlineStore.remove("publishInfo_endloc");
                 Trafficeye.offlineStore.remove("publishInfo_type");
                 Trafficeye.toPage("pcar_publishinfo.html");
             }), Trafficeye.MaskTimeOut);
         }
     };

     $(function() {
        
        window.initPageManager = function() {
             //把来源信息存储到本地
             var presource = Trafficeye.fromSource();
             var fromSource = {
                 "sourcepage": presource.sourcepage,
                 "currpage": "pcar_ride.html",
                 "prepage": presource.currpage
             }
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
             
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
               pm.elems["title"].html("司机列表");
             }else if(pcar_flag.flag == "away"){
               pm.elems["title"].html("乘客列表");
             }
             //判断缓存中是否有userinfo信息
             if (myInfo.userinfo) {
                pm.reqRideInfo("0",pcar_flag.flag,pcar_flag.type);
             } else {
                 //让用户重新登录
                 Trafficeye.toPage("pre_login.html");
             }
         }
     
         //发布
         window.pcar_ride_info = function(evt,publishid) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcar_ride_info(evt,publishid);
             }
         };
         //发布
         window.publish = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.publish(evt);
             }
         };
         //加载更多
         window.loadmorebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.loadmorebtnUp(evt);
             }
         };
        window.initPageManager();
     });

 }(window));