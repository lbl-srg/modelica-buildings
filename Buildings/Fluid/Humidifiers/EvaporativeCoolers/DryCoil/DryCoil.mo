within Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil;
model DryCoil "Dry coil model based on epsilon-NTU relation"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol1,
    final m1_flow_nominal = dat.Q_flow_nominal / cp_default / (dat.TCooOut_nominal - dat.TCooIn_nominal),
    final m2_flow_nominal = m1_flow_nominal / dat.ratCooAir_nominal,
    final dp1_nominal = dat.dp_nominal,
    final dp2_nominal = 0);
  Modelica.Blocks.Interfaces.RealOutput TLvg(
    final unit="K",
    displayUnit="degC") "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{70,-10},{90,10}})));
  Modelica.Units.SI.HeatFlowRate Q_flow=preHea.Q_flow
    "Heat input into water circuit";

  parameter Data.Generic
    dat "Performance data record"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  parameter Real yMin(min=0.01, max=1, final unit="1") = 0.3
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));
  final parameter Modelica.Units.SI.ThermalConductance UA_nominal = per.UA_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal = per.eps_nominal
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min = 0) = per.NTU_nominal "Nominal number of transfer units";

  Buildings.Fluid.Sensors.Temperature senTemAir(
    redeclare final package Medium = Medium2)
    "Entering air dry bulb temperature sensor"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Medium1.specificHeatCapacityCp(sta1_nominal)
    "Specific heat capacity";
  Modelica.Blocks.Sources.RealExpression QCoi_flow(final y = -per.Q_flow)
    "Coil heat flow rate"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow to water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-30})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaAir
    "Prescribed heat flow to air"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature in volume, leaving at port_b1"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Sources.RealExpression TCooIn(
    final y = Medium1.temperature(
      Medium1.setState_phX(
        p = port_a1.p,
        h = inStream(port_a1.h_outflow),
        X = inStream(port_a1.Xi_outflow)))) "Cooling loop fluid inlet temperature" annotation(
    Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.RealExpression mCoo_flow(final y = port_a1.m_flow) "Cooling fluid mass flow rate" annotation(
    Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.RealExpression mAir_flow(final y = port_a2.m_flow)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  BaseClasses.DryCoil per(
    redeclare final package Medium = Medium1,
    final dat=dat,
    final m_flow_nominal=m1_flow_nominal,
    final yMin=yMin) "Model for thermal performance"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(port_a2, senTemAir.port) annotation (Line(
      points={{100,-60},{50,-60},{50,-40}},
      color={0,127,255}));
  connect(preHea.port, vol1.heatPort) annotation (Line(
      points={{0,-30},{-16,-30},{-16,60},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.port, vol1.heatPort) annotation (Line(
      points={{20,40},{-16,40},{-16,60},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.T, TLvg) annotation (Line(
      points={{41,40},{80,40},{80,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemAir.T, per.TDryBul) annotation (Line(
      points={{57,-30},{70,-30},{70,20},{-60,20},{-60,-6},{-42,-6}},
      color={0,0,127}));
  connect(per.Q_flow, preHea.Q_flow) annotation(
    Line(points={{-19,-10},{30,-10},{30,-30},{20,-30}},                             color = {0, 0, 127}));
  connect(QCoi_flow.y, preHeaAir.Q_flow) annotation (Line(
      points={{-59,-90},{-40,-90}},
      color={0,0,127}));
  connect(preHeaAir.port, vol2.heatPort) annotation (Line(
      points={{-20,-90},{40,-90},{40,-60},{12,-60}},
      color={191,0,0}));
  connect(per.m_flow, mCoo_flow.y) annotation(
    Line(points={{-42,-18},{-70,-18},{-70,-30},{-79,-30}},      color = {0, 0, 127}));
  connect(TCooIn.y, per.TCooIn) annotation(
    Line(points={{-79,-10},{-70,-10},{-70,-14},{-42,-14}},      color = {0, 0, 127}));
  connect(mAir_flow.y, per.mAir_flow) annotation (Line(
      points={{-79,10},{-70,10},{-70,-2},{-42,-2}},
      color={0,0,127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false),
      graphics = {
        Text(origin = {-2, 0},textColor={255,255,255}, extent = {{-54, 6}, {58, -114}},
          textString="DryCoil")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
Model for a steady-state or dynamic dry cooling tower with a variable speed fan
using epsilon-NTU method for heat transfer. The entering air temperature and
mass flow rate are obtained from <code>port_a2</code>. The air-side nominal
mass flow rate is derived from <code>dat.ratCooAir_nominal</code>, and the
air-side nominal pressure drop is zero.
</p>
<h4>Thermal performance</h4>
<p>
To compute the thermal performance, this model takes as parameters
the nominal cooling capacity, air dry-bulb temperature, and
cooling fluid (water or glycol) inlet and outlet temperatures
as specified in the data record
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic</a>.
The cooling tower performance is
modeled using the effectiveness-NTU relationship for
a crossflow configuration.
</p>
<p>
Changes in convective heat transfer coefficient on the coolant-side and
the air-side due to change in flow rate and temperature are taken into account
using the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
This correction can be configured in the data record
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic</a>.
</p>
</html>", revisions = "<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCoil;
