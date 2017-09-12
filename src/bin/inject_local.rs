extern crate setenv;

use self::setenv::get_shell;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};

mod proj_types;
use proj_types::*;


