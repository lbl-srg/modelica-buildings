within Buildings.Fluid.FMI.Adaptors.Examples;
model ThermalZone "Example of a thermal zone"
  extends Modelica.Icons.Example;
  constant Integer nFlu = 3 "Number of fluid connectors";

  Buildings.Fluid.FMI.Adaptors.HVACConvective hvacAda(redeclare final package
      Medium = MediumA, nPorts=3)
    "Adaptor for an HVAC system that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

   replaceable package MediumA = Buildings.Media.Air "Medium for air";

   parameter Modelica.SIunits.Volume VRoo = 6*6*2.7 "Room volume";

   parameter Modelica.SIunits.MassFlowRate m_flow_nominal=VRoo*2*1.2/3600
    "Nominal mass flow rate";

  Buildings.Fluid.FMI.Conversion.InletToAir con[nFlu](redeclare package Medium =
        MediumA) "Signal conversion"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.RealExpression der_T(y=
    sum({max(0, con[i].m_flow)*1006*(con[i].T - TRoo.y) for i in 1:nFlu}))
    "Time derivative of room temperature"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Blocks.Continuous.Integrator TRoo(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=293.15,
    k=1/(VRoo*1006)) "Integrator for room air temperature"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.RealExpression der_X_w(y=
    sum({max(0, con[i].m_flow)*(con[i].X_w - X_wRoo.y) for i in 1:nFlu}))
    "Time derivative of room mass fraction"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Blocks.Continuous.Integrator X_wRoo(initType=Modelica.Blocks.Types.Init.InitialState,
    k=1/(VRoo*1.2),
    y_start=0.005) "Integrator for room water vapor mass fraction"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sup1(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=m_flow_nominal,
    T=297.15) "Supply air mass flow source"
    annotation (Placement(transformation(extent={{-90,28},{-70,48}})));
  Buildings.Fluid.Sources.Boundary_pT ret(nPorts=1, redeclare package Medium =
        MediumA) "Sink for return air mass flow"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sup2(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=m_flow_nominal*2,
    T=297.15) "Supply air mass flow source"
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
equation
  connect(der_T.y, TRoo.u)
    annotation (Line(points={{51,10},{58,10}}, color={0,0,127}));
  connect(TRoo.y, hvacAda.TZon) annotation (Line(points={{81,10},{94,10},{94,
          -60},{-10,-60},{-10,10},{-18,10}}, color={0,0,127}));
  connect(der_X_w.y, X_wRoo.u)
    annotation (Line(points={{51,-30},{58,-30}},
                                               color={0,0,127}));
  connect(X_wRoo.y, hvacAda.X_wZon) annotation (Line(points={{81,-30},{90,-30},
          {90,-56},{-6,-56},{-6,6},{-18,6}}, color={0,0,127}));
  connect(sup1.ports[1], hvacAda.ports[1]) annotation (Line(points={{-70,38},{
          -54,38},{-54,12.6667},{-40,12.6667}}, color={0,127,255}));
  connect(ret.ports[1], hvacAda.ports[2])
    annotation (Line(points={{-70,10},{-54,10},{-40,10}}, color={0,127,255}));
  connect(sup2.ports[1], hvacAda.ports[3]) annotation (Line(points={{-68,-20},{
          -56,-20},{-56,7.33333},{-40,7.33333}}, color={0,127,255}));
  connect(hvacAda.fluPor[1:nFlu], con[1:nFlu].inlet) annotation (Line(points={{
          -19,17},{-4,17},{-4,14},{-4,14},{-4,-10},{-1,-10}}, color={0,0,255}));
 annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-14,90},{96,-80}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-116,90},{-18,-80}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-112,88},{-74,64}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
an HVAC system
in Modelica that could
be exposed as an FMU"),
        Text(
          extent={{-6,84},{32,60}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
a thermal zone that
may be in an FMU
(but is here for simplicity
also implemented in Modelica)")}),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to
use the adaptor
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.HVACConvective\">
Buildings.Fluid.FMI.Adaptors.HVACConvective</a>.
On the left of the adaptor are two supply air inlets and a return air connection.
On the right of the adaptor is a simple first order differential equation
for the room air and the room water vapor concentration.
Hence, to keep the model simple, the thermal zone has no losses and exchanges heat and moisture only with
the HVAC system.
</p>
</html>", revisions="<html>
<ul>
<li>
May 23, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/ThermalZone.mos"
        "Simulate and plot"),
    experiment(StopTime=3600));
end ThermalZone;
