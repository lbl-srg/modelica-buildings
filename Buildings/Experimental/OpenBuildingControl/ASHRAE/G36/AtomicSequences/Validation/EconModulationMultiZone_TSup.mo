within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconModulationMultiZone_TSup
  "Validation model for economizer and return air damper modulation to preserve the supply air temperature"
  extends Modelica.Icons.Example;

  CDL.Continuous.Constant TSupSet(k=273.15+21)
    "Supply air temperature setpoint. The economizer control uses cooling supply temperature"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    duration=1800,
    height=4.4,
    offset=273.15+17.8) "Supply air temperature sensor output temperature"
    annotation (Placement(transformation(extent={{-80,62},{-60,82}})));
  CDL.Logical.Constant uSupFan(k=true) "Supply fan on or off"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  EconModulationMultiZone  ecoMod
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Continuous.Constant uHea(k=0) "Heating signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Constant uCoo(k=0.2) "Cooling signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Constant outDamPosMin(k=0)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  CDL.Continuous.Constant outDamPosMax(k=1)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Continuous.Constant RetDamPosMin(k=0)
    annotation (Placement(transformation(extent={{58,-20},{78,0}})));
  CDL.Continuous.Constant RetDamPosMax(k=1)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
equation
  connect(TSupSet.y, ecoMod.TCooSet) annotation (Line(points={{1,70},{8,70},{8,
          48},{-20,48},{-20,37.75},{-0.75,37.75}},
                            color={0,0,127}));
  connect(TSup.y,ecoMod.TSup)  annotation (Line(points={{-59,72},{-30,72},{-30,
          35.5833},{-0.75,35.5833}},
                   color={0,0,127}));
  connect(uCoo.y, ecoMod.uCoo)
    annotation (Line(points={{-59,10},{-38,10},{-38,34},{-0.75,34},{-0.75,33.75}},
                                                           color={0,0,127}));
  connect(uHea.y, ecoMod.uHea) annotation (Line(points={{-59,40},{-34,40},{-34,31.75},
          {-0.75,31.75}},
                    color={0,0,127}));
  connect(uSupFan.y, ecoMod.uSupFan) annotation (Line(points={{-59,-30},{-34.5,
          -30},{-34.5,29.5833},{-0.75,29.5833}},
                                color={255,0,255}));
  connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{41,-10},
          {46,-10},{46,-26},{-6,-26},{-6,20},{-6,20.9167},{-0.75,20.9167}},
                                        color={0,0,127}));
  connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{79,-10},
          {84,-10},{84,-30},{-20,-30},{-20,22.9167},{-0.75,22.9167}},
                                         color={0,0,127}));
  connect(outDamPosMax.y, ecoMod.uOutDamPosMax) annotation (Line(points={{41,-50},
          {50,-50},{50,-66},{-30,-66},{-30,25.25},{-0.75,25.25}},
                                         color={0,0,127}));
  connect(outDamPosMin.y, ecoMod.uOutDamPosMin) annotation (Line(points={{81,-50},
          {88,-50},{88,-70},{-24,-70},{-24,27.4167},{-0.75,27.4167}},
                                         color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconModulationMultiZone_TSup.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={Ellipse(
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
    experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconModulationMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconModulationMultiZone</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulationMultiZone_TSup;
