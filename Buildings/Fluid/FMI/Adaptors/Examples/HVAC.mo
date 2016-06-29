within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
  extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.ThermalZone theZonAda(
    redeclare final package Medium = MediumA, nFluPor=2)
    "Adaptor for a thermal zone in Modelica that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Integer nFluPorts=1 "Number of fluid ports.";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 30*6*6
    "Nominal heat loss of the room";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  Outlet bou[2](
    redeclare each package Medium = MediumA,
    each final allowFlowReversal=true,
    each final use_p_in=false)
    "Model to convert between the fluid and the FMI signal connectors"
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})));

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    V=V,
    mSenFac=3,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2) annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
    Q_flow_nominal/20)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{64,-70},{44,-50}})));

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

  Movers.FlowControlled_m_flow fanSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Supply fan"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));

  HeatExchangers.HeaterCooler_u
    hea(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal) "Heater"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Modelica.Blocks.Sources.RealExpression TOut(y=273.15 + 16 - 5*cos(time/86400*
    2*Modelica.Constants.pi)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
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
protected
  Modelica.Blocks.Sources.Constant mFan_flow(final k=m_flow_nominal)
    "Mass flow rate for fans"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
public
  Movers.FlowControlled_m_flow fanRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    inputType=Buildings.Fluid.Types.InputType.Continuous) "Return fan"
    annotation (Placement(transformation(extent={{-132,-50},{-152,-30}})));
  Modelica.Blocks.Sources.RealExpression TRoo(
    y(unit="K", displayUnit="degC")=theZonAda.fluPor[1].backward.T)
    "Expression to access the room temperature from the FMI adaptor theZonAda"
    annotation (Placement(transformation(extent={{-38,-22},{-58,-2}})));
equation
  connect(theCon.port_b, theZonAda.heaPorAir) annotation (Line(points={{44,-60},
          {28,-60},{28,-18},{20,-18}},color={191,0,0}));
  connect(vol.heatPort, theZonAda.heaPorAir) annotation (Line(points={{50,10},{
          28,10},{28,-18},{20,-18}}, color={191,0,0}));
  connect(TSet.y, conPI.u_s)
    annotation (Line(points={{-127,50},{-127,50},{-122,50}}, color={0,0,127}));
  connect(fanSup.port_b, hea.port_a) annotation (Line(points={{-130,10},{-130,10},
          {-90,10}}, color={0,127,255}));
  connect(TBou.port, theCon.port_a)
    annotation (Line(points={{80,-60},{64,-60}}, color={191,0,0}));
  connect(TOut.y, TBou.T)
    annotation (Line(points={{119,-60},{102,-60}},color={0,0,127}));
  connect(hex.port_b1, fanSup.port_a) annotation (Line(points={{-170,-14},{-160,
          -14},{-160,10},{-150,10}}, color={0,127,255}));
  connect(out.ports[1], hex.port_b2) annotation (Line(points={{-210,-22},{-200,-22},
          {-200,-26},{-190,-26}}, color={0,127,255}));
  connect(out.ports[2], hex.port_a1) annotation (Line(points={{-210,-18},{-200,-18},
          {-200,-14},{-190,-14}}, color={0,127,255}));
  connect(TOut.y, out.T_in) annotation (Line(points={{119,-60},{112,-60},{112,
          -80},{-240,-80},{-240,-24},{-232,-24}},
                                             color={0,0,127}));
  connect(conPI.y, hea.u) annotation (Line(points={{-99,50},{-96,50},{-96,16},{
          -92,16}}, color={0,0,127}));
  connect(bou[1].port_a, hea.port_b)
    annotation (Line(points={{-58,10},{-70,10}}, color={0,127,255}));
  connect(bou[2].port_a, fanRet.port_a) annotation (Line(points={{-58,10},{-66,10},
          {-66,-40},{-132,-40}}, color={0,127,255}));
  connect(fanRet.port_b, hex.port_a2) annotation (Line(points={{-152,-40},{-152,
          -40},{-160,-40},{-160,-26},{-170,-26}}, color={0,127,255}));
  connect(mFan_flow.y, fanSup.m_flow_in) annotation (Line(points={{-179,30},{-140.2,
          30},{-140.2,22}}, color={0,0,127}));
  connect(mFan_flow.y, fanRet.m_flow_in) annotation (Line(points={{-179,30},{-154,
          30},{-154,-12},{-141.8,-12},{-141.8,-28}}, color={0,0,127}));
  connect(bou.outlet, theZonAda.fluPor[1:2]) annotation (Line(points={{-37,10},
          {-20,10},{-20,-2},{-20,-2},{-2.2,-2},{-2.2,-1}},
                                        color={0,0,255}));
  connect(theZonAda.ports[1], vol.ports[1]) annotation (Line(points={{20,-8},{
          20,-8},{58,-8},{58,0}},
                               color={0,127,255}));
  connect(theZonAda.ports[2], vol.ports[2]) annotation (Line(points={{20,-12},{
          20,-12},{62,-12},{62,0}},
                                 color={0,127,255}));
  connect(TRoo.y, conPI.u_m) annotation (Line(points={{-59,-12},{-84,-12},{-110,
          -12},{-110,38}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-260,-100},{160,140}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-252,134},{-30,-90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-12,134},{150,-90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-244,116},{-206,92}},
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
          extent={{2,122},{40,98}},
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
The HVAC system is connected to two instances of <code>bou</code>
which convert the fluid connectors to the FMI signal connectors.
Supply and return fan are controlled such that mass is balanced. Otherwise
the adaptor <code>theZonAda</code> would throw an assertion error
during the simulation.
If a user would want to have air infiltration, then this could be added with
a third fluid stream for the HVAC system. However, all mass flow rates connected
to <code>theZonAda.fluPor</code> need to sum up to zero.
</p>
<p>
On the right of the adaptor is a simplified thermal zone model modeled
with a volume of air, and a heat conductor for steady-state
heat conduction to the outside. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2016, by Michael Wetter:<br/>
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
