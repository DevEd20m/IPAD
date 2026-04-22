## ADDED Requirements

### Requirement: Importar PDF desde almacenamiento local
El sistema SHALL permitir al usuario importar archivos PDF desde el almacenamiento local del iPad.

#### Scenario: Importar PDF exitosamente
- **WHEN** el usuario selecciona "Importar PDF" desde la pantalla principal
- **THEN** el sistema SHALL mostrar el selector de archivos del sistema
- **AND** el usuario SHALL poder seleccionar un archivo PDF
- **AND** el sistema SHALL guardar la referencia del documento en almacenamiento local

#### Scenario: Importar archivo no-PDF
- **WHEN** el usuario intenta importar un archivo que no es PDF
- **THEN** el sistema SHALL mostrar un mensaje de error indicando formato no válido

### Requirement: Visualizar PDF con alta calidad
El sistema SHALL renderizar documentos PDF con calidad visual alta, manteniendo nitidez de texto e imágenes.

#### Scenario: Abrir documento PDF
- **WHEN** el usuario abre un documento PDF importado
- **THEN** el sistema SHALL mostrar la primera página del documento
- **AND** la calidad de renderizado SHALL ser óptima para lectura

#### Scenario: Navegar entre páginas
- **WHEN** el usuario hace swipe horizontal o usa controles de navegación
- **THEN** el sistema SHALL mostrar la página anterior o siguiente
- **AND** la transición SHALL ser fluida

### Requirement: Zoom in y out suave
El sistema SHALL permitir al usuario hacer zoom in y out con gestos de pinch, manteniendo rendimiento fluido.

#### Scenario: Zoom in con pinch
- **WHEN** el usuario hace gesto de pinch hacia afuera en el documento
- **THEN** el sistema SHALL aumentar el nivel de zoom progresivamente
- **AND** el zoom SHALL detenerse en un nivel máximo definido

#### Scenario: Zoom out con pinch
- **WHEN** el usuario hace gesto de pinch hacia adentro en el documento
- **THEN** el sistema SHALL disminuir el nivel de zoom progresivamente
- **AND** el zoom SHALL detenerse en un nivel mínimo definido (100%)

### Requirement: Scroll suave y estable
El sistema SHALL permitir scroll vertical y horizontal suave sin saltos ni lags.

#### Scenario: Scroll vertical
- **WHEN** el usuario hace scroll vertical en el documento
- **THEN** el movimiento SHALL ser suave y continuo
- **AND** el contenido SHALL mantener su posición relativa correctamente

### Requirement: Mantener rendimiento en documentos extensos
El sistema SHALL mantener buen rendimiento al abrir y navegar documentos con muchas páginas.

#### Scenario: Abrir documento de 100+ páginas
- **WHEN** el usuario abre un documento PDF con más de 100 páginas
- **THEN** el sistema SHALL cargar el documento en tiempo razonable (menos de 5 segundos)
- **AND** la navegación SHALL mantener fluidez

### Requirement: Abrir documentos recientes
El sistema SHALL mostrar una lista de documentos recientes en la pantalla principal.

#### Scenario: Mostrar documentos recientes
- **WHEN** el usuario abre la aplicación
- **THEN** el sistema SHALL mostrar una lista de los últimos 10 documentos abiertos
- **AND** cada elemento SHALL mostrar nombre y fecha de última apertura

#### Scenario: Abrir documento desde recientes
- **WHEN** el usuario toca un documento en la lista de recientes
- **THEN** el sistema SHALL abrir el documento en la última página visible
