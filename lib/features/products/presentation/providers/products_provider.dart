
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

//* 3 - StateNotifierProvider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>( ( ref ) { 

  final productsRepository = ref.watch( productsRepositoryProvider );  

  return ProductsNotifier(
    productsRepository: productsRepository
  );
});


//* 2 - Notifier

class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository
  }) : super( ProductsState() ){
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct( Map<String, dynamic> productLike ) async {

    try {

      final proudct = await productsRepository.createUpdateProduct( productLike );
      final isProductInList = state.products.any( ( elemenent ) => elemenent.id == proudct.id );

      if ( !isProductInList ) {
        state = state.copyWith(
          products: [ ...state.products, proudct ]
        );

        return true;
      }

      state = state.copyWith(
        products: state.products.map( 
          ( element ) => ( element.id == proudct.id ) ? proudct : element,
        ).toList()
      );

      return true;
      
    } catch ( error ) {
      return false;
    }
  }

  Future loadNextPage() async {

    if ( state.isLastPage || state.isLoading ) return;

    state = state.copyWith(
      isLoading: true
    );

    final products = await productsRepository
      .getProductsByPage( limit: state.limit, offset: state.offset );

    if ( products.isEmpty ) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [ ...state.products, ...products ]
    );

  }
}

//*  1. State

class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.isLoading = false, 
    this.products = const[]
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products

  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products
  );
}