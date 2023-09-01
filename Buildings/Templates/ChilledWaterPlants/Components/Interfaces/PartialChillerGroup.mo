within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
partial model PartialChillerGroup "Interface class for chiller group"
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid";

  parameter Integer nChi(final min=0)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat(start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of CW pump arrangement" annotation (Evaluate=true, Dialog(group=
          "Configuration", enable=typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_varPumConWat(
    start=false)
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtlHea(
    start=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri(
    start=Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed));

  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco(
    start=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  final parameter Boolean enaTypValChiWatChiIso=
    typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Enable choices of chiller CHW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true,
    choices(choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating "Two-way modulating valve"),
    Dialog(group="Configuration", enable=enaTypValChiWatChiIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso=
    if enaTypValChiWatChiIso then typValChiWatChiIso_select
    else Buildings.Templates.Components.Types.Valve.None
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean enaTypValConWatChiIso=
    typArrPumConWat==Buildings.Templates.Components.Types.PumpArrangement.Headered
      and (typCtlHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None
      or have_varPumConWat
      and typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Enable choices of chiller CW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true,
    choices(choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Two-way modulating valve"),
    Dialog(group="Configuration", enable=enaTypValConWatChiIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso=
    if (typChi<>Buildings.Templates.Components.Types.Chiller.WaterCooled or
    typArrPumConWat==Buildings.Templates.Components.Types.PumpArrangement.Dedicated)
    then Buildings.Templates.Components.Types.Valve.None
    elseif enaTypValConWatChiIso then typValConWatChiIso_select
    else Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // The following parameter stores the user selection.
  parameter Boolean have_senTChiWatChiSup_select=false
    "Set to true for chiller CHW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=
    not
       ((typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed)
    and typMeaCtlChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.TemperatureChillerSensor
    or typCtlHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External)));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_senTChiWatChiSup=
    if (typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed)
    and typMeaCtlChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.TemperatureChillerSensor
    or typCtlHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External
    then true
    else have_senTChiWatChiSup_select
    "Set to true for chiller CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTChiWatChiRet=false
    "Set to true for chiller CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTConWatChiSup=false
    "Set to true for chiller CW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  // The following parameter stores the user selection.
  parameter Boolean have_senTConWatChiRet_select=false
    "Set to true for chiller CW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    not typCtlHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_senTConWatChiRet=
    if typCtlHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External
    then true
    elseif typChi<>Buildings.Templates.Components.Types.Chiller.WaterCooled then false
    else have_senTConWatChiRet_select
    "Set to true for chiller CW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup dat(
    final typChi=typChi,
    final nChi=nChi)
    "Parameter record for chiller group";
  final parameter Buildings.Templates.Components.Data.Chiller datChi[nChi](
    final typ=fill(typChi, nChi),
    final mChiWat_flow_nominal=mChiWatChi_flow_nominal,
    final mCon_flow_nominal=mConChi_flow_nominal,
    final cap_nominal=capChi_nominal,
    final dpChiWat_nominal=if typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpChiWatChi_nominal else fill(0, nChi),
    final dpCon_nominal=if typValConWatChiIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpConChi_nominal else fill(0, nChi),
    final TChiWatSup_nominal=dat.TChiWatChiSup_nominal,
    final TChiWatSup_max=dat.TChiWatChiSup_max,
    final TConEnt_nominal=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then dat.TConWatChiEnt_nominal
      elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
      dat.TConAirChiEnt_nominal
      else fill(Buildings.Templates.Data.Defaults.TConAirEnt, nChi),
    final TConEnt_min=dat.TConChiEnt_min,
    final TConEnt_max=dat.TConChiEnt_max,
    final PLRUnl_min=dat.PLRUnlChi_min,
    final PLR_min=dat.PLRChi_min,
    final per=dat.per)
    "Parameter record of each chiller";
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatChiIso[nChi](
    final typ=fill(typValChiWatChiIso, nChi),
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=if typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpChiWatChi_nominal else fill(0, nChi))
    "Parallel chillers CHW bypass valve parameters"
    annotation (Dialog(enable=false));
  final parameter Buildings.Templates.Components.Data.Valve datValConWatChiIso[nChi](
    final typ=fill(typValConWatChiIso, nChi),
    final m_flow_nominal=mConChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=if typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpConChi_nominal else fill(0, nChi))
    "Series chillers CHW bypass valve parameters"
    annotation (Dialog(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    dat.mChiWatChi_flow_nominal
    "CHW mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.MassFlowRate mConChi_flow_nominal[nChi]=
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled then
      dat.mConWatChi_flow_nominal
    elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
      dat.mConAirChi_flow_nominal
    else fill(0, nChi)
    "Condenser cooling fluid mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi]=
    dat.capChi_nominal
    "Cooling capacity - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    dat.dpChiWatChi_nominal
    "CHW pressure drop - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpConChi_nominal[nChi]=
    dat.dpConChi_nominal
    "CW pressure drop - Each chiller";
  final parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi]=
    dat.TChiWatChiSup_nominal
    "CHW supply temperature - Each chiller";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply"
    annotation (Placement(transformation(extent={{190,80},{210,160}}),
        iconTransformation(extent={{390,920},{410,1000}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid return (e.g. from chillers to cooling towers)"
    annotation (Placement(transformation(extent={{-210,80},{-190,160}}),
        iconTransformation(extent={{-410,920},{-390,1000}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid supply (e.g. from cooling towers to chillers)"
    annotation (Placement(transformation(extent={{-210,-140},{-190,-60}}),
        iconTransformation(extent={{-410,-1000},{-390,-920}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{190,-140},{210, -60}}),
    iconTransformation(extent={{390,-1000},{410,-920}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
    iconTransformation(extent={{-20,982},{20,1022}})));

protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-20,120},
            {20,160}}), iconTransformation(extent={{-350,6},{-310,46}})));
equation
  connect(busChi, bus.chi) annotation (Line(
      points={{0,140},{0,200}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-200,-240},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-400,-1000},{400,1000}}),
  graphics={
    Line(
      points={{180,840},{400,840}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      points={{180,960},{400,960}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 2,
      points={{180,600},{400,600}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 3,
      points={{180,240},{400,240}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 4,
      points={{180,-120},{400,-120}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Text( extent={{-151,-1008},{149,-1048}},
          textColor={0,0,255},
          textString="%name"),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi>=1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,960}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and nChi >= 1,
      extent={{260,1020},{340,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi >= 2,
      extent={{260,660},{340,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
               and nChi >= 2,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=-90,
          origin={300,600}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi >= 3,
      extent={{260,300},{340,380}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi >= 3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,240}),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-120}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=4,
      extent={{260,-60},{340,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and nChi >= 1,
      extent={{260,1020},{340,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi >= 2,
      extent={{260,660},{340,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
               and nChi >= 3,
          extent={{260,300},{340,380}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=4,
      extent={{260,-60},{340,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
          extent={{180,1000},{-180,800}},
          lineColor={0,0,0},
          lineThickness=1),
    Text(
      extent={{-180,900},{180,860}},
      textColor={0,0,0},
      textString="CHI-1"),
    Rectangle(
          extent={{180,640},{-180,440}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nChi >= 2),
    Text(
      visible=nChi >= 2,
      extent={{-180,540},{180,500}},
      textColor={0,0,0},
      textString="CHI-2"),
    Line( visible=nChi >= 2,
          points={{180,480},{400,480}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5),
    Rectangle(
      extent={{180,280},{-180,78}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nChi >= 3),
    Text(
      visible=nChi >= 3,
      extent={{-180,180},{180,140}},
      textColor={0,0,0},
      textString="CHI-3"),
    Line( points={{180,120},{400,120}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nChi >= 3),
    Rectangle(
      visible=nChi >= 4,
      extent={{180,-80},{-180,-280}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi >= 4,
      extent={{-180,-180},{180,-220}},
      textColor={0,0,0},
      textString="CHI-4"),
    Line( points={{180,-240},{400,-240}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nChi >= 4),
    Line(
      points={{300,1020},{300,960}},
      color={0,0,0},
      visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 1),
    Line(
      points={{300,660},{300,600}},
      color={0,0,0},
      visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2),
    Line(
      points={{300,300},{300,240}},
      color={0,0,0},
      visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 3),
    Line(
      points={{300,-60},{300,-120}},
      color={0,0,0},
      visible=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
            and nChi >= 4),
    Line(
      visible=nChi>=5,
      points={{180,-480},{400,-480}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi>=5,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-480}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=5,
      extent={{260,-420},{340,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating and nChi >= 5,
      extent={{260,-420},{340,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
      visible=nChi>=5,
      extent={{180,-440},{-180,-640}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi>=5,
      extent={{-180,-540},{180,-580}},
      textColor={0,0,0},
          textString="CHI-5"),
    Line( points={{180,-600},{400,-600}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nChi>=5),
    Line(
      points={{300,-420},{300,-480}},
      color={0,0,0},
      visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 5),
    Line(
      visible=nChi>=6,
      points={{180,-840},{400,-840}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi>=6,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-840}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi>=6,
      extent={{260,-780},{340,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=6,
      extent={{260,-780},{340,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
      visible=nChi>=6,
      extent={{180,-800},{-180,-1000}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi>=6,
      extent={{-180,-880},{180,-920}},
      textColor={0,0,0},
          textString="CHI-6"),
    Line( points={{180,-960},{400,-960}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nChi>=6),
    Line(
      points={{300,-780},{300,-840}},
      color={0,0,0},
      visible=typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 6),
    Line(
      visible=nChi >= 1 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,840},{-180,840}},
      color={0,0,0},
      thickness=5),
    Line(
      visible=nChi >= 1 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,960},{-180,960}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 2 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,600},{-180,600}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 3 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,240},{-180,240}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 4 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-120},{-180,-120}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 1,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,960}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and nChi >= 1,
      extent={{-320,1020},{-240,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi >= 2,
      extent={{-318,660},{-238,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,600}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
            and nChi >= 3,
      extent={{-320,300},{-240,380}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 3,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,240}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 4,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-120}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=4,
      extent={{-320,-60},{-240,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and nChi >= 1,
      extent={{-320,1020},{-240,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi >= 2,
      extent={{-318,660},{-238,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
               and nChi >= 3,
          extent={{-320,300},{-240,380}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=4,
      extent={{-320,-60},{-240,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( visible=nChi >= 2 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
          points={{-400,480},{-180,480}},
          color={0,0,0},
          thickness=5),
    Line( points={{-400,120},{-180,120}},
          color={0,0,0},
          thickness=5,
          visible=nChi >= 3 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line( points={{-400,-240},{-180,-240}},
          color={0,0,0},
          thickness=5,
          visible=nChi >= 4 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line(
      points={{-280,1020},{-280,960}},
      color={0,0,0},
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 1),
    Line(
      points={{-280,660},{-280,600}},
      color={0,0,0},
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2),
    Line( points={{-280,300},{-280,240}},
          color={0,0,0},
          visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
               and nChi >= 3),
    Line(
      points={{-280,-60},{-280,-120}},
      color={0,0,0},
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 4),
    Line(
      visible=nChi>=5 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-480},{-180,-480}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 5,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-480}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=5,
      extent={{-320,-420},{-240,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating and nChi >= 5,
      extent={{-320,-420},{-240,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( points={{-400,-600},{-180,-600}},
      color={0,0,0},
      thickness=5,
      visible=nChi>=5),
    Line(
      points={{-280,-420},{-280,-480}},
      color={0,0,0},
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 5),
    Line(
      visible=nChi>=6 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-840},{-180,-840}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
      and nChi >= 6,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-840}),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi>=6,
      extent={{-320,-780},{-240,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=6,
      extent={{-320,-780},{-240,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line(
      points={{-400,-960},{-180,-960}},
      color={0,0,0},
      thickness=5,
      visible=nChi >= 6 and typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line(
      points={{-280,-780},{-280,-840}},
      color={0,0,0},
      visible=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 6),
    Bitmap(
          extent={{-60,1000},{60,1120}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 1),
    Bitmap(
          extent={{-60,640},{60,760}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 2),
    Bitmap(
          extent={{-60,280},{60,400}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 3),
    Bitmap(
          extent={{-60,-80},{60,40}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 4),
    Bitmap(
          extent={{-60,-440},{60,-320}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 5),
    Bitmap(
          extent={{-60,-800},{60,-680}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 6)}),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for chiller group models.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available for all
models inheriting from this interface.
</p>
<ul>
<li>
Sub-bus <code>bus.chi=busChi</code> storing all signals dedicated
to each unit, with a dimensionality of one
<ul>
<li>
See the class 
<a href=\"modelica://Buildings.Templates.Components.Chillers.Compression\">
Buildings.Templates.Components.Chillers.Compression</a>
for the control signals typically included in this sub-bus.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialChillerGroup;
