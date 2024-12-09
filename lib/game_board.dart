import 'package:flutter/material.dart';
import 'dart:math';
import 'tile.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<int> grid;
  final int gridSize = 4;
  int moveCount = 0;
  int target = 2048; // Valeur cible par défaut

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      grid = List.generate(gridSize * gridSize, (_) => 0);
      moveCount = 0;
      _addRandomTile();
      _addRandomTile();
    });
  }

  void _addRandomTile() {
    List<int> emptyTiles = [];
    for (int i = 0; i < grid.length; i++) {
      if (grid[i] == 0) {
        emptyTiles.add(i);
      }
    }
    if (emptyTiles.isNotEmpty) {
      int randomIndex = emptyTiles[Random().nextInt(emptyTiles.length)];
      grid[randomIndex] = 2;
    }
  }

  void _handleSwipe(String direction) {
    setState(() {
      if (_moveTiles(direction)) {
        _addRandomTile();
        moveCount++;
        if (_isGameOver()) {
          _showGameOverDialog();
        } else if (_hasWon()) {
          _showWinDialog();
        }
      }
    });
  }

  bool _moveTiles(String direction) {
    bool moved = false;
    switch (direction) {
      case 'up':
        moved = _moveUp();
        break;
      case 'down':
        moved = _moveDown();
        break;
      case 'left':
        moved = _moveLeft();
        break;
      case 'right':
        moved = _moveRight();
        break;
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int col = 0; col < gridSize; col++) {
      List<int> column = [];
      for (int row = 0; row < gridSize; row++) {
        if (grid[row * gridSize + col] != 0) {
          column.add(grid[row * gridSize + col]);
        }
      }
      List<int> merged = _mergeTiles(column);
      for (int row = 0; row < gridSize; row++) {
        int value = row < merged.length ? merged[row] : 0;
        if (grid[row * gridSize + col] != value) {
          grid[row * gridSize + col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int col = 0; col < gridSize; col++) {
      List<int> column = [];
      for (int row = gridSize - 1; row >= 0; row--) {
        if (grid[row * gridSize + col] != 0) {
          column.add(grid[row * gridSize + col]);
        }
      }
      List<int> merged = _mergeTiles(column);
      for (int row = gridSize - 1; row >= 0; row--) {
        int value = (gridSize - 1 - row) < merged.length
            ? merged[gridSize - 1 - row]
            : 0;
        if (grid[row * gridSize + col] != value) {
          grid[row * gridSize + col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveLeft() {
    bool moved = false;
    for (int row = 0; row < gridSize; row++) {
      List<int> line = [];
      for (int col = 0; col < gridSize; col++) {
        if (grid[row * gridSize + col] != 0) {
          line.add(grid[row * gridSize + col]);
        }
      }
      List<int> merged = _mergeTiles(line);
      for (int col = 0; col < gridSize; col++) {
        int value = col < merged.length ? merged[col] : 0;
        if (grid[row * gridSize + col] != value) {
          grid[row * gridSize + col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int row = 0; row < gridSize; row++) {
      List<int> line = [];
      for (int col = gridSize - 1; col >= 0; col--) {
        if (grid[row * gridSize + col] != 0) {
          line.add(grid[row * gridSize + col]);
        }
      }
      List<int> merged = _mergeTiles(line);
      for (int col = gridSize - 1; col >= 0; col--) {
        int value = (gridSize - 1 - col) < merged.length
            ? merged[gridSize - 1 - col]
            : 0;
        if (grid[row * gridSize + col] != value) {
          grid[row * gridSize + col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  List<int> _mergeTiles(List<int> tiles) {
    List<int> merged = [];
    int i = 0;
    while (i < tiles.length) {
      if (i + 1 < tiles.length && tiles[i] == tiles[i + 1]) {
        merged.add(tiles[i] * 2);
        i += 2;
      } else {
        merged.add(tiles[i]);
        i++;
      }
    }
    return merged;
  }

  bool _isGameOver() {
    for (int i = 0; i < grid.length; i++) {
      if (grid[i] == 0) return false;
    }
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize - 1; j++) {
        if (grid[i * gridSize + j] == grid[i * gridSize + j + 1] ||
            grid[j * gridSize + i] == grid[(j + 1) * gridSize + i]) {
          return false;
        }
      }
    }
    return true;
  }

  bool _hasWon() {
    return grid.contains(target);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Vous avez perdu ! Aucune action possible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vous avez gagné !'),
          content: Text('Vous avez atteint $target. Félicitations !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text('Coups : $moveCount', style: const TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<int>(
            value: target,
            onChanged: (int? newValue) {
              setState(() {
                target = newValue!;
                _startNewGame(); // Redémarre le jeu avec la nouvelle difficulté
              });
            },
            items: const [
              DropdownMenuItem(value: 256, child: Text("256")),
              DropdownMenuItem(value: 512, child: Text("512")),
              DropdownMenuItem(value: 1024, child: Text("1024")),
              DropdownMenuItem(value: 2048, child: Text("2048")),
            ],
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: 16,
              itemBuilder: (context, index) =>
                  Tile(value: grid[index], palette: 'default'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () => _handleSwipe('up')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _handleSwipe('left')),
            const SizedBox(width: 20),
            IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _handleSwipe('right')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => _handleSwipe('down')),
          ],
        ),
        const SizedBox(height: 20),
        FloatingActionButton(
          onPressed: _startNewGame,
          tooltip: 'Restart',
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
