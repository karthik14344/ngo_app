import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/posts/controller/posts_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

import '../../models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == "image";
    final isTypeText = post.type == "Text";
    final isTypeLink = post.type == "Link";

    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      post.communityProfilePic,
                                    ),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'u/${post.username}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: const Icon(MdiIcons.delete,
                                      color: Color.fromRGBO(255, 64, 0, 1)),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.35, //retrieves the height of the current device screen, and multiplying it by 0.35 gives you 35% of the screen heigh
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  post.description!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: Icon(Constants.up,
                                        size: 28,
                                        color: post.upvotes.contains(user.uid)
                                            ? Color.fromRGBO(255, 64, 0, 1)
                                            : null),
                                  ),
                                  Text(
                                    "${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => downvotePost(ref),
                                    icon: Icon(Constants.down,
                                        size: 28,
                                        color: post.downvotes.contains(user.uid)
                                            ? Color.fromRGBO(76, 171, 255, 1)
                                            : null),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      MdiIcons.comment,
                                      size: 23,
                                    ),
                                  ),
                                  Text(
                                    "${post.commentCount == 0 ? 'Comment' : post.commentCount}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}