import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class HtmlFirstHrefExtractor {
  // 从 HTML 字符串中提取【第一个】a 标签的 href 属性
  // 返回值：成功则返回 href 字符串，无 a 标签/无 href 则返回 null
  static String? extractFirstHref(String htmlString) {
    try {
      // 1. 解析 HTML 字符串为 DOM 树
      Document document = parse(htmlString);
      
      // 2. 获取【第一个】匹配的 <a> 标签（querySelector 仅返回第一个）
      Element? firstATag = document.querySelector('a');
      
      // 3. 提取该标签的 href 属性（判断非空）
      if (firstATag != null) {
        String? href = firstATag.attributes['href'];
        return (href?.isNotEmpty ?? false) ? href : null;
      }
    } catch (e) {
      print("解析 HTML 失败：$e");
    }
    
    // 无 a 标签/解析失败/无 href 时返回 null
    return null;
  }
}