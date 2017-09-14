
use std::collections::HashMap;
use config::*;
use super::*;

pub trait Versioning {
    // command for a commit
    // return an error if using a custom vcs that is not configured properly
    fn commit(&self) -> Result<String, String>;
    fn init(&self) -> Result<String, String>;
    fn all_commands(&self) -> HashMap<String, String>; // list commands and their command strings
    fn list_commands(&self) -> Vec<String>; // just list the commands
    fn command(&self, String) -> String;
    // etc
}

// Version Control System
struct GitVcs;
struct HgVcs;
struct CustomVcs(String);
pub enum VersionControl {
    Git(GitVcs),
    Hg(HgVcs),
    Custom(CustomVcs),
    Error,
}

struct VcsCommands {
    add: String,
    author: String, // blame in git
    branch: String,
    checkout: String,
    commit: String,
    diff: String,
    download: String,
    history: String,
    init: String,
    merge: String,
    rebase: String,
    reset: String, // git reset --hard HEAD
    reset_to: String, // git reset --hard <commit>
    revert: String, // git revert <commit>
    status: String,
    undo_file: String, // git checkout HEAD <file>
    upload: String,
}

impl Versioning for GitVcs {
    
}
impl Versioning for GitVcs {
    
}

impl Versioning for VersionControl {
    
}


