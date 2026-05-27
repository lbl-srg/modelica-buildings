within Buildings.Templates.Plants.Controls.StagingRotation;
block HybridOperation
  "Controller for additional calculations required for staging hybrid plants with
  single-mode and double-mode HPs"

  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean is_HpShc[nHpTot]=fill(false,nHpTot)
    "Vector indicating if each HP is an SHC HP; True=Is SHC HP;False=Not SHC HP"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Integer nHp
    "Number of single-operation HPs"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Integer nHpShc
    "Number of SHC HPs"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  final parameter Integer nHpTot=nHp+nHpShc
    "Total number of HPs in plant";

  parameter Real staEquDouMod[:, nHpTot](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-cooling mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  parameter Real staEquSinMod[:, nHpTot](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-only and cooling-only mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  final parameter Integer nSta(
    final min=1)=size(staEquDouMod, 1)
    "Number of stages"
    annotation (Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp[nHpTot]
    "Heat pump enable signals"
    annotation (Placement(transformation(extent={{-300,-220},{-260,-180}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaHea
    "Heating plant enable"
    annotation (Placement(transformation(extent={{-298,30},{-258,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaCoo
    "Cooling plant enable"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriHea[nHpTot]
    "Primary pump enable for SHC HP heating loop"
    annotation (Placement(transformation(extent={{-300,140},{-260,180}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriCoo[nHpTot]
    "Primary pump enable for SHC HP cooling loop"
    annotation (Placement(transformation(extent={{-298,180},{-258,220}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumPri[nHpTot]
    "Primary pump enable for SHC HP (Only required for primary-secondary plant with dedicated pumps)"
    annotation (Placement(transformation(extent={{320,160},{360,200}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCoo
    "Signal indicating heat pump plant is in heating-cooling mode"
    annotation (Placement(transformation(extent={{320,20},{360,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHpShc[nHpShc]
    "SHC HP heating enable"
    annotation (Placement(transformation(extent={{320,-150},{360,-110}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooHpShc[nHpShc]
    "SHC HP cooling enable"
    annotation (Placement(transformation(extent={{320,-190},{360,-150}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaEqu[nSta,nHpTot](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage"
    annotation (Placement(transformation(extent={{320,-60},{360,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaDouMod[nSta,nHpTot](
    final k=staEquDouMod)
    "Staging matrix for heating-cooling mode"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaSinMod[nSta,nHpTot](
    final k=staEquSinMod)
    "Staging matrix for heating-only and cooling-only mode"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nSta,nHpTot]
    "Switch between staging matrices for heating-cooling mode, and the staging
    matrix for other modes"
    annotation (Placement(transformation(extent={{28,-50},{48,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if both heating plant and cooling plant are enabled"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nHpTot)
    "Generate vector with size equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(
    final nin=nHpTot,
    final nout=nSta)
    "Change into matrix with same dimensions as staging matrix"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant isHpShc[nHpTot](
    final k=is_HpShc)
    "Is the heat pump an SHC HP?"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and8[nHpTot]
    "Identify heat recovery heat pumps in heating-cooling mode"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5[nHpTot]
    "Check for primary heat pumps already enabled"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));

  Buildings.Controls.OBC.CDL.Logical.And and9[nHpTot]
    "Check if primary pump for 4 pipe ASHP is enabled"
    annotation (Placement(transformation(extent={{260,170},{280,190}})));

  Buildings.Controls.OBC.CDL.Logical.And andCooEna[nHpTot]
    "Check for cooling mode operation and enable signal"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-170})));

  Buildings.Controls.OBC.CDL.Logical.And andHeaEna[nHpTot]
    "Check for heating mode operation and enable signal"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-130})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nHpTot)
    "Generate vector with size equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(
    final nout=nHpTot)
    "Generate vector with size equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

equation
  connect(and2.y, booScaRep.u)
    annotation (Line(points={{-198,40},{-172,40},{-172,110},{-162,110}},
                                                   color={255,0,255}));
  connect(booScaRep.y, booVecRep.u)
    annotation (Line(points={{-138,110},{-88,110},{-88,-40},{-12,-40}},
                                                   color={255,0,255}));
  connect(booVecRep.y, swi.u2)
    annotation (Line(points={{12,-40},{26,-40}},  color={255,0,255}));

  connect(conStaDouMod.y, swi.u1) annotation (Line(points={{12,-10},{20,-10},{20,
          -32},{26,-32}},      color={0,0,127}));
  connect(conStaSinMod.y, swi.u3) annotation (Line(points={{12,-70},{20,-70},{20,
          -48},{26,-48}},      color={0,0,127}));
  connect(u1EnaHea, and2.u1) annotation (Line(points={{-278,50},{-230,50},{-230,
          40},{-222,40}},
        color={255,0,255}));
  connect(u1EnaCoo, and2.u2) annotation (Line(points={{-280,-10},{-230,-10},{-230,
          32},{-222,32}},                              color={255,0,255}));
  connect(swi.y, yStaEqu) annotation (Line(points={{50,-40},{340,-40}},
                      color={0,0,127}));
  connect(and9.y, y1PumPri) annotation (Line(points={{282,180},{340,180}},
        color={255,0,255}));
  connect(and2.y, y1HeaCoo)
    annotation (Line(points={{-198,40},{340,40}}, color={255,0,255}));
  connect(u1PumPriCoo, or5.u1) annotation (Line(points={{-278,200},{-32,200},{-32,
          180},{-22,180}}, color={255,0,255}));
  connect(u1PumPriHea, or5.u2) annotation (Line(points={{-280,160},{-30,160},{-30,
          172},{-22,172}}, color={255,0,255}));
  connect(and8.y, and9.u2) annotation (Line(points={{42,90},{80,90},{80,172},{258,
          172}},      color={255,0,255}));
  connect(or5.y, and9.u1)
    annotation (Line(points={{2,180},{258,180}},   color={255,0,255}));
  connect(isHpShc.y, and8.u2) annotation (Line(points={{-58,70},{8,70},{8,82},{18,
          82}},                             color={255,0,255}));
  connect(u1Hp, andCooEna.u2) annotation (Line(points={{-280,-200},{60,-200},{60,
          -178},{78,-178}}, color={255,0,255}));
  connect(u1Hp, andHeaEna.u2) annotation (Line(points={{-280,-200},{60,-200},{60,
          -138},{78,-138}}, color={255,0,255}));
  connect(booScaRep.y, and8.u1) annotation (Line(points={{-138,110},{12,110},{12,
          90},{18,90}}, color={255,0,255}));
  connect(u1EnaHea, booScaRep1.u) annotation (Line(points={{-278,50},{-238,50},{
          -238,-130},{-22,-130}}, color={255,0,255}));
  connect(booScaRep1.y, andHeaEna.u1)
    annotation (Line(points={{2,-130},{78,-130}}, color={255,0,255}));
  connect(u1EnaCoo, booScaRep2.u) annotation (Line(points={{-280,-10},{-248,-10},
          {-248,-170},{-22,-170}}, color={255,0,255}));
  connect(booScaRep2.y, andCooEna.u1)
    annotation (Line(points={{2,-170},{78,-170}}, color={255,0,255}));
  connect(andHeaEna[nHp + 1:nHpTot].y, y1HeaHpShc) annotation (Line(points={{102,
          -130},{218,-130},{218,-130},{340,-130}}, color={255,0,255}));
  connect(andCooEna[nHp + 1:nHpTot].y, y1CooHpShc) annotation (Line(points={{102,
          -170},{216,-170},{216,-170},{340,-170}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctlPlaHyb",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,100}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-260,-220},{320,220}})),
    Documentation(
      info="<html>
<p>
Block that manages custom calculations for integrating simultaneous
heating-cooling heat pumps (SHC HPs) with multiple modular single-mode heat pumps
to create a hybrid heat pump plant.
</p>
<ul>
<li>
In heating and cooling mode operation of the plant, the modular single-mode heat
pumps shall be lead-lag controlled as defined in 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>.
</li>
<li>
In simultaneous heating-cooling mode, the SHC HP operation is prioritized in both
plants.  Else it shall operate in the highest capacity stage and the modular HPs
shall operate in the lower capacity stages based on lead-lag order.
</li>
</ul>
<h4>Details</h4>
<p>
The implemented module manages the following functions.
</p>
<ul>
<li>
Uses the heating plant enable <code>u1EnaHea</code> and cooling plant enable
<code>u1EnaCoo</code> signals alng with the heat pump enable signale signals
<code>u1Hp</code> to determine operation mode and output appropriate signals for
<code>y1HeaHpShc</code>, <code>y1CooHpShc</code> and <code>yStaEqu</code>.
</li>
<li>
Identifies primary pump operation status for SHC HP, and manages enable status
as required between the three operation modes.
</li>
</ul>
<p>
The block first checks if both heating and cooling plants are enabled
using an <i>and</i> gate (<code>and2</code>).
If true, it sets the heating-cooling mode flag <code>yHeaCoo</code>
and selects the staging matrix <code>staEquDouMod</code> via a switch (<code>swi</code>).
Otherwise, it uses <code>staEquSinMod</code> for single-mode operation.
</p>
<p>
The primary pump enable <code>y1PumPri</code> activates when the SHC primary pump
is enabled in heating-cooling mode (<code>and9</code>).
</p>
<p>
The final staging matrix <code>yStaEqu</code> outputs the required staging order
based on the plant operation mode.
</p>
<p>
Staging matrices <code>staEquDouMod</code> for simultaneous heating-cooling operation,
and <code>staEquSinMod</code> for heating-only or cooling-only operation are required
as parameters.
See the documentation of
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
for the associated requirements.
</p>
</html>", revisions="<html>
<ul>
<li>
<i>July 29, 2025</i>, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end HybridOperation;
