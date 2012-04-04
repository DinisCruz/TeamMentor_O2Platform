﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" />
    

  <xsl:template match="/">
    <html>
      <head>        
        <script src="/Javascript/jQuery/jquery-1.7.1.min.js"       type="text/javascript"></script>
        
        <script src="/Javascript/jscreole/creole.min.js"           type="text/javascript"></script>           
        
        <link rel="stylesheet" href="/Javascript/bootstrap/bootstrap.min.css" type="text/css"></link>        
        
        
        <style>
            .HeaderImage  { height  : 75px }            
            .Article      { width : 75% }
        </style>
          
      </head>
      <body >
        
        <script>
           var title = '<xsl:value-of select='//Metadata/Title'/>';
           var dataType = '<xsl:value-of select='//Content/@DataType'/>';     
           
           var addBreadCrumb_Current = function()
                  {
                    var li = $("&lt;li>").append(title);                    
                    $(".breadcrumb").append(li);
                  }
                  
           var addBreadCrumb = function(newTitle)
                  {
                      $(".breadcrumb li").last().remove();
                      
                      var link = $("&lt;a>").attr('href',title).append(title);
                      var divider = $("&lt;span class='divider'>").append("/");
                      var li = $("&lt;li>");
                                
                      //if($(".breadcrumb li").size() > 0)
                        
                      li.append(link);
                      
                      li.append(divider);
                      
                      $(".breadcrumb").append(li);
                      
                      title = newTitle;                            
                      addBreadCrumb_Current();
                      
                      if($(".breadcrumb li").size() > 5)
                        $(".breadcrumb li").first().remove()
                  };
                    
          var handleClick = function()
                  {                
                    var href = $(this).attr('href');                                
                
                    if (href.split(':').length  > 1) // javascript call
                      return true;
                  
                    if (href.split('/').length  == 1) // only handle direct links
                    {
                        var target = "/html/" + encodeURIComponent(href);
                        console.log(target);  
                        $("body").animate({ scrollTop: 0 }, 'fast');
                        $("#Content").load(target, handleMediaWikiText);
                        var newTitle = $(this).html();
                        addBreadCrumb(newTitle);     
                        $("#Title").html(newTitle);                        
                        history.pushState('', 'New URL: '+href, href);                           
                    }
                    else
                      window.open(href);
                    return false;
                  }
                
                
          var handleMediaWikiText = function()
            {             
              if ($("#Content #tm_datatype_wikitext").length ===1)              
              {
                dataType = "wikitext";
                $("#Content").html($("#Content #tm_datatype_wikitext").html());
              }
              
              if (dataType.toLowerCase() === "wikitext")
              {                
                var wikiText = $("#Content").html();
                var targetDiv = document.createElement('div');        
                new creole().parse(targetDiv,wikiText )   
                var html = targetDiv.innerHTML ;
              
                $("#Content").html(html);      
             }
            };
            
          var hookContentLinks = function()
            {                
              $("a").live("click",handleClick);
            }
            
          var editArticle = function()
          {            
            document.location = "/notepad/" + title;
            //window.open ("/edit/" + title);
          }
                    
          $(function()
            {              
                addBreadCrumb_Current();
                hookContentLinks();                     
                handleMediaWikiText();
            });
        </script>
        <div >
          <div class="Header">
            <a href="/xsl/Table_of_Contents">
              <img src="/Images/HeaderImage.jpg" class="HeaderImage"/>
            </a>          
          </div>          
            <ul class="breadcrumb"> </ul>
        
          <div class="Article container">
            <xsl:apply-templates select="*"/>
          </div>
          </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Metadata">
    <div class="form-actions">
    <h1 id="Title">      
      <xsl:value-of select="Title"/>
    </h1>
      </div>
    <br/>
  </xsl:template>

  <xsl:template match="Content">
    <div id="ContentArea">
         
      <div id="Content">
        <xsl:value-of select="Data" disable-output-escaping="yes"/>
      </div>
      <hr/>
      Back to <a href="Table_of_Contents">Table of Contents</a>
      <br/>    
      Edit this <a href="javascript:editArticle()">Article</a>
      </div>
  </xsl:template>
</xsl:stylesheet>
