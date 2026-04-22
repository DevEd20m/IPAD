## Why

Los usuarios que estudian desde iPad con Apple Pencil necesitan una aplicación de lectura activa y toma de apuntes sobre PDFs que ofrezca una experiencia táctil fluida, cercana al papel pero mejorada digitalmente. Las soluciones actuales son demasiado complejas o carecen de integración nativa con Apple Pencil. Este proyecto construye un MVP enfocado en el core funcional: PDF + anotación + notas de voz ancladas.

## What Changes

- Crear aplicación Flutter para iPad enfocada en estudio y anotación PDF
- Implementar importación y visualización de PDFs con Syncfusion PDF Viewer
- Integrar herramientas de escritura (bolígrafo, lápiz, marcador, borrador) con PencilKit y Canvas custom híbrido
- Añadir notas de voz ancladas a posiciones específicas del documento
- Implementar gestión de documentos recientes
- Configurar tema claro/oscuro con GetX
- Establecer arquitectura Clean Architecture + MVVM con 80% coverage mínimo

## Capabilities

### New Capabilities
- `pdf-import-viewing`: Importación y visualización de PDFs locales con navegación, zoom y scroll suave
- `drawing-tools`: Herramientas de escritura con selección de color, grosor y tipo de herramienta
- `apple-pencil-integration`: Soporte para double tap del Apple Pencil para cambio rápido a borrador
- `audio-notes`: Notas de voz ancladas a coordenadas normalizadas del documento con reproducción
- `document-management`: Gestión de documentos recientes con persistencia local
- `settings-theme`: Configuración de tema claro/oscuro y preferencias de usuario

### Modified Capabilities
- Ninguno (proyecto nuevo desde cero)

## Impact

- Nuevo proyecto Flutter en `/lib` con estructura Clean Architecture
- Dependencias: syncfusion_flutter_pdfviewer, pencil_kit, hive, record, just_audio, get, uuid
- Módulos: document, viewer, drawing, audio_notes, settings
- Configuración de testing con coverage mínimo 80%
