use std::{
    collections::{HashSet, VecDeque},
    fs::read_to_string,
    thread::sleep,
    time::{Duration, Instant},
};

fn main() {
    let example = "Sabqponm\nabcryxxl\naccszExk\nacctuvwj\nabdefghi".to_string();
    assert_eq!(one(&example, (0, 0)), 31);
    let input = read_to_string("./input.txt").expect("Unable to can");
    let start = Instant::now();
    println!("One {}, in {:?}", one(&input, (0, 20)), start.elapsed());
    let start = Instant::now();
    let best_possible = two(&input);
    println!("Two {}, in {:?}", best_possible, start.elapsed());
}

fn create_nodes(input: &String) -> Vec<Vec<Node>> {
    return input
        .lines()
        .enumerate()
        .map(|(y, line)| {
            line.chars()
                .enumerate()
                .map(|(x, height)| Node {
                    height: if height == 'E' {
                        'z' as u8 + 1
                    } else {
                        height as u8
                    },
                    position: (x, y),
                    visited: false,
                    prev: None,
                })
                .collect()
        })
        .collect();
}

fn print_graph(nodes: Vec<Vec<Node>>) {
    print!("{esc}[2J{esc}[1;1H", esc = 27 as char);
    for row in nodes {
        for col in row {
            if !col.visited || col.height == 'X' as u8 {
                print!("{}", col.height as char);
            } else {
                print!(".");
            }
        }
        println!("");
    }
    sleep(Duration::from_millis(1));
    println!("")
}

fn one(input: &String, start_at: (usize, usize)) -> usize {
    let mut nodes: Vec<Vec<Node>> = create_nodes(&input);
    let result = bsd(start_at, &mut nodes);

    if result.is_some() {
        let (x, y) = result.unwrap();
        let mut node = &nodes[y][x];
        let mut path = Vec::new();
        while node.prev.unwrap() != start_at {
            path.push(node.prev.unwrap());
            node = &nodes[node.prev.unwrap().1][node.prev.unwrap().0];
        }

        for (x, y) in path.clone() {
            nodes[y][x].height = 'X' as u8;
            print_graph(nodes.clone());
        }
        println!("Success");

        return path.len() + 1;
    }
    return usize::MAX;
}

fn two(input: &String) -> usize {
    let possible_starts: Vec<Vec<Node>> = create_nodes(input);
    let mut results = Vec::new();
    for (y, row) in possible_starts.iter().enumerate() {
        for (x, c) in row.iter().enumerate() {
            if c.height != 'a' as u8 {
                // Skip if not a
                continue;
            }
            results.push(one(&input, (x, y)));
        }
    }
    results.sort();
    println!("Found {} ways up the hill", results.len());
    return results[0];
}

fn bsd((x, y): (usize, usize), nodes: &mut Vec<Vec<Node>>) -> Option<(usize, usize)> {
    let mut queue = VecDeque::new();
    queue.push_front(nodes[y][x].clone());

    while queue.len() > 0 {
        let current_node = queue.pop_front();
        if !current_node.is_some() {
            return None;
        }
        let current_node = current_node.unwrap();

        let possible_moves = get_possible_moves(current_node.position, &nodes);
        for possible in possible_moves {
            if !possible.visited {
                queue.push_back(possible.clone());
                let (x1, y1) = possible.position;
                nodes[y1][x1].visited = true;
                nodes[y1][x1].prev = Some(current_node.position);
            }
            if possible.height == ('z' as u8 + 1) {
                return Some(possible.position);
            }
        }
        print_graph(nodes.clone());
    }
    return None;
}

#[derive(Clone, Debug)]
struct Node {
    height: u8,
    position: (usize, usize),
    visited: bool,
    prev: Option<(usize, usize)>,
}

fn get_possible_moves((x, y): (usize, usize), grid: &Vec<Vec<Node>>) -> Vec<Node> {
    let height: u8 = if grid[y][x].height == 'S' as u8 {
        'a' as u8 - 1
    } else if grid[y][x].height == 'E' as u8 {
        'z' as u8 + 1
    } else {
        grid[y][x].height as u8
    };

    let mut directions: Vec<Node> = Vec::new();

    let valid_heights = (height as u8 - 2)..=(height as u8 + 1);

    // Up
    if y > 0 && valid_heights.contains(&(grid[y - 1][x].height as u8)) && !grid[y - 1][x].visited {
        directions.push(grid[y - 1][x].clone());
    };
    // Down
    if y < grid.len() - 1
        && valid_heights.contains(&(grid[y + 1][x].height as u8))
        && !grid[y + 1][x].visited
    {
        directions.push(grid[y + 1][x].clone());
    }

    if x > 0 && valid_heights.contains(&(grid[y][x - 1].height as u8)) && !grid[y][x - 1].visited {
        directions.push(grid[y][x - 1].clone());
    }
    if x < grid[y].len() - 1
        && valid_heights.contains(&(grid[y][x + 1].height as u8))
        && !grid[y][x + 1].visited
    {
        directions.push(grid[y][x + 1].clone());
    }

    return directions;
}
