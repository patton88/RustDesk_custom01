use std::env;

fn main() {
    println!("测试命令行参数传递功能");
    println!("程序名称: {}", env::args().next().unwrap_or_default());
    
    let args: Vec<String> = env::args().collect();
    println!("所有参数: {:?}", args);
    
    if args.len() > 1 {
        println!("第一个参数: {}", args[1]);
    }
    
    // 测试特定参数
    for (i, arg) in args.iter().enumerate() {
        match arg.as_str() {
            "--help" | "-h" => println!("显示帮助信息"),
            "--version" | "-v" => println!("显示版本信息"),
            "--debug" => println!("调试模式"),
            _ => {
                if i > 0 { // 跳过程序名称
                    println!("未知参数 {}: {}", i, arg);
                }
            }
        }
    }
}
