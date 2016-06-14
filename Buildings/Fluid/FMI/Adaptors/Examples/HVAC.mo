within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
  extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.ThermalZone theZonAda(
    redeclare final package Medium = MediumA, nFluPor=1)
    "Adaptor for a thermal zone in Modelica that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{-18,-2},{2,18}})));

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
    annotation (Placement(transformation(extent={{-54,16},{-34,36}})));

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    V=V,
    mSenFac=3,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2) annotation (Placement(transformation(extent={{44,24},{64,44}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
    Q_flow_nominal/20)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{56,-52},{36,-32}})));

  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-150,22},{-130,42}})));

  Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-122,22},{-102,42}})));

  Modelica.Blocks.Sources.Constant mFan_flow(k=m_flow_nominal)
    "Mass flow rate of the fan"
    annotation (Placement(transformation(extent={{-148,-18},{-128,2}})));

  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200) "Fan or pump"
    annotation (Placement(transformation(extent={{-126,-40},{-106,-20}})));

  HeatExchangers.HeaterCooler_u
    hea(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-88,16},{-68,36}})));
protected
  Sources.MassFlowSource_T bou(
    redeclare final package Medium = MediumA,
    final use_m_flow_in=false,
    final use_T_in=true,
    final use_X_in=MediumA.nXi > 0,
    final use_C_in=MediumA.nC > 0,
    nPorts=1,
    final m_flow=m_flow_nominal)
    "Boundary conditions for HVAC system"
    annotation (Placement(transformation(extent={{-76,-50},{-96,-30}})));
  BaseClasses.X_w_toX
    x_w_toX(
    redeclare final package Medium = MediumA) if
    MediumA.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-34,-52},{-50,-36}})));
public
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    linearized=true,
    dp_nominal=100)
    "Flow resistance to decouple pressure state from boundary"
    annotation (Placement(transformation(extent={{66,-14},{86,6}})));
  Sources.FixedBoundary bouCon(redeclare package Medium = MediumA, nPorts=1)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{116,-14},{96,6}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=273.15 + 16 - 5*cos(time/86400*
    2*Modelica.Constants.pi)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{122,-52},{102,-32}})));
  HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{88,-52},{68,-32}})));
equation
  connect(theCon.port_b, theZonAda.heaPorAir) annotation (Line(points={{36,-42},
          {20,-42},{20,0},{2,0}},     color={191,0,0}));
  connect(vol.heatPort, theZonAda.heaPorAir) annotation (Line(points={{44,34},{20,
          34},{20,0},{2,0}},         color={191,0,0}));
  connect(TSet.y, conPI.u_s)
    annotation (Line(points={{-129,32},{-129,32},{-124,32}}, color={0,0,127}));
  connect(mov.port_b, hea.port_a) annotation (Line(points={{-106,-30},{-96,-30},
          {-96,26},{-88,26}}, color={0,127,255}));
  connect(hea.port_b, bouOut.port_a)
    annotation (Line(points={{-68,26},{-68,26},{-54,26}}, color={0,127,255}));
  connect(conPI.y, hea.u)
    annotation (Line(points={{-101,32},{-101,32},{-90,32}}, color={0,0,127}));
  connect(theZonAda.TAirZon, conPI.u_m) annotation (Line(points={{-20.2,10.8},{-112,
          10.8},{-112,20}}, color={0,0,127}));
  connect(bou.T_in, conPI.u_m) annotation (Line(points={{-74,-36},{-62,-36},{-62,
          8},{-112,8},{-112,20}}, color={0,0,127}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{-51.6,-44},{-51.6,-44},
          {-74,-44}}, color={0,0,127}));
  connect(theZonAda.CZon, bou.C_in) annotation (Line(points={{-20.2,1},{-58,1},{
          -58,-48},{-76,-48}}, color={0,0,127}));
  connect(mFan_flow.y, mov.m_flow_in) annotation (Line(points={{-127,-8},{-116.2,
          -8},{-116.2,-18}}, color={0,0,127}));
  connect(x_w_toX.X_w, theZonAda.X_wZon) annotation (Line(points={{-32.4,-44},{-30,
          -44},{-30,6.2},{-20.2,6.2}}, color={0,0,127}));
  connect(theZonAda.ports[1], vol.ports[1])
    annotation (Line(points={{2,8},{44,8},{52,8},{52,24}}, color={0,127,255}));
  connect(bou.ports[1], mov.port_a) annotation (Line(points={{-96,-40},{-114,-40},
          {-130,-40},{-130,-30},{-126,-30}}, color={0,127,255}));
  connect(bouOut.outlet, theZonAda.fluPor[1]) annotation (Line(points={{-33,26},
          {-28,26},{-28,16},{-20.2,16}}, color={0,0,255}));
  connect(res.port_b, bouCon.ports[1])
    annotation (Line(points={{86,-4},{96,-4}}, color={0,127,255}));
  connect(TBou.port, theCon.port_a)
    annotation (Line(points={{68,-42},{56,-42}}, color={191,0,0}));
  connect(TOut.y, TBou.T)
    annotation (Line(points={{101,-42},{90,-42}}, color={0,0,127}));
  connect(res.port_a, vol.ports[2]) annotation (Line(points={{66,-4},{66,-4},{56,
          -4},{56,24}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-100},{140,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-154,86},{8,-90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{16,86},{130,-88}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-150,84},{-112,60}},
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
          extent={{20,86},{58,62}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
a thermal zone
in Modelica that could
be exposed as an FMU")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to 
use the <a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">
Buildings.Fluid.FMI.HVACAdaptor
</a>. 
On the left of the adaptor is 
a simplified HVAC system modeled with a PI controller, a fan 
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow
</a>
and a heater 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u
</a> which
adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> 
to the medium.
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
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/HVAC.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HVAC;
