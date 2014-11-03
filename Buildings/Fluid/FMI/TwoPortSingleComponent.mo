within Buildings.Fluid.FMI;
block TwoPortSingleComponent
  "Container to export a single thermofluid flow model with two ports as an FMU"
  extends TwoPort;
  replaceable Modelica.Fluid.Interfaces.PartialTwoPort com constrainedby
    Modelica.Fluid.Interfaces.PartialTwoPort(
      redeclare final package Medium = Medium,
      final allowFlowReversal=allowFlowReversal)
    "Component that holds actual model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
equation
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouIn.port, com.port_a) annotation (Line(
      points={{-60,0},{-42,0},{-42,4.44089e-16},{-10,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPre.port_a, com.port_a) annotation (Line(
      points={{-10,-34},{-40,-34},{-40,4.44089e-16},{-10,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pOut.u1, bouIn.p) annotation (Line(
      points={{12,-60},{-70,-60},{-70,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senRelPre.p_rel, pOut.u2) annotation (Line(
      points={{4.44089e-16,-43},{4.44089e-16,-80},{20,-80},{20,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouOut.port, com.port_b) annotation (Line(
      points={{60,0},{10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPre.port_b, com.port_b) annotation (Line(
      points={{10,-34},{40,-34},{40,0},{10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pOut.y, bouOut.p) annotation (Line(
      points={{29,-60},{70,-60},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TwoPortSingleComponent;
