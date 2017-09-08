within Buildings.Controls.OBC.ASHRAE.G36.Atomic.Validation;
model OccupiedMinAirflowReheatBox
extends Modelica.Icons.Example;
  Buildings.Controls.OBC.ASHRAE.G36.Atomic.OccupiedMinAirflowReheatBox
    occMinAir_RehBox(
    VCooMax=0.075,
    VMin=0.017,
    VHeaMax=0.05,
    maxDt=11,
    VMinCon=0.01,
    zonAre=40)
    "Output the occupied minimum airflow for VAV reheat terminal unit"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  CDL.Continuous.Sources.Ramp coCon(
    height=400,
    duration=86400,
    offset=500) "CO2 concentration"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=2,
    freqHz=1/86400,
    offset=2) "occNum"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Conversions.BooleanToInteger booToInt(integerTrue=1, integerFalse=7)
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.95)
    "Check if input is greater than 0.75"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Continuous.Sources.Ramp ram(duration=86400)
    "Generate ramp output"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  CDL.Logical.Sources.Pulse winSta(startTime=1200, period=86400)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

equation
  connect(ram.y, greThr.u)
    annotation (Line(points={{-79,-10},{-62,-10}}, color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-39,-10},{-22,-10}}, color={255,0,255}));
  connect(not1.y, booToInt.u)
    annotation (Line(points={{1,-10},{18,-10}}, color={255,0,255}));
  connect(coCon.y, occMinAir_RehBox.ppmCO2)
    annotation (Line(points={{41,70},{52,70},{52,76},{79,76}},
      color={0,0,127}));
  connect(booToInt.y, occMinAir_RehBox.uOpeMod)
    annotation (Line(points={{41,-10},{60,-10},{60,67},{79,67}},
      color={255,127,0}));
  connect(winSta.y, occMinAir_RehBox.uWin)
    annotation (Line(points={{41,-50},{64,-50},{64,63},{79,63}},
      color={255,0,255}));
  connect(sine.y, occMinAir_RehBox.nOcc)
    annotation (Line(points={{41,30},{56,30},{56,72},{79,72}},
      color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Atomic/Validation/OccupiedMinAirflowReheatBox.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Atomic.OccupiedMinAirflowReheatBox\">
Buildings.Controls.OBC.ASHRAE.G36.Atomic.OccupiedMinAirflowReheatBox</a>
for calculating occupied minimum airflow used in VAV reheat terminal unit control.
</p>
</html>", revisions="<html>
<ul>
<li>
September 07, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OccupiedMinAirflowReheatBox;
