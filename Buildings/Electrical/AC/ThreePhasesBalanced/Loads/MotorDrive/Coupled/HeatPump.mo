within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled;
model HeatPump "Motor coupled heat pump"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
    m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  //Heat pump parameters
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal(max=0) = -P_nominal * COP_nominal
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
  parameter Modelica.Units.NonSI.AngularVelocity_rpm Nrpm_nominal=1500
    "Nominal rotational speed of compressor"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));

  //Efficiency
  parameter Boolean use_eta_Carnot_nominal = true
    "Set to true to use Carnot effectiveness etaCarnot_nominal rather than COP_nominal"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCarnot_nominal(unit="1")=COP_nominal/(TUseAct_nominal/(
    TCon_nominal + TAppCon_nominal - (TEva_nominal - TAppEva_nominal)))
    "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot_nominal = true"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot_nominal));
  parameter Real COP_nominal(unit="1")=etaCarnot_nominal*TUseAct_nominal/(
    TCon_nominal + TAppCon_nominal - (TEva_nominal - TAppEva_nominal))
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

  //Motor parameters
  parameter Integer pole=4 "Number of pole pairs";
  parameter Modelica.Units.SI.Resistance R_s=0.641
    "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.332
    "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=1.106
    "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.464
    "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=26.3
    "Complex component of the magnetizing reactance";
  parameter Modelica.Units.SI.Inertia JLoad(min=0)=2 "Load inertia";
  parameter Modelica.Units.SI.Inertia JMotor=2 "Motor inertia";

  //Controller parameters
  parameter Boolean have_controller = true
    "Set to true for enableing PID control";
  parameter Modelica.Blocks.Types.SimpleController
  controllerType=Modelica.Blocks.Types.SimpleController.PI
     "Type of controller"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller));
  parameter Real k(min=0) = 1
     "Gain of controller"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
     "Time constant of Integrator block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller and
  controllerType == Modelica.Blocks.Types.SimpleController.PI or
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
     "Time constant of Derivative block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller and
  controllerType == Modelica.Blocks.Types.SimpleController.PD or
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
     annotation (Dialog(tab="Advanced",
                       group="Controller",
                       enable=have_controller));
  parameter Real yMin=0
    "Lower limit of output"
     annotation (Dialog(tab="Advanced",
                       group="Controller",
                       enable=have_controller));

  final Modelica.Blocks.Sources.RealExpression loaTor(y=mecHea.shaft.tau)
    "Heat pump torque block"
    annotation (Placement(transformation(extent={{-20,12},{-40,32}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.HeatPump mecHea(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final QEva_flow_nominal=QEva_flow_nominal,
    final QCon_flow_nominal=QCon_flow_nominal,
    final dTEva_nominal=dTEva_nominal,
    final dTCon_nominal=dTCon_nominal,
    final P_nominal=P_nominal,
    final Nrpm_nominal=Nrpm_nominal,
    final use_eta_Carnot_nominal=use_eta_Carnot_nominal,
    final etaCarnot_nominal=etaCarnot_nominal,
    final a=a,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final TAppCon_nominal=TAppCon_nominal,
    final TAppEva_nominal=TAppEva_nominal)
    "Heat pump model with mechanical interface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput setPoi "Set point of control target"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));
  Modelica.Blocks.Interfaces.RealInput meaPoi "Measured value of control target"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}}),
        iconTransformation(extent={{-120,20},{-100,40}})));

  InductionMotors.SquirrelCageDrive simMot(
    P=pole,
    J=JMotor,
    Lr=X_r,
    Ls=X_s,
    Rr=R_r,
    Lm=X_m,
    Rs=R_s) annotation (Placement(transformation(extent={{-44,40},{-20,60}})));
protected
  constant Boolean COP_is_for_cooling = false
    "Set to true if the specified COP is for cooling";

  final parameter Modelica.Units.SI.Temperature TUseAct_nominal=
    if COP_is_for_cooling
      then TEva_nominal - TAppEva_nominal
      else TCon_nominal + TAppCon_nominal
    "Nominal evaporator temperature for chiller or condenser temperature for heat pump, 
    taking into account pinch temperature between fluid and refrigerant";

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
  connect(port_a1,mecHea. port_a1) annotation (Line(points={{-100,60},{-70,60},
          {-70,6},{-10,6}}, color={0,127,255}));
  connect(port_b2,mecHea. port_b2) annotation (Line(points={{-100,-60},{-60,-60},
          {-60,-6},{-10,-6}}, color={0,127,255}));
  connect(port_b1,mecHea. port_b1) annotation (Line(points={{100,60},{60,60},
          {60,6},{10,6}}, color={0,127,255}));
  connect(port_a2,mecHea. port_a2) annotation (Line(points={{100,-60},{60,-60},
          {60,-6},{10,-6}}, color={0,127,255}));
  connect(simMot.setPoi, setPoi) annotation (Line(points={{-45.8,58},{-60,58},
          {-60,90},{-110,90}},color={0,0,127}));
  connect(meaPoi, simMot.mea) annotation (Line(points={{-110,30},{-60,30},{
          -60,52},{-45.8,52}},                                   color={0,0,127}));
  connect(loaTor.y, simMot.tau_m) annotation (Line(points={{-41,22},{-50,22},
          {-50,42},{-45.8,42}},
                       color={0,0,127}));
  connect(terminal, simMot.terminal) annotation (Line(points={{0,100},{0,66},
          {-30,66},{-30,60}},         color={0,120,120}));
  connect(mecHea.shaft, simMot.shaft) annotation (Line(points={{0,10},{0,50},
          {-20,50}},            color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,
            -80},{100,100}}),
                       graphics={
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
        Line(points={{62,0},{80,0}}, color={0,0,255}),
        Line(points={{80,30},{100,30}}, color={0,0,255}),
        Line(points={{80,0},{80,30}}, color={0,0,255}),
        Line(points={{80,-30},{100,-30}}, color={0,0,255}),
        Line(points={{80,-30},{80,0}}, color={0,0,255})}),
        defaultComponentName="hea",
    Documentation(info="<html>
<p>
This is a model of a squirrel cage induction motor coupled heat pump with 
ideal speed control. The model has electrical interfaces and can be used for 
simulating microgrids and discussing grid interactions.
</p>
</html>", revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>Updated Implementation. </li>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-80},{100,100}})));
end HeatPump;
