## ADDED Requirements

### Requirement: Seleccionar herramienta de escritura
El sistema SHALL permitir al usuario seleccionar entre bolígrafo, lápiz, marcador y borrador.

#### Scenario: Cambiar a bolígrafo
- **WHEN** el usuario toca el ícono de bolígrafo en la barra de herramientas
- **THEN** el sistema SHALL activar el modo bolígrafo
- **AND** SHALL mostrar indicador visual de herramienta activa

#### Scenario: Cambiar a lápiz
- **WHEN** el usuario toca el ícono de lápiz en la barra de herramientas
- **THEN** el sistema SHALL activar el modo lápiz
- **AND** SHALL mostrar indicador visual de herramienta activa

#### Scenario: Cambiar a marcador
- **WHEN** el usuario toca el ícono de marcador en la barra de herramientas
- **THEN** el sistema SHALL activar el modo marcador
- **AND** SHALL mostrar indicador visual de herramienta activa

#### Scenario: Cambiar a borrador
- **WHEN** el usuario toca el ícono de borrador en la barra de herramientas
- **THEN** el sistema SHALL activar el modo borrador
- **AND** SHALL mostrar indicador visual de herramienta activa

### Requirement: Seleccionar color de herramienta
El sistema SHALL permitir al usuario elegir el color de la herramienta de escritura.

#### Scenario: Seleccionar color predefinido
- **WHEN** el usuario toca un color en la paleta de colores
- **THEN** el sistema SHALL aplicar ese color a la herramienta activa
- **AND** SHALL guardar la selección como preferencia

#### Scenario: Colores disponibles
- **WHEN** el usuario abre la paleta de colores
- **THEN** el sistema SHALL mostrar al menos: negro, azul, rojo, verde, amarillo, naranja, morado

### Requirement: Seleccionar grosor de herramienta
El sistema SHALL permitir al usuario elegir el grosor del trazo.

#### Scenario: Ajustar grosor con slider
- **WHEN** el usuario mueve el slider de grosor
- **THEN** el sistema SHALL mostrar una vista previa del grosor seleccionado
- **AND** SHALL aplicar el grosor a la herramienta activa

#### Scenario: Rangos de grosor por herramienta
- **WHEN** el usuario selecciona diferentes herramientas
- **THEN** el sistema SHALL ofrecer rangos de grosor apropiados:
  - Bolígrafo: 0.5mm - 3mm
  - Lápiz: 1mm - 5mm
  - Marcador: 3mm - 15mm
  - Borrador: 5mm - 30mm

### Requirement: Persistir última configuración de herramienta
El sistema SHALL recordar la última configuración de herramienta usada por el usuario.

#### Scenario: Recordar configuración al cerrar documento
- **WHEN** el usuario cierra un documento con una herramienta activa
- **THEN** el sistema SHALL guardar: tipo de herramienta, color, grosor
- **AND** SHALL restaurar esa configuración al abrir cualquier documento

### Requirement: Escribir sobre PDF
El sistema SHALL permitir al usuario escribir sobre el documento PDF con la herramienta seleccionada.

#### Scenario: Dibujar trazo con bolígrafo
- **WHEN** el usuario toca la pantalla con el dedo o Apple Pencil en modo bolígrafo
- **THEN** el sistema SHALL dibujar un trazo del color y grosor seleccionados
- **AND** el trazo SHALL seguir el movimiento del input con baja latencia

#### Scenario: Borrar trazo con borrador
- **WHEN** el usuario toca un trazo existente con el borrador activo
- **THEN** el sistema SHALL eliminar el trazo o la parte intersectada
- **AND** el cambio SHALL reflejarse inmediatamente en pantalla

### Requirement: Marcador con transparencia
El sistema SHALL aplicar transparencia al marcador para permitir resaltar sin ocultar el texto subyacente.

#### Scenario: Usar marcador
- **WHEN** el usuario selecciona el marcador y dibuja sobre texto
- **THEN** el sistema SHALL aplicar color con opacidad del 40%
- **AND** el texto subyacente SHALL seguir siendo legible
