# UrbanVoice — App Flutter — Arquitectura

Resumen de alto nivel de la organización de la aplicación móvil. El código
fuente en `lib/` es siempre la fuente de verdad.

## Estilo arquitectónico

La app sigue **Clean Architecture** separando responsabilidades en capas y
usando **BLoC** para la gestión de estado.

```
lib/
├── core/          # Configuración transversal: DI, red, tema, constantes
├── data/          # Datasources, modelos y repositorios (implementación)
├── domain/        # Entidades, contratos de repositorio y casos de uso
└── presentation/  # BLoCs, páginas y widgets
```

## Capas

| Capa | Responsabilidad |
| --- | --- |
| `domain` | Reglas de negocio puras: entidades, casos de uso, contratos |
| `data` | Acceso a datos: llamadas HTTP, modelos y mapeo a entidades |
| `presentation` | UI y estado (BLoC): páginas, widgets y eventos/estados |
| `core` | Utilidades compartidas: inyección de dependencias, red, tema |

## Convenciones

- La capa `presentation` depende de `domain`, nunca al revés.
- Los modelos de `data` se mapean a entidades de `domain` antes de exponerse
  a la UI.
- Las constantes de red y de la app se centralizan en `core/constants`.
