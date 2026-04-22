## ADDED Requirements

### Requirement: Crear nota de voz con long press
El sistema SHALL permitir al usuario crear una nota de voz anclada a una posición específica del documento mediante long press.

#### Scenario: Iniciar creación de nota de voz
- **WHEN** el usuario hace long press (500ms) sobre un punto del PDF
- **THEN** el sistema SHALL mostrar un indicador visual de creación de pin de audio
- **AND** SHALL registrar las coordenadas normalizadas del punto (documentId, pageIndex, xNorm, yNorm)

#### Scenario: Cancelar creación de nota de voz
- **WHEN** el usuario está en proceso de crear una nota de voz y suelta el dedo antes de completar la grabación
- **THEN** el sistema SHALL cancelar la operación
- **AND** no SHALL crear ningún pin de audio

### Requirement: Grabar nota de voz
El sistema SHALL permitir al usuario grabar audio asociado a un pin.

#### Scenario: Iniciar grabación
- **WHEN** el usuario toca el botón de grabar en el popover de creación de pin
- **THEN** el sistema SHALL iniciar la grabación de audio
- **AND** SHALL mostrar indicador de grabación en progreso

#### Scenario: Detener grabación
- **WHEN** el usuario toca el botón de detener grabación
- **THEN** el sistema SHALL detener la grabación
- **AND** SHALL guardar el archivo de audio en almacenamiento local
- **AND** SHALL crear el pin de audio con las coordenadas y referencia al archivo

#### Scenario: Duración máxima de grabación
- **WHEN** la grabación supera los 5 minutos
- **THEN** el sistema SHALL detener automáticamente la grabación
- **AND** SHALL guardar el audio hasta ese punto

### Requirement: Reproducir nota de voz
El sistema SHALL permitir al usuario reproducir las notas de voz ancladas al documento.

#### Scenario: Reproducir audio desde pin
- **WHEN** el usuario toca un pin de audio existente en el documento
- **THEN** el sistema SHALL reproducir el audio asociado
- **AND** SHALL mostrar indicador visual de reproducción en curso

#### Scenario: Detener reproducción
- **WHEN** el usuario toca el botón de detener durante la reproducción
- **THEN** el sistema SHALL detener la reproducción
- **AND** SHALL reiniciar el indicador de posición

### Requirement: Mostrar pines de audio en documento
El sistema SHALL mostrar indicadores visuales (pines) en las posiciones donde existen notas de voz.

#### Scenario: Mostrar pin en página
- **WHEN** el usuario abre una página que contiene pines de audio
- **THEN** el sistema SHALL mostrar un indicador visual en cada posición de pin
- **AND** los pines SHALL mantener su posición relativa al hacer zoom

#### Scenario: Posición del pin al hacer zoom
- **WHEN** el usuario hace zoom in o out en el documento
- **THEN** los pines de audio SHALL mantener su posición en coordenadas normalizadas
- **AND** visualmente SHALL permanecer en el mismo lugar relativo del contenido

### Requirement: Eliminar nota de voz
El sistema SHALL permitir al usuario eliminar una nota de voz existente.

#### Scenario: Eliminar pin de audio
- **WHEN** el usuario mantiene presionado un pin de audio y selecciona "Eliminar"
- **THEN** el sistema SHALL eliminar el pin
- **AND** SHALL eliminar el archivo de audio asociado
- **AND** SHALL actualizar la visualización del documento

### Requirement: Persistir notas de voz
El sistema SHALL guardar las notas de voz y sus posiciones para recuperación posterior.

#### Scenario: Reabrir documento con notas de voz
- **WHEN** el usuario abre un documento que tenía notas de voz
- **THEN** el sistema SHALL cargar las notas de voz desde almacenamiento
- **AND** SHALL mostrar los pines en las posiciones correctas
