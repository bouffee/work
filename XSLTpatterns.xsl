<-- head -->

  <xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
</xsl:stylesheet>

<--remove all prefixes for namespace except root node-->
  
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="/*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>      
    </xsl:copy>
  </xsl:template>

<-- end of removing -->

<--remove ALL prefixes in whole document -->
