use std::fs::read_to_string;
use std::time::Instant;

fn main() {
    let input = read_to_string("./input.txt").expect("Unable to read file");
    let start = Instant::now();
    let res_one = one(input.clone());
    assert_eq!(res_one, "DHBJQJCCW");
    println!("One: {}, in {:?}", res_one, start.elapsed());

    let start = Instant::now();
    let res_two = two(input.clone());
    assert_eq!(res_two, "WJVRLSJJT");
    println!("Two: {}, in {:?}", res_two, start.elapsed());
}

fn one(input: String) -> String {
    let (crates, moves) = input.split_at(input.find("move").unwrap());

    let mut stacks = vec![
        vec!["F", "C", "P", "G", "Q", "R"],
        vec!["W", "T", "C", "P"],
        vec!["B", "H", "P", "M", "C"],
        vec!["L", "T", "Q", "S", "M", "P", "R"],
        vec!["P", "H", "J", "Z", "V", "G", "N"],
        vec!["D", "P", "J"],
        vec!["L", "G", "P", "Z", "F", "J", "T", "R"],
        vec!["N", "L", "H", "C", "F", "P", "T", "J"],
        vec!["G", "V", "Z", "Q", "H", "T", "C", "W"],
    ];

    for instruction in moves.lines() {
        let values: Vec<usize> = instruction
            .split_whitespace()
            .filter(|x| x.chars().all(|i| i.is_numeric()))
            .map(|x| x.parse::<usize>().unwrap())
            .collect();
        let count = values[0];
        let from = values[1];
        let to = values[2];

        stacks = move_crate(count, from, to, stacks.clone());
    }
    return get_solution(stacks.clone());
}

fn two(input: String) -> String {
    let (_, moves) = input.split_at(input.find("move").unwrap());
    let mut stacks = vec![
        vec!["F", "C", "P", "G", "Q", "R"],
        vec!["W", "T", "C", "P"],
        vec!["B", "H", "P", "M", "C"],
        vec!["L", "T", "Q", "S", "M", "P", "R"],
        vec!["P", "H", "J", "Z", "V", "G", "N"],
        vec!["D", "P", "J"],
        vec!["L", "G", "P", "Z", "F", "J", "T", "R"],
        vec!["N", "L", "H", "C", "F", "P", "T", "J"],
        vec!["G", "V", "Z", "Q", "H", "T", "C", "W"],
    ];

    for instruction in moves.lines() {
        let values: Vec<usize> = instruction
            .split_whitespace()
            .filter(|x| x.chars().all(|i| i.is_numeric()))
            .map(|x| x.parse::<usize>().unwrap())
            .collect();
        let count = values[0];
        let from = values[1];
        let to = values[2];

        stacks = move_crate_2(count, from, to, stacks.clone());
    }
    return get_solution(stacks.clone());
}

// Pop and push crates between stacks
fn move_crate(
    count: usize,
    from: usize,
    to: usize,
    mut o_stacks: Vec<Vec<&str>>,
) -> Vec<Vec<&str>> {
    for _ in 0..count {
        let moved = o_stacks[from - 1].pop().unwrap();
        o_stacks[to - 1].push(moved);
    }
    return o_stacks;
}

// Handle task two
fn move_crate_2(
    count: usize,
    from: usize,
    to: usize,
    mut o_stacks: Vec<Vec<&str>>,
) -> Vec<Vec<&str>> {
    let mut moved = vec![];
    for _ in 0..count {
        moved.push(o_stacks[from - 1].pop().unwrap())
    }
    moved.reverse();
    for c in moved {
        o_stacks[to - 1].push(c);
    }

    return o_stacks;
}

// Print top crate of all stacks
fn get_solution(crates: Vec<Vec<&str>>) -> String {
    let mut solution = String::new();
    for c in crates {
        solution.push_str(c.last().unwrap_or(&"None"));
    }
    return solution;
}
