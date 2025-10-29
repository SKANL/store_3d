import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_catalog.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../atoms/model_thumbnail.dart';
import '../molecules/cart_action_button.dart';
import '../theme.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  String? _selectedCategory;

  List<String> get _categories => productCatalog.map((p) => p.category).toSet().toList()..sort();

  List<Product> get _filteredProducts => _selectedCategory == null
      ? productCatalog
      : productCatalog.where((p) => p.category == _selectedCategory).toList();

  List<Product> get _highlighted => _filteredProducts.take(4).toList();
  List<Product> get _recommended => _filteredProducts.skip(4).take(6).toList();
  List<Product> get _moreFinds => _filteredProducts.skip(10).toList();

  void _handleCategory(String? category) {
    setState(() => _selectedCategory = category);
  }

  void _openDetail(Product product) {
    // Navigate immediately - let the detail page handle loading states
    Navigator.pushNamed(context, '/detail', arguments: product);
  }

  void _addToCart(Product product) {
    final cart = context.read<CartProvider>();
    cart.addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} agregado al carrito'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => cart.removeProduct(product.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: _HeroHeader(
                cartCount: cartCount,
                onCartTap: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              sliver: SliverToBoxAdapter(
                child: _CategoryTabs(
                  categories: _categories,
                  selected: _selectedCategory,
                  onSelected: _handleCategory,
                ),
              ),
            ),
            if (_highlighted.isNotEmpty)
              SliverToBoxAdapter(
                child: _HorizontalCarousel(
                  title: 'Compra tu carrito',
                  subtitle: 'Recomendado para completar tu setup',
                  products: _highlighted,
                  onProductTap: _openDetail,
                  onAddToCart: _addToCart,
                ),
              ),
            if (_recommended.isNotEmpty)
              SliverToBoxAdapter(
                child: _HorizontalCarousel(
                  title: 'Descubre lo que tenemos para ti',
                  subtitle: 'Basado en tus intereses recientes',
                  products: _recommended,
                  onProductTap: _openDetail,
                  onAddToCart: _addToCart,
                ),
              ),
            if (_moreFinds.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.74,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _moreFinds[index];
                      return _GridProductTile(
                        product: product,
                        onTap: () => _openDetail(product),
                        onAddToCart: () => _addToCart(product),
                      );
                    },
                    childCount: _moreFinds.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final int cartCount;
  final VoidCallback onCartTap;

  const _HeroHeader({required this.cartCount, required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La búsqueda estará disponible pronto ✨')),
                  ),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: cs.onSurfaceVariant, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Buscar en Market 3D',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.camera_alt_outlined, color: cs.onSurfaceVariant, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CartActionButton(count: cartCount, onPressed: onCartTap),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: cs.onPrimary, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Enviar a CP 97299',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: cs.onPrimary, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _CategoryTabs({required this.categories, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          final category = index == 0 ? null : categories[index - 1];
          final label = category ?? 'Todo';
          final isSelected = selected == category;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: Container(
              margin: EdgeInsets.only(right: index == categories.length ? 0 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: isSelected ? 28 : 0,
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HorizontalCarousel extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onAddToCart;

  const _HorizontalCarousel({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 12),
          SizedBox(
            height: 380,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(right: 16),
              cacheExtent: 480,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.only(right: index == products.length - 1 ? 0 : 12),
                  child: _HomeProductCard(
                    product: product,
                    onTap: () => onProductTap(product),
                    onAddToCart: () => onAddToCart(product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _HomeProductCard({required this.product, required this.onTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final priceText = formatPrice(product.price);
    final monthlyText = formatMonthly(product.price);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 228,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ModelThumbnail(label: product.title),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: cs.secondaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'MÁS VENDIDO',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: onAddToCart,
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(36, 36),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: cs.surfaceContainerHighest,
                            foregroundColor: cs.primary,
                          ),
                          icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            priceText,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                              Text(
                                monthlyText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.outline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.success),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Envío gratis FULL',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Color(0xFFFFB300)),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '+1k vendidos',
                                  style: theme.textTheme.bodySmall?.copyWith(color: cs.outline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _GridProductTile({required this.product, required this.onTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final priceText = formatPrice(product.price);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ModelThumbnail(label: product.title),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priceText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Envío gratis FULL',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: cs.secondary),
                        const SizedBox(width: 3),
                        Text(
                          '4.8',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '+1k vendidos',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.outline,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: onAddToCart,
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(30, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: cs.surfaceContainerHighest,
                            foregroundColor: cs.primary,
                          ),
                          icon: const Icon(Icons.add_shopping_cart_outlined, size: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatPrice(double value) {
  final whole = value.floor();
  final cents = ((value - whole) * 100).round();
  final wholeString = _groupThousands(whole);
  final centsString = cents.toString().padLeft(2, '0');
  return '\$$wholeString.$centsString';
}

String formatMonthly(double value) {
  final monthly = value / 12;
  final formatted = formatPrice(monthly);
  final spaced = formatted.replaceFirst('\$', '\$ ');
  return '12x $spaced sin interés';
}

String _groupThousands(int value) {
  final digits = value.toString();
  if (digits.length <= 3) {
    return digits;
  }
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining % 3 == 0 && remaining != 0) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
