import 'package:equatable/equatable.dart';

import '../../../domain/entities/UserEntity.dart';

/// Abstract class representing the various states of user loading.
///
/// This class serves as the base for all user loading states.
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Represents the initial state of user loading.
///
/// This state is used when the user loading process has not started yet.
class UserInitial extends UserState {
  const UserInitial();
}

/// Represents the loading state of users.
///
/// This state is used when the user loading process is in progress.
class UserLoading extends UserState {
  const UserLoading();
}

/// Represents the state when users are successfully loaded.
///
/// This state contains the list of loaded users.
class UserLoaded extends UserState {
  final List<UserEntity> users;
  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// Represents an error state when loading users fails.
///
/// This state contains the error message that occurred during the loading process.
class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
