within Buildings.Examples.VAVReheat.BaseClasses.Controls;
block opeMod_ASHRAE2006toG36
  parameter Integer conversionDict[7] = {1,7,5,4,2,6,3};

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput ASHRAE2006 annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput G36 annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));
equation
  G36 = conversionDict[ASHRAE2006];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end opeMod_ASHRAE2006toG36;
