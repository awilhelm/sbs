<?xml-stylesheet href="memcheck.xsl" type="text/xsl"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<style>
			ol {background: black; color: white}
			li:nth-child(even) {background: #222}
			#all:not(:target) {display: none}
			#all:target+* {display: none}
		</style>
		<xsl:apply-templates select="document('debug/memcheck.xml')/*"/>
	</xsl:template>
	<xsl:template match="valgrindoutput">
		<xsl:variable name="error" select="error[stack/frame/obj[starts-with(., '/home/')]]"/>
		<h1>
			<xsl:value-of select="tool"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="pid"/>
			<xsl:text>]</xsl:text>
		</h1>
		<xsl:for-each select="args/*"><dl><xsl:apply-templates/></dl></xsl:for-each>
		<p>
			<a href="#"><xsl:value-of select="count($error)"/></a>
			<xsl:text>/</xsl:text>
			<a href="#all"><xsl:value-of select="count(error)"/></a>
		</p>
		<div id="all"><xsl:apply-templates select="error"/></div>
		<div><xsl:apply-templates select="$error"/></div>
	</xsl:template>
	<xsl:template match="exe"><dt><xsl:value-of select="."/></dt></xsl:template>
	<xsl:template match="arg"><dd><xsl:value-of select="."/></dd></xsl:template>
	<xsl:template match="error">
		<h2>
			<xsl:choose>
				<xsl:when test="what"><xsl:value-of select="what"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="kind"/></xsl:otherwise>
			</xsl:choose>
		</h2>
		<p><xsl:value-of select="auxwhat"/></p>
		<p><xsl:value-of select="xwhat/text"/></p>
		<xsl:for-each select="stack">
			<ol>
				<xsl:for-each select="frame">
					<li>
						<code>
							<xsl:choose>
								<xsl:when test="line">
									<xsl:value-of select="dir"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="file"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="line"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="obj"/></xsl:otherwise>
							</xsl:choose>
							<xsl:text> </xsl:text>
							<xsl:value-of select="fn"/>
						</code>
					</li>
				</xsl:for-each>
			</ol>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
