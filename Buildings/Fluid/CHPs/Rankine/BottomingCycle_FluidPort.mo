within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle_FluidPort
  "Model for the Rankine cycle as a bottoming cycle using fluid ports"
  extends BaseClasses.PartialBottomingCycle;
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  // Input properties

  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final linearizeFlowResistance=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final UA=50) "Evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,52})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  HeatTransfer.Sources.PrescribedTemperature preTem "Prescribed temperature"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Sensors.TemperatureTwoPort senTem(redeclare final package Medium = Medium,
      final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,42},{-60,62}})));
  Controls.OBC.CDL.Continuous.Limiter lim(uMax=Modelica.Constants.inf, uMin=
        TEva) "Limits the direction of heat transfer"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(eva.port_b, port_b)
    annotation (Line(points={{80,52},{100,52},{100,0}}, color={0,127,255}));
  connect(heaFloSen.port_b, eva.port_ref)
    annotation (Line(points={{20,10},{70,10},{70,46}}, color={191,0,0}));
  connect(preTem.port, heaFloSen.port_a)
    annotation (Line(points={{-20,10},{0,10}}, color={191,0,0}));
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-100,52},{-80,52}}, color={0,127,255}));
  connect(senTem.port_b, eva.port_a)
    annotation (Line(points={{-60,52},{60,52}}, color={0,127,255}));
  connect(heaFloSen.Q_flow, mulExp.u1)
    annotation (Line(points={{10,-1},{10,-24},{18,-24}}, color={0,0,127}));
  connect(heaFloSen.Q_flow, mulCon.u2) annotation (Line(points={{10,-1},{10,-24},
          {-24,-24},{-24,-86},{18,-86}}, color={0,0,127}));
  connect(lim.y, preTem.T)
    annotation (Line(points={{-58,10},{-42,10}}, color={0,0,127}));
  connect(lim.u, senTem.T) annotation (Line(points={{-82,10},{-90,10},{-90,63},{
          -70,63}}, color={0,0,127}));
annotation (defaultComponentName="ran",
    Icon(coordinateSystem(preserveAspectRatio=false)),         Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle.
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.Examples.ORC_HeatPort\">
Buildings.Fluid.CHPs.Rankine.Examples.ORCWithHeatExchangers</a>
demonstrates how this model can be connected with heat exchangers.
</html>", revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle_FluidPort;
