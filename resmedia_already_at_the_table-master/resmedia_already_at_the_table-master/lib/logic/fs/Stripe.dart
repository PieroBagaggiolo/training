import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_already_at_the_table/model/stripe/SourceStripeModel.dart';

final _fs = Firestore.instance;

const customers_stripe = 'stripe_customers';

const sources = 'sources';

mixin SourceStripeDispenser implements Dispenser<SourceStripeModel> {
  @override
  FromJson<SourceStripeModel> get fromJson => SourceStripeModel.fromJson;
}

class SourceStripeCl extends CollectionFs<SourceStripeModel> with SourceStripeDispenser {
  SourceStripeCl(String userID)
      : super(_fs.collection(customers_stripe).document(userID).collection(sources));

  SourceStripeDc document(String id) => SourceStripeDc(reference.document(id));
}

class SourceStripeDc extends DocumentFs<SourceStripeModel> with SourceStripeDispenser {
  SourceStripeDc(DocumentReference reference) : super(reference);
}
