import 'package:flutter/material.dart';

class SkeletonLoader {
  /// ===== GRID SKELETON =====
  static Widget grid({
    int itemCount = 6,
    int crossAxisCount = 2,
    double aspectRatio = 0.85,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        return _cardSkeleton();
      },
    );
  }

  /// ===== LIST SKELETON =====
  static Widget list({int itemCount = 8}) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _listTileSkeleton(),
        );
      },
    );
  }

  /// ===== CARD SKELETON (FULL ITEM) =====
  static Widget _cardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 12,
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey.shade400,
          ),
          const Spacer(),
          Container(
            height: 30,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== LIST TILE SKELETON (PRIVATE) =====
  static Widget _listTileSkeleton() {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 12, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Container(height: 12, width: 150, color: Colors.grey.shade300),
            ],
          ),
        )
      ],
    );
  }

  /// ===== PUBLIC ACCESS (FIX) =====
  static Widget listTile() {
    return _listTileSkeleton();
  }

  /// ===== SIMPLE CARD SKELETON =====
  static Widget card({double height = 160}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// ===== CENTER LOADER =====
  static Widget center() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}