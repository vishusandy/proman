
// See below link for more info on library types
// https://doc.rust-lang.org/reference/linkage.html

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

pub enum ProjPhp {
    Web,
    Console,
}

pub enum {
    
}

pub struct Proj {
    
}
