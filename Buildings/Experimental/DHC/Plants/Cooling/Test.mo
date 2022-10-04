within Buildings.Experimental.DHC.Plants.Cooling;
model Test "Test model"

  package Medium=Buildings.Media.Water
    "Service side medium";

  final parameter Integer numChi=2
    "Number of chillers"
    annotation (Dialog(group="Chiller"));

  Buildings.Applications.BaseClasses.Equipment.FlowMachine_m pumCW(
    redeclare final package Medium = Medium,
    final per=fill(perCWPum, numChi),
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=1,
    final dpValve_nominal=100000,
    final num=numChi)
    "Condenser water pumps"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCW(redeclare final package Medium =
        Medium, nPorts=2)
    "Condenser water expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-10,-50})));
  Modelica.Blocks.Sources.Constant ySet[numChi](each k=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  parameter Buildings.Fluid.Movers.Data.Generic perCWPum(pressure=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
        V_flow=1/1000*{0.2,0.6,1.0,1.2}, dp=200000*{1.2,1.1,1.0,0.6}))
    "Performance data of condenser water pump" annotation (
    Dialog(group="Pump"),
    choicesAllMatching=true,
    Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(expTanCW.ports[1], pumCW.port_a) annotation (Line(points={{-11,-40},{-8,
          -40},{-8,-20},{-40,-20},{-40,10},{-20,10}}, color={0,127,255}));
  connect(expTanCW.ports[2], pumCW.port_b) annotation (Line(points={{-9,-40},{-8,
          -40},{-8,-20},{20,-20},{20,10},{0,10}}, color={0,127,255}));
  connect(ySet.y, pumCW.u) annotation (Line(points={{-59,30},{-28,30},{-28,14},
          {-22,14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test;
