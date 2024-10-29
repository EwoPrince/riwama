// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'dart:io';
// import 'package:riwama/services/reward_service.dart';



// final adProvider = ChangeNotifierProvider<AdProvider>((ref) => AdProvider());

// class AdProvider extends ChangeNotifier {
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;

//   bool _onRewardAdLoad = false;
//   bool _onInterstitialAdLoad = false;

//   int _numInterstitialLoadAttempts = 0;
//   int maxFailedLoadAttempts = 10;
//   int _numRewardedLoadAttempts = 0;

//   InterstitialAd? get interstitialAd => _interstitialAd;
//   RewardedAd? get rewardedAd => _rewardedAd;
//   bool get onRewardAdLoad => _onRewardAdLoad;
//   bool get onInterstitialAdLoad => _onInterstitialAdLoad;

//   late BannerAd _bannerAd;

//   String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-7487861260861000/4702918954";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-7487861260861000/3581408971";
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }

//   Widget banner() {
//     return Container(
//       height: _bannerAd.size.height.toDouble(),
//       width: _bannerAd.size.width.toDouble(),
//       child: AdWidget(ad: _bannerAd),
//     );
//   }

//   Future<Uri> playLocalAsset() async {
//     AudioCache cache = new AudioCache();
//     return cache.load('assets/water.mp3');
//   }

//   Future<Uri> playLocalAsset1() async {
//     AudioCache cache = new AudioCache();
//     return cache.load('assets/coin.mp3');
//   }

//   //  void _loadFInterstitialAd() async {
//   //   FacebookInterstitialAd.loadInterstitialAd(
//   //     placementId: "1779699252410321_1793108291069417",
//   //     listener: (result, value) {
//   //       if (result == InterstitialAdResult.LOADED)
//   //         setState(() {
//   //           _isInterstitialAdLoaded = true;
//   //         });

//   //       if (result == InterstitialAdResult.DISMISSED &&
//   //           value["invalidated"] == true) {
//   //         setState(() {
//   //           _isInterstitialAdLoaded = false;
//   //         });
//   //         _loadFInterstitialAd();
//   //       }
//   //     },
//   //   );
//   // }

//   // void _loadFRewardedVideoAd() async {
//   //   FacebookRewardedVideoAd.loadRewardedVideoAd(
//   //     placementId: "1779699252410321_1793108464402733",
//   //     listener: (result, value) {
//   //       if (result == RewardedVideoAdResult.LOADED)
//   //         setState(() {
//   //           _isRewardedAdLoaded = true;
//   //         });
//   //       if (result == RewardedVideoAdResult.VIDEO_COMPLETE)

//   //       if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
//   //           (value == true || value["invalidated"] == true)) {
//   //         setState(() {
//   //           _isRewardedAdLoaded = false;
//   //         });
//   //         _loadFRewardedVideoAd();
//   //       }
//   //     },
//   //   );
//   // }

//   // Future<void> _showFInterstitialAd() async {
//   //   if (_isInterstitialAdLoaded == true)
//   //     FacebookInterstitialAd.showInterstitialAd();
//   //   userx.update({
//   //     'river': FieldValue.increment(4),
//   //   });
//   //   setState(() {
//   //     _isInterstitialAdLoaded = false;
//   //   });
//   //   player.loadAsFile(coin);
//   //   _loadFInterstitialAd();
//   // }

//   // Future<void> _showFRewardedAd() async {
//   //   if (_isRewardedAdLoaded == true)
//   //     FacebookRewardedVideoAd.showRewardedVideoAd();
//   //   userx.update({
//   //     'sea': FieldValue.increment(11),
//   //   });

//   //   setState(() {
//   //     _isRewardedAdLoaded = false;
//   //   });
//   //   player.loadAsFile(coin);
//   //   _loadFRewardedVideoAd();
//   // }

//   Future<void> createInterstitialAd() async {
//     InterstitialAd.load(
//         adUnitId: Platform.isAndroid
//             //      ? 'ca-app-pub-3940256099942544/1033173712'      ///testad
//             ? 'ca-app-pub-7487861260861000/7460110080'
//             : 'ca-app-pub-7487861260861000/9847681849',
//         request: AdRequest(
//           keywords: <String>['foo', 'bar'],
//           contentUrl: 'http://foo.com/bar.html',
//           nonPersonalizedAds: true,
//         ),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             _onInterstitialAdLoad = true;
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//             notifyListeners();
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               createInterstitialAd();
//             }
//           },
//         ));
//   }

//   Future<void> showInterstitialAd() async {
//     if (_interstitialAd == null) {
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {},
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         ad.dispose();
//         _onInterstitialAdLoad = false;
//         RewardDervice().rewardUserSilver(2);
//         createInterstitialAd();
//         notifyListeners();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         ad.dispose();
//         createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }

//   Future<void> createRewardedAd() async {
//     RewardedAd.load(
//         adUnitId: Platform.isAndroid
// //            ? 'ca-app-pub-6103538067794766/8166413090'
//             ? 'ca-app-pub-7487861260861000/3155115137'
//             : 'ca-app-pub-7487861260861000/2824814780',
//         request: AdRequest(
//           keywords: <String>['foo', 'bar'],
//           contentUrl: 'http://foo.com/bar.html',
//           nonPersonalizedAds: false,
//         ),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             _onRewardAdLoad = true;
//             _rewardedAd = ad;
//             _numRewardedLoadAttempts = 0;
//             notifyListeners();
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             _rewardedAd = null;
//             _numRewardedLoadAttempts += 1;
//             if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
//               createRewardedAd();
//             }
//           },
//         ));
//   }

//   Future<void> showRewardedAd() async {
//     if (_rewardedAd == null) {
//       return;
//     }
//     _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) {
//         RewardDervice().rewardUserSilver(1);
//       },
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         ad.dispose();
//         createRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         ad.dispose();
//         createRewardedAd();
//       },
//     );
//     _rewardedAd!.setImmersiveMode(true);
//     _rewardedAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       RewardDervice().rewardUserGold(3);
//       _onRewardAdLoad = false;
//       notifyListeners();
//     });
//     _rewardedAd = null;
//   }
// }
