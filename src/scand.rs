
extern crate scan_dir;

use scan_dir::ScanDir;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;

pub struct ScanD {
    dir: PathBuf,
    mask: Mask,
    include_dirs: bool,
    recursive: bool,
    files: Vec<PathBuf>,
}

struct Mask {
    include: Vec<String>,
    exclude: Vec<String>,
}

trait ScanD {
    fn new() -> Self {
        Mask {
            dir: PathBuf::from(""),
            mask: parse_mask(Vec::<String>::new()),
            include_dirs: false,
            recursive: false,
            files: Vec::<PathBuf>::new(),
        }
    }
    fn set(&self, path: String, mask: Vec<String>) -> Self {
        Mask {
            dir: PathBuf::from(path),
            mask: ScanD::parse_mask(mask),
            .. self
        }
    }
    fn set_mask(&self, mask: Vec<String>) -> Self {
        Mask { mask: ScanD::parse_mask(mask), .. self }
    }
    fn set_dir(&self, path: String) -> Self {
        Mask { dir: PathBuf::from(path), .. self }
    }
    fn recursive(&self, recurse: bool) -> Self {
        Mask { recursive: recurse, .. self }
    }
    fn include_dirs(&self, include: bool) -> Self {
        Mask { include_dirs: include, .. self }
    }
    fn to_str(&self) -> String;
    fn scan(&self) -> Self;
    fn files(&self) -> Vec<PathBuf> {
        self.files
    }
    fn update(&self) -> Self; // adds any files/dirs that are not found in the struct
}

impl ScanD {
    fn parse_mask(mask: Vec<String>) -> Mask {
        let mut include: Vec<String> = Vec::new();
        let mut exclude: Vec<String> = Vec::new();
        for m in mask {
            if !m.starts_with("!") {
                include.push(m);
            } else {
                exclude.push(*(&m[1..]));
            }
        }
        Mask {
            include,
            exclude,
        }
    }
}

// impl ScanD for ScanD {
    
// }
