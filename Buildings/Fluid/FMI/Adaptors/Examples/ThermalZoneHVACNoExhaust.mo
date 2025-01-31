within Buildings.Fluid.FMI.Adaptors.Examples;
model ThermalZoneHVACNoExhaust
  "Example of a thermal zone and an HVAC system both exposed using the FMI adaptor"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  Buildings.Fluid.FMI.Adaptors.HVAC hvacAda(
    redeclare final package Medium=MediumA, nPorts=2)
    "Adaptor for an HVAC system that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=30*6*6
    "Nominal heat loss of the room";

  parameter Modelica.Units.SI.Volume VRoo=6*6*2.7 "Room volume";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=VRoo*2*1.2/3600
    "Nominal mass flow rate";

  Buildings.Fluid.FMI.Adaptors.ThermalZone con(
    redeclare package Medium = MediumA,
    nPorts=2) "Adaptor for thermal zone"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Controls.Continuous.LimPID conPI(
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false) "Fan or pump"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  HeatExchangers.HeaterCooler_u
    hea(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=Q_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Heater"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Sources.Boundary_pT out(
    redeclare package Medium = MediumA,
    nPorts=2,
    use_T_in=true) "Pressure and temperature source for outdoor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-150,-20})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200) "Heat recovery"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    mSenFac=3,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=VRoo,
    nPorts=2) "Room volume"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
    Q_flow_nominal/20)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{150,-60},{130,-40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{180,-60},{160,-40}})));
  Modelica.Blocks.Sources.RealExpression TOutZon(
    y=273.15 + 16 - 5*cos(time/86400*2*Modelica.Constants.pi))
    "Outdoor temperature used for the thermal zone model"
    annotation (Placement(transformation(extent={{230,-60},{210,-40}})));
  Modelica.Blocks.Sources.RealExpression TOutHVAC(
    y=273.15 + 16 - 5*cos(time/86400*2*Modelica.Constants.pi))
    "Outdoor temperature used for the HVAC model" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-190,-24})));
equation
  connect(mov.port_b,hea. port_a) annotation (Line(points={{-70,10},{-70,10},{-40,
          10}},               color={0,127,255}));
  connect(hex.port_b1,mov. port_a) annotation (Line(points={{-100,-14},{-94,-14},
          {-94,10},{-90,10}},   color={0,127,255}));
  connect(out.ports[1],hex. port_b2) annotation (Line(points={{-140,-22},{-130,-22},
          {-130,-26},{-120,-26}}, color={0,127,255}));
  connect(out.ports[2],hex. port_a1) annotation (Line(points={{-140,-18},{-130,-18},
          {-130,-14},{-120,-14}}, color={0,127,255}));
  connect(conPI.y, hea.u) annotation (Line(points={{-49,50},{-46,50},{-46,16},{-42,
          16}},       color={0,0,127}));
  connect(TBou.port,theCon. port_a)
    annotation (Line(points={{160,-50},{150,-50}},
                                                 color={191,0,0}));
  connect(vol.heatPort, theCon.port_b) annotation (Line(points={{140,30},{140,30},
          {122,30},{122,-50},{130,-50}},
                                      color={191,0,0}));
  connect(conPI.u_s, TSet.y)
    annotation (Line(points={{-72,50},{-99,50}},   color={0,0,127}));
  connect(TOutZon.y, TBou.T)
    annotation (Line(points={{209,-50},{182,-50}}, color={0,0,127}));
  connect(hvacAda.TAirZon[1], conPI.u_m) annotation (Line(points={{24,-1},{24,
          -10},{-60,-10},{-60,38}},        color={0,0,127}));
  connect(con.ports[1], vol.ports[1])
    annotation (Line(points={{100,12},{148,12},{148,20}},
                                                       color={0,127,255}));
  connect(vol.heatPort, con.heaPorAir) annotation (Line(points={{140,30},{130,30},
          {122,30},{122,2},{100,2}},
                                  color={191,0,0}));
  connect(con.ports[2], vol.ports[2]) annotation (Line(points={{100,8},{120,8},{
          152,8},{152,20}},   color={0,127,255}));
  connect(hvacAda.fluPor, con.fluPor) annotation (Line(points={{41,10},{57.5,10},
          {57.5,10},{77.8,10}},     color={0,0,255}));
  connect(hea.port_b, hvacAda.ports[1])
    annotation (Line(points={{-20,10},{20,10},{20,12}}, color={0,127,255}));
  connect(hvacAda.ports[2], hex.port_a2) annotation (Line(points={{20,8},{-2,8},
          {-2,-26},{-100,-26}}, color={0,127,255}));
  connect(TOutHVAC.y, out.T_in) annotation (Line(points={{-179,-24},{-162,-24},{
          -162,-24}}, color={0,0,127}));
 annotation (
    Diagram(coordinateSystem(extent={{-220,-120},{260,160}}), graphics={
        Rectangle(
          extent={{-210,140},{40,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{60,140},{240,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-190,124},{-152,100}},
          pattern=LinePattern.None,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Simplified model of
an HVAC system
in Modelica that could
be exposed as an FMU"),
        Text(
          extent={{90,118},{128,94}},
          pattern=LinePattern.None,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Simplified model of
a thermal zone that
may be in an FMU
(but is here for simplicity
also implemented in Modelica)")}),
    Documentation(info="<html>
<p>
This example demonstrates how to
use the adaptors
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.HVAC\">
Buildings.Fluid.FMI.Adaptors.HVAC</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.ThermalZone\">
Buildings.Fluid.FMI.Adaptors.ThermalZone</a>
</p>
<p>
On the left hand side is an HVAC system with supply and return air stream.
These are all connected to the adaptor.
On the right of the adaptor is a simple room model, approximated by a volume with
first order dynamics and heat loss to the ambient.
</p>
<p>
Note that the there is zero net air flow into and out of the volume <code>vol</code>
because the adaptor <code>hvacAda</code> conserves mass. Hence, any infiltration or
exfiltration needs to be
connected to the adaptor <code>hvacAda</code>, rather than the volume <code>vol</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Michael Wetter:<br/>
Removed <code>fontSize</code> in annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1318\">#1318</a>.
</li>
<li>
November 29, 2016, by Michael Wetter:<br/>
Added separate signal for outdoor temperature used by HVAC system. This is
to improve clarity regarding what signals are exchanged, see also
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/598\">#598</a>.
</li>
<li>
June 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/ThermalZoneHVACNoExhaust.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end ThermalZoneHVACNoExhaust;
