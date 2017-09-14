
use std::env;
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use std::ffi::OsString;

use super::*;

pub enum Scope {
    Global,
    Local,
    None,
    Error,
    // User, ??? No. The path is specified in the Executable, 
    // this struct is just used to determining what binaries to add when
}
pub struct Command {
    name: String,
    exe: Executable,
    args: VarStr,
    type: CommandScope,
    autoruns: AutoRuns,
}
pub struct NamedCommands {
    name: String,
    commands: Vec<Command>,
}
impl Command {
    pub fn blank() -> Command {
        Command {
            name: String::from(""),
            exe: Executable::blank(""),
            args: VarStr::blank(),
            type: CommandScope::None,
            autoruns: AutoRuns::(),
        }
    }
}

// this should contain all the vcs commands and custom commands
// when adding a command check the Scope to see where it belongs
pbu struct AllCommands {
    // pub global: HashMap<String, Vec<Command>>,
    // pub local: HashMap<String, Vec<Command>>,
    pub global: HashSet<NamedCommands>,
    pub local: HashSet<NamedCommands>,
}