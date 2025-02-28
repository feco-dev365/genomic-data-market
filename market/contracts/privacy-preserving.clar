;; Privacy-Preserving Genomic Data Sharing Contract

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_DATASET_NOT_FOUND (err u101))
(define-constant ERR_INVALID_PROOF (err u102))
(define-constant ERR_ALREADY_VERIFIED (err u103))

;; Data structures

;; Dataset structure
(define-map datasets
  { dataset-id: uint }
  {
    owner: principal,
    ipfs-hash: (string-ascii 46),  ;; IPFS hash of the encrypted dataset
    description: (string-utf8 256),
    is-active: bool
  }
)

;; Access requests structure
(define-map access-requests
  { request-id: uint }
  {
    dataset-id: uint,
    requester: principal,
    purpose: (string-ascii 50),
    status: (string-ascii 20)  ;; "pending", "approved", "rejected", "completed"
  }
)

;; ZKP verifications structure
(define-map zkp-verifications
  { request-id: uint }
  {
    verified: bool,
    verification-data: (buff 256)  ;; Placeholder for ZKP verification data
  }
)

;; Counters
(define-data-var dataset-counter uint u0)
(define-data-var request-counter uint u0)

;; Private functions

(define-private (is-contract-owner)
  (is-eq tx-sender CONTRACT_OWNER)
)

(define-private (is-dataset-owner (dataset-id uint))
  (let ((dataset (unwrap! (map-get? datasets { dataset-id: dataset-id }) false)))
    (is-eq tx-sender (get owner dataset))
  )
)

;; Public functions

;; Register a new dataset
(define-public (register-dataset (ipfs-hash (string-ascii 46)) (description (string-utf8 256)))
  (let
    (
      (new-id (var-get dataset-counter))
    )
    (map-set datasets
      { dataset-id: new-id }
      {
        owner: tx-sender,
        ipfs-hash: ipfs-hash,
        description: description,
        is-active: true
      }
    )
    (var-set dataset-counter (+ new-id u1))
    (ok new-id)
  )
)

;; Request access to a dataset
(define-public (request-access (dataset-id uint) (purpose (string-ascii 50)))
  (let
    (
      (new-id (var-get request-counter))
    )
    (asserts! (is-some (map-get? datasets { dataset-id: dataset-id })) ERR_DATASET_NOT_FOUND)
    (map-set access-requests
      { request-id: new-id }
      {
        dataset-id: dataset-id,
        requester: tx-sender,
        purpose: purpose,
        status: "pending"
      }
    )
    (var-set request-counter (+ new-id u1))
    (ok new-id)
  )
)

;; Approve or reject an access request
(define-public (process-access-request (request-id uint) (approve bool))
  (let
    (
      (request (unwrap! (map-get? access-requests { request-id: request-id }) ERR_DATASET_NOT_FOUND))
      (dataset (unwrap! (map-get? datasets { dataset-id: (get dataset-id request) }) ERR_DATASET_NOT_FOUND))
    )
    (asserts! (is-eq tx-sender (get owner dataset)) ERR_NOT_AUTHORIZED)
    (map-set access-requests
      { request-id: request-id }
      (merge request { status: (if approve "approved" "rejected") })
    )
    (ok true)
  )
)

;; Submit ZKP verification for an approved request
(define-public (submit-zkp-verification (request-id uint) (verification-data (buff 256)))
  (let
    (
      (request (unwrap! (map-get? access-requests { request-id: request-id }) ERR_DATASET_NOT_FOUND))
    )
    (asserts! (is-eq (get status request) "approved") ERR_NOT_AUTHORIZED)
    (asserts! (is-none (map-get? zkp-verifications { request-id: request-id })) ERR_ALREADY_VERIFIED)
    
    ;; In a real implementation, we would verify the ZKP here
    ;; For this example, we'll assume all submitted proofs are valid
    (map-set zkp-verifications
      { request-id: request-id }
      {
        verified: true,
        verification-data: verification-data
      }
    )
    (map-set access-requests
      { request-id: request-id }
      (merge request { status: "completed" })
    )
    (ok true)
  )
)

;; Read-only functions

;; Get dataset details
(define-read-only (get-dataset (dataset-id uint))
  (map-get? datasets { dataset-id: dataset-id })
)

;; Get access request details
(define-read-only (get-access-request (request-id uint))
  (map-get? access-requests { request-id: request-id })
)

;; Check if ZKP is verified for a request
(define-read-only (is-zkp-verified (request-id uint))
  (match (map-get? zkp-verifications { request-id: request-id })
    verification (get verified verification)
    false
  )
)
