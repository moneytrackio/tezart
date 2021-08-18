## [1.0.0]

### Added
- micheline codec
- contract call
- contract origination
- gas limit, storage limit, fees computation

### Changed
- BREAKING CHANGE: TezartClient doesn't inject the operations anymore. This responsability moved to OperationsList

### Fixed

## [0.2.1]

### Added

### Changed
- increase minimum required dart version to 2.11
- BREAKING CHANGE: change TezartClient constructor parameters to a single one:\
  BEFORE: `TezartClient(host: 'localhost', scheme: 'http', port: '20000');`\
  AFTER: `TezartClient('http://localhost:20000');`

### Fixed

## [0.2.0]

### Added
- initial release of the open source project.

### Changed

### Fixed
