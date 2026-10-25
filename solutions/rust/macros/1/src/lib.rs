#[macro_export]
macro_rules! hashmap {
    () => {{::std::collections::HashMap::new()}};
    ($($k:expr => $v:expr),+$(,)?) => {
        {
            let mut temp_hm = ::std::collections::HashMap::new();
            $(
                temp_hm.insert($k, $v);
            )+
            temp_hm
        }
    };
}

pub mod compile_fail_tests;
