within Buildings.Rooms.FLEXLAB.IO;
model DimmingLevel "Identifies the desired new light dimming setpoint"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.RealInput perDes
    "Light level setpoint divided by light level"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput oldDim "Old dimmer setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput newDim "New dimmer setpoint"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  newDim = max(0,min(100,oldDim - 100/3 * (1 - perDes)));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DimmingLevel;
