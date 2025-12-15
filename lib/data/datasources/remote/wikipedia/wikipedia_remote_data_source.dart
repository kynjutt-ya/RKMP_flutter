import '../../../network/dio_client.dart';
import '../../../network/network_exceptions.dart';
import 'wikipedia_dto.dart';

abstract class WikipediaRemoteDataSource {

  Future<List<WikipediaSearchResultDto>> searchArticles(String query, {int limit = 5});

  Future<WikipediaPageDto> getPageContent(String title);

  Future<List<WikipediaCategoryMemberDto>> getCategoryMembers(String category, {int limit = 10});

  Future<List<WikipediaLinkDto>> getPageLinks(String title, {int limit = 10});

  Future<List<WikipediaImageDto>> getPageImages(String title, {int limit = 10});
}

class WikipediaRemoteDataSourceImpl implements WikipediaRemoteDataSource {
  final DioClient _dioClient;
  final DioClient _restClient;

  WikipediaRemoteDataSourceImpl({
    required DioClient dioClient,
    DioClient? restClient,
  })  : _dioClient = dioClient,
        _restClient = restClient ?? dioClient;

  @override
  Future<List<WikipediaSearchResultDto>> searchArticles(String query, {int limit = 5}) async {
    try {
      print('🌐 Wikipedia: Поиск статей по запросу "$query"');
      final response = await _dioClient.get(
        '/w/api.php',
        queryParameters: {
          'action': 'query',
          'list': 'search',
          'srsearch': query,
          'srlimit': limit,
          'format': 'json',
          'srnamespace': 0,
        },
      );

      final queryData = response.data['query'] as Map<String, dynamic>?;
      if (queryData != null && queryData['search'] != null) {
        final results = (queryData['search'] as List)
            .map((json) => WikipediaSearchResultDto.fromJson(json as Map<String, dynamic>))
            .toList();
        print('✅ Wikipedia: Найдено ${results.length} статей');
        return results;
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка поиска статей Wikipedia: $e');
      throw NetworkException('Ошибка при поиске статей: $e');
    }
  }

  @override
  Future<WikipediaPageDto> getPageContent(String title) async {
    try {
      print('🌐 Wikipedia: Получение содержимого статьи "$title"');
      final response = await _dioClient.get(
        '/w/api.php',
        queryParameters: {
          'action': 'query',
          'prop': 'extracts|pageimages',
          'titles': title,
          'exintro': '1',
          'explaintext': '1',
          'format': 'json',
          'pithumbsize': 200,
        },
      );

      final queryData = response.data['query'] as Map<String, dynamic>?;
      if (queryData != null) {
        return WikipediaPageDto.fromJson(queryData);
      }

      throw NotFoundException('Статья не найдена');
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка получения содержимого Wikipedia: $e');
      throw NetworkException('Ошибка при получении содержимого статьи: $e');
    }
  }

  @override
  Future<List<WikipediaCategoryMemberDto>> getCategoryMembers(String category, {int limit = 10}) async {
    try {
      final categoryTitle = category.startsWith('Категория:') 
          ? category 
          : 'Категория:$category';
      
      print('🌐 Wikipedia: Получение статей из категории "$categoryTitle"');
      final response = await _dioClient.get(
        '/w/api.php',
        queryParameters: {
          'action': 'query',
          'list': 'categorymembers',
          'cmtitle': categoryTitle,
          'cmlimit': limit,
          'format': 'json',
          'cmnamespace': 0,
        },
      );

      final queryData = response.data['query'] as Map<String, dynamic>?;
      if (queryData != null && queryData['categorymembers'] != null) {
        final results = (queryData['categorymembers'] as List)
            .map((json) => WikipediaCategoryMemberDto.fromJson(json as Map<String, dynamic>))
            .toList();
        print('✅ Wikipedia: Найдено ${results.length} статей в категории');
        return results;
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка получения категории Wikipedia: $e');
      throw NetworkException('Ошибка при получении статей из категории: $e');
    }
  }

  @override
  Future<List<WikipediaLinkDto>> getPageLinks(String title, {int limit = 10}) async {
    try {
      print('🌐 Wikipedia: Получение связанных статей для "$title"');
      final response = await _dioClient.get(
        '/w/api.php',
        queryParameters: {
          'action': 'query',
          'prop': 'links',
          'titles': title,
          'pllimit': limit,
          'format': 'json',
          'plnamespace': 0,
        },
      );

      final queryData = response.data['query'] as Map<String, dynamic>?;
      if (queryData != null) {
        final pages = queryData['pages'] as Map<String, dynamic>?;
        if (pages != null && pages.isNotEmpty) {
          final pageData = pages.values.first as Map<String, dynamic>;
          final links = pageData['links'] as List<dynamic>?;
          if (links != null) {
            final results = links
                .map((json) => WikipediaLinkDto.fromJson(json as Map<String, dynamic>))
                .toList();
            print('✅ Wikipedia: Найдено ${results.length} связанных статей');
            return results;
          }
        }
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка получения связанных статей Wikipedia: $e');
      throw NetworkException('Ошибка при получении связанных статей: $e');
    }
  }

  @override
  Future<List<WikipediaImageDto>> getPageImages(String title, {int limit = 10}) async {
    try {
      print('🌐 Wikipedia: Получение изображений для "$title"');
      final response = await _dioClient.get(
        '/w/api.php',
        queryParameters: {
          'action': 'query',
          'prop': 'images|imageinfo',
          'titles': title,
          'imlimit': limit,
          'format': 'json',
          'iiprop': 'url|size',
        },
      );

      final queryData = response.data['query'] as Map<String, dynamic>?;
      if (queryData != null) {
        final pages = queryData['pages'] as Map<String, dynamic>?;
        if (pages != null && pages.isNotEmpty) {
          final pageData = pages.values.first as Map<String, dynamic>;
          final images = pageData['images'] as List<dynamic>?;
          if (images != null && images.isNotEmpty) {
            final imageTitles = images
                .map((img) => (img as Map<String, dynamic>)['title'] as String)
                .take(limit)
                .join('|');

            print('🌐 Wikipedia: Получение информации об изображениях для "$title"');
            final imageInfoResponse = await _dioClient.get(
              '/w/api.php',
              queryParameters: {
                'action': 'query',
                'titles': imageTitles,
                'prop': 'imageinfo',
                'iiprop': 'url|size',
                'format': 'json',
              },
            );

            final imageInfoData = imageInfoResponse.data['query'] as Map<String, dynamic>?;
            if (imageInfoData != null) {
              final imagePages = imageInfoData['pages'] as Map<String, dynamic>?;
              if (imagePages != null) {
                final results = imagePages.values
                    .map((img) => WikipediaImageDto.fromJson(img as Map<String, dynamic>))
                    .where((img) => img.url != null)
                    .take(limit)
                    .toList();
                print('✅ Wikipedia: Найдено ${results.length} изображений');
                return results;
              }
            }
          }
        }
      }

      return [];
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Ошибка получения изображений Wikipedia: $e');
      throw NetworkException('Ошибка при получении изображений: $e');
    }
  }
}

