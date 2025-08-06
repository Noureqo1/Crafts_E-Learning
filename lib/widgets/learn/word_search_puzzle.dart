import 'dart:math';
import 'package:flutter/material.dart';

class WordSearchPuzzle extends StatefulWidget {
  final List<String> words;
  
  const WordSearchPuzzle({super.key, required this.words});

  @override
  _WordSearchPuzzleState createState() => _WordSearchPuzzleState();
}

class _WordSearchPuzzleState extends State<WordSearchPuzzle> {
  late List<List<String>> grid;
  late List<List<bool>> foundCells;
  final int gridSize = 10;
  Set<String> foundWords = {};
  int score = 0;
  bool isGameOver = false;
  List<Offset> selectedCells = [];
  
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }
  
  void _initializeGame() {
    // Initialize empty grid
    grid = List.generate(gridSize, (_) => List.filled(gridSize, ''));
    foundCells = List.generate(gridSize, (_) => List.filled(gridSize, false));
    
    // Place words in the grid
    _placeWords();
    
    // Fill remaining cells with random letters
    _fillEmptyCells();
  }
  
  void _placeWords() {
    final random = Random();
    final directions = [
      [1, 0],   // Horizontal
      [0, 1],   // Vertical
      [1, 1],   // Diagonal down-right
      [1, -1],  // Diagonal up-right
    ];
    
    for (final word in widget.words) {
      if (word.length > gridSize) continue; // Skip words that are too long
      
      bool placed = false;
      int attempts = 0;
      
      while (!placed && attempts < 100) {
        attempts++;
        
        // Choose random direction
        final dir = directions[random.nextInt(directions.length)];
        final dx = dir[0];
        final dy = dir[1];
        
        // Choose random starting position
        int startX = random.nextInt(gridSize);
        int startY = random.nextInt(gridSize);
        
        // Check if word fits
        if (startX + word.length * dx >= gridSize ||
            startX + word.length * dx < 0 ||
            startY + word.length * dy >= gridSize ||
            startY + word.length * dy < 0) {
          continue;
        }
        
        // Check if cells are empty or contain the correct letter
        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          final x = startX + i * dx;
          final y = startY + i * dy;
          if (grid[y][x].isNotEmpty && grid[y][x] != word[i]) {
            canPlace = false;
            break;
          }
        }
        
        // Place the word
        if (canPlace) {
          for (int i = 0; i < word.length; i++) {
            final x = startX + i * dx;
            final y = startY + i * dy;
            grid[y][x] = word[i];
          }
          placed = true;
        }
      }
    }
  }
  
  void _fillEmptyCells() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x].isEmpty) {
          grid[y][x] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }
  
  void _onCellTapped(int x, int y) {
    if (isGameOver) return;
    
    setState(() {
      final cell = Offset(x.toDouble(), y.toDouble());
      
      // If cell is already selected, deselect it
      if (selectedCells.contains(cell)) {
        selectedCells.remove(cell);
        return;
      }
      
      // If this is the first selection or adjacent to the last selection
      if (selectedCells.isEmpty || _isAdjacent(selectedCells.last, cell)) {
        selectedCells.add(cell);
        
        // Check if we've selected a word
        _checkWord();
      } else if (selectedCells.length > 1) {
        // Start a new selection
        selectedCells = [cell];
      } else {
        // Replace single selection
        selectedCells[0] = cell;
      }
    });
  }
  
  bool _isAdjacent(Offset a, Offset b) {
    final dx = (a.dx - b.dx).abs();
    final dy = (a.dy - b.dy).abs();
    return dx <= 1 && dy <= 1;
  }
  
  void _checkWord() {
    if (selectedCells.length < 2) return;
    
    // Determine direction
    final first = selectedCells.first;
    final last = selectedCells.last;
    
    // Check if all points are in a straight line
    bool isStraight = true;
    
    if (first.dx == last.dx) {
      // Vertical
      final y1 = first.dy.toInt();
      final y2 = last.dy.toInt();
      final x = first.dx.toInt();
      
      for (int y = y1; y <= y2; y++) {
        if (!selectedCells.contains(Offset(x.toDouble(), y.toDouble()))) {
          isStraight = false;
          break;
        }
      }
    } else if (first.dy == last.dy) {
      // Horizontal
      final x1 = first.dx.toInt();
      final x2 = last.dx.toInt();
      final y = first.dy.toInt();
      
      for (int x = x1; x <= x2; x++) {
        if (!selectedCells.contains(Offset(x.toDouble(), y.toDouble()))) {
          isStraight = false;
          break;
        }
      }
    } else if ((first.dx - last.dx).abs() == (first.dy - last.dy).abs()) {
      // Diagonal
      final dx = (first.dx < last.dx) ? 1 : -1;
      final dy = (first.dy < last.dy) ? 1 : -1;
      
      int steps = (first.dx - last.dx).abs().toInt();
      for (int i = 0; i <= steps; i++) {
        final x = first.dx + i * dx;
        final y = first.dy + i * dy;
        if (!selectedCells.contains(Offset(x, y))) {
          isStraight = false;
          break;
        }
      }
    } else {
      isStraight = false;
    }
    
    if (!isStraight) return;
    
    // Sort cells to ensure consistent order
    selectedCells.sort((a, b) {
      if (a.dy != b.dy) return a.dy.compareTo(b.dy);
      return a.dx.compareTo(b.dx);
    });
    
    // Extract word from selected cells
    String word = '';
    for (final cell in selectedCells) {
      final x = cell.dx.toInt();
      final y = cell.dy.toInt();
      word += grid[y][x];
    }
    
    // Check if word is in the list
    if (widget.words.contains(word) && !foundWords.contains(word)) {
      setState(() {
        foundWords.add(word);
        score += word.length * 10;
        
        // Mark cells as found
        for (final cell in selectedCells) {
          final x = cell.dx.toInt();
          final y = cell.dy.toInt();
          foundCells[y][x] = true;
        }
        
        // Clear selection
        selectedCells.clear();
        
        // Check if all words are found
        if (foundWords.length == widget.words.length) {
          isGameOver = true;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Found: $word')),
      );
    } else {
      // Not a valid word, clear selection after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            selectedCells.clear();
          });
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Score and found words
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: widget.words.map((word) {
                  final isFound = foundWords.contains(word);
                  return Chip(
                    label: Text(
                      word,
                      style: TextStyle(
                        color: isFound ? Colors.white : Colors.black87,
                        decoration: isFound ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    backgroundColor: isFound ? Colors.green : Colors.grey[300],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        
        // Game grid
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final x = index % gridSize;
                final y = index ~/ gridSize;
                final isSelected = selectedCells.contains(Offset(x.toDouble(), y.toDouble()));
                final isFound = foundCells[y][x];
                
                return GestureDetector(
                  onTap: () => _onCellTapped(x, y),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.blue[200] 
                          : isFound 
                              ? Colors.green[200]
                              : Colors.white,
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        grid[y][x],
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Game over message
        if (isGameOver)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                const Text(
                  '🎉 Congratulations! 🎉',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'You found all ${widget.words.length} words!',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _initializeGame();
                      selectedCells.clear();
                      foundWords.clear();
                      score = 0;
                      isGameOver = false;
                    });
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}