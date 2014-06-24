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
            "backpagebtn" : null,
            "baseinfo" : null,
            "survey" : null,
            "surveydescid" : null,
            "surveydescidhtml" : null,
            "infousername" : null,
            "baseinfolist" : null,
            "surveybaseid" : null,
            "surveyextid" : null,
            "modifyPwdid" : null,
            "baseinfoimg" : null,
            "baseinfonickname" : null,
            "baseinfousername" : null,
            "suveryusername" : null,
            "suveryphonenumber" : null,
            "suverycity" : null,
            "suverysex" : null,
            "suverybirthdate" : null,
            "surveyextincome" : null,
            "surveyexttravel" : null,
            "surveyextcartime" : null,
            "surveyextcar" : null,
            "surveyextbuytime" : null,
            "surveyextmany" : null,
            "surveyextfirst" : null,
            "baseinfophonenumber" : null,
            "baseinfocity" : null,
            "baseinfosex" : null,
            "baseinfonicknameheader" : null,
            "baseinfobirthdate" : null,
            "baseinfodescript" : null,
            "car" : null,
            "pcardescid" : null,
            "pcarbaseid" : null,
            "pcarusername" : null,
            "pcarmobile" : null,
            "pcarcity" : null,
            "pcarsex" : null,
            "pcarbirthday" : null,
            "pcarcarnumber" : null,
            "pcarweixin" : null,
            "pcarqqnum" : null
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
                baseinfobtnElem = me.elems["baseinfo"],
                surveybtnElem = me.elems["survey"],
                carbtnElem = me.elems["car"],
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //查看基础信息列表按钮
            baseinfobtnElem.onbind("touchend",me.baseinfobtnUp,me);
            //查看调查问卷列表按钮
            surveybtnElem.onbind("touchend",me.surveybtnUp,me);
            //查看拼车列表按钮
            carbtnElem.onbind("touchend",me.carbtnUp,me);
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
            var myInfo = Trafficeye.getMyInfo();
            if(myInfo.isEdit == 1)
            {
                if (Trafficeye.mobilePlatform.android) {
                    window.JSAndroidBridge.closeThisPage();
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc:??closeThisPage");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }else{
                Trafficeye.toPage("pre_info.html");
            }
        },
        /**
         * 选择用户基础信息列表处理器
         * @param  {Event} evt
         */
        baseinfobtnUp : function(evt) {
            var myInfo = Trafficeye.getMyInfo();
            var me = this,
                baseinfoElem = me.elems["baseinfo"],
                surveyElem = me.elems["survey"],
                baseinfolistElem = me.elems["baseinfolist"],
                surveydescidElem = me.elems["surveydescid"],
                surveydescidhtml = me.elems["surveydescidhtml"]
                infousernameElem = me.elems["infousername"],
                surveybaseidElem = me.elems["surveybaseid"],
                surveyextidElem = me.elems["surveyextid"],
                pcarElem = me.elems["car"],
                pcardescidElem = me.elems["pcardescid"],
                pcarbaseidElem = me.elems["pcarbaseid"],
                modifyPwdidElem = me.elems["modifyPwdid"];
            
            baseinfoElem.addClass("curr");
            surveyElem.removeClass("curr");
            pcarElem.removeClass("curr");
            baseinfolistElem.css("display","");
            if(myInfo.userinfo.userType == "trafficeye"){
                modifyPwdidElem.css("display","");
            }
            surveydescidElem.css("display","none");
            surveydescidhtml.css("display","none");
            surveybaseidElem.css("display","none");
            surveyextidElem.css("display","none");
            pcardescidElem.css("display","none");
            pcarbaseidElem.css("display","none");
            var myInfo = Trafficeye.getMyInfo();
            var dataAvatar = myInfo.userinfo.avatarUrl;
            if(!dataAvatar)
            {
                dataAvatar="per_img/mm.png";
            }
            me.elems["baseinfoimg"].html("<img src="+dataAvatar+" alt=\"\" width=\"80\" height=\"80\" />");
            me.elems["baseinfonickname"].html(myInfo.userinfo.username);
            me.elems["baseinfonicknameheader"].html(myInfo.userinfo.username);
            me.elems["baseinfousername"].html(myInfo.userinfo.realName);
            me.elems["baseinfophonenumber"].html(myInfo.userinfo.mobile);
            me.elems["baseinfocity"].html(myInfo.userinfo.city);
            var baseinfoGender = myInfo.userinfo.gender;
            switch(baseinfoGender)
                {
                    case "M" :
                        me.elems["baseinfosex"].html("男");
                        break;
                    case "F" :
                        me.elems["baseinfosex"].html("女");
                        break;
                    case "S" :
                        break;
                }
            me.elems["baseinfobirthdate"].html(myInfo.userinfo.birthdate);
            me.elems["baseinfodescript"].html(myInfo.userinfo.description);
        },
        /**
         * 选择调查问卷列表处理器
         * @param  {Event} evt
         */
        surveybtnUp : function(evt) {
            var myInfo = Trafficeye.getMyInfo();
            var me = this,
                baseinfoElem = me.elems["baseinfo"],
                surveyElem = me.elems["survey"],
                 baseinfolistElem = me.elems["baseinfolist"],
                surveydescidElem = me.elems["surveydescid"],
                surveydescidhtml = me.elems["surveydescidhtml"],
                infousernameElem = me.elems["infousername"],
                surveybaseidElem = me.elems["surveybaseid"],
                surveyextidElem = me.elems["surveyextid"],
                pcarElem = me.elems["car"],
                pcardescidElem = me.elems["pcardescid"],
                pcarbaseidElem = me.elems["pcarbaseid"],
                modifyPwdidElem = me.elems["modifyPwdid"];
            
            surveyElem.addClass("curr");
            baseinfoElem.removeClass("curr");
            pcarElem.removeClass("curr");
            
            baseinfolistElem.css("display","none");
            modifyPwdidElem.css("display","none");
            surveydescidElem.css("display","");
            surveydescidhtml.css("display","");
            surveybaseidElem.css("display","");
            surveyextidElem.css("display","");
            pcardescidElem.css("display","none");
            pcarbaseidElem.css("display","none");
            var myInfo = Trafficeye.getMyInfo();
            if(myInfo.userinfo.realName){
                me.elems["suveryusername"].html(myInfo.userinfo.realName);
            }else{
                me.elems["suveryusername"].html("用于发放奖励");
            }
            me.elems["baseinfonicknameheader"].html(myInfo.userinfo.username);
            if(myInfo.userinfo.mobile){
                me.elems["suveryphonenumber"].html(myInfo.userinfo.mobile);
            }else{
                me.elems["suveryphonenumber"].html("用于发放奖励");
            }
            if(myInfo.userinfo.city){
                me.elems["suverycity"].html(myInfo.userinfo.city);
            }else{
                me.elems["suverycity"].html("用于调查地区分布");
            }
            var baseinfoGender = myInfo.userinfo.gender;
            switch(baseinfoGender)
                {
                    case "M" :
                        me.elems["suverysex"].html("男");
                        break;
                    case "F" :
                        me.elems["suverysex"].html("女");
                        break;
                    case "S" :
                        break;
                }
            if(myInfo.userinfo.birthdate){
                me.elems["suverybirthdate"].html(myInfo.userinfo.birthdate);
            }else{
                me.elems["suverybirthdate"].html("用于调查年龄分布");
            }
            me.reqSurveyInfo(myInfo.ua,myInfo.uid,myInfo.pid);
        },
        /**
         * 选择拼车列表处理器
         * @param  {Event} evt
         */
        carbtnUp : function(evt) {
            var myInfo = Trafficeye.getMyInfo();
            var me = this,
                baseinfoElem = me.elems["baseinfo"],
                surveyElem = me.elems["survey"],
                 baseinfolistElem = me.elems["baseinfolist"],
                surveydescidElem = me.elems["surveydescid"],
                surveydescidhtml = me.elems["surveydescidhtml"],
                infousernameElem = me.elems["infousername"],
                surveybaseidElem = me.elems["surveybaseid"],
                surveyextidElem = me.elems["surveyextid"],
                pcarElem = me.elems["car"],
                pcardescidElem = me.elems["pcardescid"],
                pcarbaseidElem = me.elems["pcarbaseid"],
                modifyPwdidElem = me.elems["modifyPwdid"];
            
            surveyElem.removeClass("curr");
            baseinfoElem.removeClass("curr");
            pcarElem.addClass("curr");
            // Trafficeye.offlineStore.set("traffic_infosurveycar","car");
            
            baseinfolistElem.css("display","none");
            modifyPwdidElem.css("display","none");
            surveydescidElem.css("display","none");
            surveydescidhtml.css("display","none");
            surveybaseidElem.css("display","none");
            surveyextidElem.css("display","none");
            pcardescidElem.css("display","");
            pcarbaseidElem.css("display","");
            var myInfo = Trafficeye.getMyInfo();
            
            me.elems["pcarusername"].html(myInfo.userinfo.realName);
            me.elems["pcarmobile"].html(myInfo.userinfo.mobile);
            me.elems["pcarcity"].html(myInfo.userinfo.city);
            var carGender = myInfo.userinfo.gender;
            switch(carGender)
                {
                    case "M" :
                        me.elems["pcarsex"].html("男");
                        break;
                    case "F" :
                        me.elems["pcarsex"].html("女");
                        break;
                    case "S" :
                        break;
                }
            me.elems["pcarbirthday"].html(myInfo.userinfo.birthdate);
            if(myInfo.userinfo.carNum){
                me.elems["pcarcarnumber"].html(myInfo.userinfo.carNum);
            }else{
                me.elems["pcarcarnumber"].html("选填，用于线上交流");
            }
            if(myInfo.userinfo.wxNum){
                me.elems["pcarweixin"].html(myInfo.userinfo.wxNum);
            }else{
                me.elems["pcarweixin"].html("选填，用于线上交流");
            }
            if(myInfo.userinfo.qq){
                me.elems["pcarqqnum"].html(myInfo.userinfo.qq);
            }else{
                me.elems["pcarqqnum"].html("选填，用于线上交流");
            }
        },
        /**
         * 查询调查问卷问题的内容
         */
        reqSurveyInfo : function(ua,uid,pid) {
            
            var url = Trafficeye.BASE_USER_URL + "userInfoPrize";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : ua,
                "pid" : pid,
                "uid" : uid
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
                                me.reqSurveyInfoSuccess(data.info);
                            } else{
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
         * 渲染调查问卷问题的页面部分
         * @param  {JSON Object} data
         * @param  {Boolean} flag 是否是自己的信息界面
         */
        reqSurveyInfoSuccess : function(dataSource) {
            var me = this,
            surveyextincomeElem = me.elems["surveyextincome"],
            surveyexttravelElem = me.elems["surveyexttravel"],
            surveyextcartimeElem = me.elems["surveyextcartime"],
            surveyextcarElem = me.elems["surveyextcar"],
            surveyextbuytimeElem = me.elems["surveyextbuytime"],
            surveyextmanyElem = me.elems["surveyextmany"],
            surveyextfirstElem = me.elems["surveyextfirst"];
            // console.log(dataSource);
            surveyextincomeElem.html(dataSource.income);
            surveyexttravelElem.html(dataSource.ways);
            surveyextcartimeElem.html(dataSource.driveTime);
            surveyextcarElem.html(dataSource.brand);
            surveyextbuytimeElem.html(dataSource.buyTime);
            surveyextmanyElem.html(dataSource.whichCar);
            surveyextfirstElem.html(dataSource.licenseTime);
        },
        //设置昵称的onclick事件响应函数
        infonicknameClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_nickname.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置真实姓名的onclick事件响应函数
        inforelnameClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_relname.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置手机号码的onclick事件响应函数
        infomobileClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_mobile.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置所在城市的onclick事件响应函数
        infocityClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_city.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置性别的onclick事件响应函数
        infosexClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_sex.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置生日的onclick事件响应函数
        infobirthdayClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_birthday.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置一句话简介的onclick事件响应函数
        infodescriptionClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_desc.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //修改密码的onclick事件响应函数
        modifyPassword : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_modifypwd.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //调查问卷部分
        surveyextincomeClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_income.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyexttravelClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_travel.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyextcartimeClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_cartime.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyextcarClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_car.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyextbuytimeClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_buytime.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyextmanyClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_many.html");
            }),Trafficeye.MaskTimeOut);     
        },
        surveyextfirstClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_first.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置真实姓名的onclick事件响应函数
        suveryrelnameClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_relname.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置手机号码的onclick事件响应函数
        suverymobileClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_mobile.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置所在城市的onclick事件响应函数
        suverycityClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_city.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置性别的onclick事件响应函数
        suverysexClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_sex.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //设置生日的onclick事件响应函数
        suverybirthdayClick : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_survey_birthday.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //跳转到拼车的onclick事件响应函数
        //查看他发布的动态
         pcarusername: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_relname.html");
             }), Trafficeye.MaskTimeOut);

         },
         //查看他发布的动态
         pcarmobile: function(evt) {

          
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_mobile.html");
             }), Trafficeye.MaskTimeOut);

         },
         //查看他发布的动态
         pcarcity: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_city.html");
             }), Trafficeye.MaskTimeOut);
           
         },
         //查看他发布的动态
         pcarsex: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_sex.html");
             }), Trafficeye.MaskTimeOut);
        
         },
         //查看他发布的动态
         pcarbirthday: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_birthday.html");
             }), Trafficeye.MaskTimeOut);
          
         },
         //查看他发布的动态
         pcarcarnumber: function(evt) {
 
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_carnum.html");
             }), Trafficeye.MaskTimeOut);
           
         },
         //查看他发布的动态
         pcarweixin: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_weixin.html");
             }), Trafficeye.MaskTimeOut);
           
         },
         //查看他发布的动态
         pcarqqnum: function(evt) {

             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 Trafficeye.toPage("pcar_qqnum.html");
             }), Trafficeye.MaskTimeOut);
          
         }
    };
    
    $(function(){
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage":"pre_baseinfo.html","currpage" : "pre_baseinfo.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         //获取我的用户信息
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            //让用户重新登录
            Trafficeye.toPage("pre_login.html");
        }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        var   baseinfobtnElem = pm.elems["baseinfo"],
                surveybtnElem = pm.elems["survey"],
                carbtnElem = pm.elems["car"],
                baseinfolistElem = pm.elems["baseinfolist"],
                surveydescidElem = pm.elems["surveydescid"],
                surveydescidhtml = pm.elems["surveydescidhtml"],
                infousernameElem = pm.elems["infousername"],
                surveybaseidElem = pm.elems["surveybaseid"],
                surveyextidElem = pm.elems["surveyextid"],
                pcardescidElem = pm.elems["pcardescid"],
                pcarbaseidElem = pm.elems["pcarbaseid"],
                modifyPwdidElem = pm.elems["modifyPwdid"];
            //info表示点击个人信息编辑按钮跳转过来的，survey表示点击调查问卷按钮跳转过来的,car表示拼车
            var baseinfoPageFlag = Trafficeye.offlineStore.get("traffic_infosurveycar");
            
            // baseinfoPageFlag = "survey";
            // alert(baseinfoPageFlag);
            switch(baseinfoPageFlag){
                case "info":
                // console.log(myInfo);
                    baseinfobtnElem.addClass("curr");
                    surveybtnElem.removeClass("curr");
                    carbtnElem.removeClass("curr");
                    baseinfolistElem.css("display","");
                    if(myInfo.userinfo.userType == "trafficeye"){
                        modifyPwdidElem.css("display","");
                    }
                    surveydescidElem.css("display","none");
                    surveydescidhtml.css("display","none");
                    surveybaseidElem.css("display","none");
                    surveyextidElem.css("display","none");
                    pcardescidElem.css("display","none");
                    pcarbaseidElem.css("display","none");
                    pm.baseinfobtnUp();
                    break;
                case "survey":
                    baseinfobtnElem.removeClass("curr");
                    surveybtnElem.addClass("curr");
                    carbtnElem.removeClass("curr");
                    baseinfolistElem.css("display","none");
                    modifyPwdidElem.css("display","none");
                    surveydescidElem.css("display","");
                    surveydescidhtml.css("display","");
                    surveybaseidElem.css("display","");
                    surveyextidElem.css("display","");
                    pcardescidElem.css("display","none");
                    pcarbaseidElem.css("display","none");
                    pm.surveybtnUp();
                    break;
                case "car":
                    baseinfobtnElem.removeClass("curr");
                    surveybtnElem.removeClass("curr");
                    carbtnElem.addClass("curr");
                    baseinfolistElem.css("display","none");
                    modifyPwdidElem.css("display","none");
                    surveydescidElem.css("display","none");
                    surveydescidhtml.css("display","none");
                    surveybaseidElem.css("display","none");
                    surveyextidElem.css("display","none");
                    pcardescidElem.css("display","");
                    pcarbaseidElem.css("display","");
                    pm.carbtnUp();
                    break;
                default:
                    baseinfobtnElem.addClass("curr");
                    surveybtnElem.removeClass("curr");
                    baseinfolistElem.css("display","");
                    if(myInfo.userinfo.userType == "trafficeye"){
                        modifyPwdidElem.css("display","");
                    }
                    surveydescidElem.css("display","none");
                    surveydescidhtml.css("display","none");
                    surveybaseidElem.css("display","none");
                    surveyextidElem.css("display","none");
                    // pm.baseinfobtnUp(evt);
                    pm.baseinfobtnUp();
                    break;
            }
        // 设置头像成功的回调函数
        window.callbackSetUserAvatar = function(data){
            Trafficeye.httpTip.closed();
            var myInfo = Trafficeye.getMyInfo();
            //把用户信息写入到本地
            //pid,ua,userinfo存入到浏览器本地缓存
            var userinfodata = {
                "pid" : myInfo.pid,
                "ua" : myInfo.ua,
                "uid" : myInfo.uid,
                "friend_uid" : data.uid,
                "isEdit" : myInfo.isEdit,
                "userinfo" : Trafficeye.str2Json(data)
            };
            var dataStr = Trafficeye.json2Str(userinfodata);
            Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
        }
        
        //设置头像处理函数，回调方法callbackSetUserAvatar
        window.infoimgClick = function(evt) {
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.setUserAvatar();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc:??setUserAvatar");
            } else {
                alert("调用设置头像接口,PC不支持.");
            }
        };
        
        window.infonicknameClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infonicknameClick(evt);
            }
        };
        
        window.inforelnameClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.inforelnameClick(evt);
            }
        };
        
        window.suveryrelnameClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.suveryrelnameClick(evt);
            }
        };
        
        window.infomobileClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infomobileClick(evt);
            }
        };
                     
        window.suverymobileClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.suverymobileClick(evt);
            }
        };
        
        window.infocityClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infocityClick(evt);
            }
        };
        
        window.suverycityClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.suverycityClick(evt);
            }
        };
        
        window.infosexClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infosexClick(evt);
            }
        };
        
        window.suverysexClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.suverysexClick(evt);
            }
        };
        
        window.infobirthdayClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infobirthdayClick(evt);
            }
        };
        
        window.suverybirthdayClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.suverybirthdayClick(evt);
            }
        };
        
        window.infodescriptionClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.infodescriptionClick(evt);
            }
        };
        //修改密码
        window.modifyPassword = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.modifyPassword(evt);
            }
        };
        //调查问卷部分
        window.surveyextincomeClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyextincomeClick(evt);
            }
        };
        window.surveyexttravelClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyexttravelClick(evt);
            }
        };
        window.surveyextcartimeClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyextcartimeClick(evt);
            }
        };
        window.surveyextcarClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyextcarClick(evt);
            }
        };
        window.surveyextbuytimeClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyextbuytimeClick(evt);
            }
        };
        window.surveyextmanyClick = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.surveyextmanyClick(evt);
            }
        };
        //拼车
        //真实姓名
         window.pcarusername = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarusername(evt);
             }
         };
         //手机号码
         window.pcarmobile = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarmobile(evt);
             }
         };
         //所在城市
         window.pcarcity = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarcity(evt);
             }
         };
         //性别
         window.pcarsex = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarsex(evt);
             }
         };
         //生日
         window.pcarbirthday = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarbirthday(evt);
             }
         };
         //车牌
         window.pcarcarnumber = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarcarnumber(evt);
             }
         };
         //微信
         window.pcarweixin = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarweixin(evt);
             }
         };
         //qq
         window.pcarqqnum = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.pcarqqnum(evt);
             }
         };
    }); 
    
 }(window));