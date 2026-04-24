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

  parameter Boolean have_sorRunTim=true
    "Are the lead-lag equipment rotated based on runtime?"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean is_HpShc[nHp,1]=fill(false,nHp)
    "Vector indicating if each HP is an SHC HP; True=Is SHC HP;False=Not SHC HP"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Integer nHp(min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Integer idxEquAlt[nEquAlt](final min=fill(1, nEquAlt))
    "Indices of lead-lag alternate equipment"
    annotation (Evaluate=true,
    Dialog(group="Equipment staging and rotation"));

  parameter Real staEquDouMod[:, nHp](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-cooling mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  parameter Real staEquSinMod[:, nHp](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-only and cooling-only mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  final parameter Integer nSta(
    final min=1)=size(staEquDouMod, 1)
    "Number of stages"
    annotation (Evaluate=true);

  final parameter Integer nEquAlt(
    final min=0)=if nHp==1 then 1 else
    max({sum({(if staEquDouMod[i, j] > 0 and staEquDouMod[i, j] < 1 then 1 else 0) for j in 1:nHp}) for i in 1:nSta})
    "Number of lead-lag alternate equipment"
    annotation (Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaHea
    "Heating plant enable"
    annotation (Placement(transformation(extent={{-298,70},{-258,110}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaCoo
    "Cooling plant enable"
    annotation (Placement(transformation(extent={{-300,10},{-260,50}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMod[nHp]
    if have_heaWat and have_chiWat
    "Binary mode signal indicating if 2-pipe HP is in heating mode or cooling mode"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HpAva[nHp]
    "HP availability signal vector"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriHea[nHp]
    "Primary pump enable for SHC HP heating loop"
    annotation (Placement(transformation(extent={{-300,260},{-260,300}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriCoo[nHp]
    "Primary pump enable for SHC HP cooling loop"
    annotation (Placement(transformation(extent={{-298,300},{-258,340}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaHpShcHea[nHp]
    "Availability vector of SHC HPs for heating operation" annotation (
      Placement(transformation(extent={{320,200},{360,240}}),
        iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaHpShcCoo[nHp]
    "Availability vector of SHC HPs for cooling operation" annotation (
      Placement(transformation(extent={{320,140},{360,180}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumPri[nHp]
    "Primary pump enable for SHC HP"
    annotation (Placement(transformation(extent={{320,280},{360,320}}),
      iconTransformation(extent={{100,100},{140,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaCoo
    "Signal indicating heat pump plant is in heating-cooling mode"
    annotation (Placement(transformation(extent={{320,60},{360,100}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yMod[nHp]
    "Operation mode integer signal for each HP"
    annotation (Placement(transformation(extent={{320,-30},{360,10}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSta[nEquAlt]
    if not have_sorRunTim
    "Staging index if runtime sorting is absent"
    annotation (Placement(transformation(extent={{320,-300},{360,-260}}),
      iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaEqu[nSta,nHp](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage"
    annotation (Placement(transformation(extent={{320,-200},{360,-160}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaDouMod[nSta,nHp](
      final k=staEquDouMod) "Staging matrix for heating-cooling mode"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaSinMod[nSta,nHp](
      final k=staEquSinMod)
    "Staging matrix for heating-only and cooling-only mode"
    annotation (Placement(transformation(extent={{-10,-220},{10,-200}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nSta,nHp]
    "Switch between staging matrices for heating-cooling mode, and the staging
    matrix for other modes"
    annotation (Placement(transformation(extent={{28,-190},{48,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if both heating plant and cooling plant are enabled"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nHp)
    "Generate vector with size equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(
    final nin=nHp,
    final nout=nSta)
    "Change into matrix with same dimensions as staging matrix"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nHp](
    final integerTrue=fill(Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.Heating,nHp),
    final integerFalse=fill(Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.Cooling,nHp))
    "Convert binary mode signal to Integer mode signals"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[nHp]
    "Output mode for 2-pipe and SHC HPs"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant isHpShc[nHp,1](
    final k=is_HpShc)
    "Is the heat pump an SHC HP?"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Output Integer signal 1 when both heating plant and cooling plant are enabled"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Output mode signal only when heating-cooling mode is enabled"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.HeatingCooling)
    "Constant Integer signal representing heating-cooling mode"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if not in heating-cooling mode"
    annotation (Placement(transformation(extent={{-114,-80},{-94,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Output Integer 1 when not in heating-cooling mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1
    "Output heating-only mode signal or cooling-only mode signal when not
    in heating-cooling mode"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Output non-zero mode signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nHp)
    "Vectorize mode signal with dimension equal to number of heat pumps"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1[nEquAlt] if not have_sorRunTim
    "Switch between two staging orders when runtime sorting is not used"
    annotation (Placement(transformation(extent={{30,-290},{50,-270}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDir[nEquAlt](
      final k={i for i in 1:nEquAlt}) if not have_sorRunTim
    "Sort components in direct order when runtime sorting is not used"
    annotation (Placement(transformation(extent={{-10,-310},{10,-290}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntRev[nEquAlt](
      final k={i for i in nEquAlt:-1:1}) if not have_sorRunTim
    "Sort components in reverse order when runtime sorting is not used"
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nEquAlt) if not have_sorRunTim
    "Generate vector with size equal to list of lead-lag equipment"
    annotation (Placement(transformation(extent={{-50,-290},{-30,-270}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant heaModSig[nHp](
    final k=fill(true,nHp)) if have_heaWat and not have_chiWat
    "Constant heating mode signal"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooModSig[nHp](
    final k=fill(false,nHp)) if not have_heaWat and have_chiWat
    "Constant cooling mode signal"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nHp]
    "Check for HPs in heating-cooling mode"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));

  Buildings.Controls.OBC.CDL.Logical.And and8[nHp]
    "Identify heat recovery heat pumps in heating-cooling mode"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Logical.Or or5[nHp]
    "Check for primary heat pumps already enabled"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));

  Buildings.Controls.OBC.CDL.Logical.And and9[nHp]
    "Check if primary pump for 4 pipe ASHP is enabled"
    annotation (Placement(transformation(extent={{260,290},{280,310}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(nout=nHp)
    "Vectorize mode signal with dimension equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  Buildings.Controls.OBC.CDL.Logical.And and10[nHp]
    "Extract availability signal for SHC HP"
    annotation (Placement(transformation(extent={{260,180},{280,200}})));

equation
  connect(and2.y, booScaRep.u)
    annotation (Line(points={{-198,80},{-180,80},{-180,-180},{-52,-180}},
                                                   color={255,0,255}));
  connect(booScaRep.y, booVecRep.u)
    annotation (Line(points={{-28,-180},{-12,-180}},
                                                   color={255,0,255}));
  connect(booVecRep.y, swi.u2)
    annotation (Line(points={{12,-180},{26,-180}},color={255,0,255}));

  connect(conStaDouMod.y, swi.u1) annotation (Line(points={{12,-150},{20,-150},{
          20,-172},{26,-172}}, color={0,0,127}));
  connect(conStaSinMod.y, swi.u3) annotation (Line(points={{12,-210},{20,-210},{
          20,-188},{26,-188}}, color={0,0,127}));
  connect(booToInt.y, intSwi.u3)
    annotation (Line(points={{-58,-100},{180,-100},{180,-18},{198,-18}},
                                                   color={255,127,0}));
  connect(and2.y, booToInt1.u) annotation (Line(points={{-198,80},{-180,80},{-180,
          -10},{-62,-10}},                     color={255,0,255}));
  connect(and2.y, not1.u) annotation (Line(points={{-198,80},{-180,80},{-180,-70},
          {-116,-70}},                   color={255,0,255}));
  connect(not1.y, booToInt2.u)
    annotation (Line(points={{-92,-70},{-82,-70}},
                                                 color={255,0,255}));
  connect(booToInt2.y, mulInt1.u1)
    annotation (Line(points={{-58,-70},{-40,-70},{-40,-64},{-12,-64}},
                                                          color={255,127,0}));
  connect(booToInt[nHp].y, mulInt1.u2) annotation (Line(points={{-58,-100},{-20,
          -100},{-20,-76},{-12,-76}},            color={255,127,0}));
  connect(addInt.y, intScaRep.u)
    annotation (Line(points={{102,0},{118,0}},     color={255,127,0}));
  connect(intScaRep.y, intSwi.u1) annotation (Line(points={{142,0},{180,0},{180,
          -2},{198,-2}},                           color={255,127,0}));
  connect(conIntRev.y, intSwi1.u1) annotation (Line(points={{12,-260},{12,-272},
          {28,-272}}, color={255,127,0}));
  connect(conIntDir.y, intSwi1.u3) annotation (Line(points={{12,-300},{12,-298},
          {28,-298},{28,-288}}, color={255,127,0}));
  connect(booScaRep1.y, intSwi1.u2)
    annotation (Line(points={{-28,-280},{28,-280}},  color={255,0,255}));
  connect(and2.y, booScaRep1.u) annotation (Line(points={{-198,80},{-180,80},{-180,
          -280},{-52,-280}},                      color={255,0,255}));
  connect(heaModSig.y, booToInt.u) annotation (Line(points={{-118,-120},{-100,-120},
          {-100,-100},{-82,-100}},
                                color={255,0,255}));
  connect(cooModSig.y, booToInt.u) annotation (Line(points={{-118,-160},{-100,-160},
          {-100,-100},{-82,-100}},                                      color={
          255,0,255}));
  connect(u1EnaHea, and2.u1) annotation (Line(points={{-278,90},{-230,90},{-230,
          80},{-222,80}},
        color={255,0,255}));
  connect(u1EnaCoo, and2.u2) annotation (Line(points={{-280,30},{-230,30},{-230,
          72},{-222,72}},                              color={255,0,255}));
  connect(intEqu1.y, and8.u1) annotation (Line(points={{-58,210},{18,210}},
                                                                   color={255,0,
          255}));
  connect(conInt.y, intScaRep1.u) annotation (Line(points={{-198,210},{-142,210}},
                           color={255,127,0}));
  connect(swi.y, yStaEqu) annotation (Line(points={{50,-180},{340,-180}},
                      color={0,0,127}));
  connect(mulInt1.y, addInt.u2) annotation (Line(points={{12,-70},{60,-70},{60,-6},
          {78,-6}},        color={255,127,0}));
  connect(mulInt.y, addInt.u1)
    annotation (Line(points={{12,10},{12,6},{78,6}},       color={255,127,0}));
  connect(uMod, booToInt.u) annotation (Line(points={{-280,-100},{-82,-100}},
                                                           color={255,0,255}));
  connect(intSwi.y, yMod)
    annotation (Line(points={{222,-10},{340,-10}}, color={255,127,0}));
  connect(and9.y, y1PumPri) annotation (Line(points={{282,300},{340,300}},
        color={255,0,255}));
  connect(and2.y, yHeaCoo)
    annotation (Line(points={{-198,80},{340,80}},   color={255,0,255}));
  connect(intSwi1.y, yIdxSta)
    annotation (Line(points={{52,-280},{340,-280}}, color={255,127,0}));
  connect(u1PumPriCoo, or5.u1) annotation (Line(points={{-278,320},{-32,320},{-32,
          300},{-22,300}}, color={255,0,255}));
  connect(u1PumPriHea, or5.u2) annotation (Line(points={{-280,280},{-30,280},{-30,
          292},{-22,292}}, color={255,0,255}));
  connect(booToInt1.y, mulInt.u2) annotation (Line(points={{-38,-10},{-32,-10},{
          -32,4},{-12,4}},     color={255,127,0}));
  connect(conInt.y, mulInt.u1) annotation (Line(points={{-198,210},{-170,210},{-170,
          16},{-12,16}},   color={255,127,0}));
  connect(and8.y, and9.u2) annotation (Line(points={{42,210},{80,210},{80,292},{
          258,292}},  color={255,0,255}));
  connect(or5.y, and9.u1)
    annotation (Line(points={{2,300},{258,300}},   color={255,0,255}));
  connect(isHpShc[:, 1].y, intSwi.u2) annotation (Line(points={{82,40},{160,40},
          {160,-10},{198,-10}}, color={255,0,255}));
  connect(isHpShc[:, 1].y, and8.u2) annotation (Line(points={{82,40},{160,40},{160,
          190},{12,190},{12,202},{18,202}},
                                color={255,0,255}));
  connect(and10.y, yAvaHpShcHea) annotation (Line(points={{282,190},{308,190},{308,
          220},{340,220}},     color={255,0,255}));
  connect(and10.y, yAvaHpShcCoo) annotation (Line(points={{282,190},{308,190},{308,
          160},{340,160}},   color={255,0,255}));
  connect(intSwi.y, intEqu1.u2) annotation (Line(points={{222,-10},{232,-10},{232,
          84},{-92,84},{-92,202},{-82,202}},   color={255,127,0}));
  connect(intScaRep1.y, intEqu1.u1)
    annotation (Line(points={{-118,210},{-82,210}}, color={255,127,0}));
  connect(isHpShc[:, 1].y, and10.u1) annotation (Line(points={{82,40},{160,40},{
          160,190},{258,190}},  color={255,0,255}));
  connect(u1HpAva, and10.u2) annotation (Line(points={{-280,140},{240,140},{240,
          182},{258,182}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctlPlaHyb",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}}),
      graphics={
        Rectangle(
          extent={{-100,140},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,180},{140,140}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-260,-340},{320,340}})),
    Documentation(
      info="<html>
<p>
Block that manages custom calculations for integrating a simultaneous
heating-cooling heat pump (SHC HP) with multiple modular single-mode heat pumps
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
In simultaneous heating-cooling mode, the SHC HP shall operate in Stage 1 for both
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
<code>u1EnaCoo</code> signals to determine operation mode <code>yMod</code>
(heating-only, cooling-only, or heating-cooling) for the SHC HP. This also influences
the staging order <code>yStaEqu</code>, the equipment rotation index signal
<code>yIdxSta</code>.
</li>
<li>
Generates the availability status vectors <code>yAvaHpShcCoo</code> and
<code>yAvaHpShcHea</code> to indicate availability of the SHC HP, which can operate
without a cooldown period between mode changes.
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
Staging indices <code>yIdxSta</code> are generated without sorting by switching
between direct (<code>conIntDir</code>) and reverse (<code>conIntRev</code>) orders
if <code>have_sorRunTim=false</code>.
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
