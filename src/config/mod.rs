
use std::collections::HashMap;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};



/*
global
    
local
    
*/

// a string that has methods for parsing variables
// like " -lang {{language}}"
mod config_actions;
mod config_structs;
mod config_implementations;

use config_actions::* as cfg_acts;
use config_structs::* as cfg_data;
use config_implementations::* as cfg_impl;


pub struct Command {
    name: String,
    exe: Executable,
    args: VarStr,
}

pbu struct AllCommands{
    pub global: HashMap<String, Vec<Command>>,
    // allow extra commands to be added on languages/project-types
    pub local: HashMap<String, Vec<Command>>, 
    
}

// Version Control System
pub enum VersionControl {
    Git,
    Hg,
    Custom(String),
    Error,
}

pub struct Local {
    lang: Language,
}

pub struct Global {
    install_dir: PathBuf,
    global_bin_dir: PathBuf,
    user_dir: PathBuf,
    local: Local,
    
}



