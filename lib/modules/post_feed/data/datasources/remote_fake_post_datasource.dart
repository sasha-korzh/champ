
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/data/datasources/remote_post_datasource.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';

class RemoteFakePostDataSource extends RemotePostDataSource {

  var postToCreate = Post(
    id: DateTime.now().microsecond.toString(),
    comments: [],
    createdAt: DateTime.now(),
    likesCount: 0,
    postElements: [
      PostElement(
        id: 'pe-1',
        type: PostElementType.h1,
        data: 'Бокс для начинающих: с чего начать на первой тренировке?'
      ),
      PostElement(
        id: 'pe-2',
        type: PostElementType.text,
        data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
      ),
      PostElement(
        id: 'pe-3',
        type: PostElementType.image,
        data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
      ),
    ],
    topicInfo: TopicInfo(
      id: 'topic-id1',
      name: 'Спорт Дома',
      avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
    ),
  );

  @override
  Future<Post> createPost(Post post, UserShortInfo author) async {
    return postToCreate.copyWith(
      author: author
    );
  }

  @override
  Future<void> createPostLike(String postId, String userId, int likesCount, String likeId) async {
    allPosts.firstWhere((e) => e.id == postId).likesCount++;
  }

  @override
  Future<void> deletePostLike(String postId, String userId, int likesCount, String likeId) async {
    allPosts.firstWhere((e) => e.id == postId).likesCount--;
  }

  @override
  Future<PostPage> getPostPageByTopics(List<String> topicIds, String lastEvaluatedKey) async {
    if (topicIds.isEmpty) {
      final topics = await getAllTopics();
      topicIds = topics.map((e) => e.id).toList();
    }
    if (lastEvaluatedKey == '1') {
      final posts = allPosts.where((e) => topicIds.contains(e.topicInfo.id)).skip(2).take(2);
      final itemsToPostPage = List<Post>.from(posts);
      return PostPage(
        count: 2,
        lastEvaluatedKey: 'last',
        items: itemsToPostPage,
      );
    }
    if (lastEvaluatedKey == 'last') {
      return PostPage(
        count: 0,
        lastEvaluatedKey: null,
        items: []
      );
    } 
    if (lastEvaluatedKey == null) {
      final posts = allPosts.where((e) => topicIds.contains(e.topicInfo.id)).take(2);
      final itemsToPostPage = List<Post>.from(posts);
      return PostPage(
        count: 2,
        lastEvaluatedKey: '1',
        items: itemsToPostPage,
      );
    }

  }

  @override
  Future<PostPage> getCreatedPostPageByUserId(String userId, String lastEvaluatedKey) async {
    if (lastEvaluatedKey == 'last') {
      return PostPage(
        count: 0,
        lastEvaluatedKey: null,
        items: []
      );
    } 
    if (lastEvaluatedKey == null) {
      final posts = allPosts.where((e) => e.author.id == userId);
      final itemsToPostPage = List<Post>.from(posts);
      return PostPage(
        count: itemsToPostPage.length,
        lastEvaluatedKey: 'last',
        items: itemsToPostPage,
      );
    }
  }

  @override
  Future<List<Topic>> getAllTopics() async {
    return [
      Topic(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
        followers: [
          UserShortInfo(
            id: 'user-id1',
            fullname: 'Иван Фейковый',
            avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
          ),
        ]
      ),
      Topic(
        id: 'topic-id2',
        name: 'Тенніс',
        avatarImageUrl: 'https://images.unsplash.com/photo-1561504583-061f9660a9b7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
        followers: [
        ]
      ),
      Topic(
        id: 'topic-id3',
        name: 'Бокс',
        avatarImageUrl: 'https://images.unsplash.com/photo-1552072092-7f9b8d63efcb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        followers: [
        ]
      ),
    ];
  }





  List<Post> allPosts = [
    Post(
      id: 'afsd8uf9aus9duu6ashf4k2hl',
        author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      comments: [],
      createdAt: DateTime.now(),
      likesCount: 12,
      postElements: [
        PostElement(
          id: 'pe-1',
          type: PostElementType.h1,
          data: 'Бокс для начинающих: с чего начать на первой тренировке?'
        ),
        PostElement(
          id: 'pe-2',
          type: PostElementType.text,
          data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
        ),
        PostElement(
          id: 'pe-3',
          type: PostElementType.image,
          data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
        ),
      ],
      topicInfo: TopicInfo(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
      ),
    ),
    

    // ! ################ 2 ####################
    Post(
      id: 'afsd8uf9aus9duu6ashf4k2hl',
        author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      comments: [],
      createdAt: DateTime.now(),
      likesCount: 12,
      postElements: [
        PostElement(
          id: 'pe-1',
          type: PostElementType.h1,
          data: 'Бокс для начинающих: с чего начать на первой тренировке?'
        ),
        PostElement(
          id: 'pe-2',
          type: PostElementType.text,
          data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
        ),
        PostElement(
          id: 'pe-3',
          type: PostElementType.image,
          data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
        ),
      ],
      topicInfo: TopicInfo(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
      ),
    ),


    // ! ################ 3 ####################
    Post(
      id: 'afsd8uf9aus9duu6ashf4k2hl',
        author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      comments: [],
      createdAt: DateTime.now(),
      likesCount: 12,
      postElements: [
        PostElement(
          id: 'pe-1',
          type: PostElementType.h1,
          data: 'Бокс для начинающих: с чего начать на первой тренировке?'
        ),
        PostElement(
          id: 'pe-2',
          type: PostElementType.text,
          data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
        ),
        PostElement(
          id: 'pe-3',
          type: PostElementType.image,
          data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
        ),
      ],
      topicInfo: TopicInfo(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
      ),
    ),

    // ! ################ 4 ####################
    Post(
      id: 'afsd8uf9aus9duu6ashf4k2hl',
        author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      comments: [],
      createdAt: DateTime.now(),
      likesCount: 12,
      postElements: [
        PostElement(
          id: 'pe-1',
          type: PostElementType.h1,
          data: 'Бокс для начинающих: с чего начать на первой тренировке?'
        ),
        PostElement(
          id: 'pe-2',
          type: PostElementType.text,
          data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
        ),
        PostElement(
          id: 'pe-3',
          type: PostElementType.image,
          data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
        ),
      ],
      topicInfo: TopicInfo(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
      ),
    ),

    // ! ################ 5 ####################
    Post(
      id: 'afsd8uf9aus9duu6ashf4k2hl',
        author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      comments: [],
      createdAt: DateTime.now(),
      likesCount: 12,
      postElements: [
        PostElement(
          id: 'pe-1',
          type: PostElementType.h1,
          data: 'Бокс для начинающих: с чего начать на первой тренировке?'
        ),
        PostElement(
          id: 'pe-2',
          type: PostElementType.text,
          data: 'Раньше единоборства считались одним из способов определить сильнейшего. Это был способ выживания, вариант показать свою физическую силу.'
        ),
        PostElement(
          id: 'pe-3',
          type: PostElementType.image,
          data: 'https://images.unsplash.com/photo-1509563268479-0f004cf3f58b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'
        ),
      ],
      topicInfo: TopicInfo(
        id: 'topic-id1',
        name: 'Спорт Дома',
        avatarImageUrl: 'https://images.unsplash.com/photo-1558470585-ff3a87f9e86d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
      ),
    ),
  ];
}