within Buildings.Templates.ChilledWaterPlant.Components.BaseClasses;
model ParallelPumps
  extends Fluid.Interfaces.PartialTwoPortInterface;

  // Pump parameters
  parameter Integer nPum "Number of pumps";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate per pump";
  parameter Modelica.Units.SI.PressureDifference dp_nominal "Nominal pressure drop per pump";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal "Nominal pressure drop of valve";

  // Initialization
  parameter Real threshold(min = 0.01) = 0.05
    "Hysteresis threshold";

  replaceable parameter Fluid.Movers.Data.Generic per(pressure(
    V_flow=m_flow_nominal/1000 .* {0,1,2},
    dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  replaceable Fluid.Movers.SpeedControlled_y pum[nPum](each energyDynamics=
        Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare each final package Medium=Medium,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each final per=per) "Pumps"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nPum](
    each t=1E-2,
    each h=0.5E-2) "Evaluate pump status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,70})));
  Fluid.FixedResistances.CheckValve cheVal[nPum](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final dpValve_nominal=dpValve_nominal,
    each final m_flow_nominal=m_flow_nominal)
    "Isolation valves"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y[nPum](each final unit="1")
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y_actual[nPum]
    annotation (Placement(
        transformation(extent={{100,50},{140,90}}), iconTransformation(extent={{100,70},
            {120,90}})));
  Fluid.Delays.DelayFirstOrder del_b(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal*nPum,
    nPorts=nPum+1)                                                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-30})));
  Fluid.Delays.DelayFirstOrder del_a(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal*nPum,
    nPorts=nPum+1)                                                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-30})));
equation
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{10,0},{40,0}},  color={0,127,255}));
  connect(pum.y_actual,evaSta.u) annotation (Line(points={{11,7},{20,7},{20,70},
          {38,70}},         color={0,0,127}));
  connect(evaSta.y, y_actual) annotation (Line(points={{62,70},{70,70},{70,70},
          {120,70}},color={255,0,255}));
  connect(y, pum.y) annotation (Line(points={{0,100},{0,12}},
                         color={0,0,127}));
  connect(port_a, del_a.ports[nPum+1])
    annotation (Line(points={{-100,0},{-70,0},{-70,-20}}, color={0,127,255}));
  connect(cheVal.port_b, del_b.ports[1:nPum])
    annotation (Line(points={{60,0},{70,0},{70,-20}}, color={0,127,255}));
  connect(pum.port_a, del_a.ports[1:nPum])
    annotation (Line(points={{-10,0},{-70,0},{-70,-20}}, color={0,127,255}));
  connect(port_b, del_b.ports[nPum+1])
    annotation (Line(points={{100,0},{70,0},{70,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                                               Text(
          extent={{-60,-60},{100,-100}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end ParallelPumps;
