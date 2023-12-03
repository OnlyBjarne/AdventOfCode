use std::fs::read_to_string;
use std::iter::Sum;
use std::slice::Iter;
use std::thread;
use std::time::{Duration, Instant};

fn main() {
    let input = read_to_string("./test.txt").expect("Failed to read");

    assert_eq!(one(&input).iter().sum::<i32>(), 13140);

    let input = read_to_string("./input.txt").expect("Failed to read");
    let start = Instant::now();
    println!(
        "One {}, in {:?}",
        one(&input).iter().sum::<i32>(),
        start.elapsed()
    );
    let input = read_to_string("./input.txt").expect("Failed to read");
    let start = Instant::now();
    two(&input);
    println!("two , in {:?}", start.elapsed());
}

fn one(input: &String) -> Vec<i32> {
    let mut cycle = 1;
    let mut register = 1;
    let mut signal_strenghts: Vec<i32> = Vec::new();
    for (op, value) in input
        .lines()
        .map(|line| line.split_at(4))
        .map(|(op, value)| (op, value.trim().parse::<i32>().unwrap_or(0)))
    {
        cycle += 1;
        if is_check_signal(cycle) {
            signal_strenghts.push(cycle * register);
        }
        match op {
            "addx" => {
                cycle += 1;
                register += value;
                if is_check_signal(cycle) {
                    signal_strenghts.push(cycle * register);
                }
            }
            _ => (),
        };
    }

    return signal_strenghts;
}
fn is_check_signal(cycle: i32) -> bool {
    vec![20, 60, 100, 140, 180, 220].contains(&cycle)
}

fn is_in_sprite(cycle: usize, register: i32) -> bool {
    (register - 1) == cycle as i32 || register == cycle as i32 || (register + 1) == cycle as i32
}
fn two(input: &String) {
    let mut crt = vec!["."; 40 * 6];
    let mut cycle = 1;
    let mut register = 1i32;
    for (op, value) in input
        .lines()
        .map(|line| line.split_at(4))
        .map(|(op, value)| (op, value.trim().parse::<i32>().unwrap_or(0)))
    {
        crt[cycle - 1] = if is_in_sprite(cycle % 40, register) {
            "#"
        } else {
            "."
        };

        match op {
            "addx" => {
                cycle += 1;
                register += value;
            }
            _ => (),
        };
        crt[cycle - 1] = if is_in_sprite(cycle % 40, register) {
            "#"
        } else {
            "."
        };
        cycle += 1;
    }
    for (i, line) in crt.iter().enumerate() {
        if i % 40 == 0 {
            println!();
        }
        print!("{}", line);
    }
    println!();
}
