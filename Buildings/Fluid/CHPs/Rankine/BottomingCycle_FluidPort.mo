within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle_FluidPort
  "Model for the Rankine cycle as a bottoming cycle using fluid ports"
  extends BaseClasses.PartialBottomingCycle;
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.Units.SI.ThermalConductance UA
    "Thermal conductance of heat exchanger";

  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final UA=UA,
    from_dp=false,
    dp_nominal=0,
    linearizeFlowResistance=true) "Evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,70})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="Power",
    final unit="W") "Heat injected through evaporation"    annotation (
      Placement(transformation(extent={{100,40},{120,60}}), iconTransformation(
          extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput TOut(unit="K")
    "Outlet medium temperature" annotation (Placement(transformation(extent={{100,
            60},{120,80}}), iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput TInl(unit="K")
    "Inlet medium temperature" annotation (Placement(transformation(extent={{100,
            80},{120,100}}), iconTransformation(extent={{100,90},{120,110}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant SouTEva(final k=TEva) "Source block"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(eva.port_b, port_b)
    annotation (Line(points={{60,70},{70,70},{70,0},{100,0}},
                                                        color={0,127,255}));
  connect(heaFloSen.port_b, eva.port_ref)
    annotation (Line(points={{20,30},{50,30},{50,64}}, color={191,0,0}));
  connect(preTem.port, heaFloSen.port_a)
    annotation (Line(points={{-20,30},{0,30}}, color={191,0,0}));
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-100,70},{-60,70}}, color={0,127,255}));
  connect(senTem.port_b, eva.port_a)
    annotation (Line(points={{-40,70},{40,70}}, color={0,127,255}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{61,74},{90,74},{90,50},
          {110,50}}, color={0,0,127}));
  connect(min1.y, preTem.T)
    annotation (Line(points={{-58,30},{-42,30}}, color={0,0,127}));
  connect(min1.u1, senTem.T) annotation (Line(points={{-82,36},{-90,36},{-90,90},
          {-50,90},{-50,81}},
                     color={0,0,127}));
  connect(SouTEva.y, min1.u2) annotation (Line(points={{-59,-30},{-56,-30},{-56,
          0},{-88,0},{-88,24},{-82,24}}, color={0,0,127}));
  connect(eva.T, TOut) annotation (Line(points={{61,78},{94,78},{94,70},{110,70}},
        color={0,0,127}));
  connect(senTem.T, TInl)
    annotation (Line(points={{-50,81},{-50,90},{110,90}}, color={0,0,127}));
  connect(heaFloSen.Q_flow, mulExp.u1)
    annotation (Line(points={{10,19},{10,-24},{18,-24}}, color={0,0,127}));
  connect(heaFloSen.Q_flow, mulCon.u2) annotation (Line(points={{10,19},{10,-24},
          {-30,-24},{-30,-86},{18,-86}}, color={0,0,127}));
annotation (defaultComponentName="ORC",
    Icon(coordinateSystem(preserveAspectRatio=false)),         Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle and interfaces with
other components via the fluid ports. It is implemented in a way that
it prevents heat back flow on the evaporator side when the medium temperature
drops below the working fluid temperature.
</html>", revisions="<html>
<ul>
<li>
June 30, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle_FluidPort;
