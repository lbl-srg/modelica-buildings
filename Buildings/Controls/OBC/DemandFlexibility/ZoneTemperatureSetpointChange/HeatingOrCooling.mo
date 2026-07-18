within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange;
block HeatingOrCooling
  "Zone heating or cooling temperature setpoint change"

  parameter Real dTShe(min=0)
    "Temperature setpoint change delta for the load-shed mode (positive value)";
  parameter Real dTReb(min=0)
    "Temperature setpoint change delta for the load-rebound mode (positive value)";
  parameter Real dTSheThr(min=0)
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)";
  parameter Real dTSheHys(min=0)
    "Hysteresis for the temperature difference during the load-shed mode";
  parameter Real PBuiHys(min=0,start=1)
    "Hysteresis for the electricity demand of the building"
    annotation (Dialog(enable = use_demCon));
  parameter Real TResInt(min=0)
    "Temperature resolution interval used by an external zone temperature controller";
  parameter Real samPerSetCha(min=0)
    "Sampling period for the setpoint change";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Integer nSel(min=1)
    "Number of zones to select for prioritization";


  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet[nZon]
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.RealInput TCurZon[nZon] "Current zone temperature" annotation
    (Placement(transformation(extent={{-212,2},{-172,42}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput TCurZonSet[nZon]
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-192,-42},{-152,-2}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.IntegerInput                        demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
                                                   annotation (Placement(
        transformation(extent={{-224,-86},{-184,-46}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.BooleanInput                        rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-192,118},{-152,158}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  CDL.Interfaces.RealInput                        TPreTarSet[nZon]
    "Pre-cool or pre-heat target temperature setpoint" annotation (Placement(
        transformation(extent={{-190,-114},{-150,-74}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput                        TSheTarSet[nZon]
    "Load-shed target temperature setpoint" annotation (Placement(
        transformation(extent={{-188,-154},{-148,-114}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  CDL.Interfaces.RealInput                        TDefSet[nZon] "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-188,-192},{-148,-152}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  CDL.Interfaces.RealInput                        PBuiThr if use_demCon
    "Threshold for the electricity demand of the building"        annotation (
      Placement(transformation(extent={{-192,38},{-152,78}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput                        PBui if use_demCon
    "Electricity demand of the building"                       annotation (
      Placement(transformation(extent={{-192,78},{-152,118}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Subsequences.ZoneQualification zonQua(
    final dTSheThr=dTSheThr,
    final dTSheHys=dTSheHys,
    final PBuiHys=PBuiHys,
    final TResInt=TResInt,
    final airConMod=airConMod,
    final nZon=nZon)
    annotation (Placement(transformation(extent={{-72,86},{-52,122}})));
  Subsequences.ZonePriorization zonPri(final nZon=nZon, final airConMod=
        airConMod)
    annotation (Placement(transformation(extent={{-30,8},{-10,28}})));
  Subsequences.ZoneControl zonCon[nZon](
    final dTShe=dTShe,
    final dTReb=dTReb,
    final airConMod=airConMod)
    annotation (Placement(transformation(extent={{34,-64},{54,-44}})));
  CDL.Discrete.Sampler sam[nZon](final samplePeriod=fill(samPerSetCha, nZon))
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nZon)
    annotation (Placement(transformation(extent={{-32,-34},{-12,-14}})));
equation
  connect(zonQua.disFla, zonPri.disFla) annotation (Line(points={{-50,104},{-44,
          104},{-44,24},{-32,24}}, color={255,0,255}));
  connect(zonPri.yEna, zonCon.uEna) annotation (Line(points={{-8,18},{8,18},{8,
          -44},{32,-44}}, color={255,0,255}));
  connect(sam.y, TComZonSet)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));
  connect(zonCon.TComZonSet, sam.u) annotation (Line(points={{56,-54},{62,-54},
          {62,0},{78,0}}, color={0,0,127}));
  connect(rouZonFla, zonQua.rouZonFla) annotation (Line(points={{-172,138},{-74,
          138},{-74,120}}, color={255,0,255}));
  connect(PBui, zonQua.PBui) annotation (Line(points={{-172,98},{-138,98},{-138,
          96},{-102,96},{-102,116},{-74,116}}, color={0,0,127}));
  connect(PBuiThr, zonQua.PBuiThr) annotation (Line(points={{-172,58},{-129,58},
          {-129,112},{-74,112}}, color={0,0,127}));
  connect(TCurZon, zonQua.TZon) annotation (Line(points={{-192,22},{-130,22},{
          -130,108},{-74,108}}, color={0,0,127}));
  connect(TCurZonSet, zonQua.TZonSet) annotation (Line(points={{-172,-22},{-120,
          -22},{-120,104},{-74,104}}, color={0,0,127}));
  connect(demFleMod, zonQua.demFleMod) annotation (Line(points={{-204,-66},{
          -130,-66},{-130,100},{-74,100}}, color={255,127,0}));
  connect(TPreTarSet, zonQua.TPreTarSet) annotation (Line(points={{-170,-94},{
          -110,-94},{-110,96},{-74,96}}, color={0,0,127}));
  connect(TSheTarSet, zonQua.TSheTarSet) annotation (Line(points={{-168,-134},{
          -94,-134},{-94,92},{-74,92}}, color={0,0,127}));
  connect(TDefSet, zonQua.TDefSet) annotation (Line(points={{-168,-172},{-88,
          -172},{-88,88},{-74,88}}, color={0,0,127}));
  connect(TCurZon, zonPri.TZon) annotation (Line(points={{-192,22},{-108,22},{
          -108,20},{-32,20}}, color={0,0,127}));
  connect(TCurZonSet, zonPri.TZonSet) annotation (Line(points={{-172,-22},{-99,
          -22},{-99,16},{-32,16}}, color={0,0,127}));
  connect(demFleMod, intScaRep.u) annotation (Line(points={{-204,-66},{-130,-66},
          {-130,-24},{-34,-24}}, color={255,127,0}));
  connect(intScaRep.y, zonCon.demFleMod) annotation (Line(points={{-10,-24},{6,
          -24},{6,-48},{32,-48}}, color={255,127,0}));
  connect(TCurZonSet, zonCon.TCurZonSet) annotation (Line(points={{-172,-22},{
          -70,-22},{-70,-52},{-20,-52},{-20,-52.2},{32,-52.2}}, color={0,0,127}));
  connect(TPreTarSet, zonCon.TPreTarSet) annotation (Line(points={{-170,-94},{
          -70,-94},{-70,-56},{32,-56}}, color={0,0,127}));
  connect(TSheTarSet, zonCon.TSheTarSet) annotation (Line(points={{-168,-134},{
          -68,-134},{-68,-60},{32,-60}}, color={0,0,127}));
  connect(TDefSet, zonCon.TDefSet) annotation (Line(points={{-168,-172},{-68,
          -172},{-68,-64},{32,-64}}, color={0,0,127}));
  annotation (defaultComponentName="heaOrCoo",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
July 17, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block performs zone setpoint change for either heating setpoints of
all zones, or cooling setpoints of all zones, in a building. This block
first checks whether each zone is qualified for setpoint change, then
prioritizes setpoint change for certain zones based on the difference
between the current zone setpoint and the current zone temperature, and
finally executes the setpoint change by outputting new setpoints.
</p>
<p>
Refer to the documentation of the ZoneQualification block for conditions
that qualify a zone for setpoint change. Refer to the documentation of the
ZonePrioritization block for how different zones are prioritized to perform
setpoint change. Refer to the documentation of the ZoneControl block for
how setpoint change is executed.
</p>
<p>
The parameter samPerSetCha is a setpoint change sampling period, which
specifies the time interval on how often the setpoint change operation
is executed.
</p>
<p>
There are 4 different variants of zone setpoint change. Each variant
is described below:
</p>
<ul>
<li>
Variant 1 is single setpoint adjustment, where a zone changes its
setpoint towards a setpoint limit in a single step. However, the
single-step setpoint change can still be done a few zones at a time,
rather than all zones changing setpoints at once. This variant does not
take into account the electricity demand of the building.
</li>
<li>
Variant 2 is ratcheted setpoint adjustment, where a zone changes its
setpoint towards a setpoint limit in multiple small steps. This
ratcheted multiple-step setpoint change can also be done a few zones
at a time, rather than all zones changing setpoints at once. This
provides an additional degree of freedom for the setpoint change.
This variant does not take into account the electricity demand of the
building.
</li>
<li>
Variant 3 is ratcheted setpoint adjustment with a single electricity
demand target. This is similar to Variant 2, except that the electricity
demand of the building needs to be higher than a constant electricity
demand target in order to execute setpoint change during the load-shed
demand flexibility mode.
</li>
<li>
Variant 4 is ratcheted setpoint adjustment with a varying electricity
demand target. This is similar to Variant 2, except that the electricity
demand of the building needs to be higher than a variable electricity
demand target in order to execute setpoint change during the load-shed
demand flexibility mode.
</li>
</ul>
</html>"));
end HeatingOrCooling;
