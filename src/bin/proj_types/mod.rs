use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::collections::HashMap;

// See below link for more info on library types
// https://doc.rust-lang.org/reference/linkage.html

// Sub-modules
mod proj_rust;


pub enum Language {
    AutoHotKey,
    AutoIt,
    C,
    CPlusPlus,
    CSharp,
    Go,
    Haskell,
    Java,
    JavaScript,
    Php,
    Python,
    Ruby,
    Rust,
    Web,        // Html, Html5, Xml, Xhtml, Sass, Less
    Custom(String),
    Error,
}


pub trait Runable {
    pub fn run(&self) -> Result<String, String>;
    pub fn exists(&self) -> bool;
    
}

pub trait HasVars {
    pub fn list_vars(&self) -> Vec<String>;
    pub fn replace_vars(&self, &Proman) -> VarString;
}

pub struct VarString {
    string: String,
    parsed: bool,
}
// Do parsing of vars in the VarStrings after all config info is collected
// into the Proman struct, thus giving all vars values
impl VarString {
    pub fn new() -> VarString { 
        VarString { 
            string: "".to_string(), 
            parsed: false, 
        }
    }
    pub fn from<'a>(s: &'a str) -> VarString {
        VarString {
            string: s.to_string(),
            parsed: false,
        }
    }
    pub fn display(&self) -> String {
        format!("{1}{0}", self.string, if self.parsed { "@" } else { "Raw!" })
    }
}
impl HasVars for VarString {
    pub fn list_vars(&self) -> Vec<String> {
        // do a regex search
    }
    pub fn replace_vars(&self, proman: &Proman) -> VarString {
        let mut newstr = self.string; // or self.string.clone() if needed
        for v in self.list_vars() {
            newstr.replace(v, proman.lookup_var(&v))
        }
        VarString {
            string: newstr,
            parsed: true,
        }
    }
}

pub struct Executable {
    source: PathBuf,
    // args is a string containing vars like:
    // -d {{proj_dir}} -a {{something_else}}
    args: Option<VarString>, 
}

impl Runable for Executable {
    pub fn run(&self) -> Result<String, String> {
        if self.exists() {
            
        } else {
            Err(format!("Executable {:?} {} does not exist", self.source, self.args.display()))
        }
    }
    pub fn exists(&self) -> bool {
        source.exists() && source.is_file()
    }
}

pub struct Document {
    source: PathBuf,
    open_with: Option<Executable>,
    args: Option<VarString>,
}

impl Runable for Document {
    
}

// Version Control System
pub enum Vcs {
    Git,
    Hg,
    Custom(String),
    Error,
}




pub enum TemplateSetup {
    CopyAll,
    Custom(Executable),
    Error,
}
pub struct Template {
    folder: PathBuf,
    setup: TemplateSetup,
    lang: Language,
    projtype: String,
}

pub struct Doc {
    lang: Language,
    doc: Document,
}

pub struct Docs {
    docs: 
}

pub struct AutoRuns {
    // before: HashMap<String, Vec<Executable>>,
    // after: HashMap<String, Vec<Executable>>,
    before: HashMap<Command, Vec<Executable>>,
    after: HashMap<Command, Vec<Executable>>,
}


pub enum SyncOn {
    Source(PathBuf),
    Custom(Executable), // custom executable determines whether to sync
    Error,
}
pub enum SyncAction {
    Update,
    Custom(Executable), // a custom executable will do the syncing
    Error,
}
pub struct Synchronize {
    source: PathBuf,
    on: SyncOn,
    action: SyncAction,
}
pub struct SyncFiles {
    files: Vec<Synchronize>,
}


pub struct junction {
    source: PathBuf,
    dest: PathBuf,
}
pub struct Junctions {
    junctions: Cec<Junction>,
}

pub enum CommandDest {
    Execute(Executable),
    Str(String),
    Error,
}
pub enum CommandSource {
    Default(CommandDest), // default
    Lang(CommandDest), // language config overrides default
    Proj(CommandDest), // project config overrides default
    Custom(CommandDest), // custom option
    None,
    Error,
}

#[derive(Hash, Eq, PartialEq, Debug)]
pub enum Command {
    Backup,
    Build,
    Check,
    Commit,
    Docs,
    Info,
    Interpret,
    List,
    New,
    Run,
    Save,
    Serve,
    Upload,
    Error,
}

#[derive(Debug)]
pub enum CommandData {
    Backup(CommandSource),
    Build(CommandSource),
    Check(CommandSource),
    Commit(CommandSource),
    Docs(CommandSource),
    Info(CommandSource),
    Interpret(CommandSource),
    List(CommandSource),
    New(CommandSource),
    Run(CommandSource),
    Save(CommandSource),
    Serve(CommandSource),
    Upload(CommandSource),
    Error,
}

// Keep this one or
pub struct Commands {
    // commands: Vec<CommandList>,
    commands: HashMap<Command, CommCommandData>,
}
// this one?
pub struct Commands {
    pub backup: Command,
    pub build: Command,
    pub check: Command,
    pub commit: Command,
    pub docs: Command,
    pub info: Command,
    pub interpret: Command,
    pub list: Command,
    pub new: Command,
    pub run: Command,
    pub save: Command,
    pub serve: Command,
    pub upload: Command,
}


pub struct AllTemplates {
    templates: Vec<Template>,
}
pub struct AllDocs {
    docs: Vec<Doc>,
}


pub struct ProjCfg {
    dir: PathBuf,
    vcs: Vcs,
    lang: Language,
    projtype: String,
    custom_docs: AllDocs,
    custom_templates: AllTemplates,
    commands: Commands,
    junctions: Junctions,
    sync_files: SyncFiles,
    
}


pub struct Proman {
    install_dir: PathBuf,
    user_dir: PathBuf,
    templates: AllTemplates,
    docs: AllDocs,
    proj: ProjCfg,
    
}

pub trait Config {
    // Looks for all structs implementing HasVars, like Executable, 
    // and runs parse_vars()
    pub fn parse_all_vars(&self) -> Proman; 
    pub fn lookup_var<'a>(&self, &'a str) -> String;
}



// hmm keep this?
pub trait LangTypeDefaults {
    pub fn default_commands(&self) -> Commands;
    pub fn default_proj_cfg(&self) -> ProjCfg;
    
}

























