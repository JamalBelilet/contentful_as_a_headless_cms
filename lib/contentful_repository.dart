import 'package:graphql/client.dart';

final _httpLink = HttpLink(
  'https://graphql.contentful.com/content/v1/spaces/f4aegqeepf1e',
);

final _authLink = AuthLink(
  getToken: () async => 'Bearer cgy-V7vodj8wNkPEPlMD7_xdAJ8njSmjcnfHdYaIjW4',
);

Link _link = _authLink.concat(_httpLink);

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _link,
);

class Product {
  final String slug;
  final String name;
  final String description;
  final int price;
  final Map<String, dynamic> featuredProductImage;

  const Product({
    required this.slug,
    required this.name,
    required this.description,
    required this.price,
    required this.featuredProductImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      featuredProductImage: json['featuredProductImage'],
    );
  }
}

Future<List<Product>> getProducts([limit = 10]) async {
  const String getProductsQuery = r'''
    query PageProductCollection($limit: Int) {
      pageProductCollection(limit: $limit) {
        items {
          slug
          name
          description
          price
          featuredProductImage {
            title
            url
          }
        }
      }
    }
  ''';

  final QueryOptions options = QueryOptions(
      document: gql(getProductsQuery), variables: {'limit': limit});

  final QueryResult result = await client.query(options);

  if (result.hasException) {
    throw Exception('Failed to load products');
  }

  final List<dynamic> json =
      result.data!['pageProductCollection']['items'] as List<dynamic>;

  final List<Product> products =
      json.map((productJson) => Product.fromJson(productJson)).toList();

  return products;
}

// For more check https://www.contentful.com/developers/docs/references/graphql/ 