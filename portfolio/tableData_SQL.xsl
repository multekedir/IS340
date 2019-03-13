<?xml version="1.0"?>
<!DOCTYPE doc [ <!ENTITY SQ "'" > ]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text"/>

<!-- Initialize parameters. -->
<xsl:param name="naValue">n/a</xsl:param>  <!-- Pattern to match (or empty to ignore) for inapplicable data e.g. for 1- side of 1:many cardinality -->
<xsl:param name="nullValue">NULL</xsl:param>  <!-- String to match for NULL/no data, as distinct e.g. from empty data -->
<xsl:param name="timestamp"/>

<!-- ========== 
"Use" my database, process my entity data.
========== -->
<xsl:template match="/">

  <xsl:text>/*  </xsl:text>
  <xsl:if test="$timestamp">
    <xsl:text>Created by tableData_SQL </xsl:text><xsl:value-of select="$timestamp"/><xsl:text>
      </xsl:text>
  </xsl:if>
  <xsl:text>Not-applicable (n/a) data pattern (naValue):
      </xsl:text>
  <xsl:choose><xsl:when test="string-length($naValue)=0"><xsl:text>(not used)</xsl:text></xsl:when>
  <xsl:otherwise><xsl:value-of select="$naValue"/></xsl:otherwise></xsl:choose>
  <xsl:text>
    No-data (null) data value (nullValue):
      </xsl:text><xsl:value-of select="$nullValue"/><xsl:text>
*/
USE </xsl:text><xsl:value-of select="local-name(*)"/><xsl:text>;</xsl:text>

  <xsl:apply-templates select="//data/*" mode="entity"/>
  <xsl:text>
</xsl:text>

</xsl:template>


<!-- ========== 
Document my entity data, process my applicable attribute data.
========== -->
<xsl:template match="*" mode="entity">

  <xsl:if test="local-name(preceding-sibling::*[1]) != local-name(current())">
    <xsl:text>

/*  </xsl:text><xsl:value-of select="local-name()"/><xsl:text>( </xsl:text>
    <xsl:for-each select="*">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:if test="string-length($naValue)!=0 and contains(text(),$naValue)">
        <xsl:text>[n/a:</xsl:text>
      </xsl:if>
      <xsl:value-of select="local-name()"/>
      <xsl:if test="string-length($naValue)!=0 and contains(text(),$naValue)">
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> )
*/</xsl:text>
  </xsl:if>

  <xsl:text>
INSERT INTO </xsl:text><xsl:value-of select="local-name()"/><xsl:text> VALUES (
  </xsl:text>

  <xsl:apply-templates select="*[not(string-length($naValue)!=0 and contains(text(),$naValue))]" mode="attribute"/>

  <xsl:text> );</xsl:text>

</xsl:template>


<!-- ==========
"Insert" my applicable attribute data.
========== -->
<xsl:template match="*" mode="attribute">

  <xsl:if test="position()>1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="normalize-space(text())=$nullValue"><xsl:text>NULL</xsl:text></xsl:when>
    <xsl:when test='contains(text(),"&SQ;")'><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text></xsl:when>  <!-- Contains single-quote -->
    <xsl:when test="number(text())=text()"><xsl:value-of select="."/></xsl:when>  <!-- A number, don't quote it -->
    <xsl:when test="text() = 'CURRENT'"><xsl:text>NOW()</xsl:text></xsl:when>  <!-- if it is  CURRENT change to NOW() used for timestamp-->
    <xsl:otherwise><xsl:text>'</xsl:text><xsl:value-of select="."/><xsl:text>'</xsl:text></xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>
