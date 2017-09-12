mod proj_type;

use proj_type::*;

use std::fmt;
use std::env;
use std::path::{Path, PathBuf};
use std::ffi::OsString;
use std::io::{Write};

pub trait PathStr {
    fn strpath(&self) -> String;
}
impl PathStr for PathBuf {
    fn pathstr(&self) -> String {
        self.to_str().unwrap_or("").to_string()
    }
}

impl Config for Proman {
    pub fn parse_all_vars(&self) -> Proman {
        // go through the Proman struct and call replace_vars() on all VarString's
        let all_templates = self.templates;
        let mut templates: Vec<Template> = Vec::new();
        for t in all_templates {
            templates.push(Template {
                setup: match t.setup.Custom {
                    TemplateSetup::CopyAll => TemplateSetup::CopyAll,
                    TemplateSetup::Custom(exe) => TemplateSetup::Custom(exe.replace_vars(self)),
                    TemplateSetup::Error => TemplateSetup::Error,
                },
                .. t
            });
        }
        /* do same with docs: AllDocs,
                     proj.custom_docs: AllDocs.docs: Vec<Doc.doc: Document>,
                     proj.templates: AllTemplates,
                     commands: CommandData( CommandSource( CommandDest(
                         Execute(Executable)|Str(String)|Error
                     )))
                     proj.sync_files: SyncFiles.files: Vec<
                         Synchronize.action: SyncAction(Custom(Executable))
                         Synchronize.on: SyncOn(Custom(Executable))
                     >
                     proj.
           */        
        Proman { 
            templates,
            
            .. self 
        }
    }
    pub fn lookup_var<'a>(&self, var: <'a>) -> String {
        match &var.trim().to_lowercase() {
            "install_dir" => self.install_dir.pathstr(),
            "user_dir" => self.user_dir.pathstr(),
            "proj_dir" => self.proj.dir.pathstr(),
            "language" => self.proj.lang,
            "proj_type" => self.proj.proj_type,
            "" => self.,
            "" => self..pathstr(),
            "" => self.,
            
            "" => self.,
            "" => self..pathstr(),
            _ => {},
        }
    }
}




