<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:imr="http://schema.bipm.org/xml/imres/nmrr/nmi/1.0wd"
                xmlns:IMR="http://schema.bipm.org/xml/imres/1.0wd"
                xmlns:nmi="http://schema.bipm.org/xml/imres/nmi/1.0wd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="IMR nmi xsi"
                version="1.0">
                
<!-- Stylesheet for converting mgi-resmd records to datacite records -->

   <xsl:output method="xml" encoding="UTF-8" indent="no" />
   <xsl:variable name="autoIndent" select="'  '"/>
   <xsl:preserve-space elements="*"/>

   <!--
     -  If true, insert carriage returns and indentation to produce a neatly 
     -  formatted output.  If false, any spacing between tags in the source
     -  document will be preserved.  
     -->
   <xsl:param name="prettyPrint" select="true()"/>

   <!--
     -  the per-level indentation.  Set this to a sequence of spaces when
     -  pretty printing is turned on.
     -->
   <xsl:param name="indent" select="'  '"/>


   <xsl:variable name="cr"><xsl:text>
</xsl:text></xsl:variable>

   <!-- ==========================================================
     -  General templates
     -  ========================================================== -->

   <xsl:template match="/">
      <xsl:apply-templates select="*">
         <xsl:with-param name="sp">
            <xsl:if test="$prettyPrint">
              <xsl:value-of select="$cr"/>
            </xsl:if>
         </xsl:with-param>
         <xsl:with-param name="step">
            <xsl:if test="$prettyPrint">
              <xsl:value-of select="$indent"/>
            </xsl:if>
         </xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="IMR:Resource">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <imr:Resource localid="{@localid}">
        
        <xsl:apply-templates select="resourceType">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="title">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="altTitle">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="sponsoringCountry">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="homeURL">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="contact">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="subject">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="description">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="date">
          <xsl:with-param name="sp" select="concat($sp,$step)"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>

        <xsl:value-of select="$sp"/>

      </imr:Resource>
   </xsl:template>

   <xsl:template match="sponsoringCountry">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:variable name="subsp" select="concat($sp,$step)"/>

      <xsl:value-of select="$sp"/>

      <sponsoringCountry>
        <xsl:value-of select="$subsp"/>
        <name><xsl:value-of select="."/></name>
        <xsl:value-of select="$subsp"/>
        <abbrev><xsl:value-of select="@abbrev"/></abbrev>
        <xsl:value-of select="$sp"/>
      </sponsoringCountry>
   </xsl:template>

   <xsl:template match="altTitle[@type='Abbreviation']">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <abbreviation><xsl:value-of select="."/></abbreviation>
   </xsl:template>
<!--
   <xsl:template match=""></xsl:template>
   <xsl:template match=""></xsl:template>
   <xsl:template match=""></xsl:template>
   -->

   <xsl:template match="description">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <description><xsl:value-of select="."/></description>
   </xsl:template>

   <xsl:template match="date">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <date><xsl:value-of select="."/></date>
   </xsl:template>


   <!-- default template -->
   <xsl:template match="*" priority="-1">
      <xsl:param name="sp"/>
      <xsl:param name="step"/>

      <xsl:value-of select="$sp"/>

      <xsl:copy>
         <xsl:for-each select="@*">
            <xsl:copy/>
         </xsl:for-each>

         <xsl:apply-templates select="child::node()">
            <xsl:with-param name="sp" select="concat($sp,$step)"/>
            <xsl:with-param name="step" select="$step"/>
         </xsl:apply-templates>

         <xsl:if test="$prettyPrint and contains(text()[1],$cr)">
           <xsl:value-of select="$sp"/>
         </xsl:if>
      </xsl:copy>
      
   </xsl:template>

   <!--
     -  template for handling ignorable whitespace
     -->
   <xsl:template match="text()" priority="-1">
      <xsl:variable name="trimmed" select="normalize-space(.)"/>
      <xsl:if test="not($prettyPrint) or string-length($trimmed) &gt; 0">
         <xsl:copy/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="text()" priority="-1" mode="trim">
      <xsl:if test="not($prettyPrint)">
         <xsl:choose>
            <xsl:when test="contains(.,$cr)">
               <xsl:value-of select="$cr"/>
               <xsl:call-template name="afterLastCR">
                  <xsl:with-param name="text" select="."/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>


</xsl:stylesheet>