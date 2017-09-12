
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
pub struct ExeDoc {
    doc: Document,
    exe: Executable,
    run_str: VarStr,
}