within Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad;
model PadWithBasin "Rigid media pad and sink for blowdown"
  extends Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad;

  parameter Modelica.Units.SI.Height height "Height of the tank";
  parameter Modelica.Units.SI.Area crossArea "Cross-sectional area of the tank";
  parameter Modelica.Units.SI.Height level_target(min=0, max=height) "Target water level in the tank";
  parameter Modelica.Units.SI.MassFlowRate mMakUp_flow_nominal
    "Make up water mass flow nominal";
  parameter Real cycCon
    "Cycle of concentration for blowdown";
  replaceable package MediumRecWat =
    Buildings.Media.Water "Recirculation water medium";
  Controls.OBC.CDL.Interfaces.BooleanInput wetMod
    "True: the rigid media pad and its basin are operating on the wet mode; false: they are operating on the dry mode"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Controls.OBC.CDL.Interfaces.RealOutput           dmWat_flow(final unit="kg/s",
      final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,70}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={120,60},extent={{-20,-20},{20,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput mMakUp_flow "Makeup water flow"
    annotation (Placement(transformation(extent={{100,-120},{140,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perRecPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance record for the recirculation pump" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-60,-100},{-40,
            -80}})));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin watBas(
    height=height,
    crossArea=crossArea,
    level_target=level_target,
    mMakUp_flow_nominal=mMakUp_flow_nominal,
    cycCon=cycCon,
    redeclare package MediumRecWat = MediumRecWat,
    perRecPum=perRecPum)
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
equation
  connect(dmWat_flow, swiDryWetMod.y) annotation (Line(points={{120,70},{90,70},
          {90,-30},{82,-30}}, color={0,0,127}));
  connect(watBas.mMakUp_flow, mMakUp_flow) annotation (Line(points={{22,-110},{80,
          -110},{80,-100},{120,-100}}, color={0,0,127}));
  connect(swiDryWetMod.y, watBas.mWatEva_flow) annotation (Line(points={{82,-30},
          {90,-30},{90,-80},{-20,-80},{-20,-104},{-2,-104}}, color={0,0,127}));
  connect(wetMod, swiDryWetMod.u2) annotation (Line(points={{-120,-60},{-60,-60},
          {-60,-30},{58,-30}}, color={255,0,255}));
  connect(wetMod, watBas.wetMod) annotation (Line(points={{-120,-60},{-80,-60},
          {-80,-116},{-2,-116}}, color={255,0,255}));
  annotation (defaultComponentName="padWitBas",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid)}),
                                 Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-140},{100,100}})),
    Documentation(info="<html>
<p>
Model of a rigid media pad with a water basin.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad</a>
and adds a water basin below the rigid media pad, which is implemented by
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin</a>.
</p>
<p>
The boolean input <code>wetMod</code> switches the model between the wet and
the dry mode. In the wet mode (<code>wetMod = true</code>), water from the basin
is recirculated by a pump and distributed over the rigid media pad, where a part
of it evaporates into the airstream. This reduces the dry bulb temperature and
increases the humidity mass fraction of the air. The evaporated water leaves the
recirculation loop, and to limit the accumulation of dissolved solids in the
recirculating water, a blowdown water flow is removed from the loop. Make-up
water is added to the basin to maintain the water level near the target level
<code>level_target</code>. In the dry mode (<code>wetMod = false</code>), the
recirculation pump is off, no water evaporates, and no water vapor is added to
the air, and thus <code>dmWat_flow = 0</code>.
</p>
<p>
The water vapor mass flow rate added to the air is reported by the output
<code>dmWat_flow</code>, and the make-up water mass flow rate is reported by
the output <code>mMakUp_flow</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
The geometry of the basin tank is set by <code>height</code> and
<code>crossArea</code>, and the water level control targets the level
<code>level_target</code> with a hysteresis band of <i>&plusmn;0.05</i> m.
The nominal make-up water mass flow rate is set by <code>mMakUp_flow_nominal</code>,
and the blowdown water flow is determined by the cycle of concentration
<code>cycCon</code>. The area of the rigid media pad is set by <code>padAre</code>
and its performance data by the record <code>perPad</code>, both declared in
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad</a>.
The recirculation pump is parameterized by the performance record
<code>perRecPum</code>.
</p>
<p>
Note that this model works correctly only when the air flows from
<code>port_a</code> to <code>port_b</code>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Validation.PadWithBasin_CompareEnergyPlus\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Validation.PadWithBasin_CompareEnergyPlus</a>
and
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Validation.PadWithBasin_DryWetSwitch\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Validation.PadWithBasin_DryWetSwitch</a>
for validation models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PadWithBasin;
