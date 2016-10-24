// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library recordify;
import 'package:reflectable/reflectable.dart';

/*
class Record extends Reflectable {
  const Record()
      : super.fromList(const<ReflectCapability>[
    invokingCapability,
    typeRelationsCapability,
    metadataCapability,
    superclassQuantifyCapability,
    reflectedTypeCapability
  ]);
}
*/

class Record extends Reflectable {
  const Record()
      : super(invokingCapability);
}


class Ignore {
  const Ignore();
}

class Id {
  const Id();
}

class Index {
  const Index();
}

