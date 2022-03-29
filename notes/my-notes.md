<!-- old youtube code -->
<!-- embed video -->
<xsl:if test="system-data-structure/video/embed/iframe/@src != ''">
	<xsl:text disable-output-escaping="yes">&lt;!-- wp:embed {"url":"https:</xsl:text><xsl:value-of select="system-data-structure/video/embed/iframe/@src"/><xsl:text disable-output-escaping="yes">","type":"video","providerNameSlug":"youtube","responsive":true,"classNamea":"wp-embed-aspect-16-9 wp-has-aspect-ratio"} --&gt;</xsl:text>
	<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper">
		https:<xsl:value-of select="system-data-structure/video/embed/iframe/@src"/>
	</div><figcaption><xsl:value-of select="system-data-structure/video/caption"/></figcaption></figure>
	<xsl:text disable-output-escaping="yes">&lt;!-- /wp:embed --&gt;</xsl:text>
</xsl:if>
<!-- end embed video -->


post-subtitle

campus-message
	-To
	-Form