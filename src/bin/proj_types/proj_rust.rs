
use super::{Command};

// pub enum Command {
//     None,
//     Default(String),
//     Lang(String),
//     Proj(String),
//     Custom(String),
// }

pub enum LibraryRust {
    Default,        // --crate-type=lib
    RustDynamic,    //    dylib
    Static,         //    staticlib
    SystemDynamic,  //    cdylib
    RustLibrary,    //    rlib
    ProcMacro,      //    proc-macro
    // dylib, rlib, staticlib, cdylib, and proc-macro
    Error,
}

pub enum ProjRust {
    Binary,
    GuiBinary,
    WebBinary,
    Library(LibraryRust),
    WebLibrary(LibraryRust),
    Error,
}

mod ProjLangRust {
    pub struct LangRust {
        
    }
    
    
    // struct Commands {
    //     pub backup: Command,
    //     pub build: Command,
    //     pub check: Command,
    //     pub commit: Command,
    //     pub docs: Command,
    //     pub info: Command,
    //     pub interpret: Command,
    //     pub list: Command,
    //     pub new: Command,
    //     pub run: Command,
    //     pub save: Command,
    //     pub serve: Command,
    // }
    
    
    
    
    
}



