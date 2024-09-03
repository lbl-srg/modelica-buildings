within Buildings.Applications.DataCenters.DXCooled.Controls.Validation;
model Compressor
  "Example that demonstrates the use of a speed controller for DX coil"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.DXCooled.Controls.Compressor dxSpeCon
    "Speed controller for a variable DX coil"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant TSupSet(k=291.15)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Sine TSupMea(
    amplitude=2,
    f=1/120,
    offset=291.15) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Modelica.Blocks.Sources.CombiTimeTable cooMod(
    table=[0,  Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling);
           120,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling);
           120,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical);
           240,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical);
           240,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical);
           360,Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)])
    "Cooling mode signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Math.RealToInteger reaToInt "Conversion from real to integer"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(TSupSet.y, dxSpeCon.TMixAirSet) annotation (Line(points={{-39,70},{10,
          70},{10,6},{18,6}}, color={0,0,127}));
  connect(TSupMea.y, dxSpeCon.TMixAirMea)
    annotation (Line(points={{-39,20},{6,20},{6,0},{18,0}}, color={0,0,127}));
  connect(cooMod.y[1], reaToInt.u)
    annotation (Line(points={{-39,-40},{-22,-40}}, color={0,0,127}));
  connect(reaToInt.y, dxSpeCon.cooMod) annotation (Line(points={{1,-40},{10,-40},
          {10,-7},{18,-7}}, color={255,127,0}));
  annotation (__Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DXCooled/Controls/Validation/Compressor.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 3, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how the speed signal of a variable-speed DX unit can be controlled.
The detailed control logic can be
refered in
<a href=\"modelica://Buildings.Applications.DataCenters.DXCooled.Controls.Compressor\">
Buildings.Applications.DataCenters.DXCooled.Controls.Compressor</a>.
</p>
</html>"),
    experiment(
      StartTime=0,
      StopTime=360,
      Tolerance=1e-06));
end Compressor;
