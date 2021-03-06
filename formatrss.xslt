<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1" xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/" xmlns:hh="http://www.hannonhill.com/XSL/Functions" xmlns:wp="http://wordpress.org/export/1.2/" xmlns:xalan="http://xml.apache.org/xalan">

	<xsl:include href="/formats/Format Date"/>
	<xsl:variable name="indexPageName" select="'index'"/>
	<xsl:variable name="callingPage" select="/system-index-block/calling-page/system-page"/>
	<xsl:variable name="current-date" select="/system-index-block/@current-time"/>
	<xsl:variable name="news-categories" select="//calling-page/system-page/dynamic-metadata[starts-with(name,'category-')]/value"/>
	<xsl:variable name="site-url">https://news.ucsc.edu</xsl:variable>
	<xsl:variable name="html">.html</xsl:variable>
	<xsl:variable name="smallCasemachine" select="'abcdefghijklmnopqrstuvwxyz-'"/>
	<xsl:variable name="upperCasehuman" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '"/>
	<xsl:variable name="lead-width" select="//system-data-structure/lead-image/image/width"/>
	<xsl:variable name="lead-height" select="//system-data-structure/lead-image/image/height"/>

	<xsl:template match="system-index-block">
		<rss version="2.0">
			<channel>
				<xsl:apply-templates select="calling-page/system-page"/>
				<generator>UC Santa Cruz</generator>
				<!-- folder year add "system-folder/" or categories [not(ancestor::system-data-structure)][dynamic-metadata[starts-with(name,'category-') and value=$news-categories]]-->
				<xsl:apply-templates select="system-page">
					<xsl:sort data-type="number" order="descending" select="system-data-structure/article-date"/>
					<xsl:sort data-type="number" order="descending" select="start-date"/>
				</xsl:apply-templates>
			</channel>
		</rss>
	</xsl:template>


	<xsl:template match="system-page[parent::calling-page]">
		<title>
			<xsl:value-of select="title"/>
		</title>
		<link>
			<xsl:apply-templates mode="make-absolute" select="path"/>
		</link>
		<docs>
			<xsl:apply-templates mode="make-absolute" select="path"/>
		</docs>
		<pubDate>
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="/system-index-block/@current-time"/>
				<xsl:with-param name="mask">ddd, dd mmm yyyy HH:MM:ss o</xsl:with-param>
			</xsl:call-template>
		</pubDate>
	</xsl:template>

	<xsl:template match="path" mode="make-absolute">
		<xsl:value-of select="concat($site-url, self::node())"/>
	</xsl:template>

	<!-- system-folder/system-page for year -->
	<xsl:template match="system-page">
		<xsl:if test="system-data-structure/article-text != ''">
			<item>
				
				<!-- article title -->
				<title>
					<xsl:value-of select="title"/>
				</title>
				<!-- end article title -->

				<!-- creator -->
				
				<xsl:if test="system-data-structure/contact/name != ''">
					<author>
					[cascade:cdata]
						<xsl:value-of select="system-data-structure/contact/name"/>
					[/cascade:cdata]
					</author>
				</xsl:if>

				<!--<xsl:if test="system-data-structure/contact/name != ''">
					<dc:creator>
					[cascade:cdata]
						<xsl:value-of select="system-data-structure/contact/name"/>
					[/cascade:cdata]
					</dc:creator>
				</xsl:if>-->
				
				<!-- end creator -->
				
				<!-- pubDate -->
				<pubDate>
					<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
					<xsl:call-template name="format-date">
						<xsl:with-param name="date" select="start-date"/>
						<xsl:with-param name="mask">dddd, dd mmm yyyy</xsl:with-param>
					</xsl:call-template>
					<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
				</pubDate>
				<!-- end pubDate -->
				
				<!-- guid -->
				<guid isPermaLink="false">
					<xsl:apply-templates mode="make-absolute" select="path"/><xsl:value-of select="$html"/>
				</guid>
				<!-- end guid -->
				
				<!-- description (summary)-->
				<description>
					[cascade:cdata]
						<xsl:value-of select="summary"/>
					[/cascade:cdata]
				</description>
				<!-- end description (summary)-->

				<!-- body content -->
				<content:encoded>
					[cascade:cdata]
					<div class="wp-container-16 entry-content wp-block-post-content">
					<!-- embed video -->
					<xsl:if test="system-data-structure/video/embed/iframe/@src != ''">
						<xsl:choose>
							<!-- youtube -->
							<xsl:when test="contains(system-data-structure/video/embed/iframe/@src, 'youtube.com')">
								<xsl:text disable-output-escaping="yes">&lt;!-- wp:embed {"url":"https:</xsl:text><xsl:value-of select="system-data-structure/video/embed/iframe/@src"/><xsl:text disable-output-escaping="yes">","type":"video","providerNameSlug":"youtube","responsive":true,"className":"wp-embed-aspect-16-9 wp-has-aspect-ratio"} --&gt;</xsl:text>
								<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper">
									https:<xsl:value-of select="system-data-structure/video/embed/iframe/@src"/>
								</div><figcaption><xsl:value-of select="system-data-structure/video/caption"/></figcaption></figure>
								<xsl:text disable-output-escaping="yes">&lt;!-- /wp:embed --&gt;</xsl:text>
							</xsl:when>
							<!-- end youtube -->
							<!-- vimeo -->
							<xsl:when test="contains(system-data-structure/video/embed/iframe/@src, 'vimeo.com')">
								<xsl:text disable-output-escaping="yes">&lt;!-- wp:embed {"url":"https:</xsl:text><xsl:value-of select="system-data-structure/video/embed/iframe/@src"/><xsl:text disable-output-escaping="yes">","type":"video","providerNameSlug":"vimeo","responsive":true,"className":"wp-embed-aspect-16-9 wp-has-aspect-ratio"} --&gt;</xsl:text>
								<figure class="wp-block-embed is-type-video is-provider-vimeo wp-block-embed-vimeo wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper">
									https:<xsl:value-of select="system-data-structure/video/embed/iframe/@src"/>
								</div><figcaption><xsl:value-of select="system-data-structure/video/caption"/></figcaption></figure>
								<xsl:text disable-output-escaping="yes">&lt;!-- /wp:embed --&gt;</xsl:text>
							</xsl:when>
							<!-- end vimeo -->
							<!-- others embed -->
							<xsl:otherwise>
								<xsl:text disable-output-escaping="yes">&lt;!-- wp:html --&gt;</xsl:text>
									<xsl:copy-of select="system-data-structure/video/embed/iframe"/>
								<xsl:text disable-output-escaping="yes">&lt;!-- /wp:html --&gt;</xsl:text>
							</xsl:otherwise>
							<!-- end others embed -->
						</xsl:choose>
					</xsl:if>
					<!-- end embed video -->
					
					<!-- lead image -->
					<xsl:if test="system-data-structure/lead-image/image/path != '/'">
							<xsl:text disable-output-escaping="yes">&lt;!-- wp:image {"align":"right","className":"size-large","width":</xsl:text><xsl:value-of select="$lead-width"/><xsl:text disable-output-escaping="yes">,"height":</xsl:text><xsl:value-of select="$lead-height"/><xsl:text disable-output-escaping="yes">,"sizeSlug":"large"} --&gt;</xsl:text>
							<figure class="wp-block-image alignright is-resized size-large">
								<img alt="{system-data-structure/lead-image/image-alt}" height="{$lead-height}" src="{$site-url}{system-data-structure/lead-image/image/path}" width="{$lead-width}"/>
								<xsl:if test="system-data-structure/lead-image/image-caption != ''">
									<figcaption><xsl:value-of select="system-data-structure/lead-image/image-caption"/></figcaption>
								</xsl:if>
								</figure>
							<xsl:text disable-output-escaping="yes">&lt;!-- /wp:image --&gt;</xsl:text>
					</xsl:if>
					<!-- end lead image -->
					
					<!-- secondary image -->
					<xsl:for-each select="system-data-structure/secondary-images">
						<xsl:choose>
							<xsl:when test="image/path != '/'">
								<xsl:text disable-output-escaping="yes">&lt;!-- wp:image {"align":"right","className":"size-large","width":</xsl:text><xsl:value-of select="image/width"/><xsl:text disable-output-escaping="yes">,"height":</xsl:text><xsl:value-of select="image/height"/><xsl:text disable-output-escaping="yes">,"sizeSlug":"large"} --&gt;</xsl:text>
								<figure class="wp-block-image alignright is-resized size-large">
									<img alt="{image-alt}" height="{image/height}" src="{$site-url}{image/path}" width="{image/width}"/>
									<xsl:if test="image-caption != ''">
										<figcaption><xsl:value-of select="image-caption"/></figcaption>
									</xsl:if>
									</figure>
								<xsl:text disable-output-escaping="yes">&lt;!-- /wp:image --&gt;</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					<!-- end secondary image -->
					
					<!-- article text -->
						<xsl:copy-of select="system-data-structure/article-text/node() | @*"/>
					<!-- end article text -->

					<!-- related links -->
					<xsl:if test="system-data-structure/related-links/url !='http://' ">
						<xsl:text disable-output-escaping="yes">&lt;!-- wp:list --&gt;</xsl:text>
						<h3>Related links</h3>
						<ul>
							<xsl:for-each select="system-data-structure/related-links">
								<li><a href="{url}"><xsl:value-of select="title"/></a></li>
							</xsl:for-each>
						</ul>
						<xsl:text disable-output-escaping="yes">&lt;!-- /wp:list --&gt;</xsl:text>
					</xsl:if>
					<!-- end related links -->
					</div>
					[/cascade:cdata]
					
				</content:encoded>
				<!-- end body content-->

				<xsl:for-each select="dynamic-metadata">
					<xsl:choose>
						<xsl:when test="value != ''">
							<category>[cascade:cdata]<xsl:value-of select="value"/>[/cascade:cdata]</category>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</item>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>