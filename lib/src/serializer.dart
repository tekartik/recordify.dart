import 'package:reflectable/reflectable.dart';
import 'recordify_base.dart';
import '../recordify.dart';

// Singleton that maps every class annotated with @serializable
class SerializerClassInfo {
  final ClassMirror classMirror;
  final List<VariableMirror> variableMirrors = [];
  final List<VariableMirror> indecies = [];
  SerializerClassInfo(this.classMirror) {
    classMirror.declarations
        .forEach((String key, DeclarationMirror declarationMirror) {
      if (declarationMirror is VariableMirror) {
        for (var metadata in declarationMirror.metadata) {
          if (metadata is Ignore) {
            // skip
            return;
          }
          if (metadata is Index) {
            indecies.add(declarationMirror);
          }
        }
        variableMirrors.add(declarationMirror);
      }
    });
  }
}

final Map<Type, SerializerClassInfo> _classes = {};

SerializerClassInfo getClassInfo(Type type) {
  var classInfo = _classes[type];
  if (classInfo == null) {
    var typeMirror = recordify.reflectType(type);
    if (typeMirror is ClassMirror) {
      classInfo = SerializerClassInfo(typeMirror);
      _classes[type] = classInfo;
    } else {
      throw UnsupportedError('Unsupported $type, $classInfo, $typeMirror');
    }
  }
  return classInfo;
}

// Utility class to access to the serializer api
Map toMap(Object object) {
  SerializerClassInfo classInfo = getClassInfo(object.runtimeType);
  InstanceMirror instanceMirror = recordify.reflect(object);
  Map map = {};
  classInfo.variableMirrors.forEach((VariableMirror variableMirror) {
    String varName = variableMirror.simpleName;
    dynamic value = instanceMirror.invokeGetter(varName);
    if (value != null) {
      map[varName] = value;
    }
  });
  return map;
}

T fromMap<T>(Map map) {
  SerializerClassInfo classInfo = getClassInfo(T);
  Object object = classInfo.classMirror.newInstance('', []);
  InstanceMirror instanceMirror = recordify.reflect(object);
  classInfo.variableMirrors.forEach((VariableMirror variableMirror) {
    String varName = variableMirror.simpleName;
    dynamic value = map[varName];
    if (value != null) {
      instanceMirror.invokeSetter(varName, value);
    }
  });
  return object as T;
}
