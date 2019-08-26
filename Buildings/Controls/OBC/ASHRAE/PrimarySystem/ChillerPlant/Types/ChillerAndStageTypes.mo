within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types;
package ChillerAndStageTypes "Chiller and stage type enumeration"

  constant Integer positiveDisplacement = 1 "Positive displacement chiller or a stage with all positive displacement chillers";
  constant Integer variableSpeedCentrifugal = 2 "Variable speed centrifugal chiller or a stage with any variable speed and no constant speed centrifugal chillers";
  constant Integer constantSpeedCentrifugal = 3 "Constant speed centrifugal chiller or a stage with any constant speed centrifugal chiller";

annotation (
Documentation(info="<html>
<p>
This package provides constants that indicate the chiller type based on the compressor type 
and a chiller stage type based on the type of chillers being staged. 
The chiller types are enumerated in the order of the recommended staging hierarchy, per
section 5.2.4.13., July Draft.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end ChillerAndStageTypes;
