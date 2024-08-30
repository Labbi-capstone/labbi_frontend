import 'package:labbi_frontend/app/models/organization.dart';

class OrgState {
  final List<Organization> organizationList;
  final bool isLoading;
  final String? errorMessage;

  OrgState({
    required this.organizationList,
    required this.isLoading,
    this.errorMessage,
  });

  OrgState copyWith({
    List<Organization>? organizationList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrgState(
      organizationList: organizationList ?? this.organizationList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
