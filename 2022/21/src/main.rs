use std::{
    any::{Any, TypeId},
    collections::HashMap,
    fs::read_to_string,
    ops::Mul,
};

fn main() {
    let example = "root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32"
        .to_string();
    assert_eq!(one(&example), 152);

    let input = read_to_string("./input.txt").expect("Failed to read");
    println!("One {}", one(&input));

    // assert_eq!(two(&example), 301);
    println!("Two {}", two(&input));
}

fn one(input: &String) -> i128 {
    let operations = parse_input(input);
    let start = operations.get("root");
    let result = get_value(start.unwrap(), &operations);
    return result;
}

fn two(input: &String) -> i128 {
    let mut operations = parse_input(input);
    let mut current_low = u128::MAX;
    operations.insert("humn", Monkey::Int(3373767893119));
    return loop {
        let root = operations.get("root").unwrap();
        match root {
            Monkey::Math(root) => {
                let mut steps = root.split_whitespace().take(3);
                let path_1 = steps.next().unwrap();
                let _operation = steps.next().unwrap();
                let path_2 = steps.next().unwrap();
                let v1 = get_value(operations.get(path_1).unwrap(), &operations);
                let v2 = get_value(operations.get(path_2).unwrap(), &operations);
                if v1 == v2 {
                    let humn = operations.get("humn").unwrap();
                    dbg!(v1, v2, humn);
                    if let Monkey::Int(humn) = humn {
                        break humn.clone() - 1;
                    }
                }
                let humn = operations.get_mut("humn").unwrap();
                if v1.abs_diff(v2) <= current_low {
                    current_low = v1.abs_diff(v2);
                    if let Monkey::Int(humn) = humn {
                        dbg!(current_low, &humn);
                    };
                }
                if let Monkey::Int(humn) = humn {
                    if v1 < v2 {
                        *humn -= 11;
                    } else {
                        *humn += 201;
                    }
                }
            }
            Monkey::Int(root) => break root.clone(),
        }
    };
}

#[derive(Debug)]
enum Monkey {
    Int(i128),
    Math(String),
}

fn get_value(value: &Monkey, monkeys: &HashMap<&str, Monkey>) -> i128 {
    match value {
        Monkey::Int(value) => return value.clone(),
        Monkey::Math(value) => {
            let mut operation = value.split_whitespace();
            let monkey1 = operation.next().unwrap();
            let operand = operation.next().unwrap();
            let monkey2 = operation.next().unwrap();
            let m1_value = monkeys.get(monkey1).unwrap();
            let m2_value = monkeys.get(monkey2).unwrap();
            match operand {
                "+" => {
                    return get_value(m1_value, monkeys)
                        + get_value(&monkeys.get(monkey2).unwrap(), monkeys)
                }
                "-" => {
                    return get_value(&monkeys.get(monkey1).unwrap(), monkeys)
                        - get_value(&monkeys.get(monkey2).unwrap(), monkeys)
                }
                "*" => {
                    return get_value(&monkeys.get(monkey1).unwrap(), monkeys)
                        * get_value(&monkeys.get(monkey2).unwrap(), monkeys)
                }
                "/" => {
                    return get_value(&monkeys.get(monkey1).unwrap(), monkeys)
                        / get_value(&monkeys.get(monkey2).unwrap(), monkeys)
                }
                _ => panic!("Someting went wrong, {} does not exist", operand),
            }
        }
    };
}

fn parse_input(input: &String) -> HashMap<&str, Monkey> {
    let mut mapping = HashMap::new();
    for line in input.lines() {
        let (monkey, operation) = line.split_once(":").unwrap();
        let res = operation.trim().parse::<i128>();
        match res {
            Err(_) => mapping.insert(monkey, Monkey::Math(operation.trim().to_string())),
            Ok(res) => mapping.insert(monkey, Monkey::Int(res)),
        };
    }
    return mapping;
}
