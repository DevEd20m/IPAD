## ADDED Requirements

### Requirement: Guardar documento importado
El sistema SHALL guardar la información del documento importado para gestión posterior.

#### Scenario: Guardar metadata de documento
- **WHEN** el usuario importa un PDF
- **THEN** el sistema SHALL guardar: id, nombre, tipo, ruta local, fecha de creación, fecha de última apertura

#### Scenario: Actualizar fecha de última apertura
- **WHEN** el usuario abre un documento existente
- **THEN** el sistema SHALL actualizar la fecha de última apertura

### Requirement: Listar documentos recientes
El sistema SHALL mostrar una lista de documentos recientes ordenados por fecha de última apertura.

#### Scenario: Ordenar por recientes
- **WHEN** el usuario accede a la lista de documentos
- **THEN** el sistema SHALL mostrar los documentos ordenados del más reciente al más antiguo

#### Scenario: Limitar a 10 documentos recientes
- **WHEN** la lista de documentos supera los 10
- **THEN** el sistema SHALL mostrar solo los 10 más recientes

### Requirement: Eliminar documento de la lista
El sistema SHALL permitir al usuario eliminar un documento de la lista de recientes.

#### Scenario: Eliminar documento
- **WHEN** el usuario selecciona eliminar en un documento de la lista
- **THEN** el sistema SHALL eliminar el documento de la lista
- **AND** SHALL eliminar los datos asociados (anotaciones, notas de voz)
- **AND** SHALL mantener el archivo original en el almacenamiento del sistema

### Requirement: Persistir trazos de dibujo
El sistema SHALL guardar los trazos dibujados sobre cada documento.

#### Scenario: Guardar trazos al cerrar documento
- **WHEN** el usuario cierra un documento con trazos
- **THEN** el sistema SHALL guardar todos los trazos con: id, documentId, pageIndex, toolType, color, width, opacity, lista de puntos

#### Scenario: Recuperar trazos al abrir documento
- **WHEN** el usuario abre un documento que tenía trazos
- **THEN** el sistema SHALL cargar los trazos desde almacenamiento
- **AND** SHALL mostrarlos en las posiciones correctas
