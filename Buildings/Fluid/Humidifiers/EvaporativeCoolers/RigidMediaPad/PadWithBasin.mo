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
  Controls.OBC.CDL.Interfaces.RealInput           mRecPum_flow
    "Mass flow setpoint of the recirculation pump" annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}}),iconTransformation(
          extent={{-140,-80},{-100,-40}})));
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
  connect(mRecPum_flow, watBas.mRecPum_flow) annotation (Line(points={{-120,-100},
          {-80,-100},{-80,-116},{-2,-116}}, color={0,0,127}));
  connect(watBas.mMakUp_flow, mMakUp_flow) annotation (Line(points={{22,-110},{80,
          -110},{80,-100},{120,-100}}, color={0,0,127}));
  connect(swiDryWetMod.y, watBas.mWatEva_flow) annotation (Line(points={{82,-30},
          {90,-30},{90,-80},{-20,-80},{-20,-104},{-2,-104}}, color={0,0,127}));
  connect(wetMod, swiDryWetMod.u2) annotation (Line(points={{-120,-60},{-60,-60},
          {-60,-30},{58,-30}}, color={255,0,255}));
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
This block selects the <code>nSel</code> largest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
Boolean vector <code>y</code>, where <code>true</code> means that the value at the
corresponding index is one of the largest values, and <code>false</code> means
that it is not.
</p>
<p>
If the input vector <code>u</code> contains equal values, this block will
prioritize values that appear first in <code>u</code> when
selecting the <code>nSel</code> largest values.
</p>
<p>
Setting the disabled flag vector <code>disFla = true</code> serves to exclude certain
values in the input vector from the ranking of the largest values. These values will
have the Boolean output <code>y = false</code>. If the total number of values after
excluding is less than <code>nSel</code>, all non-excluded values will have the
Boolean output <code>y = true</code>.
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
