use std::{ops::Add, process::exit, time::Instant};

fn example_monkeys() -> Vec<Monkey> {
    let mut monkeys: Vec<Monkey> = Vec::new();
    monkeys.push(Monkey {
        id: 0,
        count: 0,
        items: vec![79, 98],
        test: 23,
        operation: |old| old * 19,
        throw_to: (2, 3),
    });

    monkeys.push(Monkey {
        id: 1,
        count: 0,
        items: vec![54, 65, 75, 74],
        test: 19,
        operation: |old| old + 6,
        throw_to: (2, 0),
    });
    monkeys.push(Monkey {
        id: 2,
        count: 0,
        items: vec![79, 60, 97],
        test: 13,
        operation: |old| old * old,
        throw_to: (1, 3),
    });
    monkeys.push(Monkey {
        id: 3,
        count: 0,
        items: vec![74],
        test: 17,
        operation: |old| old + 3,
        throw_to: (0, 1),
    });
    return monkeys;
}
fn main() {
    // let mut monkeys = example_monkeys();
    // assert_eq!(one(&mut monkeys, 1), 24);
    // let mut monkeys = example_monkeys();
    // assert_eq!(one(&mut monkeys, 20), 10197, "20 rounds");
    // println!("20 rounds OK");
    // let mut monkeys = example_monkeys();
    // assert_eq!(one(&mut monkeys, 1000), 27019168, "1000 rounds");
    // let mut monkeys = example_monkeys();
    // assert_eq!(one(&mut monkeys, 4000), 433783826, "4000 rounds");
    // let mut monkeys = example_monkeys();
    // assert_eq!(one(&mut monkeys, 10000), 2713310158, "10000 rounds");
    // println!("starting real task");
    let mut monkeys: Vec<Monkey> = Vec::new();
    monkeys.push(Monkey {
        id: 0,
        count: 0,
        items: vec![62, 92, 50, 63, 62, 93, 73, 50],
        test: 2,
        operation: |old| old * 7,
        throw_to: (7, 1),
    });

    monkeys.push(Monkey {
        id: 1,
        count: 0,
        items: vec![51, 97, 74, 84, 99],
        test: 7,
        operation: |old| old + 3,
        throw_to: (2, 4),
    });

    monkeys.push(Monkey {
        id: 2,
        count: 0,
        items: vec![98, 86, 62, 76, 51, 81, 95],
        test: 13,
        operation: |old| old + 4,
        throw_to: (5, 4),
    });

    monkeys.push(Monkey {
        // 3
        id: 3,
        count: 0,
        items: vec![53, 95, 50, 85, 83, 72],
        operation: |old| old + 5,
        test: 19,
        throw_to: (6, 0),
    });
    monkeys.push(Monkey {
        // 4
        id: 4,
        count: 0,
        items: vec![59, 60, 63, 71],
        operation: |old| old * 5,
        test: 11,
        throw_to: (5, 3),
    });

    monkeys.push(Monkey {
        // 5
        id: 5,
        count: 0,
        items: vec![92, 65],
        operation: |old| old * old,
        test: 5,
        throw_to: (6, 3),
    });

    monkeys.push(Monkey {
        // 6
        id: 6,
        count: 0,
        items: vec![78],
        operation: |old| old + 8,
        test: 3,
        throw_to: (0, 7),
    });

    monkeys.push(Monkey {
        // 7
        id: 7,
        count: 0,
        items: vec![84, 93, 54],
        operation: |old| old + 1,
        test: 17,
        throw_to: (2, 1),
    });
    let start = Instant::now();
    let res = one(&mut monkeys, 10000);
    println!("finished one in {:?} with result {}", start.elapsed(), res);
}

fn one(monkeys: &mut Vec<Monkey>, rounds: usize) -> u128 {
    for _ in 0..rounds {
        for i in 0..monkeys.len() {
            monkeys[i].inspect();
            let throws = monkeys[i].throw_items();
            for (receiver, item) in throws {
                monkeys[receiver].receive(item);
            }
        }
    }

    monkeys.sort_by(|a, b| b.count.partial_cmp(&a.count).unwrap());

    for monkey in monkeys.iter() {
        println!("Monkey {}, inspected {} items", monkey.id, monkey.count);
    }
    println!();
    return monkeys
        .iter()
        .take(2)
        .map(|x| x.count)
        .fold(1u128, |acc: u128, x: u128| x * acc);
}

struct Monkey {
    id: i8,
    count: u128,
    items: Vec<u128>,
    test: u128,
    throw_to: (usize, usize),
    operation: fn(u128) -> u128,
}

impl Monkey {
    fn inspect(&mut self) -> u128 {
        for i in 0..self.items.len() {
            self.count += 1;
            let item = self.items[i];
            let new = ((self.operation)(item)) as u128;
            self.items[i] = new % 9699690;
        }
        return self.count;
    }

    fn receive(&mut self, item: u128) {
        self.items.push(item);
    }

    fn throw_items(&mut self) -> Vec<(usize, u128)> {
        let mut throws: Vec<(usize, u128)> = vec![];

        for item in self.items.iter() {
            let rem = item % self.test;
            let receiver = if rem == 0 {
                self.throw_to.0
            } else {
                self.throw_to.1
            };
            throws.push((receiver, item.clone()));
        }
        self.items.clear();
        return throws;
    }
}
