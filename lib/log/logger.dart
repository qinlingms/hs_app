// 初始化Logger实例（全局单例）
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(), // 默认格式化器，输出美观
);