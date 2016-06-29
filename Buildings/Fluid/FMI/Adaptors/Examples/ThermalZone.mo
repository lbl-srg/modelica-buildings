within Buildings.Fluid.FMI.Adaptors.Examples;
model ThermalZone "Example of a thermal zone"
  extends Modelica.Icons.Example;
  constant Integer nFlu = 3 "Number of fluid connectors";

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  Buildings.Fluid.FMI.Adaptors.HVACConvective hvacAda(redeclare final package
      Medium=MediumA, nPorts=3)
    "Adaptor for an HVAC system that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 30*6*6
    "Nominal heat loss of the room";

  parameter Modelica.SIunits.Volume VRoo = 6*6*2.7 "Room volume";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=VRoo*2*1.2/3600
    "Nominal mass flow rate";


  Buildings.Fluid.FMI.Conversion.InletToAir con[nFlu](
    redeclare package Medium = MediumA) "Signal conversion"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-130,40},{-110,60}})));
  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false)
                     "Fan or pump"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));
  HeatExchangers.HeaterCooler_u
    hea(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=Q_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                                   "Heater"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
protected
  BaseClasses.X_w_toX x_w_toX[nFlu](redeclare final package Medium = MediumA)
    if
    MediumA.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
public
  Sources.Boundary_pT out(
    redeclare package Medium = MediumA,
    nPorts=3,
    use_T_in=true) "Pressure and temperature source for outdoor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-230,-20})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200) "Heat recovery"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    mSenFac=3,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=4,
    V=VRoo) "Room volume"
              annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
    Q_flow_nominal/20)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{170,-60},{150,-40}})));
  HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{200,-60},{180,-40}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=273.15 + 16 - 5*cos(time/86400*
    2*Modelica.Constants.pi)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{250,-60},{230,-40}})));
  Sources.MassFlowSource_T mSup[nFlu](
    redeclare each package Medium = MediumA,
    each use_T_in=true,
    each use_m_flow_in=true,
    each use_X_in=true,
    each nPorts=1)
    "Source for supply air into to zone (if m_flow < 0, this model extracts air from the room)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={124,12})));
  Sensors.MassFraction senMasFra(redeclare package Medium = MediumA)
    "Sensor for water mass fraction"
    annotation (Placement(transformation(extent={{190,40},{210,60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Temperature sensor for volume"
    annotation (Placement(transformation(extent={{130,-60},{110,-40}})));
  Movers.FlowControlled_m_flow exh(
    redeclare package Medium = MediumA,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    m_flow_nominal=0.1*m_flow_nominal) "Constant air exhaust"
    annotation (Placement(transformation(extent={{-142,-70},{-162,-50}})));
  Modelica.Blocks.Routing.Replicator repMasFra(nout=nFlu)
    "Signal replicator for mass fraction"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));
  Modelica.Blocks.Routing.Replicator repTRoo(nout=nFlu)
    "Signal replicator for room air temperature"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
equation
  connect(mov.port_b,hea. port_a) annotation (Line(points={{-130,10},{-130,10},{
          -100,10}},          color={0,127,255}));
  connect(hex.port_b1,mov. port_a) annotation (Line(points={{-180,-14},{-170,-14},
          {-170,10},{-150,10}}, color={0,127,255}));
  connect(out.ports[1],hex. port_b2) annotation (Line(points={{-220,-22.6667},{
          -210,-22.6667},{-210,-26},{-200,-26}},
                                  color={0,127,255}));
  connect(out.ports[2],hex. port_a1) annotation (Line(points={{-220,-20},{-210,-20},
          {-210,-14},{-200,-14}}, color={0,127,255}));
  connect(TOut.y,out. T_in) annotation (Line(points={{229,-50},{220,-50},{220,
          -80},{-250,-80},{-250,-24},{-242,-24}},
                                             color={0,0,127}));
  connect(conPI.y, hea.u) annotation (Line(points={{-109,50},{-106,50},{-106,16},
          {-102,16}}, color={0,0,127}));
  connect(hea.port_b, hvacAda.ports[1]) annotation (Line(points={{-80,10},{-40,
          10},{-40,12.6667}},
                          color={0,127,255}));
  connect(hvacAda.ports[2], hex.port_a2) annotation (Line(points={{-40,10},{-40,
          10},{-60,10},{-60,-26},{-180,-26}},
                                            color={0,127,255}));
  connect(TBou.port,theCon. port_a)
    annotation (Line(points={{180,-50},{170,-50}},
                                                 color={191,0,0}));
  connect(hvacAda.fluPor, con.inlet) annotation (Line(points={{-19,17},{0,17},{
          0,16},{0,10},{19,10}},
                             color={0,0,255}));
  connect(vol.heatPort, theCon.port_b) annotation (Line(points={{160,30},{160,
          30},{142,30},{142,-50},{150,-50}},
                                      color={191,0,0}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{42,6},{42,6},{62,6},{
          62,-20},{68,-20}},           color={0,0,127}));
  connect(mSup.X_in, x_w_toX.X) annotation (Line(points={{112,8},{100,8},{100,
          -20},{92,-20}},
                     color={0,0,127}));
  connect(mSup.T_in, con.T)
    annotation (Line(points={{112,16},{42,16},{42,14}},      color={0,0,127}));
  connect(mSup.m_flow_in, con.m_flow)
    annotation (Line(points={{114,20},{42,20},{42,18}},      color={0,0,127}));
  connect(mSup[1:3].ports[1], vol.ports[1:3])   annotation (Line(points={{134,12},
          {168,12},{168,20},{171,20}},
                                  color={0,127,255}));
  connect(conPI.u_s, TSet.y)
    annotation (Line(points={{-132,50},{-159,50}}, color={0,0,127}));
  connect(senMasFra.port, vol.ports[4]) annotation (Line(points={{200,40},{200,
          14},{173,14},{173,20}}, color={0,127,255}));
  connect(senTem.port, vol.heatPort) annotation (Line(points={{130,-50},{142,
          -50},{142,30},{160,30}},
                              color={191,0,0}));
  connect(TOut.y, TBou.T)
    annotation (Line(points={{229,-50},{202,-50}}, color={0,0,127}));
  connect(exh.port_b, out.ports[3]) annotation (Line(points={{-162,-60},{-182,
          -60},{-214,-60},{-214,-17.3333},{-220,-17.3333}},
                                                       color={0,127,255}));
  connect(exh.port_a, hvacAda.ports[3]) annotation (Line(points={{-142,-60},{
          -106,-60},{-50,-60},{-50,7.33333},{-40,7.33333}},
                                                       color={0,127,255}));
  connect(hvacAda.TAirZon[1], conPI.u_m) annotation (Line(points={{-36,
          -0.666667},{-36,-10},{-120,-10},{-120,38}},
                                           color={0,0,127}));
  connect(senTem.T, repTRoo.u)
    annotation (Line(points={{110,-50},{96,-50},{82,-50}}, color={0,0,127}));
  connect(repTRoo.y, con.TAirZon)
    annotation (Line(points={{59,-50},{24,-50},{24,-2}}, color={0,0,127}));
  connect(senMasFra.X, repMasFra.u)
    annotation (Line(points={{211,50},{218,50},{218,50}}, color={0,0,127}));
  connect(repMasFra.y, con.X_wZon) annotation (Line(points={{241,50},{250,50},{
          250,-34},{30,-34},{30,-2}}, color={0,0,127}));
 annotation (
    Diagram(coordinateSystem(extent={{-280,-120},{280,160}}), graphics={
        Rectangle(
          extent={{-260,140},{-10,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{12,140},{260,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-250,124},{-212,100}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
an HVAC system
in Modelica that could
be exposed as an FMU"),
        Text(
          extent={{30,118},{68,94}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
a thermal zone that
may be in an FMU
(but is here for simplicity
also implemented in Modelica)")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to
use the adaptor
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.HVACConvective\">
Buildings.Fluid.FMI.Adaptors.HVACConvective</a>.
On the left of the adaptor is an HVAC system with supply and return air stream,
and a forced exhaust air stream. These are all connected to the adaptor.
On the right of the adaptor is a simple room model, approximated by a volume with
first order dynamics and heat loss to the ambient.
</p>
<p>
Note that the there is zero net air flow into and out of the volume <code>vol</code>
because the adaptor <code>hvacAda</code> conserves mass. Hence, any infiltration or
exfiltration, as is done with the flow path that contains <code>exh</code>, needs to be
connected to the adaptor <code>hvacAda</code>, rather than the volume <code>vol</code>.
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
    experiment(StopTime=172800));
end ThermalZone;
