within Buildings.Fluid.FMI.Conversion.Validation;
model AirToOutletFlowReversal
  "Validation model for air to outlet converter with flow reversal enabled"
  extends Buildings.Fluid.FMI.Conversion.Validation.AirToOutlet(
    allowFlowReversal = true);
  BoundaryCondition bouAirNoC(
    redeclare package Medium = Buildings.Media.Air (
      X_default={0.015, 0.985}))
      "Boundary condition" annotation (Placement(
        transformation(extent={{40,50},{60,70}})));
  BoundaryCondition bouAirWithC(
    redeclare package Medium = Buildings.Media.Air (
    X_default={0.015, 0.985},
    extraPropertiesNames={"CO2"}))
   "Boundary condition" annotation (Placement(
        transformation(extent={{40,10},{60,30}})));
  BoundaryCondition bouDryAirNoC(
    redeclare package Medium = Modelica.Media.Air.SimpleAir)
    "Boundary condition" annotation (Placement(
        transformation(extent={{40,-40},{60,-20}})));
  BoundaryCondition bouDryAirWithC(
    redeclare package Medium = Modelica.Media.Air.SimpleAir (
      extraPropertiesNames={"CO2"}))
     "Boundary condition" annotation (Placement(
        transformation(extent={{40,-80},{60,-60}})));

protected
  model BoundaryCondition
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component";

    final parameter Boolean use_p_in=false
      "= true to use a pressure from connector, false to output Medium.p_default";

    Adaptors.Inlet bouInlAirNoC(
      redeclare package Medium = Medium,
      allowFlowReversal=true,
      use_p_in=false)                "Boundary condition for air inlet"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Sources.Boundary_pT bou(
      redeclare package Medium = Medium,
      nPorts=1,
      p=Medium.p_default + 1000,
      T=298.15,
      C=fill(0.7, Medium.nC)) "Boundary condition"
      annotation (Placement(transformation(extent={{60,-10},{40,10}})));
    Interfaces.Inlet inlet(
      use_p_in=use_p_in,
      redeclare package Medium = Medium,
      allowFlowReversal=true)
      "Fluid inlet"
      annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

    FixedResistances.PressureDrop res(
      redeclare package Medium = Medium,
      m_flow_nominal=0.1,
      dp_nominal=1000,
      linearized=true) "Flow resistance"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(bouInlAirNoC.inlet, inlet)
      annotation (Line(points={{-61,0},{-110,0}}, color={0,0,255}));
    connect(res.port_b, bou.ports[1])
      annotation (Line(points={{10,0},{10,0},{40,0}}, color={0,127,255}));
    connect(res.port_a, bouInlAirNoC.port_b)
      annotation (Line(points={{-10,0},{-10,0},{-40,0}}, color={0,127,255}));
  end BoundaryCondition;

equation
  connect(bouAirNoC.inlet, conAirNoC.outlet)
    annotation (Line(points={{39,60},{21,60}}, color={0,0,255}));
  connect(bouAirWithC.inlet, conAirWithC.outlet)
    annotation (Line(points={{39,20},{21,20}},         color={0,0,255}));
  connect(bouDryAirNoC.inlet, conDryAirNoC.outlet)
    annotation (Line(points={{39,-30},{21,-30}},          color={0,0,255}));
  connect(bouDryAirWithC.inlet, conDryAirWithC.outlet)
    annotation (Line(points={{39,-70},{21,-70}},          color={0,0,255}));
  annotation (Documentation(info="<html>
<p>
This example is identical to
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.Validation.AirToOutlet\">
Buildings.Fluid.FMI.Conversion.Validation.AirToOutlet</a>,
except that it has reverse flow.
This tests whether the fluid properties from
the upstream media are correctly converted to
the output signals of
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.AirToOutlet\">
Buildings.Fluid.FMI.Conversion.AirToOutlet</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/AirToOutletFlowReversal.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end AirToOutletFlowReversal;
