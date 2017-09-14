
#[macro_use] extern crate lazy_static;
extern crate regex;

use std::env;
use std::path::{Path, PathBuf};
use std::process::{Command, Output, ExitStatus};
use std::ffi::OsString;
use regex::Regex;

use config_structs::*;
use config_actions::*;


// does impl need a pub modifier?
impl Executable {
    pub fn blank() -> Executable {
        source: PathBuf::from(""),
        args: None,
    }
    pub fn new(source: PathBuf, args: VarStr) -> Executable {
        source,
        args: if args.args.is_some() && args.args.unwrap_or("") !="" {
            Some(args)
        } else {
            None
        },
    }
    pub fn from(src: String, args: String) -> Executable {
        source: PathBuf::from(src),
        args: if args != "" {
            Some(args)
        } else {
            None
        }
    }
    pub fn from_str<'a>(src: &'a str) -> Executable {
        let v: Vec<&str>;
        // find next double quote that is followed by a space
        // this is because the exe must have a space before args
        // and this way it removes both the space and the quote
        if src.starts_with("\"") {
            // let v: Vec<&str> = src.splitn(2, "\" ").collect();
            // remove first character (a double quote) and split with up to 2 items
            v = src[1..].splitn(2, "\" ").collect();
        } else {
            // split based on first space
            // let v: Vec<&str> = src.splitn(2, " ").collect();
            v = src.splitn(2, " ").collect();
        }
        match v.len() {
            0 => {
                Executable {
                    source: PathBuf::new(),
                    args: None,
                }
            }, 
            1 => {
                Executable {
                    source: PathBuf::from(String::from(v[0])),
                    args: None,
                } 
            },
            2 => {
                Executable {
                    source: PathBuf::from(String::from(v[0])),
                    args: StrVar::from(v[1]),
                }
            },
            _ => {
                unreachable!();
            }
        }
    }
}

impl VarStr {
    pub fn blank() -> VarStr {
        VarStr::Unparsed( UnparsedVar { string: String::from("") } )
    }
    pub fn new(string: String) -> VarStr {
        VarStr::Unparsed( UnparsedVar { string: string } )
    }
    pub fn from(string: String) -> VarStr {
        VarStr::Unparsed( UnparsedVar { string: string } )
    }
}

impl Runnable for Executable {
    pub fn exists(&self) -> bool {
        self.source.exists()
    }
    pub fn run(&self) -> Result<String, String> {
        if self.exists() {
            let mut cmd = Command::new();
            lazy_static! {
                static ref SPLIT_ARGS: Regex = Regex::new(r#"([^ ]*)[^"] "#).unwrap();
            }
            let mut args: Vec<&str>;
            if self.arg.is_some() {
                let arg = match self.args.unwrap() {
                    VarStr::Parsed(var) => var.string,
                    // maybe add a global static for containing the Global config
                    VarStr::Unparsed(var) => var.string, // call the parse_vars()
                };
                let mut qstack: Vec<char> = Vec::new();
                let mut args: Vec<(usize, 0&str)> = Vec::new();
                let mut start: usize = 0;
                for i in 0..arg.len() {
                    let c = arg[i];
                    if c == '"' || c == '\'' {
                        if qstack.len() != 0 {
                            if qstack[qstack.len()-1] == c {
                                qstack.pop();
                            }
                            else {
                                qstack.push(c);
                            }
                        } else {
                            qstack.push(c);
                        }
                    } else if qstack.len() == 0 && c == ' ' && qstack.len() == 0 {
                        args.push(c[start..i]);
                        start = i+1;
                        
                    }
                    
                    
                    
                    if arg[i] == ' ' {
                        if i != 0 {
                            if arg[i-1] != '' {
                                
                            }
                        }
                        
                    }
                }
                
                for a in args {
                    cmd = cmd.arg();
                }
            }
            // let result = cmd.output().unwrap_or(Ouput { status: ExitStatus {}, stdout: vecu8, stderr: vecu8};
            if let Ok(result) = cmd.output() {
                Ok(result)
            } else {
                Err("Executable could not be executed.")
            }
        } else {
            Err("Executable specified does not exist.")
        }
    }
}
















