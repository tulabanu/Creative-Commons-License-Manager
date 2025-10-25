;; title: License
;; version: 1.0
;; summary: Creative Commons License Management System
;; description: Register and manage Creative Commons licenses with metadata tracking

(define-data-var license-counter uint u0)

(define-map licenses
  { license-id: uint }
  {
    owner: principal,
    title: (string-ascii 256),
    license-type: (string-ascii 64),
    creation-date: uint
  }
)

(define-public (register-license (title (string-ascii 256)) (license-type (string-ascii 64)))
  (let
    (
      (new-id (+ (var-get license-counter) u1))
      (caller tx-sender)
    )
    (map-insert licenses { license-id: new-id }
      {
        owner: caller,
        title: title,
        license-type: license-type,
        creation-date: burn-block-height
      }
    )
    (var-set license-counter new-id)
    (ok new-id)
  )
)

(define-read-only (get-license (license-id uint))
  (map-get? licenses { license-id: license-id })
)

(define-read-only (get-license-count)
  (var-get license-counter)
)

(define-read-only (license-exists (license-id uint))
  (is-some (map-get? licenses { license-id: license-id }))
)

