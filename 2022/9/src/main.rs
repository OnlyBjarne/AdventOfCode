use std::{
    collections::HashSet,
    fs::read_to_string,
    thread::sleep,
    time::{Duration, Instant},
};

fn main() {
    let input_test: String = "R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2"
    .to_string();

    assert_eq!(one(&input_test, 2), 13);

    let input = read_to_string("./input.txt").expect("File not read");
    let start = Instant::now();
    println!("One {}, in {:?}", one(&input, 2), start.elapsed());
    assert_eq!(one(&input, 2), 6503);

    let input_test: String = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"
        .to_string();

    assert_eq!(one(&input_test, 10), 36);

    let start = Instant::now();
    assert!(one(&input, 10) > 2444);
    println!("Two {}, in {:?}", one(&input, 10), start.elapsed());
}

fn one(input: &String, rope_length: usize) -> usize {
    let steps = input
        .lines()
        .map(|line| line.trim().split_once(" ").unwrap());

    let start_x = 80i32;
    let start_y = 80i32;
    let mut tail_positions: HashSet<(i32, i32)> = HashSet::new();

    let mut rope = vec![(start_x, start_y); rope_length];
    tail_positions.insert((start_x, start_y));

    for (direction, count) in steps {
        for _ in 0..count.parse::<u8>().unwrap() {
            let dir = match direction {
                "U" => (0, 1),
                "D" => (0, -1),
                "L" => (-1, 0),
                "R" => (1, 0),
                _ => continue,
            };
            rope[0] = (dir.0 + rope[0].0, dir.1 + rope[0].1);

            for knot in 1..rope_length {
                let head = rope[knot - 1];
                let tail = &mut rope[knot];
                let (x_diff, y_diff) = (head.0 - tail.0, head.1 - tail.1);
                if (x_diff - y_diff).abs() > 1 {}
                if x_diff.abs() > 1 || y_diff.abs() > 1 {
                    if tail.0 != head.0 && tail.1 != head.1 {
                        *tail = (
                            tail.0 + x_diff / x_diff.abs(),
                            tail.1 + y_diff / y_diff.abs(),
                        );
                    } else if x_diff.abs() > 1 {
                        *tail = (tail.0 + x_diff / x_diff.abs(), tail.1);
                    } else {
                        *tail = (tail.0, tail.1 + y_diff / y_diff.abs());
                    }
                }
            }
            sleep(Duration::from_millis(100));
            let mut grid = create_grid((start_x * 2) as usize, (start_y * 2) as usize);
            for (i, (x, y)) in rope.iter().enumerate() {
                grid[x.clone() as usize][y.clone() as usize] = i.to_string();
            }
            for y in grid {
                for x in y {
                    print!("{}", x);
                }
                println!("");
            }
            println!(
                "-------------------------------------------------------------------------------------"
            );
            tail_positions.insert(rope[rope_length - 1]);
        }
    }

    return tail_positions.len();
}

fn create_grid(x: usize, y: usize) -> Vec<Vec<String>> {
    vec![vec![" ".to_string(); x]; y]
}

/*
 *
--- Day 9: Rope Bridge ---

This rope bridge creaks as you walk along it. You aren't sure how old it is, or whether it can even support your weight.

It seems to support the Elves just fine, though. The bridge spans a gorge which was carved out by the massive river far below you.

You step carefully; as you do, the ropes stretch and twist. You decide to distract yourself by modeling rope physics; maybe you can even figure out where not to step.

Consider a rope with a knot at each end; these knots mark the head and the tail of the rope. If the head moves far enough away from the tail, the tail is pulled toward the head.

Due to nebulous reasoning involving Planck lengths, you should be able to model the positions of the knots on a two-dimensional grid. Then, by following a hypothetical series of motions (your puzzle input) for the head, you can determine how the tail will move.

Due to the aforementioned Planck lengths, the rope must be quite short; in fact, the head (H) and tail (T) must always be touching (diagonally adjacent and even overlapping both count as touching):

....
.TH.
....

....
.H..
..T.
....

...
.H. (H covers T)
...

If the head is ever two steps directly up, down, left, or right from the tail, the tail must also move one step in that direction so it remains close enough:

.....    .....    .....
.TH.. -> .T.H. -> ..TH.
.....    .....    .....

...    ...    ...
.T.    .T.    ...
.H. -> ... -> .T.
...    .H.    .H.
...    ...    ...

Otherwise, if the head and tail aren't touching and aren't in the same row or column, the tail always moves one step diagonally to keep up:

.....    .....    .....
.....    ..H..    ..H..
..H.. -> ..... -> ..T..
.T...    .T...    .....
.....    .....    .....

.....    .....    .....
.....    .....    .....
..H.. -> ...H. -> ..TH.
.T...    .T...    .....
.....    .....    .....

You just need to work out where the tail goes as the head follows a series of motions. Assume the head and the tail both start at the same position, overlapping.

For example:

R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2

This series of motions moves the head right four steps, then up four steps, then left three steps, then down one step, and so on. After each step, you'll need to update the position of the tail if the step means the head is no longer adjacent to the tail. Visually, these motions occur as follows (s marks the starting position as a reference point):

== Initial State ==

......
......
......
......
H.....  (H covers T, s)

== R 4 ==

......
......
......
......
TH....  (T covers s)

......
......
......
......
sTH...

......
......
......
......
s.TH..

......
......
......
......
s..TH.

== U 4 ==

......
......
......
....H.
s..T..

......
......
....H.
....T.
s.....

......
....H.
....T.
......
s.....

....H.
....T.
......
......
s.....

== L 3 ==

...H..
....T.
......
......
s.....

..HT..
......
......
......
s.....

.HT...
......
......
......
s.....

== D 1 ==

..T...
.H....
......
......
s.....

== R 4 ==

..T...
..H...
......
......
s.....

..T...
...H..
......
......
s.....

......
...TH.
......
......
s.....

......
....TH
......
......
s.....

== D 1 ==

......
....T.
.....H
......
s.....

== L 5 ==

......
....T.
....H.
......
s.....

......
....T.
...H..
......
s.....

......
......
..HT..
......
s.....

......
......
.HT...
......
s.....

......
......
HT....
......
s.....

== R 2 ==

......
......
.H....  (H covers T)
......
s.....

......
......
.TH...
......
s.....

After simulating the rope, you can count up all of the positions the tail visited at least once. In this diagram, s again marks the starting position (which the tail also visited) and # marks other positions the tail visited:

..##..
...##.
.####.
....#.
s###..

So, there are 13 positions the tail visited at least once.

Simulate your complete hypothetical series of motions. How many positions does the tail of the rope visit at least once?
 * */
