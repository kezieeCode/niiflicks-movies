class LatestReleases {
  String title;
  String slug;
  String thumbnail;

  LatestReleases({this.title, this.slug, this.thumbnail});

  LatestReleases.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    slug = json['slug'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}