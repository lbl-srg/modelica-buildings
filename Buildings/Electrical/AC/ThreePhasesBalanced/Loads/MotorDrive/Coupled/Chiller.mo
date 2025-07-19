within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled;
model Chiller "Motor coupled chiller"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
    m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare final package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare final replaceable Interfaces.Terminal_n terminal);

  //Chiller parameters
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal(max=0) = -P_nominal * COP_nominal
    "Nominal cooling heat flow rate (Negative)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = P_nominal - QEva_flow_nominal
    "Nominal heating flow rate (Positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal(
    final max=0)=-10 "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal(
    final min=0)=10 "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power P_nominal(min=0)
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser
"   annotation (Dialog(group="Nominal condition"));
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
  parameter Boolean have_controller = true
    "Set to true for enableing PID control"
    annotation (Dialog(tab="Motor"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm Nrpm_nominal=1500
    "Nominal rotational speed of compressor"
    annotation (Dialog(tab="Motor"));
  parameter Modelica.Units.SI.Inertia loaIne=1 "Chiller inertia"
    annotation (Dialog(tab="Motor"));
  replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    per constrainedby Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record of induction motor with performance data"
    annotation (choicesAllMatching=true, Dialog(tab="Motor"), Placement(transformation(extent={{30,60},{50,80}})));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Motor", group="Controller", enable=have_controller));
  parameter Real k(min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Motor", group="Controller", enable=have_controller));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block"
    annotation (Dialog(tab="Motor", group="Controller",
                       enable=have_controller and
                              controllerType == Modelica.Blocks.Types.SimpleController.PI or
                              controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
    "Time constant of Derivative block"
    annotation (Dialog(tab="Motor", group="Controller",
                       enable=have_controller and
                              controllerType == Modelica.Blocks.Types.SimpleController.PD or
                              controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
    annotation (Dialog(tab="Motor", group="Controller", enable=have_controller));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(tab="Motor", group="Controller", enable=have_controller));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K")
    "Evaporator leaving temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMea(
    final unit="K")
    "Measured evaporator leaving temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electric power consumed"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Chiller mecChi(
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
    final loaIne=loaIne,
    final use_eta_Carnot_nominal=use_eta_Carnot_nominal,
    final etaCarnot_nominal=etaCarnot_nominal,
    final COP_nominal=COP_nominal,
    final TCon_nominal=TCon_nominal,
    final TEva_nominal=TEva_nominal,
    final a=a,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final TAppCon_nominal=TAppCon_nominal,
    final TAppEva_nominal=TAppEva_nominal,
    final P_nominal=P_nominal,
    final QEva_flow_nominal=QEva_flow_nominal,
    final QCon_flow_nominal=QCon_flow_nominal,
    final Nrpm_nominal=Nrpm_nominal)
    "Chiller model with mechanical interface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive
    simMot(
    final per=per,
    final reverseActing=false,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin) "Motor model"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

protected
  final parameter Modelica.Units.SI.Temperature TUseAct_nominal= TEva_nominal - TAppEva_nominal
    "Nominal evaporator temperature for chiller, taking into account pinch temperature between fluid and refrigerant";

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

  Modelica.Blocks.Sources.RealExpression loaTor(
    final y=mecChi.shaft.tau)
    "Chiller torque block"
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));

equation
  connect(port_a1, mecChi.port_a1) annotation (Line(points={{-100,60},{-80,60},{
          -80,6},{-10,6}},  color={0,127,255}));
  connect(port_b2, mecChi.port_b2) annotation (Line(points={{-100,-60},{-80,-60},
          {-80,-6},{-10,-6}}, color={0,127,255}));
  connect(mecChi.port_b1, port_b1) annotation (Line(points={{10,6},{80,6},{80,60},
          {100,60}}, color={0,127,255}));
  connect(mecChi.port_a2, port_a2) annotation (Line(points={{10,-6},{80,-6},{80,
          -60},{100,-60}},     color={0,127,255}));
  connect(TSet, simMot.setPoi) annotation (Line(points={{-120,80},{-60,80},{-60,
          58},{-42,58}}, color={0,0,127}));
  connect(TMea, simMot.mea) annotation (Line(points={{-120,30},{-60,30},{-60,50},
          {-42,50}}, color={0,0,127}));
  connect(loaTor.y, simMot.tau_m) annotation (Line(points={{-41,20},{-50,20},{
          -50,42},{-42,42}},  color={0,0,127}));
  connect(simMot.terminal, terminal) annotation (Line(points={{-30,60},{-30,86},
          {0,86},{0,100}}, color={0,120,120}));
  connect(mecChi.shaft, simMot.shaft) annotation (Line(points={{0,10},{0,50},{
          -20,50}}, color={0,0,0}));
  connect(mecChi.P, P)
    annotation (Line(points={{11,0},{120,0}}, color={0,0,127}));
  connect(mecChi.QCon_flow, QCon_flow) annotation (Line(points={{11,9},{70,9},{70,
          90},{120,90}}, color={0,0,127}));
  connect(mecChi.QEva_flow, QEva_flow) annotation (Line(points={{11,-9},{70,-9},
          {70,-30},{120,-30}}, color={0,0,127}));

annotation (defaultComponentName="chi",
  Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},
            {100,100}}), graphics={
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
        Line(points={{20,68},{20,74},{20,90},{90,90},{100,90}},color={0,0,255}),
        Line(points={{62,0},{100,0}},color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}},color={0,0,255})}),
    Documentation(info="<html>
<p>This is a model of a squirrel cage induction motor coupled chiller with ideal speed control. The chiller operation is regulated such that TMea is able to reach the TSet. The model has electrical interfaces and can be used for simulating microgrids and discussing grid interactions.</p>
<p>Using the &apos;per&apos; parameter, the user can set desired equivalent motor that closely matches with the chiller&apos;s rating based on manufacturer datasheet.</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
Updated Implementation.
</li>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end Chiller;
