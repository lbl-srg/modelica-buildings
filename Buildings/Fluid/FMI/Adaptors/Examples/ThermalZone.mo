within Buildings.Fluid.FMI.Adaptors.Examples;
model ThermalZone "Example of a thermal zone"
  extends Modelica.Icons.Example;
  constant Integer nFlu = 3 "Number of fluid connectors";

  Buildings.Fluid.FMI.Adaptors.ThermalZoneConvective theZonAda(
    redeclare final package Medium = MediumA,
    nPorts=3) "Adaptor for the thermal zone"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

   replaceable package MediumA = Buildings.Media.Air "Medium for air";

   parameter Modelica.SIunits.Volume VRoo = 6*6*2.7 "Room volume";

   parameter Modelica.SIunits.MassFlowRate m_flow_nominal=VRoo*2*1.2/3600
    "Nominal mass flow rate";

  Buildings.Fluid.FMI.Conversion.InletToAir con[nFlu](redeclare package Medium =
        MediumA) "Signal conversion"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.RealExpression der_T(y=
    sum({max(0, con[i].m_flow)*1006*(con[i].T - TRoo.y) for i in 1:nFlu}))
    "Time derivative of room temperature"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Modelica.Blocks.Continuous.Integrator TRoo(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=293.15,
    k=1/(VRoo*1006)) "Integrator for room air temperature"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.RealExpression der_X_w(y=
    sum({max(0, con[i].m_flow)*(con[i].X_w - X_wRoo.y) for i in 1:nFlu}))
    "Time derivative of room mass fraction"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Blocks.Continuous.Integrator X_wRoo(initType=Modelica.Blocks.Types.Init.InitialState,
    k=1/(VRoo*1.2),
    y_start=0.005) "Integrator for room water vapor mass fraction"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sup1(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=m_flow_nominal,
    T=297.15) "Supply air mass flow source"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Sources.Boundary_pT ret(nPorts=1, redeclare package Medium =
        MediumA) "Sink for return air mass flow"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T sup2(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=m_flow_nominal*2,
    T=297.15) "Supply air mass flow source"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
equation
  connect(der_T.y, TRoo.u)
    annotation (Line(points={{51,50},{58,50}}, color={0,0,127}));
  connect(TRoo.y, theZonAda.TZon) annotation (Line(points={{81,50},{94,50},{94,-20},
          {0,-20},{0,10},{-18,10}}, color={0,0,127}));
  connect(der_X_w.y, X_wRoo.u)
    annotation (Line(points={{51,10},{58,10}}, color={0,0,127}));
  connect(X_wRoo.y, theZonAda.X_wZon) annotation (Line(points={{81,10},{86,10},{
          86,-14},{6,-14},{6,6},{-18,6}}, color={0,0,127}));
  connect(sup1.ports[1], theZonAda.ports[1]) annotation (Line(points={{-70,50},
          {-54,50},{-54,12.6667},{-40,12.6667}},color={0,127,255}));
  connect(ret.ports[1], theZonAda.ports[2]) annotation (Line(points={{-70,-10},{
          -54,-10},{-54,10},{-40,10}},
                                     color={0,127,255}));
  connect(sup2.ports[1], theZonAda.ports[3]) annotation (Line(points={{-70,20},
          {-56,20},{-56,7.33333},{-40,7.33333}},color={0,127,255}));
  connect(theZonAda.fluPor[1:nFlu], con[1:nFlu].inlet) annotation (Line(points={{-19,17},
          {-10,17},{-10,30},{-1,30}},      color={0,0,255}));
 annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-110,90},{-44,-80}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,90},{98,-80}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{0,92},{50,78}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="Simplified model of"),
        Text(
          extent={{0,82},{44,72}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="a thermal zone"),
        Text(
          extent={{-108,82},{-62,70}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="an HVAC system"),
        Text(
          extent={{-108,92},{-58,78}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="Simplified model of")}),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to
use the adaptor
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.ThermalZoneConvective\">
Buildings.Fluid.FMI.Adaptors.ThermalZoneConvective</a>.
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
