## ADDED Requirements

### Requirement: Detectar double tap del Apple Pencil
El sistema SHALL detectar el gesto de double tap del Apple Pencil para cambio rápido de herramienta.

#### Scenario: Double tap activa borrador
- **WHEN** el usuario hace double tap con el Apple Pencil mientras usa bolígrafo, lápiz o marcador
- **THEN** el sistema SHALL cambiar automáticamente al modo borrador
- **AND** SHALL guardar la herramienta anterior para poder restaurarla

#### Scenario: Double tap vuelve a herramienta anterior
- **WHEN** el usuario hace double tap mientras está en modo borrador
- **THEN** el sistema SHALL restaurar la herramienta que estaba activa antes de entrar en modo borrador

### Requirement: Comportamiento configurable de double tap
El sistema SHALL permitir al usuario configurar el comportamiento del double tap.

#### Scenario: Configurar double tap para activar borrador
- **WHEN** el usuario tiene habilitada la opción de double tap para borrador
- **AND** hace double tap con Apple Pencil
- **THEN** el sistema SHALL activar el borrador

#### Scenario: Deshabilitar double tap
- **WHEN** el usuario deshabilita la opción de double tap en configuración
- **AND** hace double tap con Apple Pencil
- **THEN** el sistema SHALL ignorar el gesto

### Requirement: Soporte para escritura con Apple Pencil
El sistema SHALL soportar todas las características del Apple Pencil incluyendo presión e inclinación.

#### Scenario: Escritura con presión
- **WHEN** el usuario escribe con Apple Pencil aplicando diferentes niveles de presión
- **THEN** el sistema SHALL variar el grosor del trazo según la presión aplicada
- **AND** la respuesta SHALL ser natural y fluida

#### Scenario: Escritura con inclinación
- **WHEN** el usuario inclina el Apple Pencil mientras escribe (para marcador)
- **THEN** el sistema SHALL detectar la inclinación y ajustar el trazo
- **AND** el comportamiento SHALL ser similar al marcador real
