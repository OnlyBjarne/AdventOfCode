use std::any::Any;

/*
   When comparing two values, the first value is called left and the second value is called right. Then:

   If BOTH values are INT, the LOWER integer should come first. If the LEFT integer is LOWER than the RIGHT integer,
   the inputs are in the right order. If the left integer is higher than the right integer, the inputs are not in the right order.
   Otherwise, the inputs are the same integer; CONTINUE checking the next part of the input.

   If BOTH values are LISTS, compare the first value of each list,
   then the second value, and so on. If the left list runs out of items first, the inputs are in the right order.
   If the right list runs out of items first, the inputs are not in the right order.
   If the lists are the same length and no comparison makes a decision about the order, CONTINUE checking the next part of the input.

   If exactly one value is an integer, convert the integer to a list which contains that integer as its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the right value to [2] (a list containing 2); the result is then found by instead comparing [0,0,0] and [2].



   https://adventofcode.com/2022/day/13

* */

fn main() {
    let example = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"
        .to_string();
    assert_eq!(one(&example), 13);
}

fn one(input: &String) -> u16 {
    let pairs: Vec<Vec<&str>> = input
        .split_terminator("\n\n")
        .map(|pair| pair.split_terminator("\n").collect())
        .collect();

    for mut pair in pairs {
        let first = pair.remove(0);
        let second = pair.remove(0);
        compare_pair(first, second);
    }
    return 0;
}

// NOTE
//
// Item can be Int OR List
// List can hold Int OR Other List
// List can be empty
//
// 1 < 2
// [1]  [2] -> 1 < 2
// [1,1] [1] -> 1 == 1, 1
//

fn compare_pair(a: &str, b: &str) -> bool {
    let zipped = a.chars().zip(b.chars());

    for (left, right) in zipped {
        compare_chars(left, right);
    }
    return false;
}

fn compare_chars(a: char, b: char) -> bool {
    if a == b {}

    // If both numberic
    if a.is_numeric() && b.is_numeric() {
        return dbg!(a < b);
    }
}
