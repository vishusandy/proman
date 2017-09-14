
use super::*;

pub trait LanguageType {
    fn get_language() -> Vec<Command> {
        fn insert(cmd: Command, list: &mut Vec<Command>) {
            let t = Command {  };
        }
        let mut cmds: Vec<Command> = Vec::new();
        { let c = Command; cmds.push() }
        
    }
}

pub enum Language {
    Rust,
    Php,
}

pub trait Language {
    fn backup(&self) -> Command;
    fn bench(&self) -> Command;
    fn build(&self) -> Command;
    fn check(&self) -> Command;
    fn docs(&self) -> Command;
    fn info(&self) -> Command;
    fn interpret(&self) -> Command;
    fn list(&self) -> Command;
    fn run(&self) -> Command;
    fn save(&self) -> Command;
    fn serve(&self) -> Command;
    fn test(&self) -> Command;
    fn template(&self) -> Command;
    fn upload(&self) -> Command;
    fn get_commands(&self) -> Vec<Command>
}


struct Rust;

