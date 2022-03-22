within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.Coupled;
model Pump "Motor coupled chiller"
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
  port_a(p(start=Medium.p_default)),
  port_b(p(start=Medium.p_default)));

  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  //Motor parameters
  parameter Integer pole = 4 "Number of pole pairs";
  parameter Integer n = 3 "Number of phases";
  parameter Modelica.Units.SI.Resistance R_s = 0.013
    "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r = 0.009
    "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s = 0.14
    "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r = 0.12
    "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m = 2.4
    "Complex component of the magnetizing reactance";
  parameter Modelica.Units.SI.Inertia JLoad = 2 "Pump inertia";
  parameter Modelica.Units.SI.Inertia JMotor(min=0) = 10 "Motor inertia";

  Modelica.Blocks.Sources.RealExpression loaTor(y=pum.shaft.tau) "Pump torque block"
    annotation (Placement(transformation(extent={{-20,20},{-40,40}})));
  ThermoFluid.Pump pum(
    redeclare package Medium = Medium,
    addPowerToMedium=addPowerToMedium,
    per=per) "Mechanical pump with a shaft port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power",unit="W")
    "Real power"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(quantity="Power",unit="var")
  "Reactive power"
    annotation (Placement(transformation(extent={{100,60},{120,80}}),
        iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealInput setPoi "Set point of control target" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput meaPoi "Measured value of control target" annotation (Placement(transformation(extent={{-120,40},
            {-100,60}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-10,-78},{10,-58}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));
  InductionMotors.SquirrelCageDrive simMot(
    pole=pole,
    n=n,
    J=JMotor,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation

  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}},color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(simMot.shaft, pum.shaft)
    annotation (Line(points={{-40,70},{0,70},{0,10}},   color={0,0,0}));
  connect(simMot.P, P) annotation (Line(points={{-38,78},{80,78},{80,90},{110,
          90}}, color={0,0,127}));
  connect(simMot.Q, Q) annotation (Line(points={{-38,74},{80,74},{80,70},{110,
          70}}, color={0,0,127}));
  connect(setPoi, simMot.setPoi) annotation (Line(points={{-110,80},{-88,80},{
          -88,78},{-62,78}}, color={0,0,127}));
  connect(meaPoi, simMot.mea) annotation (Line(points={{-110,50},{-88,50},{-88,
          74},{-62,74}}, color={0,0,127}));
  connect(loaTor.y, simMot.tau_m) annotation (Line(points={{-41,30},{-72,30},{-72,
          62},{-62,62}}, color={0,0,127}));
  connect(simMot.terminal, terminal) annotation (Line(points={{-50,80},{-50,100},
          {0,100}},                   color={0,120,120}));
  connect(pum.heatPort, heatPort) annotation (Line(points={{0,-6.8},{0,-20},{0,
          -68},{0,-68}},   color={191,0,0}));
  annotation (defaultComponentName="pum",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,16},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          visible=use_inputFilter,
          extent={{-10,44},{10,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-50},{54,0},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,16},{36,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Line(
          points={{10,90},{100,90}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,70},{100,70}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{66,104},{116,90}},
          textColor={0,0,127},
          textString="P"),
        Text(extent={{66,84},{116,70}},
          textColor={0,0,127},
          textString="Q"),
        Text(extent={{-140,108},{-90,94}},
          textColor={0,0,127},
          textString="set_point"),
        Text(extent={{-140,72},{-60,44}},
          textColor={0,0,127},
          textString="measure_value")}),
    Documentation(info="<html>
<p>This is a model of a squirrel cage induction motor coupled chiller with ideal speed control.</p>
</html>",
      revisions="<html>
<ul>
<li>September 15, 2021,
    by Mingzhe Liu:<br/>
    Refactored implementation to add mechanical interface and integrate inertia.
</li>
<li>6 March 2019, 
    by Yangyang Fu:<br/>
      First implementation.</li>
</ul>
</html>"));
end Pump;
