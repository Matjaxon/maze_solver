class Maze

  attr_reader :maze_grid, :start_point, :end_point

  def initialize(maze)
    @maze_grid = maze_array(maze)
    @start_point = find_point("S")
    @end_point = find_point("E")
  end

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
    @failed_paths = []
    @solved_paths = []
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
    find_move(pos, path)
    p @failed_paths.length
    p @solved_paths.length
    shortest_path = @solved_paths.min_by { |path | path.length }
    display_path(shortest_path)
    shortest_path
  end

  def find_move(pos, path)
    x, y = pos
    if solved?(pos)
      @solved_paths << path
      return nil
    else
      move_down(pos, path)
      move_right(pos, path)
      move_up(pos, path)
      move_left(pos, path)
    end
    return nil
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

  def display_path(path)
    maze_chars = ['*', 'E', 'S']
    @maze.maze_grid.each_with_index do | row, y|
      row.each_with_index do | col, x |
        if maze_chars.include?(col)
          print col
        elsif path.include?([x, y])
          print "X"
        else
          print " "
        end
      end
      print "\n"
    end
  end

  def move_down(pos, path)
    path_copy = path.dup
    x, y = pos
    y += 1
    if can_advance?([x, y], path_copy)
      # puts "Moving down"
      path_copy << [x, y]
      find_move([x, y], path_copy)
    else
      # puts "Route failed"
      @failed_paths << path_copy
    end
    return nil
  end

  def move_right(pos, path)
    path_copy = path.dup
    x, y = pos
    x += 1
    if can_advance?([x, y], path_copy)
      # puts "Moving right"
      path_copy << [x, y]
      find_move([x, y], path_copy)
    else
      # puts "Route failed"
      @failed_paths << path_copy
    end
    return nil
  end

  def move_up(pos, path)
    path_copy = path.dup
    x, y = pos
    y -= 1
    if can_advance?([x, y], path_copy)
      # puts "Moving up"
      path_copy << [x, y]
      find_move([x, y], path_copy)
    else
      # puts "Route failed"
      @failed_paths << path_copy
    end
    return nil
  end

  def move_left(pos, path)
    path_copy = path.dup
    x, y = pos
    x -= 1
    if can_advance?([x, y], path_copy)
      # puts "Moving left"
      path_copy << pos
      find_move([x, y], path_copy)
    else
      # puts "Route failed"
      @failed_paths << path_copy
    end
    return nil
  end

end


MAZE = ["****************",
  '*         *   E*',
  '*    *    *  ***',
  '*    *    *    *',
  '*    *    *    *',
  '*    *    *    *',
  '*S   *         *',
  '****************']

SMALL_MAZE = ["****************",
  '*        **    *',
  '*  ***   **  ***',
  '*  ***   *******',
  '*  ***   **  ***',
  '*  ***   **E ***',
  '*S ***       ***',
  '****************']

VERTICAL_MAZE = ['***',
"*S *",
"*  *",
"*  *",
"* E*",
"****"]

VERTICAL_MAZE_2 = ['*******',
"*S * E*",
"*  *  *",
"*  *  *",
"*     *",
"*******"]

TEST_MAZE = ["*******", "*S   E*", "*******"]

a = Maze.new(SMALL_MAZE)
b = Pather.new(a)
p b.start_point
b.solve_maze
