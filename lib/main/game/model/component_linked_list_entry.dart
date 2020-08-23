import 'dart:collection';

import 'package:flame/components/component.dart';

class ComponentLinkedListEntry extends LinkedListEntry<ComponentLinkedListEntry> {
  final Component gameComponent;
  int get priority => gameComponent?.priority()??0;
  ComponentLinkedListEntry(this.gameComponent);
}