// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:recordify/recordify.dart';
import 'package:recordify/src/serializer.dart';
import 'package:recordify/src/recordify_base.dart';
import 'package:dev_test/test.dart';

import 'serializer_test.reflectable.dart';

@Record()
class Simple {
  @Id()
  String? id;

  //@Ignore()
  //String shouldIgnore = "some_value";

  String? stringValue;
  int? intValue;

  @Index()
  int? index;

  void test() {
    print('test');
  }
}

main() {
  initializeReflectable();
  setUpAll(() {});

  tearDownAll(() {});

  group("serializer", () {
    test("invokeGetter", () {
      Simple simple = Simple()..id = "test";
      //expect(recordify.reflect(simple).invokeGetter("id"), "test");
      //recordify.reflect(simple).invoke('test', []);
      //ClassMirror typeMirror = recordify.reflectType(Simple);
      //simple = typeMirror.newInstance('', []);
      var instanceMirror = recordify.reflect(simple);
      expect(instanceMirror.invokeGetter('id'), 'test');
    });

    test("toMap", () {
      Simple simple = Simple();
      expect(toMap(simple), {});

      simple.id = "test";
      simple.stringValue = "some_string";
      simple.intValue = 1234;
      expect(toMap(simple),
          {'id': 'test', 'stringValue': 'some_string', 'intValue': 1234});
    });

    test("fromMap", () {
      Simple simple = fromMap<Simple>({});
      expect(simple.id, isNull);

      simple = fromMap<Simple>(
        {'id': 'test', 'stringValue': 'some_string', 'intValue': 1234},
      );
      expect(simple.id, "test");
      expect(simple.stringValue, "some_string");
      expect(simple.intValue, 1234);
    });
  });
}
