use std::fs::read_to_string;

fn main() {
    let example = "        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5"
        .to_string();

    assert_eq!(one(&example, 16), 6032);

    let input = read_to_string("./input.txt").expect("Unable to can");

    let one_ans = one(&input, 150);
    assert!(one_ans < 114068);
    assert!(one_ans > 76288);
    println!("One: {}", one(&input, 150));
}

fn one(input: &String, width: usize) -> usize {
    let (mut cave, moves) = parse_input(input, width);
    let mut start = Position {
        current: (0, 0),
        dir: 'R',
    };
    moves.iter().for_each(|m| match m {
        Move::Step(m) => start.step(m.clone(), &mut cave),
        Move::Dir(m) => start.rotate(m.clone(), &mut cave),
    });
    dbg!(moves);

    let (col, row) = start.current;

    let dir = start.dir;
    let directions = vec!['R', 'D', 'L', 'U'];
    return 1000 * (row + 1) + 4 * (col + 1) + directions.iter().position(|c| c == &dir).unwrap();
}

#[derive(Debug)]
struct Position {
    current: (usize, usize),
    dir: char,
}

impl Position {
    fn rotate(&mut self, direction: char, map: &mut Vec<Vec<char>>) {
        let directions = vec!['R', 'D', 'L', 'U'];
        let current_dir_index = directions.iter().position(|c| c == &self.dir).unwrap();

        match direction {
            'R' => self.dir = directions[(current_dir_index + 1) % directions.len()],
            'L' => {
                self.dir = directions[(current_dir_index + directions.len() - 1) % directions.len()]
            }
            _ => panic!("Invalid direction {}", direction),
        }

        map[self.current.1][self.current.0] = match self.dir {
            'U' => '^',
            'R' => '>',
            'D' => 'V',
            'L' => '<',
            _ => 'O',
        };
    }
    fn step(&mut self, steps: u32, map: &mut Vec<Vec<char>>) {
        let direction = match self.dir {
            'U' => (0, -1),
            'R' => (1, 0),
            'D' => (0, 1),
            'L' => (-1, 0),
            _ => panic!("Invalid direction {}", self.dir),
        };
        let height = map.len();
        let width = map[0].len();

        for _ in 0..steps {
            let (mut x0, mut y0) = self.current.clone();
            self.current = loop {
                y0 = (y0 as i32 + direction.1).rem_euclid(height as i32) as usize;
                x0 = (x0 as i32 + direction.0).rem_euclid(width as i32) as usize;

                let next = map[y0][x0];
                let is_wall = next == '#';
                if is_wall {
                    break self.current;
                }

                if next == '.' {
                    map[y0][x0] = match self.dir {
                        'U' => '^',
                        'R' => '>',
                        'D' => 'V',
                        'L' => '<',
                        _ => 'O',
                    };
                    break (x0, y0);
                }
            };
        }
    }
}

fn print_cave(cave: &Vec<Vec<char>>) {
    for y in cave {
        for x in y {
            print!("{}", x);
        }
        println!(" ");
    }
    println!("-----------------------------------------------------------------------------------------------");
}

#[derive(Debug)]
enum Move {
    Step(u32),
    Dir(char),
}

fn parse_input(input: &String, width: usize) -> (Vec<Vec<char>>, Vec<Move>) {
    let (cave, moves) = input.split_once("\n\n").unwrap();
    let cave_matrix: Vec<Vec<char>> = cave
        .lines()
        .map(|row| {
            let mut r = row.chars().collect::<Vec<char>>();
            r.resize(width, ' ');
            return r;
        })
        .collect();

    let move_vector: Vec<Move> = moves
        .trim()
        .replace("R", ",R,")
        .replace("L", ",L,")
        .split(",")
        .map(|m| {
            let parsed = m.parse::<u32>();
            match parsed {
                Err(parsed) => Move::Dir(m.chars().next().unwrap()),
                Ok(parsed) => Move::Step(parsed),
            }
        })
        .collect();

    return (cave_matrix, move_vector);
}
