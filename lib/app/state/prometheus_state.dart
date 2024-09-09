import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labbi_frontend/app/models/prometheus_endpoint.dart';

class PrometheusState {
  final List<PrometheusEndpoint> endpoints;
  final bool isLoading;
  final String? errorMessage;

  PrometheusState({
    this.endpoints = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PrometheusState copyWith({
    List<PrometheusEndpoint>? endpoints,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PrometheusState(
      endpoints: endpoints ?? this.endpoints,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
