class MoneyModel{
 String id,
  transaction_type,
  user_id,
  order_id,
  type,
  txn_id,
  payu_txn_id,
  amount,
  status,
  currency_code,
  payer_email,
  message,
  transaction_date,
  date_created;
 bool show;
 MoneyModel(
      this.id,
      this.transaction_type,
      this.user_id,
      this.order_id,
      this.type,
      this.txn_id,
      this.payu_txn_id,
      this.amount,
      this.status,
      this.currency_code,
      this.payer_email,
     this.message,
      this.transaction_date,
      this.date_created,this.show);
}