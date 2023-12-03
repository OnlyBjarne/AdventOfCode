use std::fs::read_to_string;

fn main() {
    let example = "1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122"
    .to_string();
    assert_eq!(one(&example), 4890);
    assert_eq!(decimal_to_snafu(one(&example)), String::from("2=-1=0"));

    let input = read_to_string("./input.txt").expect("Unable to can");
    dbg!(one(&input));
}

fn one(input: &String) -> i64 {
    input.lines().fold(0, |acc, cur| {
        let dec = snafu_to_decimal(cur);
        return acc + dec;
    })
}

fn snafu_to_decimal(input: &str) -> i64 {
    return input.chars().rev().enumerate().fold(0, |acc, (i, value)| {
        let adder = match value {
            '=' => -2,
            '-' => -1,
            '0' => 0,
            '1' => 1,
            '2' => 2,
            _ => panic!("Wrong symbol"),
        };
        return acc + (adder * (i64::pow(5, i as u32)) as i64);
    });
}

fn decimal_to_snafu(input: i64) -> String {
    return String::new();
}
