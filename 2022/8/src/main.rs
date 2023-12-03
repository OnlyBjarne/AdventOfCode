use std::time::Instant;
use std::{collections::HashSet, fs::read_to_string};

fn main() {
    let input = "30373\n25512\n65332\n33549\n35390\n".to_string();
    assert_eq!(one(&input), 21, "Length");
    let input = read_to_string("./input.txt").expect("Failed to read");
    let start = Instant::now();
    println!("one res {} in {:?}", one(&input), start.elapsed());
    let start = Instant::now();
    let input = "30373\n25512\n65332\n33549\n35390".to_string();
    assert_eq!(two(&input), 8, "Length");

    let input = read_to_string("./input.txt").expect("Failed to read");
    println!("two res {} in {:?}", two(&input), start.elapsed());
}

fn create_matrix(input: &str) -> Vec<Vec<u32>> {
    let matrix = input
        .lines()
        .map(|line| line.chars().map(|c| c.to_digit(10).unwrap()).collect())
        .collect();

    println!("Matrix");
    for row in &matrix {
        for column in row {
            print!("{} ", column);
        }
        println!("");
    }
    return matrix;
}

fn find_visible(trees: &Vec<Vec<u32>>) -> HashSet<(u32, usize, usize)> {
    // Loop over trees in this row
    let mut visible: HashSet<(u32, usize, usize)> = HashSet::new();
    let size = trees.len();

    for i in 0..size {
        let row: Vec<u32> = trees[i].iter().map(|x| 1 + x.clone()).collect();
        let column: Vec<u32> = trees.iter().map(|x| 1 + x[i]).collect();

        let mut current_highest = 0;

        for (x, height) in row.iter().enumerate() {
            if height > &current_highest {
                visible.insert((*height, x, i));
                current_highest = *height;
            }
        }
        let mut current_highest = 0;
        for (x, height) in row.iter().rev().enumerate() {
            if height > &current_highest {
                visible.insert((*height, row.len() - x - 1, i));
                current_highest = *height;
            }
        }

        let mut current_highest = 0;
        for (y, height) in column.iter().enumerate() {
            if height > &current_highest {
                visible.insert((*height, i, y));
                current_highest = *height;
            }
        }
        let mut current_highest = 0;
        for (y, height) in column.iter().rev().enumerate() {
            if height > &current_highest {
                visible.insert((*height, i, column.len() - y - 1));
                current_highest = *height;
            }
        }
    }
    return visible;
}

fn one(input: &String) -> usize {
    let grid = create_matrix(input);
    return find_visible(&grid).len();
}

fn find_best_score(grid: &Vec<Vec<u32>>, x: usize, y: usize) -> u32 {
    if x == 0 || y == 0 || x == grid.len() - 1 || y == grid.len() - 1 {
        return 0;
    }
    let row: Vec<u32> = grid[y].iter().map(|x| x.clone()).collect(); //heights in row
    let column: Vec<u32> = grid.iter().map(|d| d[x]).collect(); // heights in column
    let start_height = row[x];

    let mut score: u32 = 1;
    let (left, right) = row.split_at(x);
    let (up, down) = column.split_at(y);

    for (pos, height) in up.iter().rev().enumerate() {
        if &start_height <= height || pos == (up.len() - 1) {
            score = &score * (pos as u32 + 1);
            break;
        }
    }

    for (pos, height) in left.iter().rev().enumerate() {
        if &start_height <= height || pos == (left.len() - 1) {
            score = &score * (pos as u32 + 1);
            break;
        }
    }

    for (pos, height) in down.iter().skip(1).enumerate() {
        if &start_height <= height || pos == (down.len() - 2) {
            score = &score * (pos as u32 + 1);
            break;
        }
    }

    for (pos, height) in right.iter().skip(1).enumerate() {
        if &start_height <= height || pos == (right.len() - 2) {
            score = &score * (pos as u32 + 1);
            break;
        }
    }

    return score as u32;
}

fn two(input: &String) -> u32 {
    let grid = create_matrix(input);
    let mut top_score: u32 = 0;
    for x in 1..grid.len() {
        for y in 1..grid.len() {
            let found_score = find_best_score(&grid, x, y);
            if found_score > top_score {
                top_score = found_score;
            }
        }
    }
    return top_score.clone();
}

/*
--- Day 8: Treetop Tree House ---

The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

3 0 3 7 3
2 5 5 1 2
6 5 3 3 2
3 3 5 4 9
3 5 3 9 0


["30373",
"25512" ,
"65332" ,
"33549" ,
"35390]

Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

    The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
    The top-middle 5 is visible from the top and right.
    The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
    The left-middle 5 is visible, but only from the right.
    The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
    The right-middle 3 is visible from the right.
    In the bottom row, the middle 5 is visible, but the 3 and 4 are not.

With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

Consider your map; how many trees are visible from outside the grid?
 * */
