import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // VIP区域
            _buildVipSection(),
            const SizedBox(height: 16),
            // 邀请好友区域
            _buildInviteSection(),
            const SizedBox(height: 20),
            // 功能菜单区域
            _buildMenuSection(),
            const SizedBox(height: 20),
            // 联系客服和Telegram
            _buildContactSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildVipSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'XO VIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '会员到期时间：2099-10-12',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '立即续费 >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // VIP图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 左侧图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // 文字内容
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '邀请好友送VIP会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '看片神器·用 XO 视频',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // GO按钮
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'GO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 第一行菜单
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuItem(Icons.favorite_border, '我的社区'),
              _buildMenuItem(Icons.group, '我的会员'),
              _buildMenuItem(Icons.account_balance_wallet, '我的钱包'),
              _buildMenuItem(Icons.star_border, '我的收藏'),
            ],
          ),
          const SizedBox(height: 24),
          // 第二行菜单
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuItem(Icons.history, '历史记录'),
              _buildMenuItem(Icons.share, '分享邀请'),
              _buildMenuItem(Icons.monetization_on, '赚金币'),
              _buildMenuItem(Icons.handshake, '商务合作'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildContactItem(Icons.headset_mic, '联系客服'),
          const SizedBox(height: 16),
          _buildContactItem(Icons.telegram, 'Telegram群'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}