within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid;
model HeatPump "Heat pump with mechanical interface"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
    m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);

  //Heat pump parameters
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal = -P_nominal*(
      COP_nominal - 1)
    "Nominal cooling heat flow rate (Negative)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = P_nominal - QEva_flow_nominal
    "Nominal heating flow rate (Positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal(
    final max=0) = -10 "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal(
    final min=0) = 10 "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power P_nominal(min=0)
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm Nrpm_nominal=1500
    "Nominal rotational speed of compressor"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Inertia loaIne(min=0)=1 "Heat pump inertia"
    annotation (Dialog(group="Nominal condition"));

  //Efficiency
  parameter Boolean use_eta_Carnot_nominal = true
    "Set to true to use Carnot effectiveness etaCarnot_nominal rather than COP_nominal"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCarnot_nominal(unit="1") = COP_nominal/
    (TUseAct_nominal/(TCon_nominal+TAppCon_nominal - (TEva_nominal-TAppEva_nominal)))
    "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot_nominal = true"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot_nominal));
  parameter Real COP_nominal(unit="1") = etaCarnot_nominal*TUseAct_nominal/
    (TCon_nominal+TAppCon_nominal - (TEva_nominal-TAppEva_nominal))
    "Coefficient of performance at TEva_nominal and TCon_nominal, used if use_eta_Carnot_nominal = false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));
  parameter Modelica.Units.SI.Temperature TCon_nominal=303.15
    "Condenser temperature used to compute COP_nominal if use_eta_Carnot_nominal=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));
  parameter Modelica.Units.SI.Temperature TEva_nominal=278.15
    "Evaporator temperature used to compute COP_nominal if use_eta_Carnot_nominal=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));
  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, yPL=1)=1)"
    annotation (Dialog(group="Efficiency"));
  parameter Modelica.Units.SI.TemperatureDifference TAppCon_nominal(min=0) = if cp1_default < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in condenser"
    annotation (Dialog(group="Efficiency"));
  parameter Modelica.Units.SI.TemperatureDifference TAppEva_nominal(min=0) = if cp2_default < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in evaporator"
    annotation (Dialog(group="Efficiency"));
  parameter Boolean from_dp1=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistance1=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaM1=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dp2=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));
  parameter Boolean linearizeFlowResistance2=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));
  parameter Real deltaM2=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));
  parameter Modelica.Units.SI.Time tau1=60
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Units.SI.Temperature T1_start=Medium1.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Units.SI.Time tau2=60
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));
  parameter Modelica.Units.SI.Temperature T2_start=Medium2.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Evaporator and condenser"));

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electric power consumed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  Modelica.Units.SI.Torque tauHea "Heat pump torque";

  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Mechanical connector"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Fluid.HeatPumps.Carnot_y heaPum(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final dTEva_nominal=dTEva_nominal,
    final dTCon_nominal=dTCon_nominal,
    final use_eta_Carnot_nominal=use_eta_Carnot_nominal,
    final COP_nominal=COP_nominal,
    final TCon_nominal=TCon_nominal,
    final TEva_nominal=TEva_nominal,
    final etaCarnot_nominal=etaCarnot_nominal,
    final a=a,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final TAppCon_nominal=TAppCon_nominal,
    final TAppEva_nominal=TAppEva_nominal,
    final from_dp1=from_dp1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM1=deltaM1,
    final deltaM2=deltaM2,
    final tau1=tau1,
    final tau2=tau2,
    final T1_start=T1_start,
    final T2_start=T2_start,
    final energyDynamics=energyDynamics,
    final P_nominal=P_nominal) "Heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia ine(
    final J=loaIne,
    phi(fixed=true, start=0),
    w(fixed=true, start=0))
    "Heat pump inertia"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90, origin={0,80})));
  Modelica.Mechanics.Rotational.Sources.Torque tor "Torque source"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.RealExpression tauSor(
    final y=-tauHea)
    "Heat pump torque"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180, origin={-70,90})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor spe
    "Rotation speed in rad/s"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Modelica.Blocks.Math.UnitConversions.To_rpm to_rpm "Unit conversion"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));
  Modelica.Blocks.Math.MultiProduct speCub(nu=3) "Cubic calculation"
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  Modelica.Blocks.Math.Gain gaiSpe(
    final k=1/Nrpm_nominal)
    "Speed normalization"
    annotation (Placement(transformation(extent={{0,20},{-20,40}})));

initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be negative.");

protected
  constant Boolean COP_is_for_cooling = false
    "Set to true if the specified COP is for cooling";
  final parameter Modelica.Units.SI.Temperature TUseAct_nominal=
    if COP_is_for_cooling
      then TEva_nominal - TAppEva_nominal
      else TCon_nominal + TAppCon_nominal
    "Nominal evaporator temperature for chiller or condenser temperature for 
    heat pump, taking into account pinch temperature between fluid and refrigerant";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      p = Medium1.p_default,
      T = Medium1.T_default,
      X = Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      p = Medium2.p_default,
      T = Medium2.T_default,
      X = Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

equation
  heaPum.P = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.BaseClasses.Power(tauHea,spe.w,1e-6,1e-8);

  connect(port_a1, heaPum.port_a1) annotation (Line(points={{-100,60},{-80,60},{
          -80,6},{-10,6}}, color={0,127,255}));
  connect(port_b1, heaPum.port_b1) annotation (Line(points={{100,60},{80,60},{80,
          6},{10,6}}, color={0,127,255}));
  connect(port_b2, heaPum.port_b2) annotation (Line(points={{-100,-60},{-80,-60},
          {-80,-6},{-10,-6}}, color={0,127,255}));
  connect(port_a2, heaPum.port_a2) annotation (Line(points={{100,-60},{80,-60},{
          80,-6},{10,-6}},  color={0,127,255}));
  connect(tauSor.y, tor.tau) annotation (Line(points={{-59,90},{-50,90},{-50,70},
          {-42,70}}, color={0,0,127}));
  connect(ine.flange_a,spe. flange) annotation (Line(points={{0,70},{0,60},{30,60}},
          color={0,0,0}));
  connect(ine.flange_a, tor.flange) annotation (Line(points={{-1.77636e-15,70},
          {-20,70}}, color={0,0,0}));
  connect(spe.w,to_rpm. u) annotation (Line(points={{51,60},{60,60},{60,30},{42,
          30}}, color={0,0,127}));
  connect(to_rpm.y, gaiSpe.u) annotation (Line(points={{19,30},{2,30}},
          color={0,0,127}));
  connect(shaft, ine.flange_b) annotation (Line(points={{0,100},{0,90}},
          color={0,0,0}));
  connect(speCub.y, heaPum.y) annotation (Line(points={{-61.7,30},{-70,30},{-70,
          9},{-12,9}}, color={0,0,127}));
  connect(heaPum.P, P) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(heaPum.QCon_flow, QCon_flow) annotation (Line(points={{11,9},{70,9},{70,
          90},{110,90}}, color={0,0,127}));
  connect(heaPum.QEva_flow, QEva_flow) annotation (Line(points={{11,-9},{70,-9},
          {70,-90},{110,-90}}, color={0,0,127}));
  connect(gaiSpe.y, speCub.u[1]) annotation (Line(points={{-21,30},{-40,30},{
          -40,27.6667}},
                     color={0,0,127}));
  connect(gaiSpe.y, speCub.u[2]) annotation (Line(points={{-21,30},{-30,30},{-30,
          30},{-40,30}}, color={0,0,127}));
  connect(gaiSpe.y, speCub.u[3]) annotation (Line(points={{-21,30},{-40,30},{
          -40,32.3333}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,90},{0,36},{0,2},{18,2}},color={0,0,255}),
        Line(points={{20,68},{20,74},{20,90},{90,90},{100,90}},color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}},color={0,0,255}),
        Line(points={{62,0},{100,0}},color={0,0,255}),
        Text(extent={{70,24},{120,10}}, textString="P", textColor={0,0,127})}),
        defaultComponentName = "hea",
        Documentation(info="<html>
<p>
This model describes a heat pump with mechanical imterface and uses
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_y\">
Buildings.Fluid.HeatPumps.Carnot_y</a>
as a base model.The governing equation of this implementation is based on the
relationship between the power and torque of the rotating object, which is
represented as follow:
</p>
<p align=\"center\"><i>P&nbsp;=&nbsp;tau&nbsp;*&nbsp;W</i>
</p>
<p>
Where, the <i>P</i> is power [W], <i>tau</i> is torque [N.m], and <i>W</i>
is angular velocity [rad/s].
</p>
<h4>Assumption and limitation</h4>
<p>
This implementation assumes that the compressor is centrifugal
and the relationship between compressor power and speed ideally follows a
cubic relationship.
</p>
<h4>Reference</h4>
<p>
<span style=\"font-family: Arial;\"><a name=\":2k\" href=\"https://ieeexplore.ieee.org/abstract/document/8598849\">
Oliveira, Felipe, and Abhisek Ukil. &quot;Comparative performance analysis of
induction and synchronous reluctance motors in chiller systems for energy
efficient buildings.&quot;&nbsp;<i>IEEE Transactions on Industrial Informatics</i>&nbsp;15.8 (2019): 4384-4393.</a></span>
</p>
<p>
<span style=\"font-family: Arial;\"><a href=\"https://www.proquest.com/docview/2414053191?pq-origsite=gscholar\">
Lei Wang PhD, P. E., and Yasuko Sakurai. &quot;Optimize a Chilled-Water Plant
with Magnetic-Bearing Variable Speed Chillers.&quot;&nbsp;<i>ASHRAE Transactions</i>&nbsp;126 (2020): 725-735.</a></span>
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPump;
