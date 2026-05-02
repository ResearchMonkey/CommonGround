import 'package:commonground/core/event_bus/data/event_bus_impl.dart';
import 'package:commonground/core/event_bus/data/forwarding_ingest_layer.dart';
import 'package:commonground/core/event_bus/data/log_event_bus_subscriber_stub.dart';
import 'package:commonground/core/map/data/in_memory_map_hud_session_store.dart';
import 'package:commonground/core/map/data/stub_map_camera_controller.dart';
import 'package:commonground/core/map/domain/position_snapshot_event.dart';
import 'package:commonground/core/map/presentation/cg_design_tokens.dart';
import 'package:commonground/core/map/presentation/map_hud_bus_subscriber_stub.dart';
import 'package:commonground/core/map/presentation/map_hud_chrome_cubit.dart';
import 'package:commonground/core/map/presentation/map_hud_shell.dart';
import 'package:commonground/core/shared/data/cg_logger_impl.dart';
import 'package:commonground/core/shared/domain/cg_logger_contract.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// VS.1 composition root: ingest → bus → HUD subscriber + chrome Cubit (SA-004).
class MapShellBinding extends StatefulWidget {
  const MapShellBinding({super.key});

  @override
  State<MapShellBinding> createState() => _MapShellBindingState();
}

class _MapShellBindingState extends State<MapShellBinding> {
  late final EventBusImpl _bus;
  late final CgLoggerContract _logger;
  late final ForwardingIngestLayer _ingest;
  late final StubMapCameraController _cameraController;
  late final InMemoryMapHudSessionStore _sessionStore;
  late final MapHudChromeCubit _chromeCubit;
  late final MapHudBusSubscriberStub _subscriber;
  late final LogEventBusSubscriberStub _logBusSubscriber;

  @override
  void initState() {
    super.initState();
    _bus = EventBusImpl();
    _logger = CgLoggerImpl(
      backend: Logger(printer: PrettyPrinter(methodCount: 0)),
      isolateId: 'main-isolate',
      publishLogEvent: (e) => _bus.publish(e),
    );
    _ingest = ForwardingIngestLayer(_bus);
    _cameraController = StubMapCameraController();
    _sessionStore = InMemoryMapHudSessionStore();
    _chromeCubit = MapHudChromeCubit(
      cameraController: _cameraController,
      sessionStore: _sessionStore,
    );
    _subscriber = MapHudBusSubscriberStub(
      eventBus: _bus,
      onPosition: _chromeCubit.applyPositionSnapshot,
      onLocation: _chromeCubit.applyLocationEvent,
    );
    _logBusSubscriber = LogEventBusSubscriberStub(_bus);

    if (kDebugMode) {
      _seedDebugFixture();
    }
  }

  /// Debug-only seed: emits a Boston [PositionSnapshotEvent] so VS.1 has
  /// something to render before the real ingest source ships in VS.2.
  void _seedDebugFixture() {
    _ingest
        .submit(
          PositionSnapshotEvent(
            sourceFeature: 'debug_seed',
            timestamp: DateTime.now().toUtc(),
            latitude: 42.3601,
            longitude: -71.0589,
          ),
        )
        .fold(
          (fail) => _logger.warning(
            fail.message,
            sourceFeature: 'map_shell_binding',
            failure: fail,
          ),
          (_) {},
        );
  }

  @override
  void dispose() {
    _logBusSubscriber.dispose();
    _subscriber.dispose();
    _chromeCubit.close();
    _cameraController.dispose();
    _bus.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CommonGround',
      debugShowCheckedModeBanner: false,
      theme: buildCgTheme(),
      home: BlocProvider<MapHudChromeCubit>.value(
        value: _chromeCubit,
        child: const MapHudShell(),
      ),
    );
  }
}
