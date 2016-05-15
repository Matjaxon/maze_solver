class Maze

  attr_reader :maze_grid, :start_point, :end_point

  def initialize
    @maze_grid = maze_array(TEST_MAZE)
    @start_point = find_point("S")
    @end_point = find_point("E")
  end

  MAZE = ["****************",
    '*         *   E*',
    '*    *    *  ***',
    '*    *    *    *',
    '*    *    *    *',
    '*    *    *    *',
    '*S   *         *',
    '****************']

  TEST_MAZE = ["*******", "*S   E*", "*******"]

  def maze_array(maze_text)
    maze_array = maze_text.map do | line |
      line.split('')
    end
    maze_array
  end

  def display
    @maze_grid.each do | row |
      puts row.join('')
    end
  end

  def [](pos)
    x, y = pos
    @maze_grid[y][x]
  end

  def find_point(text)
    @maze_grid.each_with_index do | row, y |
      row.each_with_index do | col, x |
        if col == text
          return [x, y]
        end
      end
    end
    puts "#{text} not found in maze."
  end

end

class Pather

  attr_reader :maze, :start_point, :end_point

  def initialize(maze)
    @maze = maze
    @start_point = maze.start_point
    @end_point= maze.end_point
  end

  def display
    p @maze
    p @maze.maze_grid
    p @maze.start_point
    p @maze.end_point
  end

  def solve_maze
    solved = false
    pos = @start_point
    path = [@start_point]
    until solved
      pos, path, advanced = find_move(pos, path)
      if advanced == false
        puts "Maze cannot be solved."
        exit
      else
        if solved?(pos)
          puts "Maze solved!"
          p path
          solved = true
        end
      end
    end
  end

  def find_move(pos, path)
    x, y = pos
    if move_up?(pos, path)
      y += 1
      new_pos = [x, y]
      puts "Moving up"
      path << new_pos
      advanced = true
    elsif move_down?(pos, path)
      y -= 1
      new_pos = [x, y]
      puts "Moving down"
      path << new_pos
      advanced = true
    elsif move_left?(pos, path)
      x -= 1
      new_pos = [x, y]
      puts "Moving left"
      path << new_pos
      advanced = true
    elsif move_right?(pos, path)
      x += 1
      new_pos = [x, y]
      puts "Moving right"
      path << new_pos
      advanced = true
    else
      puts "No where to move."
      advanced = false
    end
    return new_pos, path, advanced
  end

  def can_advance?(pos, path)
    x, y = pos
    next_pos_val = @maze[[x, y]]
    return false if next_pos_val == "*" || path.include?(pos)
    true
  end

  def solved?(pos)
    pos == @end_point
  end

  def move_up?(pos, path)
    x, y = pos
    y += 1
    can_advance?([x, y], path)
  end

  def move_right?(pos, path)
    x, y = pos
    x += 1
    can_advance?([x, y], path)
  end

  def move_down?(pos, path)
    x, y = pos
    y -= 1
    can_advance?([x, y], path)
  end

  def move_left?(pos, path)
    x, y = pos
    x -= 1
    can_advance?([x, y], path)
  end

end

a = Maze.new
a.display
b = Pather.new(a)
b.display
p b.start_point
p b.maze[b.start_point]
p b.maze[b.end_point]
p b.solved?(b.end_point)
p b.move_right?(b.start_point,[b.start_point])
p b.move_up?(b.start_point,[b.start_point])
b.solve_maze
