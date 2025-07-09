within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent;
model SpeedControlled
  "Enthalpy recovery wheel with a variable speed drive"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.PartialWheel;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionLatent speCor(
    final per=per)
    "Correct the wheel performance based on the wheel speed"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulSen
    "Correct the sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulLat
    "Correct the latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

initial equation
  assert(per.have_varSpe,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the variable speed flag must be true",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";

equation
  connect(hex.port_a2, port_a2)
    annotation (Line(points={{30,-6},{40,-6},{40,-80},{100,-80}},
    color={0,127,255}));
  connect(hex.port_a1, port_a1)
    annotation (Line(points={{10,6},{0,6},{0,80},{-180,80}},      color={0,127,255}));
  connect(speCor.epsSenCor, mulSen.u1) annotation (Line(points={{-98,120},{-80,
          120},{-80,146},{-42,146}}, color={0,0,127}));
  connect(speCor.epsLatCor, mulLat.u1) annotation (Line(points={{-98,112},{-80,
          112},{-80,106},{-42,106}}, color={0,0,127}));
  connect(effCal.epsSen, mulSen.u2) annotation (Line(points={{-78,5},{-70,5},{
          -70,134},{-42,134}}, color={0,0,127}));
  connect(effCal.epsLat, mulLat.u2) annotation (Line(points={{-78,-5},{-60,-5},
          {-60,94},{-42,94}}, color={0,0,127}));
  connect(mulSen.y, hex.epsSen)
    annotation (Line(points={{-18,140},{-4,140},{-4,3},{8,3}},
                                                             color={0,0,127}));
  connect(hex.epsLat, mulLat.y) annotation (Line(points={{8,-3},{-10,-3},{-10,
          100},{-18,100}}, color={0,0,127}));
  connect(mulSen.y, epsSen) annotation (Line(points={{-18,140},{90,140},{90,40},
          {120,40}}, color={0,0,127}));
  connect(mulLat.y, epsLat) annotation (Line(points={{-18,100},{84,100},{84,0},
          {120,0}}, color={0,0,127}));
  connect(speCor.P, P) annotation (Line(points={{-98,128},{-54,128},{-54,-40},{
          120,-40}},                   color={0,0,127}));
  connect(speCor.uSpe, uSpe) annotation (Line(points={{-122,120},{-168,120},{-168,
          0},{-200,0}}, color={0,0,127}));
annotation (
   defaultComponentName="whe",Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
   graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None), Text(
          extent={{-94,12},{-64,-10}},
          textColor={0,0,127},
          textString="uSpe")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,160}})),
Documentation(info="<html>
<p>
Model of an enthalpy recovery wheel, which has the
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible and latent
heat exchanger effectiveness.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionLatent\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.SpeedCorrectionLatent</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
