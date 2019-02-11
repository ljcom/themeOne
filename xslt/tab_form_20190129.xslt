<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:decimal-format name="comma-dec" decimal-separator="," grouping-separator="."/>
  <xsl:decimal-format name="dot-dec" decimal-separator="." grouping-separator=","/>
  <xsl:variable name="allowAdd" select="/sqroot/body/bodyContent/form/info/permission/allowAdd" />
  <xsl:variable name="allowEdit" select="/sqroot/body/bodyContent/form/info/permission/allowEdit" />
  <xsl:variable name="allowAccess" select="/sqroot/body/bodyContent/form/info/permission/allowAccess" />
  <xsl:variable name="allowForce" select="/sqroot/body/bodyContent/form/info/permission/allowForce" />
  <xsl:variable name="allowDelete" select="/sqroot/body/bodyContent/form/info/permission/allowDelete" />
  <xsl:variable name="allowWipe" select="/sqroot/body/bodyContent/form/info/permission/allowWipe" />
  <xsl:variable name="allowOnOff" select="/sqroot/body/bodyContent/form/info/permission/allowOnOff" />
  <xsl:variable name="settingMode" select="/sqroot/body/bodyContent/form/info/settingMode/." />
  <xsl:variable name="docState" select="/sqroot/body/bodyContent/form/info/state/status/."/>
  <xsl:variable name="isApprover" select="/sqroot/body/bodyContent/form/info/document/isApprover"/>
  <xsl:variable name="cid" select="/sqroot/body/bodyContent/form/info/GUID/."/>
  <xsl:variable name="colMax">
    <xsl:for-each select="/sqroot/body/bodyContent/form/formPages/formPage/formSections/formSection/formCols/formCol">
      <xsl:sort select="@colNo" data-type="number" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="@colNo"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/">
    <!-- Content Header (Page header) -->
    <script>
      //loadScript('OPHContent/cdn/daterangepicker/daterangepicker.js');
      //loadScript('OPHContent/cdn/select2/select2.full.min.js');

      var xmldoc = ""
      var xsldoc = "OPHContent/themes/<xsl:value-of select="/sqroot/header/info/themeFolder"/>/xslt/" + getPage();
      <xsl:if test="sqroot/body/bodyContent/form/info/GUID!='00000000-0000-0000-0000-000000000000'">
        $('#button_save').hide();
        $('#button_cancel').hide();
        $('#button_save2').hide();
        $('#button_cancel2').hide();

        $('.action-save').hide();
        $('.action-cancel').hide();
      </xsl:if>

      var deferreds = [];
      cell_defer(deferreds);
      $(function () {

      <!--//Date picker-->
      $('.datepicker').datepicker({autoclose: true});

      <!--//Date time picker-->
      $('.datetimepicker').datetimepicker();

      $(".timepicker").timepicker({
      minuteStep: 15,
      template: 'modal',
      appendWidgetTo: 'body',
      showSeconds: false,
      showMeridian: false,
      defaultTime: false
      });

      <!--//iCheck for checkbox and radio inputs-->
      $('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
      checkboxClass: 'icheckbox_minimal-blue',
      radioClass: 'iradio_minimal-blue'
      });
      <!--//Red color scheme for iCheck-->
      $('input[type="checkbox"].minimal-red, input[type="radio"].minimal-red').iCheck({
      checkboxClass: 'icheckbox_minimal-red',
      radioClass: 'iradio_minimal-red'
      });
      <!--//Flat red color scheme for iCheck-->
      $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
      checkboxClass: 'icheckbox_flat-green',
      radioClass: 'iradio_flat-green'
      });


      });

      $.when.apply($, deferreds).done(function() {
      preview('1', getCode(), '<xsl:value-of select="/sqroot/body/bodyContent/form/info/GUID/."/>','formheader', this);
      });

      var c='<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>';
      getHash(c);
      setCookie('<xsl:value-of select="translate(/sqroot/body/bodyContent/form/info/code/., $uppercase, $smallcase)"/>_curstateid', '<xsl:value-of select="/sqroot/body/bodyContent/form/info/state/status/."/>');
      $('body').addClass('sidebar-collapse');

      var origin=window.location.origin;
      if (!(origin.substring(0,5)=='https' || origin.includes('localhost')))
      {
      $('#getImage').css("display", "block");
      $('#opencamera').css("display", "none");
      $('#takesnapshot').css("display", "none");
      $('#takeanother').css("display", "none");
      $('#savephoto').css("display", "none");

      }
      upload_init('<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>');
    </script>

    <xsl:variable name="settingmode">
      <xsl:value-of select="/sqroot/body/bodyContent/form/info/settingMode/."/>
    </xsl:variable>
    <xsl:variable name="documentstatus">
      <xsl:value-of select="/sqroot/body/bodyContent/form/info/state/status/."/>
    </xsl:variable>

    <xsl:variable name="headlabel">
      <xsl:choose>
        <xsl:when test="sqroot/body/bodyContent/form/info/GUID='00000000-0000-0000-0000-000000000000'">
          NEW
        </xsl:when>
        <xsl:when test="(($allowEdit>=1 or $allowAdd>=1 or $allowDelete>=1) and (/sqroot/body/bodyContent/form/info/state/status=0 or /sqroot/body/bodyContent/form/info/state/status=300))
							or (($allowEdit>=3 or $allowDelete>=3) and /sqroot/body/bodyContent/form/info/state/status&lt;=300)
							or (($allowEdit>=4 or $allowAdd>=4 or $allowDelete>=4) and /sqroot/body/bodyContent/form/info/state/status&lt;=400)">
          EDIT
        </xsl:when>
        <xsl:otherwise>
          VIEW
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <section class="content-header visible-phone">
      <h1 data-toggle="collapse" data-target="#header" id="header_title">
        <xsl:choose>
          <xsl:when test="sqroot/body/bodyContent/form/info/GUID='00000000-0000-0000-0000-000000000000'">
            <xsl:value-of select="$headlabel" />&#160;<xsl:value-of select="translate(sqroot/body/bodyContent/form/info/Description/., $smallcase, $uppercase)"/>
          </xsl:when>
          <xsl:when test="(sqroot/body/bodyContent/form/info/GUID)!='00000000-0000-0000-0000-000000000000' and /sqroot/body/bodyContent/form/info/settingMode/.='T'">
            <xsl:value-of select="$headlabel" />&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/docNo/."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$headlabel" />&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/id/."/>
          </xsl:otherwise>
        </xsl:choose>

      </h1>
      <ol class="breadcrumb">
        <li>
          <a href="javascript:goHome();">
            <span>
              <ix class="fa fa-home"></ix>
            </span>&#160;HOME
          </a>
        </li>
        <li>
          <a href="javascript: loadBrowse('{/sqroot/body/bodyContent/form/info/code/.}');">
            <span>
              <ix class="fa fa-file-o"></ix>
            </span>&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/Description/."/>
          </a>
        </li>
        <li class="active">
          <xsl:choose>
            <xsl:when test="sqroot/body/bodyContent/form/info/GUID='00000000-0000-0000-0000-000000000000'">
              NEW&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/Description/."/>
            </xsl:when>
            <xsl:when test="(sqroot/body/bodyContent/form/info/GUID)!='00000000-0000-0000-0000-000000000000' and /sqroot/body/bodyContent/form/info/settingMode/.='T'">
              EDIT&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/docNo/."/>
            </xsl:when>
            <xsl:otherwise>
              EDIT&#160;<xsl:value-of select="sqroot/body/bodyContent/form/info/id/."/>
            </xsl:otherwise>
          </xsl:choose>
        </li>
        <xsl:if test="sqroot/body/bodyContent/form/info/GUID!='00000000-0000-0000-0000-000000000000'">
          <li>
            <a style="color:blue" href="?code={/sqroot/body/bodyContent/form/info/code/.}&amp;guid=00000000-0000-0000-0000-000000000000">
              <span>
                <ix class="fa fa-plus-square"></ix>
              </span>
              Create New
            </a>
          </li>
        </xsl:if>
      </ol>
    </section>

    <!-- START CUSTOM TABS -->
    <!--<h2 class="page-header">CASH</h2>-->
    <section class="content">
      <form role="form" id="formheader" enctype="multipart/form-data" onsubmit="return false">
        <input type="hidden" id="cid" name="cid" value="{/sqroot/body/bodyContent/form/info/GUID/.}" />
        <input type="hidden" name ="{info/code/.}requiredname"/>
        <input type="hidden" name ="{info/code/.}requiredtblvalue"/>
      </form>
      <div class="row">
        <!--xsl:variable name="col">
          <xsl:choose>
            <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]">9</xsl:when>
            <xsl:otherwise>12</xsl:otherwise>
            </xsl:choose>
        </xsl:variable-->
        
          <div class="col-md-3">
            <xsl:variable name="fieldHead" select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/@fieldName" />
            <xsl:variable name="GTVal">
              <xsl:choose>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
                  <xsl:value-of select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/defaultvalue" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/value" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="tbContent">
              <xsl:choose>
                <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/digit = 0 and $GTVal!=''">
                  <xsl:value-of select="format-number($GTVal, '###,###,###,##0', 'dot-dec')"/>
                </xsl:when>
                <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/digit  = 1 and $GTVal!=''">
                  <xsl:value-of select="format-number($GTVal, '###,###,###,##0.0', 'dot-dec')"/>
                </xsl:when>
                <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/digit  = 2 and $GTVal!=''">
                  <xsl:value-of select="format-number($GTVal, '###,###,###,##0.00', 'dot-dec')"/>
                </xsl:when>
                <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/digit  = 3 and $GTVal!=''">
                  <xsl:value-of select="format-number($GTVal, '###,###,###,##0.000', 'dot-dec')"/>
                </xsl:when>
                <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/digit  = 4 and $GTVal!=''">
                  <xsl:value-of select="format-number($GTVal, '###,###,###,##0.0000', 'dot-dec')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$GTVal"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- Form Head-->
            <xsl:if test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]">
              <div id="profileBox" class="box box-primary">
                <div class="box-body box-profile">
                  <xsl:choose>
                    <xsl:when test="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/imageBox/. != ''">
                      <xsl:variable name="imgName">
                        <xsl:value-of select="/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/@fieldName/."/>
                      </xsl:variable>
                      <xsl:variable name="imgVal">
                        <xsl:value-of select="/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/imageBox/value/."/>
                      </xsl:variable>

                      <!--<xsl:value-of select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/imageBox/titlecaption"/>-->
                      <div id="imageBox" style=" padding:5px;">
                        <div id="{$imgName}_camera">
                          <img style="width:100%" id="{$imgName}_camera_img">
                            <xsl:attribute name="src">
                              <xsl:choose>
                                <xsl:when test="$imgVal!=''">
                                  ophcontent/documents/<xsl:value-of select="/sqroot/header/info/account" />/<xsl:value-of select="$imgVal" />
                                </xsl:when>
                                <xsl:otherwise>
                                  ophcontent/themes/themeone/images/blank-person.png
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:attribute>
                          </img>
                          &#xa0;
                        </div>
                        <div id="{$imgName}_hidden_div" style="display:none">
                          <img style="width:100%" id="{$imgName}_hidden_img">
                            <xsl:attribute name="src">
                              <xsl:choose>
                                <xsl:when test="$imgVal!=''">
                                  ophcontent/documents/<xsl:value-of select="/sqroot/header/info/account" />/<xsl:value-of select="$imgVal" />
                                </xsl:when>
                                <xsl:otherwise>
                                  ophcontent/themes/themeone/images/blank-person.png
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:attribute>
                          </img>
                        </div>
                        <form role="form" id="formwebcam" enctype="multipart/form-data" onsubmit="return false">
                          <xsl:if test="/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/imageBox/. != ''">
                            <input type="hidden" class="oph-webcam" id="{/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/@fieldName/.}" name ="{/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/@fieldName/.}"/>
                          </xsl:if>

                          <label class="btn btn-primary btn-block" id="getImage">
                            <span>
                              Get Image <input id ="{$imgName}_hidden" name="{$imgName}_hidden" type="file" style="display: none;" multiple="" data-code="{/sqroot/body/bodyContent/form/info/code/.}" data-webcam="1" data-field="{$imgName}" accept="image/*"/>
                            </span>
                          </label>
                        </form>
                        <a href="javascript:btnWebcam('opencamera', '{$imgName}')" class="btn btn-primary btn-block" style="margin-top:5px;" id="opencamera">
                          <span>
                            <ix class="fa fa-camera"></ix>
                          </span>
                          <span>
                            <b> Open Camera</b>
                          </span>
                        </a>
                        <a href="javascript:btnWebcam('takesnap')" class="btn btn-primary btn-block" style="margin-top:5px; display:none;" id="takesnapshot">
                          <span>
                            <ix class="fa fa-camera"></ix>
                          </span>
                          <span>
                            <b> Take Snapshot</b>
                          </span>
                        </a>
                        <a href="javascript:btnWebcam('takeanother')" class="btn btn-primary btn-block" style="margin-top:5px; display:none;" id="takeanother">
                          <span>
                            <ix class="fa fa-camera"></ix>
                          </span>
                          <span>
                            <b> Take Another</b>
                          </span>
                        </a>
                        <a href="javascript:btnWebcam('savephoto', '{$imgName}')" class="btn btn-primary btn-block" style="margin-top:5px; display:none;" id="savephoto">
                          <span>
                            <ix class="fa fa-camera"></ix>
                          </span>
                          <span>
                            <b> Save Photo</b>
                          </span>
                        </a>
                      </div>
                    </xsl:when>
                    <xsl:otherwise>

                      <h3 class="profile-username text-center" id="{/sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/@fieldName}">
                        <xsl:value-of select="$tbContent"/>&#160;
                      </h3>
                      <p class="text-muted text-center">
                        <xsl:value-of select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection[@sectionNo=1]/formCols/formCol[@colNo=1]/formRows/formRow[@rowNo=1]/fields/field/textBox/titlecaption"/>
                      </p>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="count(sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection/formCols/formCol/formRows/formRow[@rowNo>1]/fields/field)>0">
                    <ul class="list-group list-group-unbordered">
                      <xsl:for-each select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo=10]/formSections/formSection/formCols/formCol/formRows/formRow/fields/field">
                        <xsl:variable name="HeadVal">
                          <xsl:choose>
                            <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
                              <xsl:value-of select="textBox/defaultvalue" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="textBox/value" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="@fieldName=$fieldHead">
                          </xsl:when>
                          <xsl:when test="imageBox">
                          </xsl:when>
                          <xsl:otherwise>
                            <li class="list-group-item">
                              <xsl:value-of select="textBox/titlecaption"/>
                              <a class="pull-right" id="{@fieldName}">
                                <xsl:value-of select="$HeadVal"/>&#160;
                              </a>
                            </li>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </ul>
                  </xsl:if>
                  <xsl:if test="sqroot/body/bodyContent/form/query/reports/report">
                    <xsl:for-each select="sqroot/body/bodyContent/form/query/reports/report">
                      <xsl:variable name="qdisable">
                        <xsl:choose>
                          <xsl:when test="isVisible=1">
                          </xsl:when>
                          <xsl:otherwise>
                            disabled
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>

                      <xsl:if test="allowPDF=1">
                        <a href="javascript:genReport('{code}', 'pdf');" class="btn btn-primary btn-block {$qdisable}">
                          <span>
                            <ix class="fa fa-file-pdf"></ix>
                          </span>
                          <span>
                            <b>
                              <xsl:value-of select="description"/>
                            </b>
                          </span>
                        </a>
                      </xsl:if>
                      <xsl:if test="allowXLS=1">
                        <a href="javascript:genReport('{code}', 'xls');" class="btn btn-primary btn-block">
                          <ix class="fa fa-file-spreadsheet"></ix>
                          <b>
                            <xsl:value-of select="description"/>
                          </b>
                        </a>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                </div>

              </div>
              <!-- /.box -->
            </xsl:if>

            <!-- About Me Box -->
            <div id="aboutMeBox" class="box box-primary">
              <div class="box-header with-border">
                <h3 class="box-title">Action</h3>
              </div>
              <!-- /.box-header -->
              <div class="box-body">
                    <xsl:choose>
                      <!--location: 0 header; 1 child; 2 browse location: browse:10, header form:20, browse anak:30, browse form:40-->
                      <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
                      </xsl:when>
                      <xsl:when test="/sqroot/body/bodyContent/form/info/state/status/. = 0 or /sqroot/body/bodyContent/form/info/state/status/. = ''">
                        <xsl:if test="(/sqroot/body/bodyContent/form/info/settingMode/.)='T' and (/sqroot/body/bodyContent/form/info/state/status/.) &lt; 400 ">
                          <button id="button_submit" class="btn btn-orange-a btn-block action-submit" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'execute', 1, 20)">SUBMIT</button>
                        </xsl:if>
                        <xsl:if test="(($allowDelete>=1) and (/sqroot/body/bodyContent/form/info/state/status=0 or /sqroot/body/bodyContent/form/info/state/status=300))">
                          <button id="button_delete" class="btn btn-gray-a btn-block action-delete" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 'delete', 1, 20);">DELETE</button>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 100 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt; 300">
                        <xsl:if test="$isApprover=1">
                          <button id="button_approve" class="btn btn-orange-a btn-block action-approve" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'execute', 1, 20)">APPROVE</button>
                          <button id="button_reject" class="btn btn-gray-a btn-block action-reject" onclick="rejectPopup('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'force', 1, 20)">REJECT</button>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) = 300">
                        <xsl:if test="$isApprover=1">
                          <button id="button_submit" class="btn btn-orange-a btn-block action-submit" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'execute', 1, 20)">RE-SUBMIT</button>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 400 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt;= 499">
                        <xsl:if test="$allowForce=1">
                          <button id="button_close" class="btn btn-orange-a btn-block action-close" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'force', 1, 20)">CLOSE</button>
                        </xsl:if>
                        <xsl:if test="(($allowDelete>=1) and (/sqroot/body/bodyContent/form/info/state/status=0 or /sqroot/body/bodyContent/form/info/state/status=300))
							                or (($allowDelete>=4) and (/sqroot/body/bodyContent/form/info/state/status&lt;100 or /sqroot/body/bodyContent/form/info/state/status&gt;=300))">

                          <button id="button_delete" class="btn btn-gray-a btn-block action-delete" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 'delete', 1, 20);">DELETE</button>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 500 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt;= 899">
                        <button id="button_reopen" class="btn btn-orange-a btn-block action-reopen" onclick="btn_function('{/sqroot/body/bodyContent/form/info/code/.}', '{/sqroot/body/bodyContent/form/info/GUID/.}', 'reopen', 1, 20)">REOPEN</button>
                      </xsl:when>
                      <xsl:otherwise>
                        &#160;
                      </xsl:otherwise>
                    </xsl:choose>
                &#160;
              </div>
            </div>
          </div>
        <!--/xsl:if-->
        <div class="col-md-9">
          <!-- Custom Tabs -->
          <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
              <xsl:for-each select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo&lt;10]">
                <li>
                  <xsl:attribute name="class">
                    <xsl:if test="@pageNo=1">active</xsl:if>
                  </xsl:attribute>
                  <a href="#tab_{@pageNo}" data-toggle="tab"
                     onclick="storeHash('{/sqroot/body/bodyContent/form/info/code/.}', '#tab_{@pageNo}');">
                    <xsl:choose>
                      <xsl:when test="@pageTitle">
                        <xsl:value-of select="@pageTitle"/>
                      </xsl:when>
                      <xsl:otherwise>Header
                      </xsl:otherwise>
                    </xsl:choose>
                  </a>
                </li>
              </xsl:for-each>
              <xsl:choose>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'"></xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="sqroot/body/bodyContent/form/children/child">
                    <li>
                      <a href="#tab_{code}" data-toggle="tab"
                         onclick="storeHash('{/sqroot/body/bodyContent/form/info/code/.}', '#tab_{code}');">
                        <xsl:value-of select="childTitle"/>
                      </a>
                    </li>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </ul>
            <div class="tab-content">
              <xsl:apply-templates select="sqroot/body/bodyContent"/>
              <!-- /.tab-pane -->
              <xsl:for-each select="sqroot/body/bodyContent/form/formPages/formPage[@pageNo&gt;1 and @pageNo&lt;10]">
                <div class="tab-pane active" id="tab_{@pageNo}">
                  &#160;
                </div>
              </xsl:for-each>
              <xsl:for-each select="sqroot/body/bodyContent/form/children/child">
                <div class="tab-pane" id="tab_{code}">
                  <xsl:if test="/sqroot/body/bodyContent/form/info/GUID !='00000000-0000-0000-0000-000000000000'">
                    <xsl:apply-templates select="."/>

                  </xsl:if>
                  <!--<xsl:value-of select="code"/>-->
                </div>
              </xsl:for-each>

            </div>

            <!-- /.tab-content -->
          </div>
          <!-- nav-tabs-custom -->
        </div>
        <!-- /.col -->

      </div>
    </section>
    <!-- /.row -->
    <!-- END CUSTOM TABS -->
  </xsl:template>


  <xsl:template match="sqroot/body/bodyContent">
    <xsl:apply-templates select="form"/>
  </xsl:template>

  <xsl:template match="form">
    <xsl:apply-templates select="formPages/formPage[@pageNo&lt;9]"/>
  </xsl:template>

  <xsl:template match="formPages/formPage[@pageNo&lt;9]">
    <div id="tab_{@pageNo}">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@pageNo=1">
            tab-pane active
          </xsl:when>
          <xsl:otherwise>
            tab-pane
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute> 
      <!-- Main content -->
      <section class="content">
        <!-- title -->
        <!-- view header -->
        <div class="row">
          <script>
            var code = "<xsl:value-of select="info/code/."/>";
            var tblnm =code+"requiredname";
          </script>

          <form role="form" id="formheader_{@pageNo}" enctype="multipart/form-data" onsubmit="return false">
            <xsl:apply-templates select="formSections" />
          </form>

        </div>
        <!-- button view header -->
        <div class="row">
          <div class="col-md-12 device-sm visible-sm device-md visible-md device-lg visible-lg" style="margin-bottom:50px;">
            <div style="text-align:left">
              <xsl:choose>
                <!--location: 0 header; 1 child; 2 browse location: browse:10, header form:20, browse anak:30, browse form:40-->
                <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
                  <button id="button_save_{@pageNo}" class="btn btn-orange-a action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>&#160;
                  <button id="button_cancel_{@pageNo}" class="btn btn-gray-a action-cancel" onclick="saveCancel()">CANCEL</button>&#160;
                </xsl:when>
                <xsl:when test="/sqroot/body/bodyContent/form/info/state/status/. = 0 or /sqroot/body/bodyContent/form/info/state/status/. = ''">
                  <button id="button_save_{@pageNo}" class="btn btn-orange-a action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>&#160;
                  <button id="button_cancel_{@pageNo}" class="btn btn-gray-a action-cancel" onclick="saveCancel()">CANCEL</button>&#160;
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 100 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt; 300">
                  <button id="button_save_{@pageNo}" class="btn btn-orange-a action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>&#160;
                  <button id="button_cancel_{@pageNo}" class="btn btn-gray-a action-cancel" onclick="saveCancel()">CANCEL</button>&#160;
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) = 300">
                  <button id="button_save_{@pageNo}" class="btn btn-orange-a action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>&#160;
                  <button id="button_cancel_{@pageNo}" class="btn btn-gray-a action-cancel" onclick="saveCancel()">CANCEL</button>&#160;
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 400 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt;= 499">
                  <button id="button_save_{@pageNo}" class="btn btn-orange-a action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>&#160;
                  <button id="button_cancel_{@pageNo}" class="btn btn-gray-a action-cancel" onclick="saveCancel()">CANCEL</button>&#160;
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 500 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt;= 899">
                </xsl:when>
                <xsl:otherwise>
                  &#160;
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
          <div class="col-md-12 displayblock-phone device-xs visible-xs" style="margin-bottom:20px;">
            <div style="text-align:center">
              <xsl:choose>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
                  <button id="button_save2" class="btn btn-orange-a btn-block action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>
                  <button id="button_cancel2" class="btn btn-gray-a btn-block action-cancel" onclick="saveCancel()">CANCEL</button>
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) = 0 or (/sqroot/body/bodyContent/form/info/state/status/.) = ''">
                  <button id="button_save2" class="btn btn-orange-a btn-block action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>
                  <button id="button_cancel2" class="btn btn-gray-a btn-block action-cancel" onclick="saveCancel()">CANCEL</button>
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt; 99 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt; 199">
                  <button id="button_save2" class="btn btn-orange-a btn-block action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>
                  <button id="button_cancel2" class="btn btn-gray-a btn-block action-cancel" onclick="saveCancel()">CANCEL</button>
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) = 300">
                  <button id="button_save2" class="btn btn-orange-a btn-block action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>
                  <button id="button_cancel2" class="btn btn-gray-a btn-block action-cancel" onclick="saveCancel()">CANCEL</button>
                </xsl:when>
                <xsl:when test="(/sqroot/body/bodyContent/form/info/state/status/.) &gt;= 400 and (/sqroot/body/bodyContent/form/info/state/status/.) &lt;= 499">
                  <button id="button_save2" class="btn btn-orange-a btn-block action-save" onclick="saveThemeONE('{/sqroot/body/bodyContent/form/info/code/.}','{/sqroot/body/bodyContent/form/info/GUID/.}', 20, 'formheader');">SAVE</button>
                  <button id="button_cancel2" class="btn btn-gray-a btn-block action-cancel" onclick="saveCancel()">CANCEL</button>
                </xsl:when>
                <xsl:otherwise>
                  &#160;
                  <!--<div style="text-align:left">
                <button id="button_save" class="btn btn-orange-a" onclick="submitfunction('formheader','{/sqroot/body/bodyContent/form/info/GUID/.}','{/sqroot/body/bodyContent/form/info/code/.}');">SAVE</button>&#160;
                <button id="button_cancel" class="btn btn-gray-a" onclick="saveCancel()">CANCEL</button>&#160;
              </div>-->
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </div>
      </section>

      <!-- /.content -->
    </div>

    <!--reject modal-->
    <div id="rejectModal" class="modal fade" role="dialog">
      <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&#215;</button>
            <h4 class="modal-title" id="rejectTitle">Reject Reason</h4>
          </div>
          <div class="modal-body" id="rejectContent">
            <p>Please mention your reject reason: (required)</p>
            <textarea id="rejectComment" placeholder="Enter your reject reason." class="form-control">&#160;</textarea>
          </div>
          <div class="modal-footer">
            <button id="rejectBtn" type="button" class="btn btn-secondary" data-dismiss="modal" style="visibility:hidden">Reject</button>
            <button id="rejectCancelBtn" type="button" class="btn btn-primary btn-default" data-dismiss="modal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
    
  </xsl:template>

  <xsl:template match="formSections">
    <xsl:apply-templates select="formSection"/>
  </xsl:template>

  <xsl:template match="formSection ">
    <xsl:if test="formCols/formCol/formRows">
      <div class="col-md-12 collapse in" id="section_{@sectionNo}">
        <xsl:apply-templates select="formCols"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="formCols">
    <xsl:apply-templates select="formCol"/>
  </xsl:template>

  <xsl:template match="formCol">
    <xsl:variable name="totalcol">
      <xsl:value-of select="count(../formCol)" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@colNo='0'">
        <div class="col-md-12">
          <xsl:if test="@rowTitle/.!=''">
            <h3>
              <xsl:value-of select="@rowTitle/."/>&#160;
            </h3>
          </xsl:if>
          <xsl:apply-templates select="formRows"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$totalcol = 3 or $totalcol = 4">
          <div class="col-md-4">
            <xsl:if test="../formCol/@rowTitle/.!=''">
              <h3>
                <xsl:value-of select="@rowTitle/."/>&#160;
              </h3>
            </xsl:if>
            <xsl:if test="@colNo='1'">
              <xsl:apply-templates select="formRows"/>
            </xsl:if>
            <xsl:if test="@colNo='2'">
              <xsl:apply-templates select="formRows"/>
            </xsl:if>
            <xsl:if test="@colNo='3'">
              <xsl:apply-templates select="formRows"/>
            </xsl:if>
          </div>
        </xsl:if>
        <xsl:if test="$totalcol = 1 or $totalcol = 2">
          <div class="col-md-6">
            <xsl:if test="../formCol/@rowTitle/.!=''">
              <h3>
                <xsl:value-of select="@rowTitle/."/>&#160;
              </h3>
            </xsl:if>
            <xsl:if test="@colNo='1'">
              <xsl:apply-templates select="formRows"/>
            </xsl:if>
            <xsl:if test="@colNo='2'">
              <xsl:apply-templates select="formRows"/>
            </xsl:if>
          </div>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="formRows">
    <div class="box box-solid box-default">

      <div class="box-body">
        <xsl:apply-templates select="formRow"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="formRow ">
    <xsl:apply-templates select="fields"/>

  </xsl:template>

  <xsl:template match="fields">
    <xsl:apply-templates select="field"/>
  </xsl:template>

  <xsl:template match="field">
    <xsl:if test="@isNullable=0 and 
                    ((@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <script>
        document.getElementsByName(tblnm)[0].value = document.getElementsByName(tblnm)[0].value + ', <xsl:value-of select="@fieldName"/>'
      </script>
    </xsl:if>

    <xsl:variable name="fieldEnabled">
      <xsl:choose>
        <xsl:when test ="((@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">enabled</xsl:when>
        <xsl:otherwise>disabled</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test ="$fieldEnabled='disabled'">
        <script>
          $('#<xsl:value-of select="@fieldName"/>').attr('disabled', true);
        </script>
      </xsl:when>
    </xsl:choose>

    <div class="form-group {$fieldEnabled}-input">
      <xsl:apply-templates select="textBox"/>
      <xsl:apply-templates select="textEditor"/>
      <xsl:apply-templates select="dateBox"/>
      <xsl:apply-templates select="dateTimeBox"/>
      <xsl:apply-templates select="timeBox"/>
      <xsl:apply-templates select="passwordBox"/>
      <xsl:apply-templates select="hiddenBox"/>
      <xsl:apply-templates select="checkBox"/>
      <xsl:apply-templates select="mediaBox"/>
      <xsl:apply-templates select="imageBox"/>
      <xsl:apply-templates select="autoSuggestBox"/>
      <xsl:apply-templates select="tokenBox"/>
      <xsl:apply-templates select="radio"/>
    </div>
  </xsl:template>

  <xsl:template match="hiddenBox">
    <input type="hidden" Value="{value}" data-type="hiddenBox" data-old="{value}" name="{../@fieldName}"
           id ="{../@fieldName}"/>
  </xsl:template>

  <xsl:template match="checkBox">
    <!--Supaya bisa di serialize-->
    <input type="hidden" name="{../@fieldName}" id="{../@fieldName}" value="{value}"/>
    <!--Supaya bisa di serialize-->

    <input type="checkbox" value="{value}" id ="cb{../@fieldName}"  name="cb{../@fieldName}" data-type="checkBox" data-old="{value}"
      onchange="checkCB('{../@fieldName}');preview('{preview/.}', getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);">
      <xsl:if test="value=1">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
    </input>

    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <label id="{../@fieldName}suffixCaption">
      <xsl:value-of select="suffixCaption"/>
    </label>

  </xsl:template>

  <xsl:template match="textEditor">
    <label id="{../@fieldName}caption" data-toggle="collapse" data-target="#section_{@sectionNo}">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <textarea id ="{../@fieldName}" name ="{../@fieldName}" class="form-control">
      <xsl:choose>
        <xsl:when test="value != ''">
          <xsl:value-of select="value"/>
        </xsl:when>
        <xsl:otherwise>&#160;</xsl:otherwise>
      </xsl:choose>
    </textarea>

    <script type="text/javascript">
      CKEDITOR.replace('<xsl:value-of select="../@fieldName"/>');
      CKEDITOR.instances['<xsl:value-of select="../@fieldName"/>'].on('blur', function() {
      var teOldData = $('#<xsl:value-of select="../@fieldName"/>').html();
      var teData = CKEDITOR.instances['<xsl:value-of select="../@fieldName"/>'].getData();
      teData = teData.trim();
      $('#<xsl:value-of select="../@fieldName"/>').html(teData);
      if (teOldData != teData) {
      $('#button_save').show();
      $('#button_cancel').show();
      $('#button_save2').show();
      $('#button_cancel2').show();
      }
      preview('{preview/.}',getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);
      });
    </script>
  </xsl:template>

  <xsl:template match="textBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>


    <!--digit-->
    <xsl:variable name="tbContent">
      <xsl:choose>
        <xsl:when test="digit = 0 and value!=''">
          <xsl:value-of select="format-number(value, '###,###,###,##0', 'dot-dec')"/>
        </xsl:when>
        <xsl:when test="digit  = 1 and .!=''">
          <xsl:value-of select="format-number(value, '###,###,###,##0.0', 'dot-dec')"/>
        </xsl:when>
        <xsl:when test="digit  = 2 and .!=''">
          <xsl:value-of select="format-number(value, '###,###,###,##0.00', 'dot-dec')"/>
        </xsl:when>
        <xsl:when test="digit  = 3 and .!=''">
          <xsl:value-of select="format-number(value, '###,###,###,##0.000', 'dot-dec')"/>
        </xsl:when>
        <xsl:when test="digit  = 4 and .!=''">
          <xsl:value-of select="format-number(value, '###,###,###,##0.0000', 'dot-dec')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="align">
      <xsl:choose>
        <xsl:when test="align=0">left</xsl:when>
        <xsl:when test="align=1">center</xsl:when>
        <xsl:when test="align=2">right</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!--default value-->
    <xsl:variable name="thisvalue">
      <xsl:choose>
        <xsl:when  test="/sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000' and defaultvalue != ''">
          <xsl:value-of select="defaultvalue/." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tbContent" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <input type="text" class="form-control" Value="{$thisvalue}" data-type="textBox" data-old="{$thisvalue}" name="{../@fieldName}"
           onblur="preview('{preview/.}',getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);" id ="{../@fieldName}"
           oninput="javascript:checkChanges(this)">
      <xsl:attribute name="style">
        text-align:<xsl:value-of select="$align"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <xsl:template match="dateBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>
    <div class="input-group date">
      <div class="input-group-addon">
        <ix class="fa fa-calendar"></ix>
      </div>



      <input type="text" class="form-control pull-right datepicker" id ="{../@fieldName}" name="{../@fieldName}" Value="{value}" data-type="dateBox" data-old="{value}"
        onblur="preview('{preview/.}',getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);"
        onchange="checkChanges(this)">
      </input>
    </div>
  </xsl:template>

  <xsl:template match="dateTimeBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <div class="input-group date">
      <div class="input-group-addon">
        <ix class="fa fa-calendar"></ix>
      </div>
      <input type="text" class="form-control pull-right datetimepicker" id ="{../@fieldName}" name="{../@fieldName}" Value="{value}" data-type="dateTimeBox" data-old="{value}"
        onblur="preview('{preview/.}',getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);" >
      </input>
    </div>
  </xsl:template>

  <xsl:template match="passwordBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <input type="password" class="form-control" Value="" data-type="textBox" data-old="" name="{../@fieldName}"
           minlength="8" required="required" placeholder="8 characters minimum."
      onblur="preview('{preview/.}',getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}','formheader', this);" id ="{../@fieldName}" autocomplete="false">
    </input>

  </xsl:template>

  <xsl:template match="timeBox">
    <script>//timebox</script>
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <div class="input-group date">
      <div class="input-group-addon">
        <ix class="fa fa-clock-o"></ix>
      </div>
      <input type="text" class="form-control pull-right timepicker" id ="{../@fieldName}" name="{../@fieldName}"
             data-type="timeBox" data-old="{value}" Value="{value}"
             onblur="preview('{preview/.}','{/sqroot/body/bodyContent/form/code/id}', '{/sqroot/body/bodyContent/form/info/GUID/.}','form{/sqroot/body/bodyContent/form/code/id}', this);" >
      </input>
    </div>
  </xsl:template>

  <xsl:template match="autoSuggestBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>
    <select class="form-control select2" style="width: 100%;" name="{../@fieldName}" id="{../@fieldName}" data-type="selectBox"
      data-old="{value/.}" data-oldText="{value/.}" data-value="{value/.}"
        onchange="autosuggest_onchange(this, '{preview/.}', getCode(), '{/sqroot/body/bodyContent/form/info/GUID/.}', 'formheader');" >
      <option></option>
    </select>

    <!--AutoSuggest Add New Form Modal-->
    <xsl:if test="(@allowAdd&gt;=1 or @allowEdit=1) and ../@isEditable=1">
      <div id="addNew{../@fieldName}" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close" >
                <span aria-hidden="true">&#215;</span>
              </button>
              <div style="float:left;margin-top:-15px;">
                <h3>
                  <xsl:value-of select="titlecaption"/>
                </h3>
                <span>(Quick Add New Data Set)</span>
              </div>
              <div style="float:left">
                <a id="link{../@fieldName}" data-toggle="tooltip" data-placement="right" title="Click to see more detail" style="cursor:pointer;" onclick="">
                  <ix class="fa fa-external-link fa-2x"></ix>
                </a>
                <script>
                  $('#link<xsl:value-of select="../@fieldName"/>').click(function(){
                  var guid = (isGuid($('#<xsl:value-of select="../@fieldName"/>').val())) ? $('#<xsl:value-of select="../@fieldName"/>').val() : '00000000-0000-0000-0000-000000000000';
                  var url = '?code=<xsl:value-of select="@comboCode"/>&amp;guid=' + guid;
                  window.open(url);
                  });
                </script>
              </div>
            </div>
            <div class="modal-body">
              <div class="row" id="modalForm{../@fieldName}">
                &#160;
              </div>
            </div>
            <script>
              if ($('body').children('#addNew<xsl:value-of select="../@fieldName"/>').length == 1) {
              $('body').children('#addNew<xsl:value-of select="../@fieldName"/>').remove();
              }
              $('#addNew<xsl:value-of select="../@fieldName"/>').appendTo("body");
              $('#addNew<xsl:value-of select="../@fieldName"/>').on('show.bs.modal', function (event) {
              $('#<xsl:value-of select="../@fieldName"/>').select2('close');
              $('#modalForm<xsl:value-of select="../@fieldName"/>').append('<div class="col-md-12"></div>');
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('.col-md-12').append('<div style="float:left;"></div>');
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('.col-md-12').append('<div style="float:left; margin-left:10px;font-size:20px;">Please wait...</div>');
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('.col-md-12').children('div:first').append('<ix class="fa fa-spinner fa-pulse fa-2x fa-fw"></ix>');
              }).on('shown.bs.modal', function (event) {
              if (isGuid($('#<xsl:value-of select="../@fieldName"/>').val()) &amp;&amp; $(event.relatedTarget).data('.action') == 'edit' ) {
              loadModalForm('modalForm<xsl:value-of select="../@fieldName"/>', '<xsl:value-of select="@comboCode"/>', $('#<xsl:value-of select="../@fieldName"/>').val());
              }
              else {
              loadModalForm('modalForm<xsl:value-of select="../@fieldName"/>', '<xsl:value-of select="@comboCode"/>', '00000000-0000-0000-0000-000000000000');
              }
              }).on('hide.bs.modal', function(event){
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('div').remove();
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('form').remove();
              $('#modalForm<xsl:value-of select="../@fieldName"/>').children('button').remove();
              $('#addNew<xsl:value-of select="../@fieldName"/> .modal-footer').children('button[id*="btn_save"]').remove();
              $('#modalForm<xsl:value-of select="../@fieldName"/>').text('&#160;');
              });
            </script>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal" >Cancel</button>
            </div>
          </div>
        </div>
      </div>

      <xsl:if test="@allowAdd&gt;=1">
        <span class="select2-search select2-box--dropdown" id="select2-{../@fieldName}-addNew" style="display:none;">
          <ul class="select2-results__options" role="tree" aria-expanded="true" aria-hidden="false">
            <li class="select2-results__option" role="treeitem" aria-selected="false">
              <a data-toggle="modal" data-target="#addNew{../@fieldName}" data-backdrop="static" data-action="new">
                Add New <xsl:value-of select="titlecaption"/>
              </a>
            </li>
          </ul>
        </span>
        <script>
          $("#<xsl:value-of select="../@fieldName"/>").on("select2:open", function(e) {
          var s2id = $("span[class*='select2-dropdown select2-dropdown']").children('.select2-results').children().attr('id');
          s2id = s2id.split('select2-').join('').split('-results').join('');
          if (s2id == '<xsl:value-of select="../@fieldName"/>') {
          $('#select2-<xsl:value-of select="../@fieldName"/>-addNew').appendTo("span[class*='select2-dropdown select2-dropdown']").show();
          }
          });
        </script>
      </xsl:if>
      <xsl:if test="@allowEdit=1">
        <span id="editForm{../@fieldName}" data-toggle="modal" data-target="#addNew{../@fieldName}" data-backdrop="static" data-action="edit"
          style="cursor: pointer;margin: 8px 45px 0px 0px;position: absolute;top: 0px;right: 0px; display:none">
          <ix class="far fa-pencil-alt" title= "Edit" data-toggle="tooltip"></ix>
        </span>

        <script>
          $("#<xsl:value-of select="../@fieldName"/>").on("select2:select", function(e) {
          $selection = $('#select2-<xsl:value-of select="../@fieldName"/>-container').parents('.selection');
          if ($selection.children('#editForm<xsl:value-of select="../@fieldName"/>').length == 0)
          $('#editForm<xsl:value-of select="../@fieldName"/>').appendTo($selection);
          $('#editForm<xsl:value-of select="../@fieldName"/>').show();
          });
        </script>
      </xsl:if>
    </xsl:if>
    <xsl:if test="@allowEdit=1">
      <span id="removeForm{../@fieldName}" style="cursor: pointer;margin: 8px 30px 0px 0px;position: absolute;top: 0px;right: 0px; display:none">
        <ix class="far fa-times" title= "Remove Selection" data-toggle="tooltip" onclick="javascript: $('#{../@fieldName}').val(null).trigger('change');$('#editForm{../@fieldName}').hide();$('#removeForm{../@fieldName}').hide();"></ix>
      </span>
      <script>
        $("#<xsl:value-of select="../@fieldName"/>").on("select2:select", function(e) {
        $selection = $('#select2-<xsl:value-of select="../@fieldName"/>-container').parents('.selection');
        if ($selection.children('#removeForm<xsl:value-of select="../@fieldName"/>').length == 0)
        $('#removeForm<xsl:value-of select="../@fieldName"/>').appendTo($selection)
        $('#removeForm<xsl:value-of select="../@fieldName"/>').show();
        });
      </script>
    </xsl:if>


    <script>
      $("#<xsl:value-of select="../@fieldName"/>").select2({
      placeholder: 'Select <xsl:value-of select="titlecaption"/>',
      onAdd: function(x) {
      preview('<xsl:value-of select="preview/."/>', getCode(), '<xsl:value-of select="/sqroot/body/bodyContent/form/info/GUID/."/>','formheader', this);
      },
      onDelete: function(x) {
      preview('<xsl:value-of select="preview/."/>', getCode(), '<xsl:value-of select="/sqroot/body/bodyContent/form/info/GUID/."/>','formheader', this);
      },
      ajax: {
      url:"OPHCORE/api/msg_autosuggest.aspx",
      delay : 0,
      data: function (params) {
      var query = {
      code:"<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>",
      colkey:"<xsl:value-of select="../@fieldName"/>",
      search: params.term==undefined?'':params.term.toString().split('+').join('%2B'),
      wf1value: ($("#<xsl:value-of select='whereFields/wf1'/>").val() == undefined ? "" : $("#<xsl:value-of select='whereFields/wf1'/>").val()),
      wf2value: ($("#<xsl:value-of select='whereFields/wf2'/>").val() == undefined ? "" : $("#<xsl:value-of select='whereFields/wf2'/>").val()),
      parentCode: getCode(),
      page: params.page
      }
      return query;
      },
      dataType: 'json',
      }
      });
      <xsl:if test="value!=''">
        //deferreds.push(
        autosuggest_setValue(deferreds, '<xsl:value-of select="../@fieldName"/>','<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>','<xsl:value-of select='../@fieldName'/>', '<xsl:value-of select='value'/>', '<xsl:value-of select='whereFields/wf1'/>', '<xsl:value-of select='whereFields/wf2'/>')
        //);
      </xsl:if>
    </script>
  </xsl:template>

  <xsl:template match="tokenBox">
    <script type="text/javascript">
      var sURL<xsl:value-of select="../@fieldName"/>='OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>&amp;colkey=<xsl:value-of select="../@fieldName"/>'
      var noPrepopulate<xsl:value-of select="../@fieldName"/>=1;
      <xsl:if test="value">
        noPrepopulate<xsl:value-of select="../@fieldName"/>=0;
      </xsl:if>
      var cURL<xsl:value-of select="../@fieldName"/>='OPHCore/api/msg_autosuggest.aspx?mode=token&amp;code=<xsl:value-of select="/sqroot/body/bodyContent/form/info/code/."/>&amp;colkey=<xsl:value-of select="../@fieldName"/>&amp;search=<xsl:value-of select="value"/>'

      $(document).ready(function(){
      $.ajax({
      url: cURL<xsl:value-of select="../@fieldName"/>,
      dataType: 'json',
      success: function(data){
      if (noPrepopulate<xsl:value-of select="../@fieldName"/>==1) data='';
      $("#<xsl:value-of select="../@fieldName"/>").tokenInput(
      sURL<xsl:value-of select="../@fieldName"/>,
      {
      hintText: "please type...",
      searchingText: "Searching...",
      preventDuplicates: true,
      allowCustomEntry: true,
      highlightDuplicates: false,
      tokenDelimiter: "*",
      theme:"facebook",
      prePopulate: data,
      onReady: function(x) {
      },
      onAdd: function(x) {
      preview('<xsl:value-of select="preview/."/>', getCode(), '<xsl:value-of select="/sqroot/body/bodyContent/form/info/GUID/."/>','formheader', this);
      },
      onDelete: function(x) {
      preview('<xsl:value-of select="preview/."/>', getCode(), '<xsl:value-of select="/sqroot/body/bodyContent/form/info/GUID/."/>','formheader', this);
      }
      }
      );
      }
      });
      });


    </script>

    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>

    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <!--digit-->
    <xsl:variable name="tbContent">
      <xsl:value-of select="value"/>
    </xsl:variable>

    <!--default value-->
    <xsl:variable name="thisvalue">
      <xsl:choose>
        <xsl:when  test="/sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000' and defaultvalue != ''">
          <xsl:value-of select="defaultvalue/." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tbContent" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <input type="text" class="form-control" Value="{$thisvalue}" data-type="tokenBox" data-old="{$thisvalue}" data-newJSON="" data-code="{code/.}"
      data-key="{key}" data-id="{id}" data-name="{name}"
      name="{../@fieldName}" id ="{../@fieldName}">
      <xsl:choose>
        <xsl:when test="((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and /sqroot/body/bodyContent/form/info/state/status/.&lt;400)
                        or (../@isEditable='4' and /sqroot/body/bodyContent/form/info/state/status/.&lt;500))">
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="disabled">disabled</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </input>
  </xsl:template>
  <xsl:template match="imageBox">
  </xsl:template>

  <xsl:template match="mediaBox">
    <label id="{../@fieldName}caption">
      <xsl:value-of select="titlecaption"/>
    </label>
    <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
      <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
    </xsl:if>

    <!--default value-->
    <xsl:variable name="thisvalue">
      <xsl:choose>
        <xsl:when  test="/sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000' and defaultvalue != ''">
          <xsl:value-of select="defaultvalue/." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="input-group">
      <label class="input-group-btn">
        <span class="btn btn-primary">
          Browse <input id ="{../@fieldName}_hidden" name="{../@fieldName}_hidden" type="file" style="display: none;" multiple="" />
        </span>
      </label>
      <input id ="{../@fieldName}" name="{../@fieldName}" Value="{value}" type="text" class="form-control" readonly="" />
      <span class="input-group-btn">
        <button class="btn btn-secondary" type="button" onclick="javascript:popTo('OPHcore/api/msg_download.aspx?fieldAttachment={../@fieldName}&#38;code={/sqroot/body/bodyContent/form/info/code/.}&#38;GUID={/sqroot/body/bodyContent/form/info/GUID/.}');">
          <xsl:if test="/sqroot/body/bodyContent/form/info/GUID='00000000-0000-0000-0000-000000000000'">
            <xsl:attribute name="disabled">disabled</xsl:attribute>
          </xsl:if>
          <ix class="fa fa-paperclip"></ix>&#160;
        </button>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="radio">
    <xsl:variable name="radioVal">
      <xsl:choose>
        <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
          <xsl:value-of select="defaultvalue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <script>
      function <xsl:value-of select="../@fieldName" />_hide(shownId) {
      $('#accordion_<xsl:value-of select="../@fieldName" />').children().each(function(){
      if ($(this).hasClass('in') &#38;&#38; this.id!=shownId) {
      $(this).collapse('toggle');
      }
      });

      }
      <xsl:if test="$radioVal != ''">
        panel_display('<xsl:value-of select="../@fieldName"/>', '<xsl:value-of select="$radioVal"/>', true);
      </xsl:if>

    </script>
    <div>
      <label id="{../@fieldName}caption">
        <xsl:value-of select="titlecaption"/>
      </label>
      <xsl:if test="../@isNullable = 0 and 
                    ((../@isEditable='1' and (/sqroot/body/bodyContent/form/info/state/status/.='' or /sqroot/body/bodyContent/form/info/state/status/.=0 or /sqroot/body/bodyContent/form/info/state/status/.=300 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')) 
                        or (../@isEditable='2' and /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')
                        or (../@isEditable='3' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;400 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000'))
                        or (../@isEditable='4' and (/sqroot/body/bodyContent/form/info/state/status/.&lt;500 or /sqroot/body/bodyContent/form/info/GUID/. = '00000000-0000-0000-0000-000000000000')))">
        <span id="rfm_{../@fieldName}" style="color:red;float:right;">required field</span>
      </xsl:if>
    </div>
    <div class = "btn-group" data-toggle = "radios">
      <xsl:apply-templates select="radioSections/radioSection"/>
    </div>
    <xsl:if test="radioSections/radioSection/radioRows">
      <div class="panel-body" id="accordion_{../@fieldName}" style="box-shadow:none;border:none;display:none;">
        <xsl:for-each select="radioSections/radioSection">
          <!--<xsl:if test="radioSections/radioSection/radioRows/radioRow">-->
          <div id="panel_{../../../@fieldName}_{@radioNo}" class="box collapse" style="box-shadow:none;border:none;padding-bottom:0;padding-top:0;margin-bottom:0">
            <xsl:apply-templates select="radioRows/radioRow/fields" />
          </div>
          <!--</xsl:if>-->
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="radioSections/radioSection">

    <xsl:variable name="pandis" select="count(radioRows)"/>
    <xsl:variable name="radioVal1">
      <xsl:choose>
        <xsl:when test="(/sqroot/body/bodyContent/form/info/GUID/.) = '00000000-0000-0000-0000-000000000000'">
          <xsl:value-of select="../../defaultvalue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../../value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@fieldName=$radioVal1">
        <xsl:choose>
          <xsl:when test="radioRows">
            <label class="radio-inline" for="{../../../@fieldName}_{@radioNo}" onclick="panel_display('{../../../@fieldName}', '@radioNo')" >
              <input type="radio" name="{../../../@fieldName}" id="{../../../@fieldName}_{@radioNo}" value="{@fieldName}" checked="checked" />
              <xsl:value-of select="@radioRowTitle"/>
            </label>
          </xsl:when>
          <xsl:otherwise>
            <label class="radio-inline" for="{../../../@fieldName}_{@radioNo}" onclick="panel_display('{../../../@fieldName}', '@radioNo')" >
              <input type="radio" name="{../../../@fieldName}" id="{../../../@fieldName}_{@radioNo}" value="{@fieldName}" checked="checked" />
              <xsl:value-of select="@radioRowTitle"/>
            </label>
          </xsl:otherwise>
        </xsl:choose>
        <script>
          $('#panel_<xsl:value-of select="../../../@fieldName" />_<xsl:value-of select="@radioNo" />').collapse('show');
        </script>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="radioRows">
            <label class="radio-inline" for="{../../../@fieldName}_{@radioNo}" onclick="panel_display('{../../../@fieldName}', '{@radioNo}')" >
              <input type="radio" name="{../../../@fieldName}" id="{../../../@fieldName}_{@radioNo}" value="{@fieldName}" />
              <xsl:value-of select="@radioRowTitle"/>
            </label>
          </xsl:when>
          <xsl:otherwise>
            <label class="radio-inline" for="{../../../@fieldName}_{@radioNo}" onclick="panel_display('{../../../@fieldName}', '{@radioNo}')" >
              <input type="radio" name="{../../../@fieldName}" id="{../../../@fieldName}_{@radioNo}" value="{@fieldName}" />
              <xsl:value-of select="@radioRowTitle"/>
            </label>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

    <script>
      $('#<xsl:value-of select="../../../@fieldName" />_<xsl:value-of select="@radioNo" />').click(function(){
      <xsl:value-of select="../../../@fieldName" />_hide('panel_<xsl:value-of select="../../../@fieldName" />_<xsl:value-of select="@radioNo" />');
      $('#panel_<xsl:value-of select="../../../@fieldName" />_<xsl:value-of select="@radioNo" />').collapse('show');
      var x=$('input[name=<xsl:value-of select="../../../@fieldName" />]:checked').val();
      $('#<xsl:value-of select="../../../@fieldName" />').val(x);
      });
      <xsl:if test="../../../@isEditable=0">
        $('#<xsl:value-of select="../../../@fieldName" />_<xsl:value-of select="@radioNo" />').attr('disabled', true);
      </xsl:if>
    </script>
  </xsl:template>

  <xsl:template match="radioRow/fields">
    <xsl:apply-templates select="field" />
  </xsl:template>

  <xsl:template match="sqroot/body/bodyContent/form/children">

    <xsl:apply-templates select="child"/>

  </xsl:template>

  <xsl:template match="child">
    <xsl:if test="info/permission/allowBrowse='1'">
      <input type="hidden" id="PKID" value="child{code/.}"/>
      <input type="hidden" id="filter{code/.}" value="{parentkey/.}='{/sqroot/body/bodyContent/form/info/GUID/.}'"/>
      <input type="hidden" id="parent{code/.}" value="{parentkey/.}"/>
      <input type="hidden" id="PKName" value="{parentkey/.}"/>

      <script>

        //xmldoc = "OPHCORE/api/default.aspx?code=<xsl:value-of select ="code/."/>&amp;mode=browse&amp;sqlFilter=<xsl:value-of select ="parentkey/."/>='<xsl:value-of select ="/sqroot/body/bodyContent/form/info/GUID/."/>'"
        //showXML('child<xsl:value-of select ="code/."/>', xmldoc, xsldoc + "_childBrowse.xslt", true, true, function () {});

        var code='<xsl:value-of select ="code/."/>';
        var parentKey='<xsl:value-of select ="parentkey/."/>';
        var GUID='<xsl:value-of select ="/sqroot/body/bodyContent/form/info/GUID/."/>';
        var browsemode='<xsl:value-of select ="browseMode/."/>';
        loadChild(code, parentKey, GUID, null, browsemode);
      </script>


      <div class="box box-solid box-default" style="box-shadow:0px;border:none" id="child{code/.}{/sqroot/body/bodyContent/form/info/GUID/.}">
        &#160;
      </div>

    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
