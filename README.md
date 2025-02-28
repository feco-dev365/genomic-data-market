# genomic-data-market

## Overview
The Genomic Data Marketplace Smart Contract is designed to facilitate seamless data licensing for biotech, pharmaceutical, and AI-driven research platforms. This contract supports cross-chain compatibility, enabling broader adoption in healthcare and research industries.

## Features
- **Data Licensing**: Enables secure and controlled access to genomic datasets.
- **Cross-Chain Interoperability**: Supports trusted bridges for cross-chain data transactions.
- **Dataset Management**: Allows providers to register and update datasets with licensing terms.
- **License Purchase**: Enables consumers to purchase and manage dataset licenses.
- **Security Mechanisms**: Implements error handling, dataset authentication, and trusted bridge verification.

## Data Structures
### License Terms
Stores licensing details for each dataset:
- `duration`: License duration in seconds
- `commercial-use`: Boolean flag for commercial use permission
- `modification`: Boolean flag for modification permission
- `royalty-percentage`: Royalty fees in basis points
- `allowed-purposes`: List of approved usage purposes

### Datasets
Manages genomic dataset metadata and availability:
- `provider`: Dataset owner
- `metadata-uri`: URI reference for dataset details
- `price`: Licensing fee
- `active`: Availability status
- `access-method`: API endpoint or IPFS hash

### Licenses
Stores purchased licenses:
- `dataset-id`: Associated dataset
- `licensee`: Consumer who purchased the license
- `expiration-time`: License validity period
- `active`: License status
- `approved-purposes`: List of permitted usage purposes

### Cross-Chain Messages
Handles secure cross-chain transactions:
- `source-chain-id`: Origin chain ID
- `target-chain-id`: Destination chain ID
- `sender`: Message sender
- `data`: Encoded transaction data
- `processed`: Status flag

### Provider and Consumer Mappings
- **Provider Datasets**: Maps providers to their registered datasets.
- **Consumer Licenses**: Maps consumers to their purchased licenses.

### Trusted Bridges
Defines trusted cross-chain communication bridges:
- `chain-id`: Target blockchain network
- `bridge-address`: Address of the trusted bridge

## Error Codes
- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized action
- `ERR-DATASET-NOT-FOUND (u101)`: Dataset not found
- `ERR-DATASET-INACTIVE (u102)`: Dataset is inactive
- `ERR-LICENSE-NOT-FOUND (u103)`: License not found
- `ERR-LICENSE-EXPIRED (u104)`: License has expired
- `ERR-LICENSE-INACTIVE (u105)`: License is inactive
- `ERR-INVALID-PURPOSE (u106)`: Invalid usage purpose
- `ERR-PAYMENT-FAILED (u107)`: Payment failure
- `ERR-BRIDGE-NOT-TRUSTED (u108)`: Untrusted cross-chain bridge
- `ERR-INVALID-SIGNATURE (u109)`: Signature verification failed
- `ERR-MESSAGE-ALREADY-PROCESSED (u110)`: Cross-chain message was already processed

## Functions
### Private Functions
- `is-contract-owner()`: Verifies contract owner
- `is-dataset-provider(dataset-id)`: Checks dataset ownership
- `add-provider-dataset(provider, dataset-id)`: Registers dataset under provider
- `add-consumer-license(consumer, license-id)`: Registers license under consumer
- `is-purpose-allowed(purpose, allowed-purposes)`: Validates allowed license purposes

### Public Functions
- `register-dataset(metadata-uri, price, access-method, duration, commercial-use, modification, royalty-percentage, allowed-purposes)`: Registers a new genomic dataset.
- `update-dataset(dataset-id, metadata-uri, price, active, access-method, duration, commercial-use, modification, royalty-percentage, allowed-purposes)`: Updates dataset details.
- `purchase-license(dataset-id, payment-token, purposes)`: Purchases a dataset license.

## Usage
1. **Register a Dataset**: A provider registers a genomic dataset with metadata, access methods, pricing, and licensing terms.
2. **Update a Dataset**: The provider can modify dataset details and licensing terms.
3. **Purchase a License**: A consumer selects a dataset, makes a payment, and receives a license for approved purposes.

## Security Considerations
- Implements strict authorization checks to prevent unauthorized actions.
- Utilizes cross-chain messaging security for trusted data exchanges.
- Enforces expiration and validity checks for datasets and licenses.

## License
This smart contract is provided under an open-source license for community-driven enhancements.

