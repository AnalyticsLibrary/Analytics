<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
>
  <!--<xsl:output method="text" indent="yes"/>-->

  <xsl:template match="/">
    <mapping>
      <xsl:text>&#xA;</xsl:text>
      <xsl:apply-templates select="*"/>
    </mapping>
  </xsl:template>

  <xsl:template match="xsd:element[xsd:simpleType/xsd:restriction/xsd:enumeration/xsd:annotation]">
    <xsl:apply-templates select="xsd:simpleType/xsd:restriction/xsd:enumeration" mode="copy">
      <xsl:with-param name="name" select="@name"></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsd:simpleType[@name and xsd:restriction/xsd:enumeration/xsd:annotation]">
    <xsl:apply-templates select="xsd:restriction/xsd:enumeration" mode="copy">
      <xsl:with-param name="name" select="@name"></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xsd:enumeration" mode="copy">
    <xsl:param name="name"/>
    <xsl:value-of select="$name"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

</xsl:stylesheet>
