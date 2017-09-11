within Buildings.ThermalZones.Detailed.Examples;
model MixedAirCO2
  "Mixed air room model with CO2 concentration simulated"
  extends Buildings.ThermalZones.Detailed.Examples.ElectroChromicWindow(
    bou(use_m_flow_in=true),
    redeclare package MediumA = Buildings.Media.Air(extraPropertiesNames={"CO2"}),
    roo(
      use_C_flow=true,
      nPorts=3),
    nPer(
      width=100*2/24,
      amplitude=5,
      startTime=43200));

  parameter Modelica.SIunits.MassFlowRate mOut_flow = 47*2/3600*1.2
    "Typical outside air mass flow rate, unless increased by controller";

  Modelica.Blocks.Math.Gain gaiCO2(k=8.18E-6) "CO2 emission per person"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.Sensors.PPM senCO2(
    redeclare package Medium = MediumA,
    MM=Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM)
    "CO2 sensor that measures concentration in the room"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Modelica.Blocks.Sources.Constant CO2Set(k=700)
    "CO2 set point in PPM above the initial value"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Modelica.Blocks.Math.Gain norCO2Set(k=1/700)
    "Normalization for CO2 set point" annotation (
      Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Modelica.Blocks.Math.Gain norCO2Mea(k=1/700)
    "Normalization for CO2 measurement" annotation (
      Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.Continuous.LimPID conPI(
    k=5,
    Ti=120,
    yMax=10,
    yMin=0,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "PI controller for fresh air supply, with negative minimum because of reverse action"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addFlo(
    p = -mOut_flow,
    k=-mOut_flow)
    "Gain that increases the mass flow rate above its typical value"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
equation
  connect(roo.C_flow[1], gaiCO2.y) annotation (Line(points={{60.4,6.8},{36,6.8},
          {36,-30},{21,-30}},
                            color={0,0,127}));
  connect(nPer.y, gaiCO2.u) annotation (Line(points={{-59,-10},{-59,-10},{-50,-10},
          {-50,-30},{-2,-30}},
                             color={0,0,127}));
  connect(senCO2.port, roo.ports[3]) annotation (Line(points={{80,-60},{80,-70},
          {62,-70},{62,-6},{67,-6}}, color={0,127,255}));
  connect(CO2Set.y, norCO2Set.u)
    annotation (Line(points={{-139,-120},{-139,-120},{-122,-120}},
                                                   color={0,0,127}));
  connect(senCO2.ppm, norCO2Mea.u) annotation (Line(points={{91,-50},{92,-50},{96,
          -50},{100,-50},{100,-170},{-140,-170},{-140,-150},{-122,-150}}, color=
         {0,0,127}));
  connect(norCO2Set.y, conPI.u_s)
    annotation (Line(points={{-99,-120},{-82,-120}},         color={0,0,127}));
  connect(norCO2Mea.y, conPI.u_m) annotation (Line(points={{-99,-150},{-99,-150},
          {-70,-150},{-70,-132}}, color={0,0,127}));
  connect(conPI.y,addFlo. u)
    annotation (Line(points={{-59,-120},{-52,-120}}, color={0,0,127}));
  connect(addFlo.y, bou.m_flow_in) annotation (Line(points={{-29,-120},{-16,-120},
          {-16,-112},{-10,-112}},
                               color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
Example that demonstrates how to add CO2 emission that scales with
the number of person, and then add a feedback control that increases
the outside air mass flow rate.
</p>
<p>
The gain <code>gaiCO2</code> adds a CO2 mass flow rate of 8.18E-6 kg/s
per person to the room. It is scaled with the number of person, as obtained
from the block <code>nPer</code>. In this example, the number of person are
zero except for 2 hours, starting at 11 AM. During this time, 5 people
are in the room.
</p>
<p>
The sensor <code>senCO2</code> measures the CO2 PPM in the room.
This is used by the controller <code>conPI</code> to adjust the
outside air flow rate.
Two gains are used to normalize the control input. This is
simply done to make it easier to configure the gains of the controller.
The block <code>addFlo</code> increases
the outdoor air flow rate above the base flow rate,
which is set to <code>mOut_flow</code>.
Plotting the control error shows that the set point is being tracked after
a brief overshoot during the initial transient.
</p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/MixedAirCO2.mos"
        "Simulate and plot"),
experiment(StopTime=86400, Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-180,-200},{220,160}}), graphics={
        Rectangle(
          extent={{58,-26},{140,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,-90},{-20,-166}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-164,-86},{-92,-108}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Feedback control for fresh air"),
        Text(
          extent={{84,-22},{156,-44}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="CO2 sensor for room air")}));
end MixedAirCO2;
