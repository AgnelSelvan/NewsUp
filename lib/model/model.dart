



// public class Source
// {
//     public string id { get; set; }
//     public string name { get; set; }
//     public string description { get; set; }
//     public string url { get; set; }
//     public string category { get; set; }
//     public string language { get; set; }
//     public string country { get; set; }
// }

// public class Article
// {
//     public Source source { get; set; }
//     public string author { get; set; }
//     public string title { get; set; }
//     public string description { get; set; }
//     public string url { get; set; }
//     public string urlToImage { get; set; }
//     public DateTime publishedAt { get; set; }
//     public string content { get; set; }
// }


// public class RootObject
// {
//     public string status { get; set; }
//     public List<Source> sources { get; set; }
// }

class Article{
  final Source source ;
  final String author ;
  final String title ;
  final String description ;
  final String url ;
  final String urlToImage ;
  final String publishedAt ;
  final String content ;

  Article({
    this.author,
    this.content,
    this.description,
    this.publishedAt,
    this.source,
    this.title,
    this.url,
    this.urlToImage
  });
  
  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
      source: Source.fromJsonForArticle(json['source']),
      author: json['author'],
      content: json['content'],
      description: json['description'],
      publishedAt: json['publishedAt'],
      title: json['title'],
      url: json['url'],
      urlToImage: json['urlToImage']
    );
  }

}

class Source {
  final String id ;
  final String name ;
  final String description ;
  final String url ;
  final String category ;
  final String language ;
  final String country ;

  Source({
    this.id,
    this.category,
    this.country,
    this.description,
    this.language,
    this.name,
    this.url
  });

  factory Source.fromJson(Map<String, dynamic> json){
    return Source(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      country: json['country'],
      description: json['description'],
      language: json['language'],
      url: json['url']
    );
  }
  factory Source.fromJsonForArticle(Map<String, dynamic> json){
    return Source(
      id: json['id'],
      name: json['name']
    );
  }

}


class NewsAPI{
  final String status ;
  final List<Source> sources ;
  NewsAPI({this.status, this.sources});

  factory NewsAPI.fromJson(Map<String, dynamic> json){
    return NewsAPI(
      status: json['status'],
      sources: (json['articles'] as List).map((source) => Source.fromJson(source)).toList()
    );
  }
}
  