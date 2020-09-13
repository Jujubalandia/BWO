import 'package:flutter/material.dart';

import '../../../entity/wall/furniture.dart';
import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../build_tools_bar.dart';
import '../door_build.dart';
import '../tool_item.dart';

class BuildToolsDoor extends BuildSubToolsBar {
  final MapController _map;

  int width = 16;
  int height = 16;

  BuildToolsBar toolsBar;

  DoorBuild _doorBuild;
  String _selectedDoor;
  Furniture _instatiatedFuniture;

  BuildToolsDoor(this._map, this.toolsBar, HUD hudRef) {
    buttonList = [
      ToolItem("door1", "Door 1", hudRef, onPress, size: Offset(2, 1)),
      ToolItem("door2", "Door 2", hudRef, onPress, size: Offset(2, 1)),
      ToolItem("door3", "Door 3", hudRef, onPress, size: Offset(2, 1)),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (_selectedDoor == null) return;

    _doorBuild?.drawCollisionArea(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnWorld =
          TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
      var tapOnScreen = TapState.currentPosition;

      var verticalBarButtons =
          Rect.fromLTWH(0, GameController.screenSize.height - 235, 48, 235);

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          TapState.currentClickingAtInside(verticalBarButtons) == false) {
        previewFurniture(tapOnWorld.dx.floor(), tapOnWorld.dy.floor());
      }
    }
    if (GameController.tapState == TapState.up) {
      if (_doorBuild != null && _doorBuild.isValidTerrain) {
        addDoor();
      }
    }
  }

  void onPress(ToolItem bt) {
    selectButtonHighlight(bt);

    width = bt.size.dx.floor();
    height = bt.size.dy.floor();

    print('onPress ${bt.spriteName}');
    _selectedDoor = bt.spriteName;
  }

  //create foundation
  void previewFurniture(int posX, int posY) {
    var x = posX - (width / 2.0).floor();
    var y = posY - (height / 2.0).floor();

    var isValid = _map.buildFoundation.isValidAreaOnFoundation(
        x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble());

    dynamic doorData = {
      'id': _selectedDoor,
      'x': x,
      'y': y,
      'w': width,
      'h': height,
    };
    if (_doorBuild == null) {
      _doorBuild = DoorBuild(doorData, _map);
    }
    _doorBuild.isValidTerrain = isValid;
    _doorBuild.setup(doorData);
  }

  void addDoor() {
    /*if (_instatiatedFuniture == null) {
      _instatiatedFuniture = _doorBuild.getFurniture();
      _map.buildFoundation.placeFurniture(_instatiatedFuniture);

      _selectedDoor = null;
      _instatiatedFuniture = null;
      _doorBuild = null;

      selectButtonHighlight(null);
    } else {
      //update
    }*/
  }
}