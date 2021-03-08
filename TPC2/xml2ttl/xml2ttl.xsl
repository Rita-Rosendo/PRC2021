<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8" indent="yes"/>
    
    
    <xsl:template match="obra">
        ###  http://www.semanticweb.org/aninhas/ontologies/arquivoMusical#<xsl:value-of select="@id"/>
        :<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
        :Obra ;
        <xsl:if test="tipo">:tipo "<xsl:value-of select="tipo"/>" ;  </xsl:if>
        <xsl:if test="titulo">
        :título "<xsl:value-of select="titulo"/>"</xsl:if> .
        # ----------------------------------------------------------------
        
        <xsl:if test="compositor">
        ###  http://www.semanticweb.org/aninhas/ontologies/arquivoMusical#<xsl:value-of select="translate(compositor,' ','')"/>
        :<xsl:value-of select="translate(compositor,' ','')"/> rdf:type owl:NamedIndividual ,
        :Compositor ;
        :compôs :<xsl:value-of select="@id"/> ;
        :nome "<xsl:value-of select="compositor"/>" .
        # -----------------------------------------------------------------
        </xsl:if>
       
        <xsl:for-each-group select="instrumentos/instrumento" group-by=".">
        ###  http://www.semanticweb.org/aninhas/ontologies/arquivoMusical#<xsl:value-of select="translate(designacao,' ','')"/>
        :<xsl:value-of select="translate(designacao,' ','')"/> rdf:type owl:NamedIndividual ,
        :Instrumento ;
        :utilizadoEm :<xsl:value-of select="../../@id"/> ;
        :designação "<xsl:value-of select="designacao"/>" .
        # ----------------------------------------------------------------
            
       <xsl:for-each select="partitura">
        ###  http://www.semanticweb.org/aninhas/ontologies/arquivoMusical#:<xsl:value-of select="@path"/>
        :<xsl:value-of select="@path"/> rdf:type owl:NamedIndividual ,
        :Partitura ;
        :relativaA :<xsl:value-of select="translate(../designacao,' ','')"/> ;
        <xsl:if test="@path">:path "<xsl:value-of select="@path"/>" ;</xsl:if>
        <xsl:if test="@type">
        :tipo "<xsl:value-of select="@type"/>" ;</xsl:if>
        <xsl:if test="@voz">
        :voz "<xsl:value-of select="@voz"/>"</xsl:if> .
        # ----------------------------------------------------------------
       </xsl:for-each>
            
        </xsl:for-each-group>
     
    </xsl:template>  
    

    
    
</xsl:stylesheet>