within Buildings.Templates.AHUs.Types;
type Fan = enumeration(
    None
    "No fan",
    SingleConstant
    "Single fan - Constant speed",
    SingleTwoSpeed
    "Single fan - Two speed",
    SingleVariable
    "Single fan - Variable speed",
    MultipleConstant
    "Multiple fans (identical) - Constant speed",
    MultipleTwoSpeed
    "Multiple fans (identical) - Two speed",
    MultipleVariable
    "Multiple fans (identical) - Variable speed")
  "Enumeration to configure the fan";
