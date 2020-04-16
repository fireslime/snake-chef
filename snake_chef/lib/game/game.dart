import 'package:flame/game.dart';
import 'package:flame/keyboard.dart';
import 'package:flame/position.dart';
import 'package:flutter/services.dart';
import 'package:flame/time.dart';
import 'package:flame/components/timer_component.dart';

import './components/game_board.dart';
import './components/top_bar.dart';
import './components/top_left_bar.dart';
import './components/bottom_left_bar.dart';
import './widgets/game_over.dart';
import './stage.dart';
import './cell.dart';

class SnakeChef extends BaseGame with KeyboardEvents, HasWidgetsOverlay {
  GameBoard gameBoard;
  int boardWidth;
  int boardHeight;
  Stage stage;
  int recipeIndex = 0;

  Timer stageTimerController;
  int stageTimer = 0;

  Recipe get currentRecipe => stage.recipes[recipeIndex];

  List<Ingredient> collectedIngredients = [];

  SnakeChef({this.boardWidth, this.boardHeight, this.stage}) {
    final renderOffset = Position(300, 100);
    add(gameBoard = GameBoard(
            boardHeight: boardHeight,
            boardWidth: boardWidth,
            renderOffset: renderOffset,
    ));

    add(
        TopBar()
        ..x = renderOffset.x
        ..height = renderOffset.y
        ..width = boardWidth * Cell.cellSize
    );

    final middleY = ((boardHeight * Cell.cellSize) + renderOffset.y) / 2;
    add(
        TopLeftBar()
        ..x = 0 
        ..height = middleY
        ..width = renderOffset.x 
    );

    add(
        BottomLeftBar()
        ..x = 0 
        ..y = middleY
        ..height = middleY
        ..width = renderOffset.x 
    );

    stageTimerController = Timer(1, repeat: true, callback: () {
      stageTimer++;
    })..start();

    add(TimerComponent(stageTimerController));
  }

  void collectIngredient(Ingredient ingredient) {
    print(ingredient);
    if (currentRecipe.validIngredient(ingredient)) {
      collectedIngredients.add(ingredient);
      gameBoard.spawnIngredient(ingredient);

      if (currentRecipe.ingredients.length == collectedIngredients.length) {
        if (currentRecipe.checkCompletion(collectedIngredients)) {
          collectedIngredients = [];

          if (recipeIndex + 1 < stage.recipes.length) {
            print("next recipe");
            recipeIndex++;
          } else {
            // TODO show win and go to next level
            print("Ganhouuuuu");
          }
        } else {
          gameBoard.gameOver();
        }
      }
    } else {
      gameBoard.gameOver();
    }
  }

  void onKeyEvent(event) {
    if (event is RawKeyUpEvent) {
      final key = event.data.keyLabel;

      if (key == "ArrowRight") {
        gameBoard.turnRight();
      } else if (key == "ArrowLeft") {
        gameBoard.turnLeft();
      } else if (key == "ArrowUp") {
        gameBoard.turnUp();
      } else if (key == "ArrowDown") {
        gameBoard.turndown();
      }
    }
  }

  void showGameOver() {
    addWidgetOverlay(
      'GameOverMenu',
      GameOver(restartGame: gameBoard.restartGame),
    );
  }

  void hideGameOver() {
    removeWidgetOverlay('GameOverMenu');
  }
}
