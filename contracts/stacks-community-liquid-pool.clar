(define-constant ADMIN tx-sender) ;; Admin who deploys the contract

;; -------------------------------
;; State Variables
;; -------------------------------
(define-data-var total-staked uint u0) ;; Total STX staked in the pool
(define-data-var reward-pool uint u0) ;; Total STX available for rewards
(define-data-var last-distribution uint u0) ;; Counter for reward distributions

(define-map user-stakes { user: principal } uint) ;; Mapping of user stakes
(define-map user-rewards { user: principal } uint) ;; Mapping of user rewards

;; -------------------------------
;; Stake STX into the Pool
;; -------------------------------
(define-public (stake (amount uint))
  (begin
    (asserts! (> amount u0) (err u100)) ;; Ensure valid amount
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      success
        (let ((current-stake (default-to u0 (map-get? user-stakes { user: tx-sender }))))
          (map-set user-stakes { user: tx-sender } (+ current-stake amount))
          (var-set total-staked (+ (var-get total-staked) amount))
          (ok true))
      error (err error) ;; Transfer failed
    )
  )
)

;; -------------------------------
;; Withdraw STX from Pool
;; -------------------------------
(define-public (withdraw (amount uint))
  (let ((current-stake (default-to u0 (map-get? user-stakes { user: tx-sender }))))
    (begin
      (asserts! (>= current-stake amount) (err u101)) ;; Ensure sufficient balance
      (match (stx-transfer? amount (as-contract tx-sender) tx-sender)
        success
          (begin
            (map-set user-stakes { user: tx-sender } (- current-stake amount))
            (var-set total-staked (- (var-get total-staked) amount))
            (ok true))
        error (err error) ;; Transfer failed
      )
    )
  )
)

;; -------------------------------
;; Fund Reward Pool (Admin Only)
;; -------------------------------
(define-public (fund-reward-pool (amount uint))
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err u102)) ;; Only admin can fund
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      success
        (begin
          (var-set reward-pool (+ (var-get reward-pool) amount))
          (ok true))
      error (err error) ;; Transfer failed
    )
  )
)

;; -------------------------------
;; Distribute Rewards (Admin Only)
;; -------------------------------
(define-public (distribute-rewards)
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err u103)) ;; Only admin can distribute
    (asserts! (> (var-get total-staked) u0) (err u104)) ;; Ensure users are staked
    (asserts! (> (var-get reward-pool) u0) (err u105)) ;; Ensure rewards exist

    ;; Distribute rewards based on stake percentage
    (map-set user-rewards { user: tx-sender }
      (* (var-get reward-pool) (/ (default-to u0 (map-get? user-stakes { user: tx-sender })) (var-get total-staked))))
    
    ;; Increment distribution counter
    (var-set last-distribution (+ (var-get last-distribution) u1))
    (ok true)
  )
)

;; -------------------------------
;; Claim Rewards
;; -------------------------------
(define-public (claim-rewards)
  (let ((reward (default-to u0 (map-get? user-rewards { user: tx-sender }))))
    (begin
      (asserts! (> reward u0) (err u106)) ;; Ensure user has rewards
      (asserts! (<= reward (var-get reward-pool)) (err u107)) ;; Check reward pool
      (match (stx-transfer? reward (as-contract tx-sender) tx-sender)
        success
          (begin
            (map-set user-rewards { user: tx-sender } u0) ;; Reset user rewards
            (var-set reward-pool (- (var-get reward-pool) reward))
            (ok true))
        error (err error) ;; Transfer failed
      )
    )
  )
)

;; -------------------------------
;; Read-Only Functions
;; -------------------------------
(define-read-only (get-user-stake (user principal))
  (ok (default-to u0 (map-get? user-stakes { user: user })))
)

(define-read-only (get-total-staked)
  (ok (var-get total-staked))
)

(define-read-only (get-reward-pool)
  (ok (var-get reward-pool))
)

(define-read-only (get-user-rewards (user principal))
  (ok (default-to u0 (map-get? user-rewards { user: user })))
)

(define-read-only (get-last-distribution)
  (ok (var-get last-distribution))
)

