
use std::env;
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};



/*
    Serialize the Global project settings (which contain the Local settings)
      into a file stored in the project.
    If the serialized binary config file is newer than the local and global,
      do not read the config files again.
    
*/

// a string that has methods for parsing variables
// like " -lang {{language}}"
mod config_actions;
mod config_structs;
mod config_implementations;
mod config_commands;
mod config_versioning;
mod proj_defaults;

use config_actions::* as cfg_acts;
use config_structs::* as cfg_data;
use config_implementations::* as cfg_impl;
use config_commands::* as cfg_cmds;
use config_versioning::* as cfg_vcs;
use proj_defaults::* as cfg_proj;


// Check to make sure all executables specified in the config exist
// if they do not copy the stub executable as <command>.exe (on windows)
// read local config then global config then parse all VarStrs using the Global struct


pub struct AutoRuns {
    before: Vec<Executable>,
    after: Vec<Executable>,
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



