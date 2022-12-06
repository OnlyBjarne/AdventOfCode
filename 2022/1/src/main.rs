use std::fs::read_to_string;
use std::time::Instant;

fn main() {
    /*
     * Read file
     * split on empty new line into blocks
     * sum block
     * find max
     * */
    let content = read_to_string("src/input.txt").expect("File should exist");
    let before = Instant::now();
    let mut data: Vec<u32> = Vec::new();
    let mut sum = 0;
    for line in content.lines() {
        if line.is_empty() {
            data.push(sum);
            sum = 0;
            continue;
        }
        sum = sum + line.parse::<u32>().unwrap();
    }

    data.sort_by(|x, y| y.partial_cmp(x).unwrap());

    let top_3: u32 = data.iter().take(3).sum();
    let max = data[0];

    println!("Max {}", max);
    println!("Top 3 {}", top_3);
    // Max 68442
    // Top 3 11239184
    // Runtime: 254.99µs
    println!("Runtime: {:.2?}", before.elapsed());
}
