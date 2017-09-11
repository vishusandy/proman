extern crate setenv;

use self::setenv::get_shell;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};


pub fn env_append(new: Vec<PathBuf>) -> Vec<PathBuf> {
    
    // if let Some(path) = env::var_os("PATH") {
    //     // let mut paths = env::split_paths(&path).collect::<Vec<_>>();
        
    //     for n in new {
    //         // paths.push(PathBuf::from(&n));
    //         paths.push(n);
    //     }
    //     // let new_path = env::join_paths(paths).unwrap();
    //     let joined = env::join_paths(&paths).unwrap_or(OsString::from(""));
    //     paths
    //     // env::set_var("PATH", &new_path);
    // } else {
    //     Vec::<PathBuf>::new()
    // }
    let mut paths = env::split_paths(&env::var_os("PATH").unwrap()).collect::<Vec<_>>();
    for n in new {
        paths.push(n);
    }
    paths
}

pub fn find_files() -> Vec<PathBuf> {
    let default_files: Vec<PathBuf> = vec![
        PathBuf::from(r"c:\code\lang\rust\proj\cmds\target\release\cmds.exe"),
    ];
    
    default_files
}



// pub fn inject(files: Vec<PathBuf>) {
pub fn inject() {
    let s = get_shell();
    // let path = env::join_paths(files).unwrap_or( env::var_os("PATH").unwrap_or(OsString::from("")) );
    // sh.setenv(OsString::from("PATH"), path);
    // s.setenv_list(OsString::from("PATH"), files);
    
    // let mut paths = s.split_env(OsString::from("PATH"));
    // let mut paths = env::split_paths(&env::var_os("PATH").unwrap()).collect::<Vec<_>>();
    let mut paths = env::split_paths(&env::var_os("PATH").unwrap()).collect::<Vec<_>>();
    let add = find_files();
    for a in add {
        paths.push(a);
    }
    
    s.setenv_list(OsString::from("PATH"), paths)
    
}

fn main() {
    // let paths = env_append(find_files());
    // inject(paths);
    // inject();
        // let args : Vec<String> = args().collect();
    // let mut stderr = std::io::stderr();
    // for a in &args {
    //    writeln!(stderr, "arg: {:?}", a);
    // }
    
    // let mut test = env::current_dir().unwrap();
    // test.set_file_name("proman.cfg");
    
    let curdir = env::current_dir().unwrap();
    let test = env::current_dir().unwrap().join("proman.cfg");
    
    let add = vec![
        PathBuf::from(r"c:\code\lang\rust\proj\cmds\target\release"),
    ];
    let path_env = env::var_os("Path").unwrap();
    let mut paths = env::split_paths(&path_env).collect::<Vec<_>>();
    let s = get_shell();
    let mut stderr = std::io::stderr();
    
    if  !test.exists() {
        // writeln!(stderr, "No proman file found in {:?} / {:?}", test, curdir);
        let mut old: Vec<PathBuf> = Vec::new();
        /*
        for v in &paths {
            if !add.contains(v) {
                old.push(v.clone());
            } else {
                writeln!(stderr, "Old contains added path {:?}", v);
            }
        }
        */
        
        let old1: Vec<PathBuf> = paths.into_iter().filter(|s| !add.contains(&s)).collect();
        // let old2: Vec<PathBuf> = paths.into_iter().filter_map(|s| if add.contains(&s) { Some(s) } else { None } ).collect();
        
        // writeln!(stderr, "Old has {} items", old.len());
        writeln!(stderr, "Old1 has {} items", old1.len());
        // writeln!(stderr, "Old2 has {} items", old2.len());
        old.dedup();
        let mut revert = env::join_paths(old1).unwrap_or(OsString::from("ErrOR"));
        revert = OsString::from( revert.into_string().unwrap_or("eErrOR".to_string()).replace(";;", ";") );
        s.setenv(OsString::from("Path"), revert);
        return;
    }
    writeln!(stderr, "Proman file found.");
    for a in add {
        paths.push(a);
    }
    paths.dedup();
    let mut output = env::join_paths(paths).unwrap_or(OsString::from("ErRoR"));
    output = OsString::from(output.into_string().unwrap_or("EerroeR".to_string()).replace(";;", ";"));
    
    // let td = TempDir::new_in(std::env::current_dir().unwrap(), "setenv_test_dir").unwrap();
    // let p = td.into_path().join("test_dir_test");
    // create_dir(&p).unwrap();
    // s.cd(p);
    
    // s.setenv_list(OsString::from("PATH"), paths);
    s.setenv(OsString::from("Path"), output);
    
}
