﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="colMenu">
    <xsl:choose>
      <xsl:when test="count(/sqroot/header/menus/menu[@code='primaryback']/submenus/submenu)=0">12</xsl:when>
      <xsl:when test="count(/sqroot/header/menus/menu[@code='primaryback']/submenus/submenu)=1">12</xsl:when>
      <xsl:when test="count(/sqroot/header/menus/menu[@code='primaryback']/submenus/submenu)=2">6</xsl:when>
      <xsl:otherwise>4</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

 
  <xsl:template match="/">
    <div style="display:none" id="pageName">&#xA0;</div>
    <div style="display:none" id="themeName">&#xA0;</div>											
    <script>
      sideShowInit();
      
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

      changeSkinColor();
      $("body").addClass("hold-transition");
      $("body").addClass("sidebar-mini");
      $("body").addClass("fixed");

      loadScript('OPHContent/cdn/admin-LTE/js/app.min.js');

      document.getElementById("pageName").innerHTML = getCookie('page');
      document.getElementById("themeName").innerHTML = getCookie('themeFolder');

      document.title='<xsl:value-of select="/sqroot/header/info/title"/>';

      resetBrowseCookies();
      loadContent(1);																
      setCookie('userURL', 'OPHContent/documents/<xsl:value-of select="sqroot/header/info/account" />/<xsl:value-of select="sqroot/header/info/user/userURL"/>', 7);
      setCookie('userName', '<xsl:value-of select="sqroot/header/info/user/userName"/>', 7);
      //setCookie('userId', '<xsl:value-of select="sqroot/header/info/user/userId"/>', 7);
      changeSkinColor;
      $('body').addClass('sidebar-collapse');



      sideShowProfile('<xsl:value-of select="/sqroot/header/info/title"/>', '<xsl:value-of select="/sqroot/header/info/user/userName"/>');
      $(document).ready(function () {
      if (getQueryVariable('help') == 1) Sideshow.start();
      });

		var n=new Date(Date.now());
		$('#cp').html($('#cp').html().split('#year#').join(n.getFullYear()));

    </script>

    <!-- Page script -->

    <header class="main-header">
      <!-- Logo -->
      <a href="javascript:goHome();" class="logo visible-phone" style="text-align:left;">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini" style="font-size:9px; text-align:center">
          <img width="30" src="OPHContent/themes/{/sqroot/header/info/themeFolder}/images/oph4_logo.png" alt="Logo Image" />
        </span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg" style="font-size:22px;">
          <div class="pull-left" style="margin-right:10px;">
            <img width="30" style="margin-top:-9px;" src="OPHContent/themes/{/sqroot/header/info/themeFolder}/images/oph4_logo.png" alt="Logo Image" />
          </div>
          <xsl:value-of select="sqroot/header/info/company" />
        </span>
      </a>
      <!-- Header Navbar: style can be found in header.less -->
      <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle visible-phone" data-toggle="offcanvas" role="button" >
          <span class="sr-only">Toggle navigation</span>
        </a>
        <div id ="button-menu-phone" class="unvisible-phone" style="color:white;  margin:0; display:inline-table; margin-top:15px; margin-left:10px" data-toggle="collapse" data-target="#mobilemenupanel">
          <a href="#" style="color:white;">
            <span>
              <img width="30" style="margin-top:-9px;" src="OPHContent/themes/{/sqroot/header/info/themeFolder}/images/oph4_logo.png" alt="Logo Image" />
            </span>&#160;
            <xsl:value-of select="sqroot/header/info/code/name"/>&#160;(<xsl:value-of select="sqroot/header/info/code/id"/>)<span class="caret"></span>
          </a>
        </div>
        <div class="accordian-body collapse top-menu-div" id="mobilemenupanel" style="color:white; position:absolute; background:#222D32; z-index:100; width:100%; right:0px; top:50px; ">
          <div class="input-group sidebar-form">
            <!--<input type="text" id="searchBox" name="searchBox" class="form-control" placeholder="Search..." onkeypress="return searchText(event,this.value);" value="" />-->
            <span class="input-group-btn">
              <button type="button" name="search" id="search-btn" class="btn btn-flat" onclick="searchText(event);">
                <ix class="fa fa-search" aria-hidden="true"></ix>
              </button>
            </span>
          </div>
          <div class="panel-group" id="accordion2">
            <xsl:apply-templates select="sqroot/header/menus/menu[@code='sidebar']/submenus/submenu" />
            &#160;
          </div>
        </div>
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
            <li>
              <a style="cursor:pointer;" onclick="Sideshow.start();" data-toggle="tooltip" data-placement="bottom" title="Help?">
                <ix class="fa fa-question-circle fa-lg"></ix>
              </a>
            </li>
            <li class="dropdown user user-menu">
              <xsl:choose>
                <xsl:when test="not(sqroot/header/info/user/userId)">
                  <a href="?code=login">
                    <span>
                      <ix class="fa fa-sign-in"></ix>&#160;
                    </span>
                    <span>Sign in</span>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                    <img src="OPHContent/documents/{sqroot/header/info/account}/{sqroot/header/info/user/userURL}" class="user-image" alt="User Image"/>
                    <span class="hidden-xs">
                      <xsl:value-of select="sqroot/header/info/user/userName"/>
                    </span>
                  </a>
                  <ul class="dropdown-menu">
                    <!-- User image -->
                    <li class="user-header">
                      <img src="OPHContent/documents/{sqroot/header/info/account}/{sqroot/header/info/user/userURL}" class="img-circle" alt="User Image"/>
                      <p>
                        <xsl:value-of select="sqroot/header/info/user/userName"/>
                        <small>
                          Active since <xsl:value-of select="sqroot/header/info/user/dateCreate"/>
                        </small>
                      </p>
                    </li>
                    <!-- Menu Body -->
                    <li class="user-body">
                      <div class="row">
                        <xsl:for-each select="sqroot/header/menus/menu[@code='primaryback']/submenus/submenu">
                          <div class="col-xs-{$colMenu} text-center">
                            <a class="withBorder" href="{pageURL}">
                              <xsl:value-of select="caption" />&#160;
                            </a>
                          </div>
                        </xsl:for-each>
                        <!--<xsl:apply-templates select="sqroot/header/menus/menu[@code='primaryback']/submenus/submenu" />-->
                      </div>
                    </li>
                    <!-- Menu Footer-->
                    <li class="user-footer">
                      <div class="pull-left">
                        <a href="?code=profile" class="btn btn-default btn-flat">
                          <span>
                            <ix class="fa fa-user"></ix>
                          </span>
                          <span>Profile</span>
                        </a>
                      </div>
                      <div class="pull-right">
                        <a href="javascript:signOut()" class="btn btn-default btn-flat">
                          <span>
                            <ix class="fa fa-power-off"></ix>
                          </span>
                          <span>Sign out</span>
                        </a>
                      </div>
                    </li>
                  </ul>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </ul>
        </div>
      </nav>
    </header>

    <!-- *** LOGIN MODAL ***-->
    <div class="modal fade" id="login-modal" tabindex="-1" role="dialog" aria-labelledby="signinLabel" aria-hidden="true">
      <div class="modal-dialog modal-sm" role="document">

        <div class="modal-content">
          <form id="signinForm" method="post">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&#215;</button>
              <h4 class="modal-title" id="signinLabel">Sign in</h4>
            </div>

            <div class="modal-body">
              <div class="form-group">
                <input type="text" class="form-control" id="userid" placeholder="user id" />
              </div>
              <div class="form-group">
                <input type="password" class="form-control" id="pwd" placeholder="password" />
              </div>

              <p class="text-center text-muted">Not registered yet?</p>
              <p class="text-center text-muted">
                <a href="customer-register.html">
                  <strong>Register now</strong>
                </a>! It is easy and done in 1&#160;minute and gives you access to special discounts and much more!
              </p>

            </div>
											  
            <div class="modal-footer">

              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
              <a href="javascript: signIn();">
                <button type="button" class="btn btn-primary">
                  <span>
                    <ix class="fa fa-sign-in"></ix>&#160;
                  </span>Sign In
                </button>
              </a>

            </div>
          </form>
        </div>
      </div>
    </div>
    <!-- *** LOGIN MODAL END *** -->				
    
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
			<button id="modal-btn-close" type="button" class="btn btn-warning" data-dismiss="modal">Close</button>
            <button id="modal-btn-cancel" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			<button id="modal-btn-confirm" type="button" class="btn btn-warning" data-dismiss="modal">Confirm</button>
          </div>
        </div>
      </div>
    </div>
    <!-- *** NOTIFICATION MODAL END -->

    <!-- Left side column. contains the logo and sidebar -->
    <aside  class="main-sidebar">
      <!-- sidebar: style can be found in sidebar.less -->
      <section id="sidebarWrapper" class="sidebar">
        <script>
          $("#searchBox").val(getSearchText());
          var c=getQueryVariable('code');
          try {
          $($('.treeview').children().find('a[href$="'+c+'"]')[0].parentNode.parentNode.parentNode.parentNode.parentNode).addClass('active');
          $($('.treeview').children().find('a[href$="'+c+'"]')[0].parentNode.parentNode.parentNode).addClass('active');
          $($('.treeview').children().find('a[href$="'+c+'"]')[0].parentNode).addClass('active');
          } catch(e) {}
        </script>
        <!-- search form -->
        <!--<form method="get" class="sidebar-form">-->
        <div class="user-panel">
          <div class="pull-left image">
            <img src="OPHContent/documents/{sqroot/header/info/account}/{sqroot/header/info/user/userURL}" class="img-circle" alt="User Image" />
          </div>
          <div class="pull-left info">
            <p>
              <xsl:value-of select="sqroot/header/info/user/userName"/>
            </p>
            <a href="#">
              <ix class="fa fa-circle text-success"></ix> Online
            </a>
          </div>
        </div>
        <div class="input-group sidebar-form">
          <input type="text" id="searchBox" name="searchBox" class="form-control" placeholder="Search..." onkeypress="return searchText(event,this.value);" value="" />
          <span class="input-group-btn">
            <button type="submit" name="search" id="search-btn" class="btn btn-flat">
              <ix class="fa fa-search" aria-hidden="true"></ix>
            </button>
          </span>
        </div>
        <!--</form>-->
        <!-- sidebar menu: : style can be found in sidebar.less -->
        <ul class="sidebar-menu">
          <xsl:apply-templates select="sqroot/header/menus/menu[@code='sidebar']/submenus/submenu" />
        </ul>

      </section>


      <!-- /.sidebar -->
    </aside>
    
    <!-- Content Wrapper. Contains page content -->
    <div id="contentWrapper" class="content-wrapper">
      <section class="content-header">
        <h1>
          User Profile
        </h1>
        <ol class="breadcrumb">
          <li>
            <a href="#">
              <span>
                <ix class="fa fa-dashboard"></ix>
              </span> Home
            </a>
          </li>
          <li>
            <a href="#">Account</a>
          </li>
          <li class="active">User profile</li>
        </ol>
      </section>

      <!-- Main content -->
      <section class="content">

        <div class="row">
          <div class="col-md-3">

            <!-- Profile Image -->
            <div id="profileBox" class="box box-primary">
              <xsl:for-each select="sqroot/body/bodyContent/profile/row">
                <xsl:if test="type = 'file'">
                  <div style="float:right;position:inherit;display:none;" id="uploadBox" onmouseover="showUploadBox('uploadBox', 1);">
                    <button onclick="uploadBox('{@key}', 'formProfile', 'profile', '{/sqroot/body/bodyContent/info/GUID}' )" style="position:absolute;top:10px;right:15px;background:none;border:none; color:blue;" title="upload your poto profile" >
                      <ix class="fa fa-upload fa-lg"></ix>
                    </button>
                  </div>
                </xsl:if>              
              </xsl:for-each>
              <div class="box-body box-profile" onmouseover="showUploadBox('uploadBox', 1);" onmouseout="showUploadBox('uploadBox', 0);">
                <img class="profile-user-img img-responsive img-circle" src="OPHContent/documents/{sqroot/header/info/account}/{sqroot/body/bodyContent/browse/bodyContent/info/foto}" alt="User profile picture"/>
                <h3 class="profile-username text-center">
                  <xsl:value-of select="sqroot/body/bodyContent/info/name"/>
                </h3>
                <p class="text-muted text-center">
                  <xsl:value-of select="sqroot/body/bodyContent/info/id"/>
                </p>
                <p class="text-muted text-center">
                  <xsl:value-of select="sqroot/body/bodyContent/info/carolid"/>
                </p>
              </div>
            </div>
            <!-- /.box -->

            <!-- About Me Box -->
            <div id="aboutMeBox" class="box box-primary">
              <div class="box-header with-border">
                <h3 class="box-title">About Me</h3>
              </div>
              <!-- /.box-header -->
              <div class="box-body">
                <strong>
                  <span>
                    <ix class="fa fa-briefcase"></ix>
                  </span> position
                </strong>
                <p class="text-muted">
                  <xsl:value-of select="sqroot/body/bodyContent/info/position"/>
                </p>
                <hr/>
                <strong>
                  <span>
                    <ix class="fa fa-envelope"></ix>
                  </span> e-mail
                </strong>
                <p class="text-muted">
                  <xsl:value-of select="sqroot/body/bodyContent/info/email"/>
                </p>
                <hr/>
                <strong>
                  <span>
                    <ix class="fa fa-phone-square"></ix>
                  </span> home phone
                </strong>
                <p class="text-muted">
                  <xsl:value-of select="sqroot/body/bodyContent/info/homephone"/>
                </p>
                <hr/>
                <strong>
                  <span>
                    <ix class="fa fa-mobile-phone"></ix>
                  </span> mobile phone
                </strong>
                <p class="text-muted">
                  <xsl:value-of select="sqroot/body/bodyContent/info/mobilephone"/>
                </p>
              </div>
            </div>
          </div>

          <div id="profileTabBox" class="col-md-9">
            <div class="nav-tabs-custom">
              <!--Menu Tab-->
              <ul class="nav nav-tabs">
                <li class="active">
                  <a href="#password" data-toggle="tab">Change Password</a>
                </li>
                <!--li>
                  <a href="#journal" data-toggle="tab">Journal</a>
                </li>
                <li>
                  <a href="#profile" data-toggle="tab">Profile</a>
                </li-->
                <li>
                  <a href="#delegation" data-toggle="tab">Delegation</a>
                </li>
              </ul>
              
              <div class="tab-content">
                <!--Journal Content-->
                <div class="tab-pane" id="journal">
                  <ul class="timeline timeline-inverse">
                    <xsl:for-each select="sqroot/body/bodyContent/journal/item">
                      <xsl:choose>
                        <xsl:when test="@label = 1 and @no = 1">
                          <li class="time-label">
                            <span class="bg-blue">
                              <xsl:value-of select="@date"/>
                            </span>
                          </li>
                        </xsl:when>
                        <xsl:when test="@label = 1 and @no &gt; 1">
                          <li class="time-label">
                            <span class="bg-gray">
                              <xsl:value-of select="@date"/>
                            </span>
                          </li>
                        </xsl:when>
                        <xsl:otherwise>
                          
                        </xsl:otherwise>
                      </xsl:choose>

                      <xsl:choose>
                        <xsl:when test="@no = 1">
                          <li>
                            <ix class="fa fa-bell bg-blue"></ix>
                          </li>
                        </xsl:when>
                        <xsl:otherwise>
                          <li>
                            <ix class="fa fa-bell bg-gray"></ix>
                          </li>
                        </xsl:otherwise>
                      </xsl:choose>

                      <li>
                        <div class="timeline-item">
                          <span class="time">
                            <span>
                              <ix class="fa fa-clock-o"></ix>
                            </span>
                            <xsl:value-of select="@time"/>
                          </span>
                          <h3 class="timeline-header" id="id_{@no}">
                            <xsl:value-of select="comment"/>
                          </h3>
                        </div>
                      </li>                      
                    </xsl:for-each>
                    <li>
                      <ix class="fa fa-clock-o bg-gray"></ix>
                    </li>
                  </ul>
                </div>
                
                <!--Profile Content-->
                <div class="tab-pane" id="profile">
                  <form class="form-horizontal" id="formProfile">
                    <xsl:apply-templates select="sqroot/body/bodyContent/profile"/>
                  </form>
                </div>
                
                <!--Delegation Content-->
                <div class="tab-pane" id="delegation">
                  <div class="form-horizontal" >
                    <div class="form-group">
                      <div class="col-sm-5">
                        <p style="font-weight:bold;float:left;">Delegate to :</p>
                        <span style="color:red;float:right;">required field</span>
                      </div>
                      <div class="col-sm-5">
                        <p style="font-weight:bold;float:left;">for Modules :</p>
                        <span style="color:red;float:right;">required field</span>
                      </div>
                      <div class="col-sm-2">
                        &#160;
                      </div>                    
                    </div>                    
                    <div id="deleparent">
                      <div class="form-group" id="delechild0" style="display:none;" >
                        <form id="formDelegate0">
                          <input type="hidden" id="guid0" value=""/>
                          <input type="hidden" id="UserGUID0" name="UserGUID0" value="{/sqroot/body/bodyContent/info/GUID}"/>
                          <div class="col-sm-5">
                            <input type="text" class="form-control" id="TokenDelegate0" name="TokenDelegate0" data-type="tokenBox" data-old-value ="" value="" />
                          </div>
                          <div class="col-sm-5">
                            <input type="text" class="form-control" id="TokenModule0" name="TokenModule0" data-type="tokenBox" data-old-value ="" value="" />
                          </div>
                          <div class="col-sm-2">
                            <button type="button" class="btn btn-warning" id="btn-del0" data-toggle="tooltip" title="Delete This Entry?" 
                              data-target="#notiModal" data-caption="Deleting Entry" data-msg="Are you sure you want to delete this entry ?" 
                                onclick="showModal(this, 'delete', 'formDelegate0', 'delechild0', '')" >
                              <ix class="fal fa-trash" aria-hidden="true"></ix>
                            </button>
                            <button type="button" class="btn btn-success" id="btn-save0" data-toggle="tooltip" title="Save This Entry?" 
                              data-target="#notiModal" data-caption="Saving Entry" data-msg="Are you sure you want to save this entry ?" 
                                onclick="showModal(this, 'save', 'formDelegate0', 'delechild0', '')" disabled="disabled">
                              <ix class="fal fa-save" aria-hidden="true"></ix>
                            </button>
                          </div>  
                        </form>
                      </div>                    
                      <xsl:apply-templates select="sqroot/body/bodyContent/delegation" />                    
                    </div>
                    <div class="form-group">
                      <div class="col-sm-10">
                        <button type="button" class="btn btn-primary" id="addele" onclick="addNewDele(this);" >
                          <ix class="fa fa-plus" aria-hidden="true"></ix>
                          &#160; Add New Delegation
                        </button>
                      </div>
                    </div>
                  </div>
                </div>

                <!--Password Content-->
                <div class="active tab-pane" id="password">
                  <form class="form-horizontal" id="formPass">
                    <div class="form-group">
                      <label for="curPass" class="col-sm-3 control-label">Current Password</label>
                      <div class="col-sm-6">
                        <span id="ecurPass" style="color:red;display:none;">&#160;</span>
                        <input type="password" class="form-control" id="curPass" value="" onblur="checkPassProfile('curPass')" />
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="newPass" class="col-sm-3 control-label">New Password</label>
                      <div class="col-sm-6">
                        <span id="enewPass" style="color:red;display:none;">&#160;</span>
                        <input type="password" class="form-control" id="newPass" value="" onblur="checkPassProfile('newPass')" />
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="conPass" class="col-sm-3 control-label">Confirm Password</label>
                      <div class="col-sm-6">
                        <span id="econPass" style="color:red;display:none;">&#160;</span>
                        <input type="password" class="form-control" id="conPass" value="" onblur="checkPassProfile('conPass')" />
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="col-sm-offset-3 col-sm-7">
                        <span style="font-size:12px;">*) This action is only change this application password, not your windows password.</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="col-sm-offset-3 col-sm-7">
                        <button type="button" class="btn btn-danger" id="btn_pass" onclick="changePassProfile()" disabled="disabled">Submit</button>
                      </div>
                    </div>
                  </form>
                </div>

                <!-- /.tab-pane -->
              </div>
              <!-- /.tab-content -->
            </div>
            <!-- /.nav-tabs-custom -->
          </div>
          <!-- /.col -->
        </div>
        <!-- /.row -->

      </section>
    </div>
    <!-- /.content-wrapper -->
    <footer class="main-footer">
      <div class="pull-right hidden-xs">
        <b>Version</b> 4.0
      </div>
	  <div id="cp">
		  <strong>
			Copyright &#169; #year# <a href="#">operahouse.systems</a>.
		  </strong> All rights reserved.
	  </div>
    </footer>

    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
      <!-- Create the tabs -->
      <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
        <li>
          <a href="#control-sidebar-home-tab" data-toggle="tab">
            <ix class="fa fa-home"></ix>
          </a>
        </li>
        <li>
          <a href="#control-sidebar-settings-tab" data-toggle="tab">
            <ix class="fa fa-gears"></ix>
          </a>
        </li>
      </ul>

    </aside>
    <!-- /.control-sidebar -->
    <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
    <div class="control-sidebar-bg">&#160;</div>

    <!-- ./wrapper -->
    <script>
      $(document).ready(function(){
      $("#button-menu-phone").click(function(){
      $('#right-menu-phone').removeClass("in");

      });
      $("#button-menu-phone2").click(function(){
      $('#mobilemenupanel').removeClass("in");


      });
      $('.expand-td').click(function(){
      var target = $(this).attr('data-target');
      // alert(target);
      var ids = $('.browse-data').map(function() {
      var id = this.id;
      if ('#'+id != target){
      // alert(id);
      $('#'+id).attr('class', 'browse-data accordian-body collapse');
      }
      // this.id.removeClass(in)
      // alert(this.id);
      })

      // alert(ids); // Result: a,b,c,d
      });
      });
    </script>

  </xsl:template>

  <xsl:include href="_menu.xslt" />
  
  <xsl:template match="sqroot/body/bodyContent/profile">
    <xsl:for-each select="row">
      <xsl:choose>
        <xsl:when test="@isViewable=1">
          <div class="form-group">
            <label for="{@key}" class="col-sm-3 control-label">
              <xsl:value-of select="caption"/>
            </label>

            <div class="col-sm-8">
              <xsl:choose>
                <xsl:when test="type = 'number'">
                  <input type="{type}" min="0" class="form-control" id="{@key}" name="{@key}" data-old="{value}" value="{value}" onchange="profileOnChange('{@key}')" />                                
                </xsl:when>
                <xsl:when test="type = 'textarea'">
                  <xsl:choose>
                    <xsl:when test="value != ''">
                      <textarea class="form-control" id="{@key}" name="{@key}" data-old="{value}" onchange="profileOnChange('{@key}')" > 
                        <xsl:value-of select="value"/>                                    
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <textarea class="form-control" id="{@key}" name="{@key}" data-old="{value}" onchange="profileOnChange('{@key}')" >&#160;</textarea>
                    </xsl:otherwise>                                    
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <input type="{type}" class="form-control" id="{@key}" name="{@key}" data-old="{value}" value="{value}" onchange="profileOnChange('{@key}')" />                                
              </xsl:otherwise>                              
              </xsl:choose>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="form-group">
            <div class="col-sm-8">
              <xsl:choose>
                <xsl:when test="type = 'file'">
                  <input type="file" class="form-control" id ="{@key}_file" style="visibility: hidden; width: 0; height: 0;" />
                  <input type="hidden" class="form-control" id="{@key}" name="{@key}" value="{value}"/>                                
                </xsl:when>
                <xsl:otherwise>
                  <input type="hidden" class="form-control" id="{@key}" name="{@key}" value="{value}"/>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </xsl:otherwise>                      
      </xsl:choose>
    </xsl:for-each>                 
    <div class="form-group">
      <div class="col-sm-offset-3 col-sm-8">
        <button type="button" class="btn btn-success" id="save_profile" onclick="saveProfile('formProfile', 'profile', '{/sqroot/body/bodyContent/info/GUID}' )"
          data-loading-text="Processing..." data-text="Save Profile" disabled="disabled">
            Save Profile
        </button>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="sqroot/body/bodyContent/delegation">
    <xsl:for-each select="row">
      <div class="form-group" id="delechild{@no}">
        <form id="formDelegate{@no}">        
          <input type="hidden" id="guid{@no}" value="{@GUID}"/>
          <input type="hidden" id="UserGUID{@no}" name="UserGUID{@no}" value="{/sqroot/body/bodyContent/info/GUID}"/>
          <div class="col-sm-5">
            <input type="text" class="form-control" id="TokenDelegate{@no}" name="TokenDelegate{@no}" data-type="tokenBox" data-old-value="{tokenDelegate/value}" value="{tokenDelegate/value}" />
          </div>
          <div class="col-sm-5">
            <input type="text" class="form-control" id="TokenModule{@no}" name="TokenModule{@no}" data-type="tokenBox" data-old-value="{tokenModule/value}" value="{tokenModule/value}" />
          </div>
          <div class="col-sm-2">
            <button type="button" class="btn btn-warning" id="btn-del{@no}" data-toggle="tooltip" title="Delete This Entry?" data-target="#notiModal" 
              data-caption="Deleting Entry" data-msg="Are you sure you want to delete this entry ?" onclick="showModal(this, 'delete', 'formDelegate{@no}', 'delechild{@no}', '{@GUID}')" >
              <ix class="fa fa-trash-o" aria-hidden="true"></ix>
            </button>
            <button type="button" class="btn btn-success" id="btn-save{@no}" data-toggle="tooltip" title="Save This Entry?" 
              data-target="#notiModal" data-caption="Saving Entry" data-msg="Are you sure you want to save this entry ?" 
                onclick="showModal(this, 'save', 'formDelegate{@no}', 'delechild{@no}', '{@GUID}')" disabled="disabled">
              <ix class="fa fa-floppy-o" aria-hidden="true"></ix>
            </button>
          </div>              
        </form>
        <script type="text/javascript">
          //TokenDelegate
          var urlTokenDelegate<xsl:value-of select="@no"/> = 'OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=userdele&amp;colkey=TokenDelegate'
          var curlTokenDelegate<xsl:value-of select="@no"/> = 'OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=userdele&amp;colkey=TokenDelegate&amp;search=<xsl:value-of select="tokenDelegate/value"/>';                  
          $.ajax({
              url: curlTokenDelegate<xsl:value-of select="@no"/>, dataType: 'json', success: function (data) {
                  $('#TokenDelegate<xsl:value-of select="@no"/>').tokenInput(urlTokenDelegate<xsl:value-of select="@no"/>, {
                      hintText: "please type...", searchingText: "Searching...", preventDuplicates: true, allowCustomEntry: false, highlightDuplicates: false,
                      tokenDelimiter: "*", theme: "facebook", prePopulate: data,
                      onAdd: function(x) {  checkToken('TokenDelegate<xsl:value-of select="@no"/>'); },
                      onDelete: function(x) { checkToken('TokenDelegate<xsl:value-of select="@no"/>'); }
                  });
              }
          });
          
          //TokenModule
          var urlTokenModule<xsl:value-of select="@no"/> = 'OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=userdele&amp;colkey=TokenModule'
          var curlTokenModule<xsl:value-of select="@no"/> = 'OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=userdele&amp;colkey=TokenModule&amp;search=<xsl:value-of select="tokenModule/value"/>';                  
          $.ajax({
              url: curlTokenModule<xsl:value-of select="@no"/>, dataType: 'json', success: function (data) {
                  $('#TokenModule<xsl:value-of select="@no"/>').tokenInput(urlTokenModule<xsl:value-of select="@no"/>, {
                      hintText: "please type...", searchingText: "Searching...", preventDuplicates: true, allowCustomEntry: false, highlightDuplicates: false,
                      tokenDelimiter: "*", theme: "facebook", prePopulate: data,
                      onAdd: function(x) {  checkToken('TokenModule<xsl:value-of select="@no"/>'); },
                      onDelete: function(x) { checkToken('TokenModule<xsl:value-of select="@no"/>'); }
                  });
              }
          });         
        </script>      
      </div>                    
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
