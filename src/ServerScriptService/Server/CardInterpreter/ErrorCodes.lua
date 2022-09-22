export type ExecutionCode = string
return {
    Success = "Success",
    InvalidId = "Card with that id doesn't exists",
    InvalidUseInfo = "Card used wrong!",
    OutOfRange = "This is player is too far away!",

} :: {[string]: ExecutionCode}