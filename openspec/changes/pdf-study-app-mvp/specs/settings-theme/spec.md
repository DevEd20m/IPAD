## ADDED Requirements

### Requirement: Cambiar tema visual
El sistema SHALL permitir al usuario alternar entre Light Theme y Dark Theme.

#### Scenario: Cambiar a tema oscuro
- **WHEN** el usuario selecciona "Dark Theme" en configuración
- **THEN** el sistema SHALL aplicar el tema oscuro a toda la interfaz
- **AND** SHALL guardar la preferencia

#### Scenario: Cambiar a tema claro
- **WHEN** el usuario selecciona "Light Theme" en configuración
- **THEN** el sistema SHALL aplicar el tema claro a toda la interfaz
- **AND** SHALL guardar la preferencia

#### Scenario: Mantener tema al reiniciar aplicación
- **WHEN** el usuario cambia el tema y cierra la aplicación
- **AND** vuelve a abrir la aplicación
- **THEN** el sistema SHALL mantener el tema seleccionado

### Requirement: Persistir preferencias de usuario
El sistema SHALL guardar todas las preferencias del usuario de forma local.

#### Scenario: Guardar preferencias
- **WHEN** el usuario modifica cualquier configuración
- **THEN** el sistema SHALL guardar la preferencia en almacenamiento local
- **AND** SHALL aplicar el cambio inmediatamente

#### Scenario: Preferencias guardadas
- **WHEN** el usuario abre la aplicación por primera vez
- **AND** no tiene preferencias previas
- **THEN** el sistema SHALL usar valores por defecto:
  - Theme: Light Theme
  - Herramienta reciente: Bolígrafo
  - Color reciente: Negro
  - Grosor reciente: 1.5mm
  - Double tap: Activado (borrador)

### Requirement: Pantalla de configuración
El sistema SHALL mostrar una pantalla de configuración accesible desde la pantalla principal.

#### Scenario: Acceder a configuración
- **WHEN** el usuario toca el ícono de configuración en la pantalla principal
- **THEN** el sistema SHALL mostrar la pantalla de configuración
- **AND** SHALL mostrar las opciones: Tema, Comportamiento de Double Tap, Acerca de
