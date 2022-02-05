import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangavocabulometer/test/CsvData.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'dart:convert';//文字コード変換のためのライブラリ

GlobalKey globalKey = GlobalKey(); //←これが重要.よくわからん

class textBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return textBoxState();
  }
}

class textBoxState extends State<StatefulWidget> {
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();
  /*
  List<GlobalKey> keys = [];
  */
  get to => null;

  _callback() {
    print(scaleStateController.scaleState);
    print("aa");
  }

  double pagehei = 100.0;
  double pagewid = 100.0;

  //漫画ページのオブジェクトを格納するRenderBox
  //↓変数はRenderBoxで宣言（.findRenderObject()で帰ってくるのは"RenderObject"のため
  RenderBox page;
  //Flutter(1.5ver)では、NullSafetyが使えるかわからないので、代入するタイミングを工夫しないといけない。
  List<CsvData> balloon = [];//吹き出しの座標を取得する2次元リスト

  @override
  void initState() {
    super.initState();
    getCsvData('assets/ep1_VisionAPI.csv');//<CsvData>リストに変換して格納している。
    /*
    Future(() async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        return addkey();
      });
      //ここに記述すると、エラーは出ないが先に処理されて値が0.0のまま
    });
    */
  }

  Future<List<CsvData>> getCsvData(String path) async {

    String csv = await rootBundle.loadString(path);
    print('csv was inserted.');
    for (String line in csv.split("\r\n")) {
      // カンマ区切りで各列のデータを配列に格納
      List rows = line.split(','); // split by comma
      if(rows[0] != '項') {
        // csvデータを生成
        CsvData rowData = CsvData(
          //page_id: int.parse(rows[0]),
          //top_x: double.parse(rows[1]),
          top_y: double.parse(rows[2]),
          width: double.parse(rows[3]),
          height: double.parse(rows[4]),
        );
        // csvデータをリストに格納
        balloon.add(rowData);
      }else{
      }
    }
    print(balloon.length);
    // リターン

    return balloon;
  }



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(globalKey.currentContext != null){
      return addkey();
      }
    }); //見た目上はマーカーが引かれてるけど、毎コマで数値代入してるから、かなり効率が悪い
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: InteractiveViewer(
        //これで拡大縮小ができる
        minScale: 1.0,
        maxScale: 3.0,
        constrained: true,
        child: Stack(children: [
          Container(
            child: Center(
              //画像を中心に配置することで、正確にマーカーを配置している。
              child: Image.asset(
                //ここで画像（"assets/0002.png"）を表示。数字をいじれば画像が変わる
                //keyを設定
                //画面全体に沿うように画像を拡大させる
                "assets/10005.png", key: globalKey, fit: BoxFit.cover,
              ),
            ), //←知りたいWidgetにGlobalKeyをセット
          ),
          //ここからが吹き出しマーカーの表示（全部同じ感じ）
          for (int i = 0; i < balloon.length; i++)
            if(balloon.isNotEmpty)
              marker(balloon[i].top_x, balloon[i].top_y, balloon[i].width, balloon[i].height, 'text'),
              /*
            ここで、難解な単語であったときの処理をする。
            if(balloon[i].level == 'hard')
              jp_marker[]


               */
          /*
          aaa(0.112, 0.72, 0.075, 0.048),
          aaa(0.098, 0.11, 0.11, 0.18),
          aaa(0.27, 0.743, 0.10, 0.13),
          aaa(0.29, 0.33, 0.024, 0.079),
          aaa(0.296, 0.13, 0.06, 0.119),
          aaa(0.467, 0.80, 0.064, 0.072),
          aaa(0.444, 0.081, 0.202, 0.107),
          aaa(0.815, 0.82, 0.058, 0.056),
          aaa(0.802, 0.73, 0.048, 0.062),
          aaa(0.814, 0.532, 0.035, 0.063),
          aaa(0.852, 0.39, 0.057, 0.103),

           */
        ]),
      ),
    );
  }

  //これが、画像サイズを取得するための関数
  void addkey() {
    setState(() {
      page = globalKey.currentContext.findRenderObject(); //ここでnullエラーが起きがち
      pagehei = page.size.height;
      pagewid = page.size.width; //画像サイズを取得
      //print('値を代入しました。');理想としては、ここが一回だけ呼び出される。
    });
  }

  Widget marker(double le, double top, double wid, double hei, String word) {
    //マーカーを引くための関数
    //build完了後にkeyを代入。nullエラー対策
    return Positioned(
      //引数の座標に応じて赤色のマーカーを引いている
      //スマホ画面の中心からの画像の距離を用いて正確に出力できるっぽい
      top: MediaQuery.of(context).size.height * 0.5 - pagehei * (0.5 - top),
      left: MediaQuery.of(context).size.width * 0.5 - pagewid * (0.5 - le),
      height: pagehei * hei,
      width: pagewid * wid,
      child: Container(
        color: Colors.blue.withOpacity(0.9),
        child: FittedBox(child: Text(word, style: TextStyle(
          height: 0.8, // heightプロパティを追加。 任意の値を設定して調整する
          ),
        ),
        ),
      ),
    );
  }
}
