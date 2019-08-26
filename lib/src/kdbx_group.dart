import 'package:kdbx/src/kdbx_entry.dart';
import 'package:kdbx/src/kdbx_xml.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import 'kdbx_object.dart';

class KdbxGroup extends KdbxObject {
  KdbxGroup.create({@required this.parent, @required String name}) : super.create('Group') {
    this.name.set(name);
  }

  KdbxGroup.read(this.parent, XmlElement node) : super.read(node) {
    node
        .findElements('Group')
        .map((el) => KdbxGroup.read(this, el))
        .forEach(groups.add);
    node
        .findElements('Entry')
        .map((el) => KdbxEntry.read(this, el))
        .forEach(entries.add);
  }

  /// Returns all groups plus this group itself.
  List<KdbxGroup> getAllGroups() => groups
      .expand((g) => g.getAllGroups())
      .followedBy([this]).toList(growable: false);

  /// Returns all entries of this group and all sub groups.
  List<KdbxEntry> getAllEntries() =>
      getAllGroups().expand((g) => g.entries).toList(growable: false);

  /// null if this is the root group.
  final KdbxGroup parent;
  final List<KdbxGroup> groups = [];
  final List<KdbxEntry> entries = [];

  StringNode get name => StringNode(this, 'Name');
//  String get name => text('Name') ?? '';
}
