within Buildings.Fluid.FMI;
block Fixme
  "Container to export a single thermofluid flow model with two ports as an FMU"
  import Buildings;
  extends TwoPort(redeclare package Medium =
        Buildings.Media.Water);
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Blocks.Math.Feedback pOut "Pressure at component outlet"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

protected
  BaseClasses.Inlet bouIn(redeclare final package Medium=Medium)
    "Boundary model for inlet"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BaseClasses.Outlet bouOut(redeclare final package Medium=Medium)
    "Boundary component for outlet"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Sensor for pressure difference across the component"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));
public
  Modelica.Blocks.Sources.Constant const(k=22222)
    annotation (Placement(transformation(extent={{-44,-90},{-24,-70}})));
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Fluid.Interfaces.ConservationEquation conservationEquation(
    nPorts=2,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    fluidVolume=1)
    annotation (Placement(transformation(extent={{6,0},{26,20}})));
public
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
public
  Modelica.Blocks.Sources.Constant const2(k=0)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pOut.u1, bouIn.p) annotation (Line(
      points={{12,-60},{-70,-60},{-70,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pOut.y, bouOut.p) annotation (Line(
      points={{29,-60},{70,-60},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouIn.port, res.port_a) annotation (Line(
      points={{-60,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_a, senRelPre.port_a) annotation (Line(
      points={{-40,0},{-42,0},{-42,-34},{-10,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, senRelPre.port_b) annotation (Line(
      points={{-20,0},{-6,0},{-6,-20},{10,-20},{10,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPre.p_rel, pOut.u2) annotation (Line(
      points={{0,-43},{-2,-43},{-2,-80},{20,-80},{20,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res.port_b, conservationEquation.ports[1]) annotation (Line(
      points={{-20,0},{-2,0},{-2,-4.44089e-16},{14,-4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const1.y, conservationEquation.Q_flow) annotation (Line(
      points={{-39,70},{-4,70},{-4,16},{4,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conservationEquation.ports[2], bouOut.port) annotation (Line(
      points={{18,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const2.y, conservationEquation.mWat_flow) annotation (Line(
      points={{-39,30},{-28,30},{-28,28},{-14,28},{-14,12},{4,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Fixme;
