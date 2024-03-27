within Buildings.DHC.Plants.Cooling.Controls.Validation;
model ChilledWaterBypass
  "Example to test the chilled water bypass controller"
  extends Modelica.Icons.Example;
  Buildings.DHC.Plants.Cooling.Controls.ChilledWaterBypass chiBypCon(numChi=2,
    mMin_flow=0.03)
    "Chilled water bypass loop control"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.BooleanTable onOne(
    table(
      each displayUnit="s")={300,900})
    "On signal of the first chiller"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.BooleanTable onTwo(
    table(
      each displayUnit="s")={600,900})
    "On signal of the second chiller"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Sine mFloChi(
    amplitude=0.03,
    f=1/300,
    offset=0.03,
    startTime=300) "Mass flow rate through the chillers"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(mFloChi.y,chiBypCon.mFloChi)  annotation (Line(points={{-39,-30},{-20,
          -30},{-20,-15},{-2,-15}},
                                  color={0,0,127}));
  connect(onTwo.y,chiBypCon.chiOn[2])
    annotation (Line(points={{-39,10},{-20,10},{-20,-4},{-2,-4}},
      color={255,0,255}));
  connect(onOne.y,chiBypCon.chiOn[1])
    annotation (Line(points={{-39,40},{-20,40},{-20,-6},{-2,-6}},
      color={255,0,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    experiment(
      Tolerance=1e-06, StopTime=1200),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Cooling/Controls/Validation/ChilledWaterBypass.mos"
      "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
May 3, 2021 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model validates the chilled water bypass valve control logic implemented in
<a href=\"modelica://Buildings.DHC.Plants.Cooling.Controls.ChilledWaterBypass\">
Buildings.DHC.Plants.Cooling.Controls.ChilledWaterBypass</a>.
</p>
</html>"));
end ChilledWaterBypass;
