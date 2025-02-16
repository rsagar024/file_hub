import 'dart:math';

class ImageGenerator {
  static final List<String> images = [
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/hand-album-cover-art-design-template-c9f917f0d697b93c71d863420446fee7_screen.jpg?ts=1715038263',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/blue-butterfly-mixtape-cd-cover-music-design-template-6a47472b4f2cf5694e49c874695df845_screen.jpg?ts=1579037995',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/mixtape-cover-art-album-cd-artwork-design-template-e6f6e4bcfda1c7d33d7be37a85009260_screen.jpg?ts=1710606706',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/mixtape-cover-design-template-ef31879e6da9ddcc2a2c61a89e87a16b_screen.jpg?ts=1713189715',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/album-cover-art-design-template-94a702a2a9aa229651c863caacacd169_screen.jpg?ts=1709146088',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/full-moon-cd-mixtape-cover-template-design-34fcefdda4d6ae65fa214d08eb9700ae_screen.jpg?ts=1570009897',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/black-best-cover-album-music-art-trap-mixtap-design-template-adac9ee28c3441fe97c070c04e044775_screen.jpg?ts=1736710259',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/mixtape-cover-design-template-dc9a16e11e7dbf426fe7262cd6807971_screen.jpg?ts=1674112157',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/moonlight-mixtape-album-cover-art-album-cover-design-template-9e908af0ac736d8405b58da0e6526f33_screen.jpg?ts=1730554337',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/cd-mixtape-album-cover-artwork-template-design-fc43d275457b4e9c2f09998911afd250_screen.jpg?ts=1724378435',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/best-album-cover-music-art-trap-mixtape-rap-design-template-a921b1c09e217a67f5415575c86df37d_screen.jpg?ts=1708452045',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/abstract-round-ball-cd-cover-template-design-1a7910aa5d647dbef2e532d73c9395bc_screen.jpg?ts=1567975414',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/cover-art-design-djallel-gfx-template-818d9ede1c7ec7162855a0e19121ff35_screen.jpg?ts=1735240832',
  ];

  static String generate() {
    return images[Random().nextInt(13)];
  }
}
