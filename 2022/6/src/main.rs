/*
--- Day 6: Tuning Trouble ---

The preparations are finally complete; you and the Elves leave camp on foot and begin to make your way toward the star fruit grove.

As you move through the dense undergrowth, one of the Elves gives you a handheld device. He says that it has many fancy features, but the most important one to set up right now is the communication system.

However, because he's heard you have significant experience dealing with signal-based systems, he convinced the other Elves that it would be okay to give you their one malfunctioning device - surely you'll have no problem fixing it.

As if inspired by comedic timing, the device emits a few colorful sparks.

To be able to communicate with the Elves, the device needs to lock on to their signal. The signal is a series of seemingly-random characters that the device receives one at a time.

To fix the communication system, you need to add a subroutine to the device that detects a start-of-packet marker in the datastream.
In the protocol being used by the Elves, the start of a packet is indicated by a sequence of four characters that are all different.

The device will send your subroutine a datastream buffer (your puzzle input); your subroutine needs to identify the first position where the four most recently received characters were all different.
Specifically, it needs to report the number of characters from the beginning of the buffer to the end of the first such four-character marker.

For example, suppose you receive the following datastream buffer:
      X
123456789
mjqjpqmgbljsphdztnvjfqwrcgsmlb,    // 7
After the first three characters (mjq) have been received, there haven't been enough characters received yet to find the marker.
The first time a marker could occur is after the fourth character is received, making the most recent four characters mjqj.
Because j is repeated, this isn't a marker.

The first time a marker appears is after the seventh character arrives.
Once it does, the last four characters received are jpqm, which are all different.
In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.

Here are a few more examples:

    bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
    nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11

How many characters need to be processed before the first start-of-packet marker is detected?
 * */

use std::time::Instant;
use std::{collections::HashSet, fs::read_to_string};

fn main() {
    let values = vec![
        "mjqjpqmgbljsphdztnvjfqwrcgsmlb",    // 7
        "bvwbjplbgvbhsrlpgdmjqwftvncz",      // 5
        "nppdvjthqldpwncqszvftbrmjlhg",      // 6
        "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", // 10
        "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw",  // 11
    ];

    assert_eq!(one(&values[0].to_string(), 4), 7, "First");
    assert_eq!(one(&values[1].to_string(), 4), 5, "Second");
    assert_eq!(one(&values[2].to_string(), 4), 6, "Third");
    assert_eq!(one(&values[3].to_string(), 4), 10, "Fourth");
    assert_eq!(one(&values[4].to_string(), 4), 11, "Fifth");

    let values = read_to_string("./input.txt").expect("Could not read file");

    let start = Instant::now();
    println!("One {}", one(&values, 4));
    println!("One took: {:?}", start.elapsed());

    let start = Instant::now();
    println!("Two {}", one(&values, 14));
    println!("Two took: {:?}", start.elapsed());
}

fn has_duplicates(values: Vec<char>) -> bool {
    let mut existing = HashSet::new();
    for value in values {
        if !existing.insert(value) {
            return true;
        }
    }
    return false;
}

fn one(input: &String, length: usize) -> usize {
    let mut last_four: Vec<char> = Vec::new();
    for (i, c) in input.chars().enumerate() {
        if last_four.len() < length {
            last_four.push(c);
        }
        last_four[i % length] = c;

        if last_four.len() == length && !has_duplicates(last_four.clone()) {
            return i + 1;
        }
    }

    return 0;
}
