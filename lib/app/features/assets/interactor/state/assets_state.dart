import 'package:tractian_challenge/app/core/states/base_state.dart';
import 'package:tractian_challenge/app/features/assets/interactor/models/asset_three_model.dart';

class AssetsInitialState extends InitialState {}

class AssetsLoadingState extends LoadingState {}

class AssetsSuccessState extends SuccessState<AssetTreeModel?> {
  AssetsSuccessState({required super.data});
}

class AssetsErrorState extends ErrorState {
  AssetsErrorState({required super.exception});
}
