<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Project Record</title>
            </head>
            <body>
                <h1><center>Project Record</center></h1>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="meta">
        <table style="width:80%" >
            <tr align="left">
                <th><b>Key:</b></th>
                <td> <xsl:value-of select="key"/> </td>
                <th><b>Begin Date:</b></th>
                <td> <xsl:value-of select="bdate"/> </td>
            </tr>
            <tr align="left">
                <th><b>Title:</b></th>
                <td> <xsl:value-of select="title"/> </td>
                <th><b>End Date:</b></th>
                <td> <xsl:value-of select="edate"/> </td>
            </tr>
            <tr align="left">
                <th> <b> Supervisor: </b> </th>
                <td> <xsl:value-of select="supervisor"/> </td>
            </tr>
        </table>
        <hr/>
        
    </xsl:template>
    
    <xsl:template match="workteam">
        <hr/>
        <h3>WorkTeam:</h3>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>
    
    <xsl:template match="worker">
        <li>
            <xsl:value-of select="@number"/> : 
            <xsl:value-of select="name"/> :
            <a href="mailto:{email}"><xsl:value-of select="email"/></a>
        </li>
    </xsl:template>
    
    <xsl:template match="abstract">
        <hr/>
        <h3>Abstract:</h3>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>
    
    
    <xsl:template match="deliverables">
        <hr/>
        <h3>Deliverables:</h3>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>
    
    <xsl:template match="link">
        <li>
            <a href="{@url}"><xsl:value-of select="."/></a>
        </li>
    </xsl:template>
    
    <xsl:template match="p">
        <div style="display:block; margin:10px;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="//b">
        <span style="font-weight: bold;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="//i">
        <span style="font-weight: italic;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="//u">
        <span style="text-decoration: underline;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    
    
    
    
</xsl:stylesheet>