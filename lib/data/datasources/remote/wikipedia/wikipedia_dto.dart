class WikipediaSearchResultDto {
  final int pageId;
  final String title;
  final String snippet;

  WikipediaSearchResultDto({
    required this.pageId,
    required this.title,
    required this.snippet,
  });

  factory WikipediaSearchResultDto.fromJson(Map<String, dynamic> json) {
    return WikipediaSearchResultDto(
      pageId: json['pageid'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      snippet: json['snippet'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': pageId,
      'title': title,
      'snippet': snippet,
    };
  }
}

class WikipediaPageDto {
  final int pageId;
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String? fullUrl;

  WikipediaPageDto({
    required this.pageId,
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    this.fullUrl,
  });

  factory WikipediaPageDto.fromJson(Map<String, dynamic> json) {
    final pages = json['pages'] as Map<String, dynamic>?;
    if (pages == null || pages.isEmpty) {
      throw Exception('Страница не найдена');
    }

    final pageData = pages.values.first as Map<String, dynamic>;
    final thumbnail = pageData['thumbnail'] as Map<String, dynamic>?;
    final original = pageData['original'] as Map<String, dynamic>?;

    return WikipediaPageDto(
      pageId: pageData['pageid'] as int? ?? 0,
      title: pageData['title'] as String? ?? '',
      extract: pageData['extract'] as String? ?? '',
      thumbnailUrl: thumbnail?['source'] as String?,
      fullUrl: original?['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': pageId,
      'title': title,
      'extract': extract,
      'thumbnail': thumbnailUrl,
      'fullurl': fullUrl,
    };
  }
}

class WikipediaSummaryDto {
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String contentUrl;

  WikipediaSummaryDto({
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    required this.contentUrl,
  });

  factory WikipediaSummaryDto.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;
    return WikipediaSummaryDto(
      title: json['title'] as String? ?? '',
      extract: json['extract'] as String? ?? '',
      thumbnailUrl: thumbnail?['source'] as String?,
      contentUrl: json['content_urls']?['desktop']?['page'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'extract': extract,
      'thumbnail': thumbnailUrl,
      'content_urls': {'desktop': {'page': contentUrl}},
    };
  }
}

class WikipediaCategoryMemberDto {
  final int pageId;
  final String title;
  final String ns;

  WikipediaCategoryMemberDto({
    required this.pageId,
    required this.title,
    required this.ns,
  });

  factory WikipediaCategoryMemberDto.fromJson(Map<String, dynamic> json) {
    return WikipediaCategoryMemberDto(
      pageId: json['pageid'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      ns: json['ns'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': pageId,
      'title': title,
      'ns': ns,
    };
  }
}

class WikipediaLinkDto {
  final int pageId;
  final String title;
  final int ns;

  WikipediaLinkDto({
    required this.pageId,
    required this.title,
    required this.ns,
  });

  factory WikipediaLinkDto.fromJson(Map<String, dynamic> json) {
    return WikipediaLinkDto(
      pageId: json['pageid'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      ns: json['ns'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': pageId,
      'title': title,
      'ns': ns,
    };
  }
}

class WikipediaImageDto {
  final String title;
  final String? url;
  final int? width;
  final int? height;

  WikipediaImageDto({
    required this.title,
    this.url,
    this.width,
    this.height,
  });

  factory WikipediaImageDto.fromJson(Map<String, dynamic> json) {
    final imageInfo = json['imageinfo'] as List<dynamic>?;
    final info = imageInfo?.isNotEmpty == true 
        ? imageInfo!.first as Map<String, dynamic> 
        : null;

    return WikipediaImageDto(
      title: json['title'] as String? ?? '',
      url: info?['url'] as String?,
      width: info?['width'] as int?,
      height: info?['height'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'width': width,
      'height': height,
    };
  }
}

