extern crate setenv;

use self::setenv::get_shell;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};

mod proj_types;
use proj_types::*;

// look for a binary msgpack serialized config, if not exists or
// the file is older than the local / global run a shorter config
// deserialization function that just gets the command names/dirs

