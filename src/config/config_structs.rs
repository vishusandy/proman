
#[derive(Debug)]
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

pub enum VarStr {
    Parsed(ParsedVar),
    Unparsed(UnparsedVar),
    Error,
}
pub struct ParsedVar {
    string: String,
}
pub struct UnparsedVar {
    string: String,
}

pub struct Executable {
    source: PathBuf,
    args: Option<VarStr>,
}
// name is a little misleading, can also hold just a folder
pub struct Document {
    source: PathBuf,
}
// a document that is passed as a parameter to an executable
// an example of the run_str looks like "{{exe}} {{doc}}"
pub struct ExeDoc {
    doc: PathBuf,
    exe: Option<PathBuf>,
    run_str: Option<VarStr>,
}