within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types;
type ChillersAndStages = enumeration(
    PositiveDisplacement
  "Positive displacement chiller or a stage with all positive displacement chillers",
    VariableSpeedCentrifugal
  "Variable speed centrifugal chiller or a stage with any variable speed and no constant speed centrifugal chillers",
    ConstantSpeedCentrifugal
  "Constant speed centrifugal chiller or a stage with any constant speed centrifugal chiller")
  "Chiller and stage type enumeration"
 annotation (
Documentation(info="<html>
<p>
It provides constants that indicate the chiller type based on the compressor type 
and a chiller stage type based on the type of chillers being staged. 
The chiller types are enumerated in the order of the recommended staging hierarchy, per
ASHRAE Guideline 36-2021, section 5.20.4.14.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
