within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconModulation_TSup
  "Validation model for economizer and return air damper modulation to preserve the supply air temperature"
  extends Modelica.Icons.Example;

  CDL.Continuous.Constant TCooSet(k=70, unit="F", displayUnit="F")
    "Supply air temperature setpoint. The economizer control uses cooling supply temperature"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    duration=1800,
    height=8,
    offset=64,
    unit="F", displayUnit="F") "Supply air temperature sensor output temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Logical.Constant uSupFan(k=true) "Supply fan on or off"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  EconModulation ecoMod
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Continuous.Constant uHea(k=0) "Heating signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Constant uCoo(k=0.2) "Cooling signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Constant EcoDamPosMin(k=0)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  CDL.Continuous.Constant EcoDamPosMax(k=1)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Continuous.Constant RetDamPosMin(k=0)
    annotation (Placement(transformation(extent={{58,-20},{78,0}})));
  CDL.Continuous.Constant RetDamPosMax(k=1)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
equation
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Validation/fixme.mos"
  //     "Simulate and plot"),
  connect(TCooSet.y, ecoMod.TCooSet) annotation (Line(points={{1,70},{8,70},{8,48},
          {-20,48},{-20,38},{-2,38}},
                            color={0,0,127}));
  connect(TSup.y,ecoMod.TSup)  annotation (Line(points={{-59,70},{-30,70},{-30,34},
          {-2,34}},color={0,0,127}));
  connect(uCoo.y, ecoMod.uCoo)
    annotation (Line(points={{-59,10},{-2,10},{-2,30}},    color={0,0,127}));
  connect(uHea.y, ecoMod.uHea) annotation (Line(points={{-59,40},{-30,40},{-30,26},
          {-2,26}}, color={0,0,127}));
  connect(uSupFan.y, ecoMod.uSupFan) annotation (Line(points={{-59,-30},{-30.5,-30},
          {-30.5,23},{-2,23}},  color={255,0,255}));
  connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{41,-10},
          {50,-10},{50,-30},{-20,-30},{-20,10},{-2,10}},
                                        color={0,0,127}));
  connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{79,-10},
          {90,-10},{90,-30},{-20,-30},{-20,13},{-2,13}},
                                         color={0,0,127}));
  connect(EcoDamPosMax.y, ecoMod.uEcoDamPosMax) annotation (Line(points={{41,-50},
          {50,-50},{50,-70},{-30,-70},{-30,16},{-2,16}},
                                         color={0,0,127}));
  connect(EcoDamPosMin.y, ecoMod.uEcoDamPosMin) annotation (Line(points={{81,-50},
          {90,-50},{90,-70},{-20,-70},{-20,19},{-2,19}},
                                         color={0,0,127}));
  annotation (
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulation_TSup;
