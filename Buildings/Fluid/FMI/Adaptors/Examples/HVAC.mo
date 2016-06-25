within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
  extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.ThermalZone theZonAda(
    redeclare final package Medium = MediumA, nFluPor=1)
    "Adaptor for a thermal zone in Modelica that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Integer nFluPorts=1 "Number of fluid ports.";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 30*6*6
    "Nominal heat loss of the room";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  Outlet bouOut(
    redeclare package Medium = MediumA,
    final allowFlowReversal=false,
    final use_p_in=false)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    V=V,
    mSenFac=3,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2) annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
    Q_flow_nominal/20)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{54,-70},{34,-50}})));

  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-148,40},{-128,60}})));

  Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

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
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  HeatExchangers.HeaterCooler_u
    hea(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Sources.MassFlowSource_T bou(
    redeclare final package Medium = MediumA,
    final use_m_flow_in=false,
    final use_T_in=true,
    final use_X_in=MediumA.nXi > 0,
    final use_C_in=MediumA.nC > 0,
    final m_flow=m_flow_nominal,
    nPorts=1)
    "Boundary conditions for HVAC system"
    annotation (Placement(transformation(extent={{-78,-70},{-98,-50}})));
  BaseClasses.X_w_toX
    x_w_toX(
    redeclare final package Medium = MediumA) if
    MediumA.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-38,-72},{-54,-56}})));
public
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    linearized=true,
    dp_nominal=100)
    "Flow resistance to decouple pressure state from boundary"
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  Sources.Boundary_pT   bouCon(redeclare package Medium = MediumA, nPorts=1,
    use_T_in=true)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{120,-20},{100,0}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=273.15 + 16 - 5*cos(time/86400*
    2*Modelica.Constants.pi)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{86,-70},{66,-50}})));
  Sources.Boundary_pT out(
    redeclare package Medium = MediumA,
    nPorts=2,
    use_T_in=true) "Pressure and temperature source for outdoor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-220,-20})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200) "Heat recovery"
    annotation (Placement(transformation(extent={{-190,-30},{-170,-10}})));
equation
  connect(theCon.port_b, theZonAda.heaPorAir) annotation (Line(points={{34,-60},
          {18,-60},{18,-18},{0,-18}}, color={191,0,0}));
  connect(vol.heatPort, theZonAda.heaPorAir) annotation (Line(points={{40,10},{18,
          10},{18,-18},{0,-18}},     color={191,0,0}));
  connect(TSet.y, conPI.u_s)
    annotation (Line(points={{-127,50},{-127,50},{-122,50}}, color={0,0,127}));
  connect(mov.port_b, hea.port_a) annotation (Line(points={{-120,10},{-120,10},
          {-90,10}},          color={0,127,255}));
  connect(hea.port_b, bouOut.port_a)
    annotation (Line(points={{-70,10},{-70,10},{-60,10}}, color={0,127,255}));
  connect(theZonAda.TAirZon, conPI.u_m) annotation (Line(points={{-22.2,-7.2},{-110,
          -7.2},{-110,38}}, color={0,0,127}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{-55.6,-64},{-55.6,-64},
          {-76,-64}}, color={0,0,127}));
  connect(theZonAda.CZon, bou.C_in) annotation (Line(points={{-22.2,-17},{-60,-17},
          {-60,-68},{-78,-68}},color={0,0,127}));
  connect(x_w_toX.X_w, theZonAda.X_wZon) annotation (Line(points={{-36.4,-64},{-32,
          -64},{-32,-12},{-28,-12},{-28,-11.8},{-22.2,-11.8}},
                                       color={0,0,127}));
  connect(theZonAda.ports[1], vol.ports[1])
    annotation (Line(points={{0,-10},{42,-10},{48,-10},{48,0}},
                                                           color={0,127,255}));
  connect(bouOut.outlet, theZonAda.fluPor[1]) annotation (Line(points={{-39,10},
          {-34,10},{-34,-2},{-22.2,-2}}, color={0,0,255}));
  connect(res.port_b, bouCon.ports[1])
    annotation (Line(points={{90,-10},{90,-10},{100,-10}},
                                               color={0,127,255}));
  connect(TBou.port, theCon.port_a)
    annotation (Line(points={{66,-60},{54,-60}}, color={191,0,0}));
  connect(TOut.y, TBou.T)
    annotation (Line(points={{99,-60},{88,-60}},  color={0,0,127}));
  connect(res.port_a, vol.ports[2]) annotation (Line(points={{70,-10},{70,-10},{
          52,-10},{52,0}},
                        color={0,127,255}));
  connect(theZonAda.TAirZon, bou.T_in) annotation (Line(points={{-22.2,-7.2},{-66,
          -7.2},{-66,-56},{-76,-56}},     color={0,0,127}));
  connect(hex.port_b1, mov.port_a) annotation (Line(points={{-170,-14},{-160,-14},
          {-160,10},{-140,10}}, color={0,127,255}));
  connect(bou.ports[1], hex.port_a2) annotation (Line(points={{-98,-60},{-160,-60},
          {-160,-26},{-170,-26}}, color={0,127,255}));
  connect(out.ports[1], hex.port_b2) annotation (Line(points={{-210,-22},{-200,-22},
          {-200,-26},{-190,-26}}, color={0,127,255}));
  connect(out.ports[2], hex.port_a1) annotation (Line(points={{-210,-18},{-200,-18},
          {-200,-14},{-190,-14}}, color={0,127,255}));
  connect(TOut.y, bouCon.T_in) annotation (Line(points={{99,-60},{94,-60},{94,-32},
          {132,-32},{132,-6},{122,-6}}, color={0,0,127}));
  connect(TOut.y, out.T_in) annotation (Line(points={{99,-60},{96,-60},{96,-82},
          {-238,-82},{-238,-24},{-232,-24}}, color={0,0,127}));
  connect(conPI.y, hea.u) annotation (Line(points={{-99,50},{-96,50},{-96,16},{
          -92,16}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-260,-100},{140,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-252,80},{-30,-96}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,80},{138,-96}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-244,70},{-206,46}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
an HVAC system that
may be in an FMU
(but is here for simplicity
also implemented in Modelica)"),
        Text(
          extent={{-14,72},{24,48}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
a thermal zone
in Modelica that could
be exposed as an FMU"),
        Text(
          extent={{-230,154},{-94,120}},
          lineColor={238,46,47},
          textString="fixme: this is wrong. 
mov.m_flow and bou.m_flow sum up to zero,
yet res.m_flow is not zero. Hence, this model
creates mass")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to 
use the <a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">
Buildings.Fluid.FMI.HVACAdaptor
</a>. 
On the left of the adaptor is 
a simplified HVAC system with constant volume flow rate,
heat recovery and feedback control that
adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> 
to the supply air.
</p>
<p>
The heater tracks the set point temperature of the volume air.
The set point temperature is different between night and day.
</p>
<p>
On the right of the adaptor is a simplified thermal zone model modeled
with a volume of air, and a heat conductor for steady-state
heat conduction to the outside. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2016, by Michael Wetter:<br/>
Revised example.
</li>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/HVAC.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HVAC;
