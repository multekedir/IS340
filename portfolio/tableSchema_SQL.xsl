<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text"/>

<!-- n.b. Many-to-many relationships not allowed in a _table_ schema design, will error in mysterious ways. -->

<!-- Initialize parameters and variables. -->
<xsl:param name="schemaTypes">ENTITY;RELATIONSHIP</xsl:param>  <!-- "ENTITY" or "RELATIONSHIP" or both -->
<xsl:param name="dataTypes"></xsl:param>  <!-- e.g. for typical SQL DBMS: "STR=VARCHAR(100);MONEY=NUMERIC(10,2)"; or ID/REF; or DEFAULT for default -->
<xsl:param name="idSuffix">_PK</xsl:param>
<xsl:param name="refSuffix">_FK</xsl:param>
<xsl:param name="timestamp"></xsl:param>

<!-- ========== -->
<xsl:template match="/">
  <xsl:variable name="focus"><xsl:choose><xsl:when test="entities/focus!=''"><xsl:value-of select="translate(entities/focus/text(),' ','_')"/></xsl:when>
    <xsl:otherwise>NO_FOCUS</xsl:otherwise></xsl:choose></xsl:variable>

  <xsl:if test="contains($schemaTypes,'ENT')">
    <xsl:text>/*  UNCOMMENT to start over:
DROP DATABASE IF EXISTS </xsl:text><xsl:value-of select="$focus"/><xsl:text>;
*/
</xsl:text>
  </xsl:if>
  <xsl:text>/*  </xsl:text>
  <xsl:if test="$timestamp">
    <xsl:text>Created by tableDesign_SQL </xsl:text><xsl:value-of select="$timestamp"/><xsl:text>

      </xsl:text>
  </xsl:if>
  <xsl:text>Schema types (schemaTypes):
      </xsl:text><xsl:value-of select="$schemaTypes"/>
  <xsl:if test="contains($schemaTypes,'ENT')">
    <xsl:text>
    Design data types mapped to SQL data types (dataTypes):
      </xsl:text>
    <xsl:choose><xsl:when test="string-length($dataTypes)>0"><xsl:value-of select="$dataTypes"/></xsl:when>
      <xsl:otherwise><xsl:text>(none; use ID, REF, DEFAULT, ...)</xsl:text></xsl:otherwise></xsl:choose>
  </xsl:if>
    <xsl:text>
    ID/Reference constraint suffixes (idSuffix, refSuffix):
      </xsl:text><xsl:value-of select="$idSuffix"/><xsl:text>, </xsl:text><xsl:value-of select="$refSuffix"/>
  <xsl:text>
*/
</xsl:text>
  <xsl:if test="contains($schemaTypes,'ENT')">
    <xsl:text>CREATE DATABASE IF NOT EXISTS </xsl:text><xsl:value-of select="$focus"/>
<xsl:text>;
</xsl:text>
  </xsl:if>
  <xsl:text>USE </xsl:text><xsl:value-of select="$focus"/>
<xsl:text>;</xsl:text>

  <xsl:if test="contains($schemaTypes,'ENT')">
    <xsl:apply-templates select="//entity"/>
  </xsl:if>
  <xsl:text>
</xsl:text>

  <xsl:if test="contains($schemaTypes,'REL')">
    <xsl:text>
/*************************************************************************************
    Note for foreign key constraints below:
    - Consider applying these constraints AFTER adding initial data, to avoid nuisance
      errors and to more directly identify issues with design or initial data
**************************************************************************************/
</xsl:text>
  </xsl:if>

<xsl:if test="contains($schemaTypes,'REL')">
  <xsl:apply-templates select="//attribute[(@type='REF' or @relationship='#') and @max!='*']" mode="addFKs"/>
</xsl:if>

</xsl:template>


<!-- ========== -->
<xsl:template match="entity">
<!--n.b. By convention for 1:1 two-way relationship, puts foreign key in _first_ entity (in doc order). -->

  <xsl:text>

CREATE TABLE </xsl:text><xsl:value-of select="@name"/><xsl:text> (
</xsl:text>

  <xsl:apply-templates select="attribute[not(@type='REF')
    or (@max!='*' and count(../preceding-sibling::entity/attribute[@name=current()/@name and @max!='*'])=0)]"/>
  <xsl:apply-templates select="attribute[@type='ID']" mode="addPK"/>

  <xsl:text>
);</xsl:text>

</xsl:template>


<!-- ========== -->
<xsl:template match="attribute">

  <xsl:if test="position()>1">
    <xsl:text>,
</xsl:text>
  </xsl:if>
  <!-- Disambiguate attribute names  -->
  <xsl:choose>
     <xsl:when test="@name=preceding-sibling::attribute/@name or @name=following-sibling::attribute/@name">
       <xsl:text>  </xsl:text><xsl:value-of select="@relationship"/><xsl:text>_</xsl:text><xsl:value-of select="@name"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>  </xsl:text><xsl:value-of select="@name"/>
     </xsl:otherwise>
  </xsl:choose>

<xsl:value-of select="substring('             ',string-length(@name))"/>

  <xsl:choose>
    <xsl:when test="@type and string-length(@type)>0 and contains(concat(';',$dataTypes),concat(';',@type,'='))">
      <xsl:variable name="mappedType"><xsl:value-of select="substring-before(substring-after(concat(';',$dataTypes,';'),concat(';',@type,'=')),';')"/></xsl:variable>
      <xsl:text>  </xsl:text><xsl:value-of select="$mappedType"/>
      <xsl:value-of select="substring('        ',string-length($mappedType))"/>
    </xsl:when>
    <xsl:when test="not(@type)
        or (@type and not(contains(concat(';',$dataTypes),concat(';',@type,'='))) and contains(concat(';',$dataTypes),';DEFAULT='))">
      <xsl:variable name="mappedType"><xsl:value-of select="substring-before(substring-after(concat(';',$dataTypes,';'),';DEFAULT='),';')"/></xsl:variable>
      <xsl:text>  /* DEFAULT DATA TYPE: */ </xsl:text><xsl:value-of select="$mappedType"/>
      <xsl:value-of select="substring('     ',string-length($mappedType))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>  /* DESIGN DATA TYPE: */ </xsl:text><xsl:value-of select="@type"/>
      <xsl:value-of select="substring('     ',string-length(@type))"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="@type='ID'"><xsl:text>  NOT NULL  /* PK */</xsl:text></xsl:when>
    <xsl:when test="@min=0"><xsl:text>      NULL</xsl:text></xsl:when>
    <xsl:when test="not(@max) or @max='+' or @max>0"><xsl:text>  NOT NULL</xsl:text></xsl:when>
  </xsl:choose>

</xsl:template>


<!-- ========== -->
<xsl:template match="attribute" mode="addPK">

  <xsl:choose>
    <xsl:when test="@type='ID'">
      <xsl:if test="position()=1">
        <xsl:text>,
      CONSTRAINT  </xsl:text>
        <xsl:value-of select="../@name"/><xsl:value-of select="$idSuffix"/>
        <xsl:text>  PRIMARY KEY (</xsl:text>
      </xsl:if>
      <xsl:if test="position()>1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="@name"/>
      <xsl:if test="position()=last()">
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:when>
  </xsl:choose>

</xsl:template>


<!-- ========== -->
<xsl:template match="attribute" mode="addFKs">
<!-- n.b. Generates bi-directional FK constraints for 1:1; design may use @min=0 to support data inserts in any order AND/OR may remove over-zealous constraints. -->

  <xsl:text>
ALTER TABLE </xsl:text><xsl:value-of select="../@name"/><xsl:text>
  ADD CONSTRAINT  </xsl:text>
  <xsl:value-of select="../@name"/>_<xsl:value-of select="@name"/><xsl:value-of select="$refSuffix"/>
    <xsl:text> FOREIGN KEY (</xsl:text>
  <xsl:value-of select="@name"/>
    <xsl:text>)</xsl:text>
  <xsl:text> REFERENCES </xsl:text><xsl:value-of select="@name"/>
  <xsl:text> (</xsl:text>
  <xsl:for-each select="//entity[@name=current()/@name]/attribute[@type='ID']/@name">
    <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
    <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:text>)
;
</xsl:text>

</xsl:template>

</xsl:stylesheet>
