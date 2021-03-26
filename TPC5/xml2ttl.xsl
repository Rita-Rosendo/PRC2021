<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/bibliography">
        <xsl:apply-templates select="/bibliography/inproceedings"/>
        <xsl:apply-templates select="/bibliography/inbook"/>
        <xsl:apply-templates select="/bibliography/article"/>
        <xsl:apply-templates select="/bibliography/book"/>
        <xsl:apply-templates select="/bibliography/masterthesis"/>
        <xsl:apply-templates select="/bibliography/misc"/>
        <xsl:apply-templates select="/bibliography/phdthesis"/>
        <xsl:apply-templates select="/bibliography/proceedings"/>
        <xsl:for-each select="*/author">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
             :Author ;
    :name "<xsl:value-of select="."/>" .
        </xsl:for-each>
        <xsl:for-each select="*/editor">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
            :Editor ;
    :name "<xsl:value-of select="."/>" .
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="inproceedings">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                   :Inproceedings ;
           :isWritten <xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/></xsl:variable><xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">:<xsl:value-of select="@id"/> ,</xsl:for-each>
            <xsl:for-each select="author[position() != 1]">
                      :<xsl:value-of select="@id"/> ,</xsl:for-each>
           <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                      :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
           <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                      :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
           :address "<xsl:value-of select="address"/>" ;
           :booktitle "<xsl:value-of select="booktitle"/>" ;
           :month "<xsl:value-of select="month"/>" ;
           :title "<xsl:value-of select="title"/>" ;
           <xsl:if test="deliverables">
           :deliverables "<xsl:value-of select="deliverables/pdf/@url"/>" ;</xsl:if> 
           <xsl:if test="editor">
           :editor "<xsl:value-of select="editor/@id"/>" ;</xsl:if> 
           <xsl:if test="uri">
           :uri "<xsl:value-of select="uri"/>" ;</xsl:if> 
           <xsl:if test="issn"> 
           :issn "<xsl:value-of select="issn"/>" ;</xsl:if> 
           :year <xsl:value-of select="year"/> .
    </xsl:template>  
    
    <xsl:template match="inbook">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                  :Inbook ;
        :isWritten  <xsl:choose>
            <xsl:when test="editor or editor-ref">
                <xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/></xsl:variable><xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">:<xsl:value-of select="@id"/>,</xsl:for-each>
                <xsl:for-each select="author[position() != 1]">
                    :<xsl:value-of select="@id"/>,</xsl:for-each>
                <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:variable name="countEditors"> <xsl:value-of select="count(editor)"/></xsl:variable><xsl:variable name="countEditorsREF"><xsl:value-of select="count(editor-ref)"/> </xsl:variable>
                <xsl:for-each select="editor-ref[position() = 1]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="editor-ref[position() != 1]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="editor[position() &lt; $countEditors]">
                    :<xsl:value-of select="@id"/> ,</xsl:for-each>
                <xsl:for-each select="editor[position() = $countEditors]">
                    :<xsl:value-of select="@id"/>;</xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/></xsl:variable><xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">:<xsl:value-of select="@id"/>,</xsl:for-each>
                <xsl:for-each select="author[position() != 1]">
                    :<xsl:value-of select="@id"/>,</xsl:for-each>
                <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        
        :chapter "<xsl:value-of select="chapter"/>" ;
        :month "<xsl:value-of select="month"/>" ; 
        <xsl:if test="volume">
        :volume "<xsl:value-of select="volume"/>" ;</xsl:if> 
        :pages "<xsl:value-of select="pages"/>" ;
        :publisher "<xsl:value-of select="publisher"/>" ;
        :title "<xsl:value-of select="title"/>" ;
        <xsl:if test="isbn">:isbn "<xsl:value-of select="isbn"/>" ;</xsl:if>
        <xsl:if test="doi">
        :doi "<xsl:value-of select="doi"/>" ;</xsl:if> 
        :year <xsl:value-of select="year"/> .
     </xsl:template>
    
    <xsl:template match="article">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                  :Article ;
        :isWritten  <xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/></xsl:variable><xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">:<xsl:value-of select="@id"/> ,</xsl:for-each>
        <xsl:for-each select="author[position() != 1]">
                   :<xsl:value-of select="@id"/> ,</xsl:for-each>
        <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
        <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
        :title "<xsl:value-of select="title"/>" ;
        <xsl:if test="doi">
        :doi "<xsl:value-of select="doi"/>" ;</xsl:if>
        <xsl:if test="issn">
        :issn "<xsl:value-of select="issn"/>" ;</xsl:if>
        <xsl:if test="month">
        :month "<xsl:value-of select="month"/>" ;</xsl:if>
        <xsl:if test="publisher">
        :publisher "<xsl:value-of select="publisher"/>" ;</xsl:if>
        <xsl:if test="uri">
        :uri "<xsl:value-of select="uri"/>" ;</xsl:if>
        <xsl:if test="volume">
        :volume "<xsl:value-of select="volume"/>" ;</xsl:if>
        <xsl:if test="year">
        :year <xsl:value-of select="year"/> ;</xsl:if>
        <xsl:if test="number">
        :number <xsl:value-of select="number"/> ;</xsl:if> 
        :journal "<xsl:value-of select="journal"/>" .
    </xsl:template>
    
    <xsl:template match="book">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                  :Book ;
        :isWritten  <xsl:choose>
            <xsl:when test="author"><xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">
                    :<xsl:value-of select="@id"/> ,</xsl:for-each>
                <xsl:for-each select="author[position() != 1]">
                    :<xsl:value-of select="@id"/> ;</xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable>
                <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                    :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        
        :title "<xsl:value-of select="title"/>" ;
        :publisher "<xsl:value-of select="publisher"/>" ;
        :year <xsl:value-of select="year"/> ;
        :address "<xsl:value-of select="address"/>" ;<xsl:if test="isbn">
        :isbn "<xsl:value-of select="isbn"/>" ;</xsl:if>
        :month "<xsl:value-of select="month"/>" .
    </xsl:template>
    
    <xsl:template match="masterthesis">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                  :Masterthesis ;
        :isWritten :<xsl:value-of select="author-ref/@authorid"/> ;
        :title "<xsl:value-of select="title"/>" ;
        :school "<xsl:value-of select="school"/>" ;
        :year <xsl:value-of select="year"/> ;
        :month "<xsl:value-of select="month"/>" .
    </xsl:template>
    
    <xsl:template match="misc">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                  :Misc ;
        :isWritten  <xsl:variable name="countAuthors"> <xsl:value-of select="count(author)"/></xsl:variable><xsl:variable name="countAuthorsREF"><xsl:value-of select="count(author-ref)"/> </xsl:variable><xsl:for-each select="author[position() = 1]">:<xsl:value-of select="@id"/> ,</xsl:for-each>
        <xsl:for-each select="author[position() != 1]">
                   :<xsl:value-of select="@id"/> ,</xsl:for-each>
        <xsl:for-each select="author-ref[position() &lt; $countAuthorsREF]">
                   :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
        <xsl:for-each select="author-ref[position() = $countAuthorsREF]">
                   :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
        :title "<xsl:value-of select="title"/>" ;
        :howpublished "<xsl:value-of select="howpublished"/>" ;<xsl:if test="doi">
        :doi "<xsl:value-of select="doi"/>" ;</xsl:if>
        :year <xsl:value-of select="year"/> .
    </xsl:template>
    
    
    <xsl:template match="phdthesis">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
                :Phdthesis ;
        :isWritten :<xsl:value-of select="author-ref/@authorid"/> ;
        :title "<xsl:value-of select="title"/>" ;
        :school "<xsl:value-of select="school"/>" ;
        :year <xsl:value-of select="year"/> ;
        :address "<xsl:value-of select="address"/>" ;
        :month "<xsl:value-of select="month"/>" ;
        :doi "<xsl:value-of select="doi"/>" .
    </xsl:template>
    
    
    
    <xsl:template match="proceedings">
###  http://www.semanticweb.org/aninhas/ontologies/pubs#<xsl:value-of select="@id"/>
:<xsl:value-of select="@id"/> rdf:type owl:NamedIndividual ,
        :Proceedings ;
        :isWritten  <xsl:choose>
            <xsl:when test="editor ">
                <xsl:variable name="countEditors"> <xsl:value-of select="count(editor)"/></xsl:variable><xsl:variable name="countEditorsREF"><xsl:value-of select="count(editor-ref)"/> </xsl:variable>
                <xsl:for-each select="editor-ref[position() = 1]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="editor-ref[position() != 1]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="editor[position() &lt; $countEditors]">
                    :<xsl:value-of select="@id"/> ,</xsl:for-each>
                <xsl:for-each select="editor[position() = $countEditors]">
                    :<xsl:value-of select="@id"/> ;</xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="countEditorsREF"><xsl:value-of select="count(editor-ref)"/> </xsl:variable>
                <xsl:for-each select="editor-ref[position() &lt; $countEditorsREF]">
                    :<xsl:value-of select="@authorid"/> ,</xsl:for-each>
                <xsl:for-each select="editor-ref[position() = $countEditorsREF]">
                    :<xsl:value-of select="@authorid"/> ;</xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        :title "<xsl:value-of select="title"/>" ;
        :year <xsl:value-of select="year"/> ;
        :address "<xsl:value-of select="address"/>" ;
        :month "<xsl:value-of select="month"/>" ; 
        <xsl:if test="isbn">
        :isbn "<xsl:value-of select="isbn"/>" ;</xsl:if> 
        :doi "<xsl:value-of select="doi"/>" .
    </xsl:template>
    
  </xsl:stylesheet>