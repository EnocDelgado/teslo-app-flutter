

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

import '../../../../../config/constants/environment.dart';

//! 3 - StateNotfifierProvider
final productFormProvider = StateNotifierProvider.autoDispose.family<ProducFormNotifier, ProductFormState, Product>( ( ref, product ) {

  // Update createUpdateCallback

  return ProducFormNotifier(
    product: product,
    // onSubmitCallBack: createUpdateCallback
  );
});


//* 2 - Notifier
class ProducFormNotifier extends StateNotifier<ProductFormState> {

  final void Function( Map<String, dynamic> productLike )? onSubmitCallBack;

  ProducFormNotifier({
    this.onSubmitCallBack,
    required Product product
  }) : super( 
    ProductFormState(
      id: product.id,
      title: Title.dirty(product.title),
      slug: Slug.dirty(product.slug),
      price: Price.dirty(product.price),
      inStock: Stock.dirty(product.stock),
      sizes: product.sizes,
      gender: product.gender,
      desciption: product.description,
      tags: product.tags.join(', '),
      images: product.images,
    )
  );

  Future<bool> onFormSubmit() async {
    _touchedEverything();

    if ( !state.isFormValid ) return false;

    // if ( onSubmitCallBack == null ) return false;

    final productLike = {
      "id": state.id,
      "title": state.title.value,
      "price": state.price.value,
      "description":state.desciption,
      "slug": state.slug,
      "stock": state.inStock.value,
      "sizes": state.sizes,
      "gender": state.gender,
      "tags": state.tags.split(','),
      "images": state.images.map( 
        ( image ) => image.replaceAll('${ Environment.apiUrl }/files/product/', '')
      ).toList()
    };

    return true;
    // invoke submitCallback
  }

  // To know if field have been toched
  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( state.slug.value ),
        Price.dirty( state.price.value ),
        Stock.dirty( state.inStock.value ),
      ])
    );
  }

  // return bool
  void onTitleChanged( String value ) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ])
    );
  }

  void onSlugChanged( String value ) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ])
    );
  }

  void onPriceChanged( double value ) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.inStock.value)
      ])
    );
  }

  void onStockChanged( int value ) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(value)
      ])
    );
  }

  void onSizeChanged( List<String> sizes ) {
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderChanged( String gender ) {
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChanged( String description ) {
    state = state.copyWith(
      desciption: description
    );
  }

  void onTagsChanged( String tags ) {
    state = state.copyWith(
      tags: tags
    );
  }

}

//! 1 - State
class ProductFormState {

  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String desciption;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.slug = const Slug.dirty(''), 
    this.price = const Price.dirty(0), 
    this.sizes = const [], 
    this.gender = 'men', 
    this.inStock = const Stock.dirty(0), 
    this.desciption = '', 
    this.tags = '', 
    this.images = const []
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? desciption,
    String? tags,
    List<String>? images
    
  }) => ProductFormState(

    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    desciption: desciption ?? this.desciption,
    tags: tags ?? this.tags,
    images: images ?? this.images
  );
  
}