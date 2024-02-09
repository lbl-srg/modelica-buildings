within Buildings.Templates.Components.Interfaces;
model PartialHeatPumpEquationFit
  "Interface for heat pump using equation fit model"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump(
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit);

  Modelica.Blocks.Routing.BooleanPassThrough y1Hea if is_rev
    "Operating mode command: true=heating, false=cooling"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,130})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1HeaNonRev(
    final k=true) if not is_rev
    "Placeholder signal for non-reversible heat pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,130})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1_actual
    "Compute heat pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,130})));
  Fluid.Sensors.MassFlowRate mChiHeaWat_flow(redeclare final package Medium =
        MediumHeaWat) "CHW/HW mass flow rate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatEnt(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW entering temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatLvg(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW leaving temperature"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Fluid.Sensors.TemperatureTwoPort TSouEnt(
    redeclare final package Medium = MediumSou, final m_flow_nominal=
        mSouHea_flow_nominal) "Source fluid entering temperature"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Fluid.Sensors.TemperatureTwoPort TSouLvg(
    redeclare final package Medium = MediumSou,
    final m_flow_nominal=
        mSouHea_flow_nominal) "Source fluid leaving temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-20})));
  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    uMod(start=0),
    redeclare final package Medium1=MediumHeaWat,
    redeclare final package Medium2=MediumSou,
    final per=dat.perFit,
    final energyDynamics=energyDynamics)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1Int
    "Convert on/off command into integer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,90})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1HeaInt(
    y(start=0),
    final integerTrue=1,
    final integerFalse=-1)
    "Convert heating mode command into integer"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,90})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Combine on/off and operating mode command signals"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,50})));
equation
  /* Control point connection - start */
  /* Control point connection - stop */
  connect(bus.y1Heat, y1Hea.u) annotation (Line(
      points={{0,160},{0,156},{-80,156},{-80,142}},
      color={255,204,51},
      thickness=0.5));
  connect(y1_actual.y, bus.y1_actual) annotation (Line(points={{60,142},{60,156},
          {0,156},{0,160}},
                          color={255,0,255}));
  connect(port_a, mChiHeaWat_flow.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(mChiHeaWat_flow.port_b, TChiHeaWatEnt.port_a)
    annotation (Line(points={{-70,0},{-60,0}}, color={0,127,255}));
  connect(TChiHeaWatLvg.port_b, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(TSouLvg.port_b, port_bSou) annotation (Line(points={{-40,-20},{-80,-20},
          {-80,-140}},      color={0,127,255}));
  connect(y1Hea.y, y1HeaInt.u) annotation (Line(points={{-80,119},{-80,110.5},{-80,
          110.5},{-80,102}}, color={255,0,255}));
  connect(y1HeaNonRev.y, y1HeaInt.u) annotation (Line(points={{-40,118},{-40,110},
          {-80,110},{-80,102}}, color={255,0,255}));
  connect(y1HeaInt.y, mulInt.u2) annotation (Line(points={{-80,78},{-80,70},{-26,
          70},{-26,62}}, color={255,127,0}));
  connect(y1Int.y, mulInt.u1) annotation (Line(points={{-20,78},{-20,70},{-14,70},
          {-14,62}}, color={255,127,0}));
  connect(mulInt.y, heaPum.uMod)
    annotation (Line(points={{-20,38},{-20,-6},{-11,-6}}, color={255,127,0}));
  connect(TChiHeaWatEnt.port_b, heaPum.port_a1)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(heaPum.port_b1, TChiHeaWatLvg.port_a)
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  connect(TSouLvg.port_a, heaPum.port_b2) annotation (Line(points={{-20,-20},{-20,
          -12},{-10,-12}}, color={0,127,255}));
  connect(TSouEnt.port_b, heaPum.port_a2)
    annotation (Line(points={{20,-20},{20,-12},{10,-12}}, color={0,127,255}));
  connect(bus.y1, y1Int.u) annotation (Line(
      points={{0,160},{0,110},{-20,110},{-20,102}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1, y1_actual.u) annotation (Line(
      points={{0,160},{0,110},{60,110},{60,118}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  defaultComponentName="heaPum",
  Documentation(info="<html>
FIXME: dTEva_nominal
<p>
This is a model for an air-to-water heat pump where the capacity
and drawn power are computed based on the equation fit method.
The model can be configured with the parameter <code>is_rev</code>
to represent either a non-reversible heat pump (heating only) or a 
reversible heat pump.
This model uses 
<a href=\\\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\\\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>,
which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Heat pump on/off command signal <code>y1</code>:
DO signal, with a dimensionality of zero
</li>
<li>For reversible heat pumps only (<code>is_rev=true</code>),
Heat pump operating mode command signal <code>y1Hea</code>:
DO signal, with a dimensionality of zero<br/>
(<code>y1Hea=true</code> for heating mode, 
<code>y1Hea=false</code> for cooling mode)
<li>
Heat pump supply temperature setpoint <code>TSet</code>:
AO signal, with a dimensionality of zero<br/>
(for reversible heat pumps, the setpoint value must be
switched externally between HW and CHW supply temperature)
</li>
<li>
Heat pump status <code>y1_actual</code>:
DI signal, with a dimensionality of zero
</li>
</ul>
</html>"));
end PartialHeatPumpEquationFit;
