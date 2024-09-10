import 'package:labbi_frontend/app/models/organization.dart';

class OrgState {
  final bool isLoading;
  final String? errorMessage;
  final List<Organization> organizationList;

  OrgState({
    this.isLoading = false,
    this.errorMessage,
    this.organizationList = const [],
  });

  OrgState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Organization>? organizationList,
  }) {
    return OrgState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      organizationList: organizationList ?? this.organizationList,
    );
  }
}
