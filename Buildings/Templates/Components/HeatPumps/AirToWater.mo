within Buildings.Templates.Components.HeatPumps;
model AirToWater "Air-to-water heat pump"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump(
    redeclare replaceable package MediumSou=Buildings.Media.Air,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    bou(nPorts=3));

  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    uMod(start=0),
    redeclare final package Medium1 = MediumLoa,
    redeclare final package Medium2 = MediumSou,
    final per=dat.per,
    final energyDynamics=energyDynamics)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData souAir(
    redeclare final package Medium=MediumSou,
    final use_m_flow_in=true,
    nPorts=1)
    "Air flow source"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1Int
    "Convert on/off command into integer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger y1HeaInt(
    y(start=0),
    final integerTrue=1,
    final integerFalse=-1)
    "Convert heating mode command into integer"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,30})));
  Modelica.Blocks.Routing.BooleanPassThrough y1Hea if is_rev
    "Operating mode command: true=heating, false=cooling"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1HeaNonRev(
    final k=true) if not is_rev
    "Placeholder signal for non-reversible heat pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,70})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Combine on/off and operating mode command signals"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-10})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAir_flow(
    k=max(dat.per.hea.mSou_flow,
    dat.per.coo.mSou_flow))
    "Air mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert on/off command into real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1_actual "Compute heat pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,70})));
equation
  connect(port_a, heaPum.port_a1)
    annotation (Line(points={{-100,0},{-96,0},{-96,-28},{-10,-28}},
    color={0,127,255}));
  connect(heaPum.port_b1, port_b)
    annotation (Line(points={{10,-28},{96,-28},{96,0},{100,0}},
    color={0,127,255}));
  connect(souAir.ports[1], heaPum.port_a2)
    annotation (Line(points={{40,-50},{40,-40},{10,-40}}, color={0,127,255}));
  connect(heaPum.port_b2, bou.ports[3])
    annotation (Line(points={{-10,-40},{-40,-40},{-40,-80},{0,-80}}, color={0,127,255}));
  connect(busWea, souAir.weaBus) annotation (Line(
      points={{-60,100},{-60,90},{-90,90},{-90,-70},{40.2,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1, y1Int.u) annotation (Line(
      points={{0,100},{0,50},{-20,50},{-20,42}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Heat, y1Hea.u) annotation (Line(
      points={{0,100},{0,90},{-40,90},{-40,82}},
      color={255,204,51},
      thickness=0.5));
  connect(y1HeaNonRev.y, y1HeaInt.u) annotation (Line(points={{-70,58},{-70,42}},
                                       color={255,0,255}));
  connect(y1Hea.y, y1HeaInt.u) annotation (Line(points={{-40,59},{-40,50},{-70,50},
          {-70,42}}, color={255,0,255}));
  connect(y1Int.y, mulInt.u1) annotation (Line(points={{-20,18},{-20,10},{-44,10},
          {-44,2}},  color={255,127,0}));
  connect(y1HeaInt.y, mulInt.u2) annotation (Line(points={{-70,18},{-70,10},{-56,
          10},{-56,2}},  color={255,127,0}));
  connect(mulInt.y, heaPum.uMod) annotation (Line(points={{-50,-22},{-50,-34},{-11,
          -34}}, color={255,127,0}));
  connect(mAir_flow.y, souAir.m_flow_in) annotation (Line(points={{80,-72},{80,
          -80},{48,-80},{48,-70}}, color={0,0,127}));
  connect(y1Rea.y, mAir_flow.u)
    annotation (Line(points={{20,18},{20,-20},{80,-20},{80,-48}},
                                                color={0,0,127}));
  connect(bus.y1, y1Rea.u) annotation (Line(
      points={{0,100},{0,50},{20,50},{20,42}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TSet, heaPum.TSet) annotation (Line(
      points={{0,100},{0,0},{-20,0},{-20,-25},{-11.4,-25}},
      color={255,204,51},
      thickness=0.5));
  connect(y1_actual.y, bus.y1_actual) annotation (Line(points={{40,82},{40,96},{
          0,96},{0,100}}, color={255,0,255}));
  connect(bus.y1, y1_actual.u) annotation (Line(
      points={{0,100},{0,50},{40,50},{40,58}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  defaultComponentName="heaPum",
  Documentation(info="<html>
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
end AirToWater;
