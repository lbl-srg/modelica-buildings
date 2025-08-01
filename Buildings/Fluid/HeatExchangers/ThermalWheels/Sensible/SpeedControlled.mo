within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model SpeedControlled
  "Sensible heat recovery wheel with a variable speed drive"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel(
    hex(
      final dp1_nominal=per.dpSup_nominal,
      final dp2_nominal=per.dpExh_nominal));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible speCor(
    final per=per)
    "Correct the wheel performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulEps
    "Calculate the heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

initial equation
  assert(per.have_varSpe,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the variable speed flag must be true",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";

equation
  connect(port_a1, hex.port_a1) annotation (Line(points={{-180,80},{-20,80},{
          -20,6},{-10,6}},
                    color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,
          -80},{100,-80}}, color={0,127,255}));
  connect(speCor.epsSenCor, mulEps.u2) annotation (Line(points={{-138,0},{-130,0},
          {-130,-16},{-62,-16}},    color={0,0,127}));
  connect(effCal.eps, mulEps.u1) annotation (Line(points={{-78,0},{-70,0},{-70,
          -4},{-62,-4}}, color={0,0,127}));
  connect(mulEps.y, hex.eps) annotation (Line(points={{-38,-10},{-30,-10},{-30,
          0},{-12,0}}, color={0,0,127}));
  connect(uSpe,speCor. uSpe) annotation (Line(points={{-200,0},{-162,0}},
          color={0,0,127}));
  connect(speCor.P, P) annotation (Line(points={{-138,8},{-130,8},{-130,68},{88,
          68},{88,-40},{120,-40}}, color={0,0,127}));
  connect(eps, mulEps.y) annotation (Line(points={{120,40},{80,40},{80,-20},{
          -30,-20},{-30,-10},{-38,-10}},
                                     color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None), Text(
          extent={{-92,12},{-62,-10}},
          textColor={0,0,127},
          textString="uSpe")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})),
Documentation(info="<html>
<p>
Model of a generic, sensible heat recovery wheel, which has the
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible heat
exchanger effectiveness.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionSensible</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
