﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

  <xsl:template match="/">
    <script>
      var meta = document.createElement('meta');
      meta.charset = "UTF-8";
      loadMeta(meta);

      var meta = document.createElement('meta');
      meta.httpEquiv = "X-UA-Compatible";
      meta.content = "IE=edge";
      loadMeta(meta);

      var meta = document.createElement('meta');
      meta.name = "viewport";
      meta.content = "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no";
      loadMeta(meta);


      $("body").addClass("lockscreen");
      $("body").addClass("hold-transition");
      $("body").addClass("sidebar-mini");
      $("body").addClass("fixed");


      //var lastPar=getCookie('lastPar');
      //if (lastPar=='') lastPar='index.aspx';
      //if (getCookie('lockScreen')=='1') window.location=lastPar;
      //setCookie('lockScreen',1);
      uid=getCookie('<xsl:value-of select="sqroot/header/info/account"/>'.toLowerCase()+'_userId');
      if(uid == undefined) window.location='index.aspx?code=login';
      $('#userImage').attr('src', getCookie('userURL'));
      $('#userName').html(getCookie('userName')+' ');


      function checkenter(e) {
      if (e.keyCode == 13) {
      if (getCookie('isWhiteAddress') == '1') {
      signIn('<xsl:value-of select="sqroot/header/info/account"/>');
      }
      else {
      signIn('<xsl:value-of select="sqroot/header/info/account"/>');
      }
      }
      }

		var n=new Date(Date.now());
		$('#cp').html($('#cp').html().split('#year#').join(n.getFullYear()));

    </script>
    <!-- Automatic element centering -->
    <div class="lockscreen-wrapper">
      <div class="lockscreen-logo">
        <a href="?">
          <xsl:value-of select="sqroot/header/info/company"/>&#160;
          <b>
            <xsl:value-of select="sqroot/header/info/productName" />
          </b><br/>
		  <xsl:value-of select="sqroot/header/info/suba" />
        </a>
      </div>
      <!-- User name -->
      <div class="lockscreen-name">
        <p id="userName"><xsl:value-of select="sqroot/header/info/user/userName"/></p>
      </div>

      <!-- START LOCK SCREEN ITEM -->
      <div class="lockscreen-item">
        <!-- lockscreen image -->
        <div class="lockscreen-image">
          <img id="userImage" src="OPHContent/documents/{sqroot/header/info/account}/{sqroot/header/info/user/userURL}" alt="User Image"/>
        </div>
        <!-- /.lockscreen-image -->

        <!-- lockscreen credentials (contains the form) -->
        <div class="input-group">
          <form id="signInForm" class="lockscreen-credentials">
            <input type="text" class="form-control" name ="userid" id ="userid" value="" style="display:none"/>
            <input type="password" class="form-control" name ="pwd" id ="pwd" autocomplete="off" placeholder="password" onkeypress="return checkenter(event)"/>
          </form>
          <div class="input-group-btn">
            <button type="button" class="btn" onclick="javasript:signIn('{/sqroot/header/info/account}');">
              <ix class="fa fa-arrow-right text-muted"></ix>
            </button>
          </div>
        </div>
        <!-- /.lockscreen credentials -->

      </div>
      <!-- /.lockscreen-item -->
      <div class="help-block text-center">
        Enter your password to retrieve your session
      </div>
      <div class="text-center">
        <a href="index.aspx">Or sign in as a different user</a>
      </div>
      <div id="cp" class="lockscreen-footer text-center">
        <strong>
          Copyright &#169; #year# <a href="#">operahouse.systems</a>.
        </strong> All rights reserved.

      </div>
    </div>
    <!-- /.center -->
    <!-- *** NOTIFICATION MODAL -->
    <div id="notiModal" class="modal fade" role="dialog" tabindex="-1">
      <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&#215;</button>
            <h4 class="modal-title" id="notiTitle">Modal Header</h4>
          </div>
          <div class="modal-body" id="notiContent">
            <p>Some text in the modal.</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>

      </div>
    </div>
    <!-- *** NOTIFICATION MODAL END -->

  </xsl:template>




</xsl:stylesheet>
