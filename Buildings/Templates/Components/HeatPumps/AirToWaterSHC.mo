within Buildings.Templates.Components.HeatPumps;
model AirToWaterShc
  "Air-to-water heat pump with simultaneous heating and cooling"
  extends
    Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep(
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWaterShc,
    final allowFlowReversalSou=false,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
      QHeaShc_flow_nominal=dat.capHeaShc_nominal,
      QCooShc_flow_nominal=dat.capCooShc_nominal,
      final dat=dat.perShc),
    break connect(bus.y1, hp.on),
    break connect(hp.on, y1_actual.y1),
    break connect(bus.TSet, hp.THwSet),
    break connect(bus.y1Hea, hp.hea));

  Buildings.Controls.OBC.CDL.Integers.Equal intEquCoo
    "Check for cooling mode signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,90})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquHea
    "Check for heating mode signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquHeaCoo
    "Check for heating-cooling mode signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,90})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntMod[3](k={
        Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.Cooling,
        Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.Heating,
        Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.HeatingCooling})
    "Mode signals" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,140})));
  Buildings.Controls.OBC.CDL.Logical.Or orCoo
    "Send cooling mode signal to heat-pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,50})));
  Buildings.Controls.OBC.CDL.Logical.Or orHea
    "Send heating mode signal to heat-pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,50})));
  Buildings.Controls.OBC.CDL.Logical.Or or_y1_actual
    "Check for heat pump enable signals" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,50})));
equation
  connect(bus.yMod, intEquHeaCoo.u1) annotation (Line(
      points={{0,160},{0,112},{-20,112},{-20,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.yMod, intEquHea.u1) annotation (Line(
      points={{0,160},{0,112},{-50,112},{-50,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus.yMod, intEquCoo.u1) annotation (Line(
      points={{0,160},{0,112},{-80,112},{-80,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conIntMod[1].y, intEquCoo.u2) annotation (Line(points={{-70,128},{-70,
          114},{-88,114},{-88,102}}, color={255,127,0}));
  connect(conIntMod[2].y, intEquHea.u2) annotation (Line(points={{-70,128},{-70,
          114},{-58,114},{-58,102}}, color={255,127,0}));
  connect(conIntMod[3].y, intEquHeaCoo.u2) annotation (Line(points={{-70,128},{-70,
          114},{-28,114},{-28,102}}, color={255,127,0}));
  connect(intEquCoo.y, orCoo.u2) annotation (Line(points={{-80,78},{-80,68},{-78,
          68},{-78,62}}, color={255,0,255}));
  connect(intEquHeaCoo.y, orCoo.u1) annotation (Line(points={{-20,78},{-20,66},{
          -70,66},{-70,62}}, color={255,0,255}));
  connect(orCoo.y, hp.onCoo) annotation (Line(points={{-70,38},{-70,20},{-24,20},
          {-24,-10},{-12,-10}}, color={255,0,255}));
  connect(intEquHea.y, orHea.u2) annotation (Line(points={{-50,78},{-50,70},{-38,
          70},{-38,62}}, color={255,0,255}));
  connect(intEquHeaCoo.y, orHea.u1) annotation (Line(points={{-20,78},{-20,66},{
          -30,66},{-30,62}}, color={255,0,255}));
  connect(orHea.y, hp.onHea) annotation (Line(points={{-30,38},{-30,24},{-20,24},
          {-20,-8},{-12,-8}}, color={255,0,255}));
  connect(bus.TChiWatSupSet, hp.TChwSet) annotation (Line(
      points={{0,160},{0,16},{-18,16},{-18,-6},{-12,-6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.THeaWatSupSet, hp.THwSet) annotation (Line(
      points={{0,160},{0,136},{2,136},{2,14},{-14,14},{-14,-2},{-12,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(hp.onHea, or_y1_actual.u1) annotation (Line(points={{-12,-8},{-20,-8},
          {-20,24},{30,24},{30,38}}, color={255,0,255}));
  connect(hp.onCoo, or_y1_actual.u2) annotation (Line(points={{-12,-10},{-24,-10},
          {-24,20},{38,20},{38,38}}, color={255,0,255}));
  connect(or_y1_actual.y, y1_actual.y1) annotation (Line(points={{30,62},{30,98},
          {40,98},{40,108}}, color={255,0,255}));
  connect(TSouEnt.port_a, port_aSou)
    annotation (Line(points={{40,-20},{80,-20},{80,-140}}, color={0,127,255}));
  connect(hp.weaBus, busWea) annotation (Line(
      points={{0,4},{0,10},{50,10},{50,-60},{-40,-60},{-40,-140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for an air-to-water heat pump where the capacity
and input power are computed by interpolating manufacturer data
along the condenser entering or leaving temperature, the
evaporator entering or leaving temperature and the part load ratio.
The model can be configured to represent either a non-reversible
(heating-only) heat pump (<code>is_rev=false</code>) or a
reversible heat pump (<code>is_rev=true</code>).
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the base class
<a href=\"modelica://Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep\">
Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep</a>
for a description of the available control input and output variables.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirToWaterShc;
