

pub trait HasVars {
    fn list_vars(&self) -> Vec<String>;
    fn replace_vars(&self) -> Self;
    fn replace_custom<'a>(&self, Vec<&'a str>) -> Self;
}
pub trait Runnable {
    fn exists(&self) -> bool;
    fn run(&self) -> Result<String, String>;
}