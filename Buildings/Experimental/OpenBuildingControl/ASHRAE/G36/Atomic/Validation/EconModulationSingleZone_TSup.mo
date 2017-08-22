within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconModulationSingleZone_TSup
  "Validation model for single zone VAV AHU outdoor and return air damper position modulation sequence"
  extends Modelica.Icons.Example;

  EconModulationSingleZone ecoMod "Economizer modulation sequence"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

protected
  final parameter Modelica.SIunits.Temperature THeaSet=291.15
    "Supply air temperature setpoint";

  CDL.Continuous.Sources.Constant THeaSetSig(final k=THeaSet) "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    final duration=900,
    final height=4,
    final offset=THeaSet - 2) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Continuous.Sources.Constant outDamPosMin(final k=0)
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Sources.Constant outDamPosMax(final k=1)
    "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.Sources.Constant RetDamPosMin(final k=0)
    "Minimum return air damper position"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Sources.Constant RetDamPosMax(final k=1)
    "Maximum return air damper position"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(THeaSetSig.y, ecoMod.THeaSet) annotation (Line(points={{1,70},{8,70},{
          8,48},{8,39},{39,39}}, color={0,0,127}));
  connect(TSup.y,ecoMod.TSup)  annotation (Line(points={{-39,70},{-30,70},{-30,36},
          {39,36}},color={0,0,127}));
  connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{-59,-40},
          {-20,-40},{-20,24},{-6,24},{39,24}}, color={0,0,127}));
  connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{-59,-70},
          {8,-70},{8,16},{8,21},{39,21}},color={0,0,127}));
  connect(outDamPosMax.y, ecoMod.uOutDamPosMax) annotation (Line(points={{-59,20},
          {-48,20},{-30,20},{-30,31},{39,31}}, color={0,0,127}));
  connect(outDamPosMin.y, ecoMod.uOutDamPosMin) annotation (Line(points={{-59,-10},
          {-34,-10},{-24,-10},{-24,28},{39,28}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconModulationSingleZone_TSup.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationSingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationSingleZone</a>
for supply air temeperature (<code>TSup</code>) and supply air temperature heating setpoint (<code>THeaSet</code>)
control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
July 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulationSingleZone_TSup;
