use std::{collections::HashSet, fs::read_to_string};

fn main() {
    let example = "498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9"
        .to_string();
    //
    let mut cave = parse_cave(&example, (550, 12));
    cave[0][500] = 'O';

    let mut settled = 1;
    for _ in 0..100 {
        let (x, y) = rock_fall((500, 0), &mut cave);
        cave[y][x] = 'X';
        // draw_cave(&cave, 300);
        if y > 0 {
            settled += 1;
        } else {
            break;
        }
    }
    draw_cave(&cave, 300);
    assert_eq!(settled, 93);

    let input = read_to_string("./input.txt").expect("Unable to read file");
    let mut cave = parse_cave(&input, (1000, 162 + 3));
    cave[0][500] = 'O';
    let mut settled = 0;
    for _ in 0..38000 {
        let (x, y) = rock_fall((500, 0), &mut cave);
        cave[y][x] = 'X';
        if y > 0 {
            settled += 1;
        } else {
            break;
        }
    }
    draw_cave(&cave, 300);
    println!("One: {}", settled);
}

fn parse_cave(input: &String, (width, height): (usize, usize)) -> Vec<Vec<char>> {
    let mut cave = vec![vec![' '; width]; height - 1];
    cave.push(vec!['■'; width]);
    //draw cave
    for line in input.lines() {
        let wall: Vec<(usize, usize)> = line
            .split("->")
            .map(|x| x.trim().split_once(",").unwrap())
            .map(|(x, y)| {
                (
                    x.trim().parse::<usize>().unwrap(),
                    y.trim().parse::<usize>().unwrap(),
                )
            })
            .collect();
        let mut max = 0;
        for (x, y) in points(&wall) {
            cave[y][x] = '■';
            if y > max {
                max = y;
                println!("{}", max);
            }
        }
    }

    return cave;
}

fn rock_fall((x0, y0): (usize, usize), cave: &Vec<Vec<char>>) -> (usize, usize) {
    let mut x = x0;
    let mut y = y0;

    if y + 1 >= cave.len() {
        return (x, y);
    }

    if move_down((x, y), cave) {
        y += 1;
        return rock_fall((x, y), cave);
    } else if move_down_left((x, y), cave) {
        x -= 1;
        return rock_fall((x, y), cave);
    } else if move_down_right((x, y), cave) {
        x += 1;
        y += 1;
        return rock_fall((x, y), cave);
    } else {
        return (x, y);
    }
}

fn draw_cave(cave: &Vec<Vec<char>>, offset: usize) {
    for row in cave {
        for x in row.iter().skip(offset) {
            if x == &' ' {
                print!(" ")
            } else {
                print!("{}", x);
            }
        }
        println!("");
    }
    println!("{}", String::from("-").repeat(cave[0].len() - offset));
}

fn points(instructions: &Vec<(usize, usize)>) -> HashSet<(usize, usize)> {
    let mut steps = HashSet::new();
    for step in 1..instructions.len() {
        let (x1, y1) = instructions[step - 1];
        let (x2, y2) = instructions[step];
        steps.insert((x1, y1));
        steps.insert((x2, y2));
        for x in x1.min(x2)..=x1.max(x2) {
            steps.insert((x, y1));
            steps.insert((x, y2));
        }

        for y in y1.min(y2)..=y1.max(y2) {
            steps.insert((x1, y));
            steps.insert((x2, y));
        }
        // Create steps for filling each x or y
    }
    println!("max y: {}", steps.iter().map(|(_, y)| y).max().unwrap());
    return steps;
}

fn move_down((x, y): (usize, usize), grid: &Vec<Vec<char>>) -> bool {
    if grid[y + 1][x] != ' ' {
        return false;
    }
    return true;
}

fn move_down_left((x, y): (usize, usize), grid: &Vec<Vec<char>>) -> bool {
    if grid[y + 1][x - 1] != ' ' {
        return false;
    }
    return true;
}
fn move_down_right((x, y): (usize, usize), grid: &Vec<Vec<char>>) -> bool {
    if grid[y + 1][x + 1] != ' ' {
        return false;
    }
    return true;
}
