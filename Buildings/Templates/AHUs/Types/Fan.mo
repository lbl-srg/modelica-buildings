within Buildings.Experimental.Templates.AHUs.Types;
type Fan = enumeration(
    None
    "No fan",
    SingleConstant
    "Single fan - Constant speed",
    SingleTwoSpeed
    "Single fan - Two speed",
    SingleVariable
    "Single fan - Variable speed",
    SingleDischargeDamper
    "Single fan - Discharge damper",
    MultipleConstant
    "Multiple fan - Constant speed",
    MultipleTwoSpeed
    "Multiple fan - Two speed",
    MultipleVariable
    "Multiple fan - Variable speed",
    MultipleDischargeDamper
    "Multiple fan - Discharge damper") "Enumeration to configure the fan";
