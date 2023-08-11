within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences;
block HumidityRatio_TDryBulPhi
  "Block to compute the humidity ratio based on relative humidity"
  extends Modelica.Blocks.Icons.Block;

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa")=101325
    "Atmospheric pressure";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Air relative humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Xout(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Air humidity ratio"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi ent(
    final pAtm=pAtm)
    "Block for computating specific enthalpy of moist air"
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Calculation of the specific enthalpy difference between moist air and dry air"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeHeaAir(
    final k=1006)
    "Specific heat of dry air at constant pressure"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Calculation of specific enthalpy of dry air"
    annotation (Placement(transformation(extent={{-40,-24},{-20,-4}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Compute humidity ratio of moist air"
    annotation (Placement(transformation(extent={{50,-76},{70,-56}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conLatHea(
    final k=2501014.5)
    "Specific enthalpy of vaporization of water"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeHeaWat(
    final k=1860)
    "Specific heat of water vapor at constant pressure"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Calculation of sensible heat of water vapor"
    annotation (Placement(transformation(extent={{0,56},{20,76}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Calculatio of specific enthalpy of water vapor"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1[2]
    "Convert Kelvin to degC"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[2](
    final k=273.15)
    "Constant conversion value"
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=2)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

equation
  connect(phi, ent.phi) annotation (Line(points={{-120,-60},{-42,-60}},
                    color={0,0,127}));
  connect(ent.h, sub.u1)
    annotation (Line(points={{-18,-54},{-2,-54}},         color={0,0,127}));
  connect(mul.y, sub.u2) annotation (Line(points={{-18,-14},{-10,-14},{-10,-66},
          {-2,-66}},                     color={0,0,127}));
  connect(sub.y, div1.u1) annotation (Line(points={{22,-60},{48,-60}},
        color={0,0,127}));
  connect(add2.y, div1.u2) annotation (Line(points={{72,0},{80,0},{80,-20},{30,-20},
          {30,-72},{48,-72}},     color={0,0,127}));
  connect(conSpeHeaWat.y, mul1.u1) annotation (Line(points={{-18,80},{-10,80},{-10,
          72},{-2,72}}, color={0,0,127}));
  connect(div1.y, Xout) annotation (Line(points={{72,-66},{90,-66},{90,0},{120,0}},
        color={0,0,127}));
  connect(conLatHea.y, add2.u2) annotation (Line(points={{22,30},{30,30},{30,-6},
          {48,-6}}, color={0,0,127}));
  connect(add2.u1, mul1.y)
    annotation (Line(points={{48,6},{40,6},{40,66},{22,66}}, color={0,0,127}));
  connect(conSpeHeaAir.y, mul.u2)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={0,0,127}));
  connect(con.y, sub1.u2)
    annotation (Line(points={{-58,24},{-42,24}}, color={0,0,127}));
  connect(TOut, reaScaRep.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(sub1[1].y, mul1.u2) annotation (Line(points={{-18,30},{-10,30},{-10,60},
          {-2,60}}, color={0,0,127}));
  connect(sub1[2].y, mul.u1) annotation (Line(points={{-18,30},{-10,30},{-10,10},
          {-48,10},{-48,-8},{-42,-8}}, color={0,0,127}));
  connect(ent.TDryBul, TOut) annotation (Line(points={{-42,-48},{-90,-48},{-90,60},
          {-120,60}}, color={0,0,127}));
  connect(reaScaRep.y, sub1.u1) annotation (Line(points={{-58,60},{-50,60},{-50,
          36},{-42,36}}, color={0,0,127}));

  annotation (
    defaultComponentName="wBulPhi",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
          Text(
            extent={{-100,66},{-62,52}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TOut"),
          Text(
            extent={{-100,-54},{-64,-66}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="Phi"),
          Text(
            extent={{60,8},{98,-6}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="XOut")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
  <p>
  This block computes the humidity ratio for a given dry bulb temperature, relative air humidity
  and atmospheric pressure. 
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  August 10, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end HumidityRatio_TDryBulPhi;
