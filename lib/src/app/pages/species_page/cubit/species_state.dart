part of 'species_cubit.dart';

sealed class SpeciesState extends Equatable {
  const SpeciesState();

  @override
  List<Object> get props => [];
}

final class SpeciesInitial extends SpeciesState {}
