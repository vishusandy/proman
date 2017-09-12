
use config::*;

pub trait Versioning {
    // command for a commit
    fn commit() -> String;
    fn init() -> String;
}


