import 'product_model.dart';

/// Central list of products used across the app. In a real application this
/// would come from an API or repository layer.
final List<Product> productCatalog = [
  Product(
    id: 'mac_studio',
    title: 'Mac Studio — Estación Pro',
    description:
        'Estación de trabajo compacta y potente para creadores y profesionales. Diseño térmico optimizado y gran capacidad de CPU/GPU para cargas de trabajo creativas.',
    price: 2199.00,
    imageUrl: 'assets/products/Mac_Studio.glb',
    category: 'Computación',
  ),
  Product(
    id: 'razer_kraken',
    title: 'Razer Kraken — Auriculares Gaming',
    description:
        'Auriculares gaming con sonido envolvente y diseño cómodo para sesiones largas. Micrófono con cancelación de ruido y almohadillas ergonómicas.',
    price: 139.99,
    imageUrl: 'assets/products/Razer_Kraken.glb',
    category: 'Audio',
  ),
  Product(
    id: 'led_tv',
    title: 'Smart LED TV 4K',
    description:
        'Televisor Smart 4K con procesador de imagen mejorado y múltiples entradas HDMI. Ideal para cine en casa y entretenimiento.',
    price: 749.00,
    imageUrl: 'assets/products/LED_tv.glb',
    category: 'Electrónica',
  ),
  Product(
    id: 'vp',
    title: 'Figura Decorativa VP',
    description:
        'Figura decorativa de diseño moderno para estanterías y escritorios. Material ligero y acabado detallado.',
    price: 54.90,
    imageUrl: 'assets/products/VP.glb',
    category: 'Decoración',
  ),
  Product(
    id: 'bar_cabinet',
    title: 'Mueble Bar Classic',
    description:
        'Mueble bar de diseño clásico con espacio para botellas y copas. Añade elegancia a tu salón o zona de entretenimiento.',
    price: 349.00,
    imageUrl: 'assets/products/Bar_Cabinet.glb',
    category: 'Hogar',
  ),
  Product(
    id: 'basket_ball',
    title: 'Balón de Baloncesto Pro',
    description:
        'Balón de baloncesto con textura realista y buen rebote. Perfecto para entrenamiento y partidos.',
    price: 24.90,
    imageUrl: 'assets/products/basket_ball_GLB.glb',
    category: 'Deportes',
  ),
  Product(
    id: 'car_police',
    title: 'Coche Policía a Escala',
    description:
        'Modelo a escala de coche de policía con detalles realistas. Ideal para coleccionistas y regalo para niños.',
    price: 34.90,
    imageUrl: 'assets/products/car_police.glb',
    category: 'Juguetes',
  ),
  Product(
    id: 'synthesizer',
    title: 'Sintetizador Portátil',
    description:
        'Sintetizador portátil con controles intuitivos y diseño compacto. Perfecto para producir música y practicar en casa.',
    price: 429.00,
    imageUrl: 'assets/products/Synthesizer_GameReady.glb',
    category: 'Música',
  ),
  Product(
    id: 'table_bell',
    title: 'Timbre de Mesa Vintage',
    description:
        'Timbre de mesa con acabado clásico. Ideal para recepción, decoración o uso en eventos.',
    price: 29.50,
    imageUrl: 'assets/products/Table_Bell.glb',
    category: 'Decoración',
  ),
  Product(
    id: 'teapot',
    title: 'Tetera Clásica',
    description:
        'Tetera con diseño tradicional y detalles ornamentales. Añade carácter a tu cocina o colección.',
    price: 39.00,
    imageUrl: 'assets/products/Teapot.glb',
    category: 'Hogar',
  ),
  Product(
    id: 'vintage_lantern',
    title: 'Lámpara Vintage',
    description:
        'Lámpara/linterna de estilo vintage con detalles metálicos y acabado envejecido. Perfecta para ambientes retro.',
    price: 64.99,
    imageUrl: 'assets/products/vintage_Lantern.glb',
    category: 'Decoración',
  ),
  Product(
    id: 'watch',
    title: 'Reloj de Pulsera Premium',
    description:
        'Reloj de pulsera con diseño elegante y correa intercambiable. Ideal como detalle de moda o regalo.',
    price: 199.00,
    imageUrl: 'assets/products/watch.glb',
    category: 'Accesorios',
  ),
  Product(
    id: 'wheelbarrow',
    title: 'Carretilla Robust',
    description:
        'Carretilla resistente para jardín con estructura reforzada. Ideal para transportar tierra, herramientas y materiales.',
    price: 99.00,
    imageUrl: 'assets/products/Wheelbarrow_GameReady.glb',
    category: 'Jardín',
  ),
];
