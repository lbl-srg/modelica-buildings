within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconModulation_TSup
  "Validation model for economizer and return air damper modulation to preserve the supply air temperature"
  extends Modelica.Icons.Example;

  CDL.Continuous.Constant TCooSet(k=70)
    "Supply air temperature setpoint. The economizer control uses cooling supply temperature"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Modelica.Blocks.Sources.Ramp TCoo(
    duration=1800,
    height=8,
    offset=64) "Supply air temperature sensor output temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Logical.Constant uSupFan(k=true) "Supply fan on or off"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  EconModulation ecoMod
    annotation (Placement(transformation(extent={{2,-20},{22,0}})));
  CDL.Continuous.Constant uHea(k=0) "Heating signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Constant uCoo(k=0.2) "Cooling signal, range 0 - 1"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant EcoDamPosMin(k=0)
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  CDL.Continuous.Constant EcoDamPosMax(k=1)
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  CDL.Continuous.Constant RetDamPosMin(k=0)
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  CDL.Continuous.Constant RetDamPosMax(k=1)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Validation/fixme.mos"
  //     "Simulate and plot"),
  connect(TCooSet.y, ecoMod.TCooSet) annotation (Line(points={{-59,110},{-40,110},
          {-40,-2},{0,-2}}, color={0,0,127}));
  connect(TCoo.y, ecoMod.TCoo) annotation (Line(points={{-59,70},{-30,70},{-30,-6},
          {0,-6}}, color={0,0,127}));
  connect(uCoo.y, ecoMod.uCoo)
    annotation (Line(points={{-59,-10},{-30,-10},{0,-10}}, color={0,0,127}));
  connect(uHea.y, ecoMod.uHea) annotation (Line(points={{-59,30},{-30,30},{-30,-14},
          {0,-14}}, color={0,0,127}));
  connect(uSupFan.y, ecoMod.uSupFan) annotation (Line(points={{-59,-50},{-30.5,-50},
          {-30.5,-17},{0,-17}}, color={255,0,255}));
  connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{-59,-90},
          {-30,-90},{-30,-30},{0,-30}}, color={0,0,127}));
  connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{-59,-130},
          {-30,-130},{-30,-27},{0,-27}}, color={0,0,127}));
  connect(EcoDamPosMax.y, ecoMod.uEcoDamPosMax) annotation (Line(points={{-59,-170},
          {-30,-170},{-30,-24},{0,-24}}, color={0,0,127}));
  connect(EcoDamPosMin.y, ecoMod.uEcoDamPosMin) annotation (Line(points={{-59,-210},
          {-30,-210},{-30,-21},{0,-21}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,140}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,
            140}})),
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
    // __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Validation/fixmeAddFile.mos"
    //   "Simulate and plot"),
end EconModulation_TSup;
