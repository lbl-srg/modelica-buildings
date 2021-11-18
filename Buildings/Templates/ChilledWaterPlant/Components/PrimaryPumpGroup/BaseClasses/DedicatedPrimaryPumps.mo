within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.BaseClasses;
model DedicatedPrimaryPumps
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  // Pump parameters
  parameter Integer nPum "Number of pumps";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate per pump";
  parameter Modelica.SIunits.PressureDifference dp_nominal "Nominal pressure drop per pump";
  parameter Modelica.SIunits.PressureDifference dpValve_nominal "Nominal pressure drop of valve";

  // Initialization
  parameter Real threshold(min = 0.01) = 0.05
    "Hysteresis threshold";

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPum](
    redeclare each final package Medium = Medium,
    each m_flow(min=0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-108,-30},{-92,30}}),
        iconTransformation(extent={{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare each final package Medium = Medium,
    each m_flow(max=0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));

  replaceable parameter Fluid.Movers.Data.Generic per(pressure(
    V_flow=m_flow_nominal/1000 .* {0,1,2},
    dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
  replaceable Fluid.Movers.SpeedControlled_y pum[nPum](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare each final package Medium=Medium,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each final per=per) "Pumps"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nPum](
    t=1E-2, h=0.5E-2) "Evaluate pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,70})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nPum](
    each final uLow=threshold, each final uHigh=2*threshold)
    "Hysteresis for isolation valves"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Boolean to real conversion for isolation valves"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Fluid.Actuators.Valves.TwoWayLinear val[nPum](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final dpValve_nominal=dpValve_nominal,
    each final m_flow_nominal=m_flow_nominal)
    "Isolation valves"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Interfaces.RealInput y[nPum](unit="1")
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Interfaces.BooleanOutput y_actual[nPum]
    annotation (Placement(
        transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,70},
            {120,90}})));
  Fluid.MixingVolumes.MixingVolume vol(nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-30})));
equation
  connect(pum.port_b,val. port_a)
    annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(hys.y,booToRea. u)
    annotation (Line(points={{-38,50},{-22,50}}, color={255,0,255}));
  connect(booToRea.y,val. y)
    annotation (Line(points={{2,50},{20,50},{20,12}}, color={0,0,127}));
  connect(pum.y_actual,evaSta. u) annotation (Line(points={{-9,7},{10,7},{10,30},
          {30,30},{30,70},{38,70}},
                            color={0,0,127}));
  connect(evaSta.y, y_actual) annotation (Line(points={{62,70},{80,70},{80,70},
          {120,70}},color={255,0,255}));
  connect(y, hys.u) annotation (Line(points={{0,100},{0,72},{-80,72},{-80,50},{-62,
          50}}, color={0,0,127}));
  connect(y, pum.y) annotation (Line(points={{0,100},{0,72},{-80,72},{-80,20},{-20,
          20},{-20,12}}, color={0,0,127}));
  connect(val.port_b, vol.ports)
    annotation (Line(points={{30,0},{60,0},{60,-20}}, color={0,127,255}));
  connect(ports_a, pum.port_a)
    annotation (Line(points={{-100,0},{-30,0}}, color={0,127,255}));
  connect(vol.ports[1], port_b)
    annotation (Line(points={{60,-20},{60,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Text(extent={{-149,-114},{151,-154}},lineColor={0,0,255},textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                                               Text(
          extent={{-60,-60},{100,-100}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end DedicatedPrimaryPumps;
