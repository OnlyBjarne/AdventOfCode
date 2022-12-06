use std::fs::read_to_string;

fn main() {
    let input = read_to_string("./input.txt").expect("Unable to read file");
    // let input = "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8\n2-3,3-3".to_string();
    let output_one = one(input.clone());
    let output_two = two(input.clone());
    assert_eq!(output_one, 584);
    assert_eq!(output_two, 933);

    println!("One: {}", output_one);
    println!("Two: {}", output_two);
}

fn is_contained(parts: Vec<&str>) -> bool {
    let first: Vec<u64> = parts[0]
        .split("-")
        .map(|f| f.parse::<u64>().unwrap())
        .collect();
    let second: Vec<u64> = parts[1]
        .split("-")
        .map(|f| f.parse::<u64>().unwrap())
        .collect();

    let fmax = first.iter().max().unwrap();
    let fmin = first.iter().min().unwrap();
    let smax = second.iter().max().unwrap();
    let smin = second.iter().min().unwrap();

    if fmin <= smin && fmax >= smax {
        return true;
    } else if smin <= fmin && smax >= fmax {
        return true;
    }
    return false;
}

fn is_contained_2(parts: Vec<&str>) -> bool {
    let first: Vec<u64> = parts[0]
        .split("-")
        .map(|f| f.parse::<u64>().unwrap())
        .collect();
    let second: Vec<u64> = parts[1]
        .split("-")
        .map(|f| f.parse::<u64>().unwrap())
        .collect();

    let fmax = first.iter().max().unwrap();
    let fmin = first.iter().min().unwrap();
    let smax = second.iter().max().unwrap();
    let smin = second.iter().min().unwrap();

    if fmin <= smin && smin <= fmax || fmin <= smax && smax <= fmax {
        return true;
    }

    if smin <= fmax && fmin <= smax || smin <= fmax && fmax <= smax {
        return true;
    }
    return false;
}

fn one(input: String) -> usize {
    input
        .lines()
        .map(|line| line.split(",").collect())
        .map(is_contained)
        .filter(|x| x.clone() == true)
        .count()
}

fn two(input: String) -> usize {
    input
        .lines()
        .map(|line| line.split(",").collect())
        .map(is_contained_2)
        .filter(|x| x.clone() == true)
        .count()
}

/*
--- Day 4: Camp Cleanup ---

Space needs to be cleared before the last supplies can be unloaded from the ships, and so several Elves have been assigned the job of cleaning up sections of the camp. Every section has a unique ID number, and each Elf is assigned a range of section IDs.

However, as some of the Elves compare their section assignments with each other, they've noticed that many of the assignments overlap. To try to quickly find overlaps and reduce duplicated effort, the Elves pair up and make a big list of the section assignments for each pair (your puzzle input).

For example, consider the following list of section assignment pairs:

2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8

For the first few pairs, this list means:

    Within the first pair of Elves, the first Elf was assigned sections 2-4 (sections 2, 3, and 4), while the second Elf was assigned sections 6-8 (sections 6, 7, 8).
    The Elves in the second pair were each assigned two sections.
    The Elves in the third pair were each assigned three sections: one got sections 5, 6, and 7, while the other also got 7, plus 8 and 9.

This example list uses single-digit section IDs to make it easier to draw; your actual list might contain larger numbers. Visually, these pairs of section assignments look like this:

.234.....  2-4
.....678.  6-8

.23......  2-3
...45....  4-5

....567..  5-7
......789  7-9

.2345678.  2-8
..34567..  3-7

.....6...  6-6
...456...  4-6

.23456...  2-6
...45678.  4-8

Some of the pairs have noticed that one of their assignments fully contains the other. For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6.
In pairs where one assignment fully contains the other, one Elf in the pair would be exclusively cleaning sections their partner will already be cleaning,
so these seem like the most in need of reconsideration. In this example, there are 2 such pairs.

In how many assignment pairs does one range fully contain the other?
 * */
