## Context

Proyecto de aplicación Flutter para iPad de estudio y anotación PDF. El brief especifica:
- Stack: Flutter + Syncfusion PDF Viewer + PencilKit + Hive
- Arquitectura: Clean Architecture + MVVM + GetX
- Cobertura mínima: 80%
- Scope MVP: PDF + Drawing + Audio Pins (hojas en blanco en fase 2)

## Goals / Non-Goals

**Goals:**
- Implementar MVP con importación de PDF, herramientas de dibujo, notas de voz ancladas
- Establecer arquitectura Clean Architecture + MVVM mantenible
- Lograr 80% coverage mínimo en tests
- Integrar Apple Pencil con double tap para cambio rápido a borrador

**Non-Goals:**
- Sincronización en la nube
- Colaboración en tiempo real
- OCR o transcripción automática
- Exportación avanzada de anotaciones
- Hojas en blanco con plantillas (MVP+)

## Decisions

### D1: PDF Viewer - Syncfusion con licencia free
**Alternativas:** pdfx, flutter_pdfview
**Decisión:** Usar `syncfusion_flutter_pdfviewer` (licencia free disponible)
**Rationale:** Cumple requisitos de zoom, scroll suave, navegación entre páginas. La licencia free es suficiente para MVP.

### D2: Estrategia de Dibujo - Híbrido PencilKit + Canvas Custom
**Alternativas:** Solo PencilKit, solo Canvas custom
**Decisión:** Enfoque híbrido:
- **PencilKit**: Usar para experiencia de tinta nativa Apple Pencil (presión, inclinación)
- **Canvas Custom**: Usar para overlays de dibujo sobre PDF donde se requiere control de coordenadas y sincronización con scroll/zoom del visor

**Rationale:** 
- PencilKit ofrece la mejor experiencia de escritura nativa pero tiene limitaciones en Flutter para coordinar con overlays de PDF
- Canvas custom permite control total de coordenadas normalizadas para sincronización con pines de audio
- La combinación optimiza UX y control técnico

### D3: Coordenadas para Overlays
**Alternativas:** Coordenadas absolutas, coordenadas normalizadas
**Decisión:** Usar coordenadas normalizadas (xNorm, yNorm) para pines de audio y trazos
**Rationale:** Las coordenadas normalizadas (0-1) mantienen posición válida ante cambios de zoom, tamaño de viewport, o rotación. Estructura: `{documentId, pageIndex, xNorm, yNorm}`.

### D4: Persistencia - Hive
**Alternativas:** SQLite, drift, sembast
**Decisión:** Usar Hive para persistencia local
**Rationale:** Integración simple con Flutter, rendimiento adecuado para MVP, sin configuración de servidor.

### D5: Gestión de Estado - GetX
**Alternativas:** Provider, Riverpod, BLoC
**Decisión:** Usar GetX para inyección de dependencias, gestión de estado y navegación
**Rationale:** Requirement del brief. GetX permite bindings por módulo y separación clara de responsabilidades cuando se usa correctamente (lógica de negocio en use cases, no en controladores).

### D6: Testing - Coverage 80%
**Alternativas:** 90% (brief original), 70%
**Decisión:** 80% coverage mínimo
**Rationale:** Balance entre calidad y velocidad para MVP. 90% puede tomar 30-50% extra del tiempo de desarrollo.

## Risks / Trade-offs

### R1: Sincronización PDF + Overlays
**Riesgo:** Coordinar zoom, scroll y posición de trazos/pines entre el visor PDF y las capas de dibujo
**Mitigación:** Usar coordenadas normalizadas y escuchar eventos del visor para actualizar posición de overlays

### R2: Integración PencilKit en Flutter
**Riesgo:** Limitaciones del wrapper de PencilKit en Flutter para coordinación con PDF
**Mitigación:** Implementar capa de coordinación que sincronice el canvas de PencilKit con el viewport del PDF

### R3: Apple Pencil Double Tap
**Riesgo:** El paquete `apple_pencil_double_tap` puede tener limitaciones
**Mitigación:** Implementar detección de double tap a nivel de widget de dibujo, independiente del paquete

### R4: Rendimiento en Documentos Grandes
**Riesgo:** Scroll y zoom pueden degradarse en PDFs extensos
**Mitigación:** Usar lazy loading de páginas, cache de renderizado

## Migration Plan

N/A - Proyecto nuevo desde cero. Estructura inicial:
```
lib/
  core/
  features/
    document/
    viewer/
    drawing/
    audio_notes/
    settings/
  app/
```

## Open Questions

- ¿Necesidad de exportar anotaciones como PDF modificado en versión futura?
- ¿Prefiere sincronización iCloud o local-only para este MVP?
