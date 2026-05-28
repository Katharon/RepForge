import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/onboarding_application.dart';
import '../domain/onboarding_domain.dart';
import 'onboarding_page.dart';

class OnboardingGate extends StatefulWidget {
  const OnboardingGate({
    required this.loadOnboardingStatus,
    required this.skipOnboarding,
    required this.completeOnboarding,
    required this.child,
    super.key,
  });

  final LoadOnboardingStatus loadOnboardingStatus;
  final SkipOnboarding skipOnboarding;
  final CompleteOnboarding completeOnboarding;
  final Widget child;

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  OnboardingStatus? _status;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    if (_error != null) {
      return _GateMessage(
        icon: Icons.error_outline,
        title: AppLocalizations.of(context).onboardingErrorTitle,
        message: AppLocalizations.of(context).onboardingErrorMessage,
        actionLabel: AppLocalizations.of(context).settingsRetry,
        onAction: _load,
      );
    }

    if (status == null) {
      return _GateMessage(
        icon: Icons.person_add_alt_1_outlined,
        title: AppLocalizations.of(context).onboardingLoading,
      );
    }

    if (!status.shouldShowOnboarding) {
      return widget.child;
    }

    return OnboardingPage(
      skipOnboarding: widget.skipOnboarding,
      completeOnboarding: widget.completeOnboarding,
      onFinished: _load,
    );
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _status = null;
    });
    try {
      final status = await widget.loadOnboardingStatus();
      if (!mounted) {
        return;
      }
      setState(() {
        _status = status;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
      });
    }
  }
}

class _GateMessage extends StatelessWidget {
  const _GateMessage({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(RepForgeSpacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon),
                    const SizedBox(height: RepForgeSpacing.md),
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    if (message != null) ...[
                      const SizedBox(height: RepForgeSpacing.xs),
                      Text(message!),
                    ],
                    if (actionLabel != null && onAction != null) ...[
                      const SizedBox(height: RepForgeSpacing.md),
                      TextButton.icon(
                        onPressed: onAction,
                        icon: const Icon(Icons.refresh),
                        label: Text(actionLabel!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
