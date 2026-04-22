import 'package:get/get.dart';
import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/core/services/audio_service.dart';
import 'package:ipad/features/document/data/datasources/document_local_datasource.dart';
import 'package:ipad/features/document/data/repositories/document_repository_impl.dart';
import 'package:ipad/features/document/domain/repositories/document_repository.dart';
import 'package:ipad/features/document/domain/usecases/import_document_usecase.dart';
import 'package:ipad/features/document/domain/usecases/get_recent_documents_usecase.dart';
import 'package:ipad/features/document/domain/usecases/delete_document_usecase.dart';
import 'package:ipad/features/document/presentation/viewmodels/document_viewmodel.dart';
import 'package:ipad/features/drawing/data/datasources/stroke_local_datasource.dart';
import 'package:ipad/features/drawing/data/repositories/stroke_repository_impl.dart';
import 'package:ipad/features/drawing/domain/repositories/stroke_repository.dart';
import 'package:ipad/features/drawing/domain/usecases/save_stroke_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/get_strokes_usecase.dart';
import 'package:ipad/features/drawing/domain/usecases/delete_stroke_usecase.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';
import 'package:ipad/features/audio_notes/data/datasources/audio_pin_local_datasource.dart';
import 'package:ipad/features/audio_notes/data/repositories/audio_pin_repository_impl.dart';
import 'package:ipad/features/audio_notes/domain/repositories/audio_pin_repository.dart';
import 'package:ipad/features/audio_notes/domain/usecases/create_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/get_audio_pins_usecase.dart';
import 'package:ipad/features/audio_notes/domain/usecases/delete_audio_pin_usecase.dart';
import 'package:ipad/features/audio_notes/presentation/viewmodels/audio_notes_viewmodel.dart';
import 'package:ipad/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:ipad/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ipad/features/settings/domain/repositories/settings_repository.dart';
import 'package:ipad/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:ipad/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:ipad/features/settings/presentation/viewmodels/settings_viewmodel.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Services
    Get.lazyPut<AudioService>(() => AudioService(), fenix: true);

    // Data Sources
    Get.lazyPut<DocumentLocalDataSource>(
      () => DocumentLocalDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<StrokeLocalDataSource>(
      () => StrokeLocalDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<AudioPinLocalDataSource>(
      () => AudioPinLocalDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<DocumentRepository>(
      () => DocumentRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<StrokeRepository>(
      () => StrokeRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<AudioPinRepository>(
      () => AudioPinRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<SettingsRepository>(
      () => SettingsRepositoryImpl(Get.find()),
      fenix: true,
    );

    // Use Cases - Document
    Get.lazyPut(() => ImportDocumentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetRecentDocumentsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteDocumentUseCase(Get.find()), fenix: true);

    // Use Cases - Drawing
    Get.lazyPut(() => SaveStrokeUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetStrokesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteStrokeUseCase(Get.find()), fenix: true);

    // Use Cases - Audio Notes
    Get.lazyPut(() => CreateAudioPinUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetAudioPinsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteAudioPinUseCase(Get.find()), fenix: true);

    // Use Cases - Settings
    Get.lazyPut(() => GetSettingsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateSettingsUseCase(Get.find()), fenix: true);

    // ViewModels
    Get.lazyPut(() => DocumentViewModel(), fenix: true);
    Get.lazyPut(() => DrawingViewModel(), fenix: true);
    Get.lazyPut(() => AudioNotesViewModel(), fenix: true);
    Get.lazyPut(() => SettingsViewModel(), fenix: true);
  }
}
