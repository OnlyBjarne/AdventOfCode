use std::{
    collections::HashSet,
    fs::read_to_string,
    ops::{Range, RangeBounds},
};

fn main() {
    let example = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"
        .to_string();

    let mut sensors: Vec<Sensor> = parse_input(&example);
    sensors.sort_by(|sensor1, sensor2| sensor2.beacon.0.partial_cmp(&sensor1.beacon.0).unwrap());
    let max_x = sensors.first().unwrap().beacon.0.clone();
    let min_x = sensors.last().unwrap().beacon.0.clone();
    let row = 10;
    let binding = check_impossible_row((min_x, max_x), row, &sensors);
    let impossible: HashSet<&(i32, i32)> = binding
        .iter()
        .filter(|(x, _)| x >= &min_x && x <= &max_x)
        .collect();
    dbg!(&impossible);
    assert_eq!(impossible.len(), 26);

    let input = read_to_string("./input.txt").expect("File not available ");
    let mut sensors: Vec<Sensor> = parse_input(&input);
    sensors.sort_by(|sensor1, sensor2| sensor2.beacon.0.partial_cmp(&sensor1.beacon.0).unwrap());
    let max_x = sensors.first().unwrap().beacon.0.clone();
    let min_x = sensors.last().unwrap().beacon.0.clone();
    let row = 2000000;
    let binding = check_impossible_row((min_x, max_x), row, &sensors);
    let impossible: HashSet<&(i32, i32)> = binding
        .iter()
        .filter(|(x, _)| x >= &min_x && x <= &max_x)
        .collect();
    assert_ne!(impossible.len(), 4299549);
    assert_ne!(impossible.len(), 4391004);
    assert!(impossible.len() < 4999339);
    assert!(impossible.len() > 3999339);

    dbg!(impossible.len());
}

#[derive(Debug)]
struct Sensor {
    position: (i32, i32),
    beacon: (i32, i32),
}

impl Sensor {
    fn distance_to_point(&self, (x, y): (i32, i32)) -> u32 {
        let (x0, y0) = self.position;
        return x.abs_diff(x0) + y.abs_diff(y0);
    }

    fn distance_to_beacon(&self) -> u32 {
        let (dx, dy) = self.beacon;
        return self.distance_to_point((dx, dy));
    }

    fn intersects_line(&self, (x, y): (i32, i32)) -> bool {
        self.distance_to_point((x, y)) <= self.distance_to_beacon()
    }

    fn covers_line(&self, check_y: i32) -> Range<i32> {
        let offset = self.position.1.abs_diff(check_y);
        let reminder = self.distance_to_beacon().abs_diff(offset);

        if reminder <= 0 {
            return 0..0;
        }

        return (self.position.0 - reminder as i32)..(self.position.0 + reminder as i32);
    }
}

fn check_impossible_row(
    (x0, x1): (i32, i32),
    y: i32,
    sensors: &Vec<Sensor>,
) -> HashSet<(i32, i32)> {
    let mut impossible_locations: HashSet<(i32, i32)> = HashSet::new();
    for sensor in sensors {
        for x in sensor.covers_line(y) {
            // print!("({}, {})", x, y);
            impossible_locations.insert((x, y));
        }
    }

    return impossible_locations;
}

fn parse_input(input: &String) -> Vec<Sensor> {
    input
        .lines()
        .map(|line| line.split_once(":").unwrap())
        .map(|(sensor, beacon)| Sensor {
            position: sensor
                .replace("Sensor at ", "")
                .replace("x=", "")
                .replace("y=", "")
                .split_once(",")
                .map(|(x, y)| {
                    (
                        x.trim().parse::<i32>().unwrap(),
                        y.trim().trim().parse::<i32>().unwrap(),
                    )
                })
                .unwrap(),
            beacon: beacon
                .replace("closest beacon is at ", "")
                .replace("x=", "")
                .replace("y=", "")
                .split_once(",")
                .map(|(x, y)| {
                    (
                        x.trim().parse::<i32>().unwrap(),
                        y.trim().parse::<i32>().unwrap(),
                    )
                })
                .unwrap(),
        })
        .collect()
}
