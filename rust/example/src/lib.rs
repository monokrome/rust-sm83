#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Disable interrupts, then halt.
    unsafe {
        di();
        halt();
    }
    loop {}
}

#[no_mangle]
pub extern "C" fn add(a: u8, b: u8) -> u8 {
    a.wrapping_add(b)
}

#[no_mangle]
pub extern "C" fn add16(a: u16, b: u16) -> u16 {
    a.wrapping_add(b)
}

extern "C" {
    fn di();
    fn halt();
}
