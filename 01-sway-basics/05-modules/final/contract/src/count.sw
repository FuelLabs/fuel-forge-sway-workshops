library;

use ::default::Default;

pub struct Count {
    val: u64,
}

#[error_type]
enum CountError {
    #[error(m = "Incrementing above the maximal count is not allowed.")]
    IncAboveMaxCount: (),
    #[error(m = "Decreasing below zero is not allowed.")]
    DecBelowZero: (),
}

impl Count {
    const MAX: u64 = 5;

    pub fn inc(ref mut self) -> Result<(), CountError> {
        if self.val == Self::MAX {
            return Err(CountError::IncAboveMaxCount);
        }

        self.val += 1;

        Ok(())
    }

    pub fn dec(ref mut self) -> Result<(), CountError> {
        if self.val == 0 {
            return Err(CountError::DecBelowZero);
        }

        self.val -= 1;

        Ok(())
    }

    pub fn val(self) -> u64 {
        self.val
    }
}

impl Default for Count {
    fn default() -> Self {
        Self {
            val: 0,
        }
    }
}

impl From<u64> for Count {
    fn from(val: u64) -> Self {
        Self {
            val,
        }
    }
}
