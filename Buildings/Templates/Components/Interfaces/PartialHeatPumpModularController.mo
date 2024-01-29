within Buildings.Templates.Components.Interfaces;
partial block PartialHeatPumpModularController
  "Interface class for modular heat pump controller"

  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus bus
    "Control bus for heat pump model" annotation (Placement(transformation(
          extent={{-20,160},{20,200}}),iconTransformation(extent={{-20,80},{20,
            120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet
    "Supply temperature setpoint" annotation (Placement(transformation(extent={{-200,
            -20},{-160,20}}),       iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating/cooling mode command (true=heating)" annotation (Placement(
        transformation(extent={{-200,60},{-160,100}}),iconTransformation(extent
          ={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1 "Enable command"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Relative compressor speed between 0 and 1" annotation (Placement(
        transformation(extent={{180,-20},{220,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    "Heating/cooling mode command (true=heating)" annotation (Placement(
        transformation(extent={{180,60},{220,100}}),iconTransformation(extent={
            {100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1 "Enable command"
    annotation (Placement(transformation(extent={{180,140},{220,180}}),
        iconTransformation(extent={{100,60},{140,100}})));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(extent={{-160,-180},{
            180,180}})));
end PartialHeatPumpModularController;
