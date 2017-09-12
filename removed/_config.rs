


use std::path::Path;
use std::env;
use std::fmt;
use std::collections::HashMap;

/*  Variables to be defined in the proman config file,
        located in the user dir
    %C++Compiler%   path and executable to use for compiling c++ programs
    
    Runtime variables
    %sources%
    %cd%
    %projdir%
    %cfgdif%
    
    
*/

enum Cmds {
    NewProject,
    NewFile,
    NewTemplate,
    Save,
    Delete,
    
}


// struct CustomCommands(Vec<Command>);

struct CustomCommands(HashMap<&String, CustomCommand>);

struct CustomCommand {
    Name: String,
    FireOn: Vec<String>,
    Launch: String,
}

impl CustomCommands {
    fn find_idx(&self, s: &str) -> Option<usize> {
        
    }
    fn contains(&self, s: &str) -> bool {
        
    }
    
}

struct CustomCmds(Vec<Cmd>);
struct CustomCmd(String, String);

impl PartialEq for CustomCmd {
    fn eq(&self, other: &CustomCmd) -> bool {
        self.0 == other.0
    }
}

impl CustomCmds {
    fn find_idx(&self, s: &str) -> Option<usize> {
        for i in &self.0 {
            if i.0 == s {
                return Ok(i);
            }
        }
        None
    }
    fn contains(&self, s: &str) -> bool {
        for i in &self.0 {
            if i.0 == s {
                return true;
            }
        }
        false
    }
    
}


struct ProjDef {
    Name: String,
    Type: ProjType,
    Compile: String,
    Execute: String, // a string with instructions on how to execute the project
    Template: String, // a folder (or zipped file?) containing the files for the project template
    
}

struct Project {
    Name: String,
    Root: Path,
    Type: String,
    Language: String,
    // Customs: HashMap<String, String>,
    // Customs: (String, String),
    Customs: CustomCmds,
    
    
}

struct ProjCfg {
    
}

enum ProjType {
    Binary,
    Script,
    DynamicLibrary,
    StaticLibrary,
    StaticWebsite,
    DynamicWebsite,
    LaravelWebsite,
    Error,
}

impl ProjType {
    pub fn new(s: &str) -> ProjType {
        match s.trim().to_lowercase().as_str() {
            "bin" | "binary" | "exe" | "executable" => ProjType::Binary,
            "script" | "interpreted" => ProjType::Script,
            "lib" | "library" | "dynlib" | "dll" | "dlib" | "dyanmiclib" | "dyanmiclibrary" => ProjType::DynamicLibrary,
            "staticlibrary" | "staticlib" | "slib" => ProjType::StaticLibrary,
            "website" | "web" | "dynamicwebsite" | "dynamicweb" | "dynweb" | "dweb" | "" => ProjType::DynamicWebsite,
            "staticweb" | "staticwebsite" | "sweb" => ProjType::StaticWebsite,
            "laravel" | "laravelwebsite" | "lweb" | "laravelproject" => ProjType::LaravelWebsite,
            
             _ => ProjType::Error,
        }
    }
}

impl FromStr for ProjType {
    type Err = ();
    fn from_str(s: &str) -> Result<ProjType, Self::Err> {
        match ProjType::new(s) {
            ProjType::Error => Err(()),
            a => Ok(a),
        }
    }
}

impl fmt::Display for ProjType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            ProjType::Binary => write!(f, "Binary"),
            ProjType::DynamicLibrary => write!(f, "DynamicLibrary"),
            ProjType::StaticLibrary => write!(f, "StaticLibrary"),
            ProjType::StaticWebsite => write!(f, "StaticWebsite"),
            ProjType::DynamicWebsite => write!(f, "DynamicWebsite"),
            ProjType::LaravelWebsite => write!(f, "LaravelWebsite"),
            _ => ProjType:: => write!(f, "ProjTypeError"),
            
        }
    }
}


fn set_cfg() {
    
}

/*
fn get_cfg() -> ProjCfg {
    
}
*/

fn get_proj(from: &str) -> Result<Project> {
    // look at up to 4 parent directories for the file
    
    let exed_in = env::current_dir().unwrap();
    
    let mut Name = "";
    let mut Root = exed_in;
    let mut Type = "";
    let mut Language = "";
    Ok(
        Project {
            Name.to_string(),
            Root,
            Type.to_string(),
            Language.to_string(),
        }
        
    )
}

fn set_proj
